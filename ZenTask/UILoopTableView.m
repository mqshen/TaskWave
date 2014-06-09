//
//  UILoopTableView.m
//  ZenTask
//
//  Created by GoldRatio on 6/4/14.
//  Copyright (c) 2014 GoldRatio. All rights reserved.
//

#import "UILoopTableView.h"
#import "CKLinkedList.h"

const CGFloat _UITableViewDefaultRowHeight = 43;

#define MIN_TOGGLE_DURATION 0.1
#define MAX_TOGGLE_DURATION 0.2
#define SCROLL_DURATION 0.4
#define INSERT_DURATION 0.4
#define DECELERATE_THRESHOLD 0.1f
#define SCROLL_SPEED_THRESHOLD 2.0f
#define SCROLL_DISTANCE_THRESHOLD 0.1f
#define DECELERATION_MULTIPLIER 30.f


#define MAX_VISIBLE_EXTEND 60.f

typedef enum {
	DIRECTION_UP,
	DIRECTION_DOWN,
} MoveDirection;

@interface UILoopTableView()

@property (nonatomic, assign) CGFloat previousTranslation;
@property (nonatomic, assign) BOOL didDrag;
@property (nonatomic, assign) CGFloat startVelocity;
@property (nonatomic, assign, getter = isDecelerating) BOOL decelerating;
@property (nonatomic, assign) CGFloat startOffset;
@property (nonatomic, assign) CGFloat endOffset;
@property (nonatomic, assign) NSTimeInterval startTime;
@property (nonatomic, assign) NSTimeInterval lastTime;
@property (nonatomic, assign) NSTimeInterval scrollDuration;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger previousItemIndex;
@property (nonatomic, assign) NSTimeInterval toggleTime;
@property (nonatomic, strong) CKLinkedList *itemViews;
@property (nonatomic, strong) NSMutableSet *placeholderViewPool;
@property (nonatomic, strong) NSMutableSet *itemViewPool;
@property (assign) MoveDirection direction;
@property (assign) NSInteger startIndex;
@property (assign) NSInteger endIndex;

@end

@implementation UILoopTableView {
    BOOL _needsReload;
    NSNumber *_selectedRow;
    NSNumber *_highlightedRow;
    NSMutableDictionary *_cachedCells;
    NSMutableSet *_reusableCells;
    
    struct {
        unsigned heightForRowAtIndex: 1;
        unsigned willSelectRowAtIndex: 1;
        unsigned didSelectRowAtIndex: 1;
        unsigned willDeselectRowAtIndex: 1;
        unsigned didDeselectRowAtIndex: 1;
        unsigned willBeginEditingRowAtIndex: 1;
        unsigned didEndEditingRowAtIndex: 1;
        unsigned titleForDeleteConfirmationButtonForRowAtIndexPath: 1;
    } _delegateHas;
    
    struct {
        unsigned numberOfRowsInTableView : 1;
        unsigned titleForHeaderInSection : 1;
        unsigned titleForFooterInSection : 1;
        unsigned commitEditingStyle : 1;
        unsigned canEditRowAtIndexPath : 1;
    } _dataSourceHas;
}

- (id)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame style:UITableViewStylePlain];
}

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)theStyle
{
    if ((self=[super initWithFrame:frame])) {
        _style = theStyle;
        _cachedCells = [[NSMutableDictionary alloc] init];
        _itemViews = [[CKLinkedList alloc] init];
        _reusableCells = [[NSMutableSet alloc] init];
        
        self.separatorColor = [UIColor colorWithRed:.88f green:.88f blue:.88f alpha:1];
        self.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        self.allowsSelection = YES;
        self.allowsSelectionDuringEditing = NO;
        
        _vertical = YES;
        _offsetMultiplier = 1.0f;
        _scrollSpeed = 1.0f;
        
        if (_style == UITableViewStylePlain) {
            self.backgroundColor = [UIColor whiteColor];
        }
        
        [self _setNeedsReload];
        _panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(_gestureDidChange:)];
        [self addGestureRecognizer:_panGestureRecognizer];
        
    }
    return self;
}


- (void)setDataSource:(id<UILoopTableViewDataSource>)newSource
{
    _dataSource = newSource;
    
    _dataSourceHas.numberOfRowsInTableView = [_dataSource respondsToSelector:@selector(numberOfRowsInTableView:)];
    _dataSourceHas.titleForHeaderInSection = [_dataSource respondsToSelector:@selector(tableView:titleForHeaderInSection:)];
    _dataSourceHas.titleForFooterInSection = [_dataSource respondsToSelector:@selector(tableView:titleForFooterInSection:)];
    _dataSourceHas.commitEditingStyle = [_dataSource respondsToSelector:@selector(tableView:commitEditingStyle:forRowAtIndexPath:)];
    _dataSourceHas.canEditRowAtIndexPath = [_dataSource respondsToSelector:@selector(tableView:canEditRowAtIndexPath:)];
    
    [self _setNeedsReload];
}

- (void)setDelegate:(id<UILoopTableViewDelegate>)newDelegate
{
    _delegate = newDelegate;
    _delegateHas.heightForRowAtIndex = [newDelegate respondsToSelector:@selector(tableView:heightForRowAtIndex:)];
    _delegateHas.didSelectRowAtIndex= [newDelegate respondsToSelector:@selector(tableView:didSelectRowAtIndex:)];
    _delegateHas.willDeselectRowAtIndex= [newDelegate respondsToSelector:@selector(tableView:willDeselectRowAtIndex:)];
    _delegateHas.didDeselectRowAtIndex= [newDelegate respondsToSelector:@selector(tableView:didDeselectRowAtIndex:)];
    _delegateHas.willBeginEditingRowAtIndex= [newDelegate respondsToSelector:@selector(tableView:willBeginEditingRowAtIndex:)];
    _delegateHas.titleForDeleteConfirmationButtonForRowAtIndexPath = [newDelegate respondsToSelector:@selector(tableView:titleForDeleteConfirmationButtonForRowAtIndexPath:)];
}


- (void)_layoutTableView
{
    // lays out headers and rows that are visible at the time. this should also do cell
    // dequeuing and keep a list of all existing cells that are visible and those
    // that exist but are not visible and are reusable
    // if there's no section cache, no rows will be laid out but the header/footer will (if any).
    
    
    CGFloat topBounds = -MAX_VISIBLE_EXTEND;
    CGFloat startY = 0;
    _startIndex = -1;
    while (startY > topBounds) {
        CGFloat height = _delegateHas.heightForRowAtIndex?
            [self.delegate tableView:self heightForRowAtIndex:@(_startIndex)] : _UITableViewDefaultRowHeight;
        UIView *cell = [self.dataSource tableView:self cellForRowAtIndex:_startIndex];
        [_itemViews pushFront:cell];
        startY -= height;
        CGRect frame = cell.frame;
        frame.origin.y = startY;
        frame.size.height = height;
        frame.size.width = 320;;
        cell.frame = frame;
        --_startIndex;
        [self addSubview:cell];
    }
    _endIndex = 0;
    startY = 0;
    CGFloat bottomBounds = self.frame.size.height + MAX_VISIBLE_EXTEND;
    while (startY < bottomBounds) {
        CGFloat height = _delegateHas.heightForRowAtIndex?
        [self.delegate tableView:self heightForRowAtIndex:@(_endIndex)] : _UITableViewDefaultRowHeight;
        UIView *cell = [self.dataSource tableView:self cellForRowAtIndex:_endIndex];
        [_itemViews pushBack:cell];
        CGRect frame = cell.frame;
        frame.size.height = height;
        frame.size.width = 320;;
        frame.origin.y = startY;
        cell.frame = frame;
        startY += height;
        ++_endIndex;
        [self addSubview:cell];
    }
    
    
    
}

- (CGRect)_CGRectFromVerticalOffset:(CGFloat)offset height:(CGFloat)height
{
    return CGRectMake(0,offset,self.bounds.size.width,height);
}

- (CGFloat)_currentOffset
{
    CGFloat offset = _tableHeaderView? _tableHeaderView.frame.size.height : 0;
    
    return offset;
}


- (void) beginUpdates
{
}

- (void)endUpdates
{
}

- (UITableViewCell *)cellForRowAtIndex:(NSNumber*)indexPath
{
    // this is allowed to return nil if the cell isn't visible and is not restricted to only returning visible cells
    // so this simple call should be good enough.
    return [_cachedCells objectForKey:indexPath];
}


//- (NSArray *)indexPathsForVisibleRows
//{
//    [self _layoutTableView];
//    
//    NSMutableArray *indexes = [NSMutableArray arrayWithCapacity:[_cachedCells count]];
//    const CGRect bounds = self.bounds;
//    
//    // Special note - it's unclear if UIKit returns these in sorted order. Because we're assuming that visibleCells returns them in order (top-bottom)
//    // and visibleCells uses this method, I'm going to make the executive decision here and assume that UIKit probably does return them sorted - since
//    // there's nothing warning that they aren't. :)
//    
//    for (NSNumber *index in [[_cachedCells allKeys] sortedArrayUsingSelector:@selector(compare:)]) {
//        if (CGRectIntersectsRect(bounds,[self rectForRowAtIndex:index])) {
//            [indexes addObject:index];
//        }
//    }
//    
//    return indexes;
//}


- (void)setTableHeaderView:(UIView *)newHeader
{
    if (newHeader != _tableHeaderView) {
        [_tableHeaderView removeFromSuperview];
        _tableHeaderView = newHeader;
        [self addSubview:_tableHeaderView];
    }
}

- (void)setTableFooterView:(UIView *)newFooter
{
    if (newFooter != _tableFooterView) {
        [_tableFooterView removeFromSuperview];
        _tableFooterView = newFooter;
        [self addSubview:_tableFooterView];
    }
}

- (void)setBackgroundView:(UIView *)backgroundView
{
    if (_backgroundView != backgroundView) {
        [_backgroundView removeFromSuperview];
        _backgroundView = backgroundView;
        [self insertSubview:_backgroundView atIndex:0];
    }
}


- (NSInteger)numberOfRows
{
    return [self.dataSource numberOfRowsInTableView:self];
}

- (void)reloadData
{
}

- (void)reloadRowsAtIndexPaths:(NSArray *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation
{
    [self reloadData];
}

- (void)_reloadDataIfNeeded
{
    if (_needsReload) {
        [self reloadData];
    }
}

- (void)_setNeedsReload
{
    _needsReload = YES;
    [self _layoutTableView];
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    _backgroundView.frame = self.bounds;
    [super layoutSubviews];
}

- (void)setFrame:(CGRect)frame
{
    const CGRect oldFrame = self.frame;
    if (!CGRectEqualToRect(oldFrame,frame)) {
        [super setFrame:frame];
    }
}

- (NSNumber *)indexPathForSelectedRow
{
    return _selectedRow;
}

- (NSIndexPath *)indexPathForCell:(UITableViewCell *)cell
{
    for (NSIndexPath *index in [_cachedCells allKeys]) {
        if ([_cachedCells objectForKey:index] == cell) {
            return index;
        }
    }
    
    return nil;
}

- (void)deselectRowAtIndex:(NSNumber *)index animated:(BOOL)animated
{
    
}

- (void)selectRowAtIndex:(NSNumber *)indexPath animated:(BOOL)animated scrollPosition:(UITableViewScrollPosition)scrollPosition
{
    
}

- (void)_setUserSelectedRowAtIndex:(NSNumber *)rowToSelect
{
    if (_delegateHas.willSelectRowAtIndex) {
        rowToSelect = [self.delegate tableView:self willSelectRowAtIndex:rowToSelect];
    }
    
    NSNumber *selectedRow = [self indexPathForSelectedRow];
    
    if (selectedRow && ![selectedRow isEqual:rowToSelect]) {
        NSNumber *rowToDeselect = selectedRow;
        
        if (_delegateHas.willDeselectRowAtIndex) {
            rowToDeselect = [self.delegate tableView:self willDeselectRowAtIndex:rowToDeselect];
        }
        
        [self deselectRowAtIndex:rowToDeselect animated:NO];
        
        if (_delegateHas.didDeselectRowAtIndex) {
            [self.delegate tableView:self didDeselectRowAtIndex:rowToDeselect];
        }
    }
    
    [self selectRowAtIndex:rowToSelect animated:NO scrollPosition:UITableViewScrollPositionNone];
    
    if (_delegateHas.didSelectRowAtIndex) {
        [self.delegate tableView:self didSelectRowAtIndex:rowToSelect];
    }
}

- (void)_scrollRectToVisible:(CGRect)aRect atScrollPosition:(UITableViewScrollPosition)scrollPosition animated:(BOOL)animated
{
    if (!CGRectIsNull(aRect) && aRect.size.height > 0) {
        // adjust the rect based on the desired scroll position setting
        switch (scrollPosition) {
            case UITableViewScrollPositionNone:
                break;
                
            case UITableViewScrollPositionTop:
                aRect.size.height = self.bounds.size.height;
                break;
                
            case UITableViewScrollPositionMiddle:
                aRect.origin.y -= (self.bounds.size.height / 2.f) - aRect.size.height;
                aRect.size.height = self.bounds.size.height;
                break;
                
            case UITableViewScrollPositionBottom:
                aRect.origin.y -= self.bounds.size.height - aRect.size.height;
                aRect.size.height = self.bounds.size.height;
                break;
        }
        
    }
}

- (UITableViewCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier
{
    for (UITableViewCell *cell in _reusableCells) {
        if ([cell.reuseIdentifier isEqualToString:identifier]) {
            UITableViewCell *strongCell = cell;
            
            // the above strongCell reference seems totally unnecessary, but without it ARC apparently
            // ends up releasing the cell when it's removed on this line even though we're referencing it
            // later in this method by way of the cell variable. I do not like this.
            [_reusableCells removeObject:cell];
            
            [strongCell prepareForReuse];
            return strongCell;
        }
    }
    
    return nil;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animate
{
    _editing = editing;
}

- (void)setEditing:(BOOL)editing
{
    [self setEditing:editing animated:NO];
}

- (void)insertSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation
{
    [self reloadData];
}

- (void)deleteSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation
{
    [self reloadData];
}

- (void)insertRowsAtIndexPaths:(NSArray *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation
{
    [self reloadData];
}

- (void)deleteRowsAtIndexPaths:(NSArray *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation
{
    [self reloadData];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

- (void)_gestureDidChange:(UIPanGestureRecognizer *)panGesture
{
        switch (panGesture.state) {
            case UIGestureRecognizerStateBegan: {
                _dragging = YES;
                _scrolling = NO;
                _decelerating = NO;
                _previousTranslation = _vertical? [panGesture translationInView:self].y: [panGesture translationInView:self].x;
                //[_delegate carouselWillBeginDragging:self];
                break;
            }
            case UIGestureRecognizerStateEnded:
            case UIGestureRecognizerStateCancelled: {
                _dragging = NO;
                _didDrag = YES;
                if ([self shouldDecelerate]) {
                    _didDrag = NO;
                    [self startDecelerating];
                }
                break;
            }
            default: {
                CGFloat translation = (_vertical? [panGesture translationInView:self].y: [panGesture translationInView:self].x) - _previousTranslation;
                self.direction = translation > 0 ? DIRECTION_DOWN : DIRECTION_UP;
                CGFloat factor = 1.0f;
                if (_bounces) {
                    factor = 1.0f - fminf(0, _bounceDistance) / _bounceDistance;
                }
                
                _previousTranslation = _vertical? [panGesture translationInView:self].y: [panGesture translationInView:self].x;
                _startVelocity = -(_vertical? [panGesture velocityInView:self].y: [panGesture velocityInView:self].x) * factor * _scrollSpeed;
                _scrollOffset = translation * factor * _offsetMultiplier ;
                [self didScroll];
            }
        }
}

- (NSInteger)minScrollDistanceFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex
{
    NSInteger directDistance = toIndex - fromIndex;
    NSInteger wrappedDistance = MIN(toIndex, fromIndex) + _numberOfItems - MAX(toIndex, fromIndex);
    if (fromIndex < toIndex) {
        wrappedDistance = -wrappedDistance;
    }
    return (ABS(directDistance) <= ABS(wrappedDistance))? directDistance: wrappedDistance;
    return directDistance;
}

- (void)didScroll
{
    if (_scrollOffset == 0) {
        return;
    }
    //check if index has changed
    _toggleTime = CACurrentMediaTime();
    
    [self startAnimation];
    
    [self loadUnloadViews];
    [self transformItemViews];
    
    [self pushAnimationState:YES];
    [self popAnimationState];
    
    //notify delegate of change index
    if ([self clampedIndex:_previousItemIndex] != self.currentItemIndex)
    {
        [self pushAnimationState:YES];
        [self popAnimationState];
    }
    
    //update previous index
    //_previousItemIndex = currentIndex;
}

- (void)transformItemViews
{
    LNode *i = nil;
    int index = 0;
    for (i = [_itemViews firstNode]; i; i= i->next) {
        UIView *view = i->obj;
        [self transformItemView:view atIndex:index];
        ++ index;
    }
}

- (NSInteger)currentItemIndex
{
    return [self clampedIndex:roundf(_scrollOffset)];
}

- (NSInteger)clampedIndex:(NSInteger)index
{
    return _numberOfItems? (index - floorf((CGFloat)index / (CGFloat)_numberOfItems) * _numberOfItems): 0;
}

- (CGFloat)offsetForItemAtIndex:(NSInteger)index
{
    //calculate relative position
    CGFloat offset = index - _scrollOffset;
    if (offset > _numberOfItems/2.0f) {
        offset -= _numberOfItems;
    }
    else if (offset < -_numberOfItems/2.0f) {
        offset += _numberOfItems;
    }
    
    return offset;
}

- (void)loadUnloadViews
{
    CGFloat bottomBound = self.frame.size.height + MAX_VISIBLE_EXTEND;
    CGFloat upBound = - MAX_VISIBLE_EXTEND;
    switch (self.direction) {
        case DIRECTION_DOWN: {
            UIView *headView = [_itemViews firstObject];
            CGFloat top = headView.frame.origin.y;
            if (headView.frame.origin.y > upBound) {
                UIView *view = [_dataSource tableView:self cellForRowAtIndex:_startIndex];
                CGFloat height = _delegateHas.heightForRowAtIndex ? [self.delegate tableView:self heightForRowAtIndex:@(_startIndex)] : _UITableViewDefaultRowHeight;
                [_itemViews pushFront:view];
                CGRect frame = view.frame;
                frame.origin.y = top - height;
                frame.size.width = 320;
                frame.size.height = height;
                view.frame = frame;
                [self addSubview:view];
                --_startIndex;
                
                UIView *lastView = [_itemViews lastObject];
                if (lastView.frame.origin.y > bottomBound) {
                    [_itemViews popBack];
                    [lastView removeFromSuperview];
                    --_endIndex;
                }
            }
            break;
        }
        case DIRECTION_UP: {
            
            UIView *lastView = [_itemViews lastObject];
            CGFloat bottom = lastView.frame.origin.y + lastView.frame.size.height;
            if (bottom < bottomBound) {
                UIView *view = [_dataSource tableView:self cellForRowAtIndex:_endIndex];
                CGFloat height = _delegateHas.heightForRowAtIndex ? [self.delegate tableView:self heightForRowAtIndex:@(_endIndex)] : _UITableViewDefaultRowHeight;
                [_itemViews pushBack:view];
                CGRect frame = view.frame;
                frame.origin.y = bottom;
                frame.size.width = 320;
                frame.size.height = height;
                view.frame = frame;
                [self addSubview:view];
                ++_endIndex;
                
                UIView *headView = [_itemViews firstObject];
                if (headView.frame.origin.y < upBound) {
                    [_itemViews popFront];
                    [headView removeFromSuperview];
                    ++_startIndex;
                }
            }
            break;
        }
        default:
            break;
    }
//    CGFloat
//    NSInteger min = -(NSInteger)ceilf((CGFloat)MAX_VISIBLE_ITEMS/2.0f);
//    NSInteger max = _numberOfItems - 1 + MAX_VISIBLE_ITEMS/2;
//    NSInteger offset = self.currentItemIndex - MAX_VISIBLE_ITEMS/2;
//    offset = MAX(min, MIN(max - MAX_VISIBLE_ITEMS + 1, offset));
//    for (NSInteger i = 0; i < MAX_VISIBLE_ITEMS; i++) {
//        NSInteger index = i + offset;
//        index = [self clampedIndex:index];
//    }
    
}

- (void)pushAnimationState:(BOOL)enabled
{
    [CATransaction begin];
    [CATransaction setDisableActions:!enabled];
}

- (UIView *)loadViewAtIndex:(NSInteger)index
{
    [self pushAnimationState:NO];
    
    UIView *view = [_dataSource tableView:self cellForRowAtIndex:index];
    
    if (view == nil)
    {
        view = [[UIView alloc] init];
    }
    
    [_itemViews addObject:view];
    //[self setItemView:view forIndex:index];
    
    [self addSubview:view];
    [self transformItemView:view atIndex:index];
    
    [self popAnimationState];
    
    return view;
}

- (void)popAnimationState
{
    [CATransaction commit];
}


- (void)transformItemView:(UIView *)view atIndex:(NSInteger)index
{
    //calculate offset
    CGFloat offset = [self offsetForItemAtIndex:index];
    //special-case logic for iCarouselTypeCoverFlow2
    CGFloat clampedOffset = fmaxf(-1.0f, fminf(1.0f, offset));
    if (_decelerating || (_scrolling && !_didDrag) )
    {
        if (offset > 0)
        {
            _toggle = (offset <= 0.5f)? -clampedOffset: (1.0f - clampedOffset);
        }
        else
        {
            _toggle = (offset > -0.5f)? -clampedOffset: (- 1.0f - clampedOffset);
        }
    }
    
    CGRect frame = view.frame;
    frame.origin.y += _scrollOffset;
    view.frame = frame;
}


- (void)queuePlaceholderView:(UIView *)view
{
    if (view)
    {
        [_placeholderViewPool addObject:view];
    }
}

- (void)queueItemView:(UIView *)view
{
    if (view)
    {
        [_itemViewPool addObject:view];
    }
}

- (UIView *)dequeueItemView
{
    UIView *view = [_itemViewPool anyObject];
    if (view)
    {
        [_itemViewPool removeObject:view];
    }
    return view;
}

- (UIView *)dequeuePlaceholderView
{
    UIView *view = [_placeholderViewPool anyObject];
    if (view)
    {
        [_placeholderViewPool removeObject:view];
    }
    return view;
}



- (CGFloat)decelerationDistance
{
    CGFloat acceleration = -_startVelocity * DECELERATION_MULTIPLIER * (1.0f - _decelerationRate);
    return -powf(_startVelocity, 2.0f) / (2.0f * acceleration);
}

- (BOOL)shouldDecelerate
{
    return (fabsf(_startVelocity) > SCROLL_SPEED_THRESHOLD) &&
    (fabsf([self decelerationDistance]) > DECELERATE_THRESHOLD);
}

- (void)startDecelerating
{
    CGFloat distance = [self decelerationDistance];
    _startOffset = _scrollOffset;
    _endOffset = _startOffset + distance;
    
    
    if (_bounces) {
        _endOffset = fmaxf(-_bounceDistance, fminf(_numberOfItems - 1.0f + _bounceDistance, _endOffset));
    }
    distance = _endOffset - _startOffset;
    
    _startTime = CACurrentMediaTime();
    _scrollDuration = fabsf(distance) / fabsf(0.03f * _startVelocity);
    
    if (distance != 0.0f) {
        _decelerating = YES;
        [self startAnimation];
    }
}

- (void)startAnimation
{
    if (!_timer)
    {
        self.timer = [NSTimer timerWithTimeInterval:1.0/60.0
                                             target:self
                                           selector:@selector(step)
                                           userInfo:nil
                                            repeats:YES];
        
        [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
        
        
        [[NSRunLoop mainRunLoop] addTimer:_timer forMode:UITrackingRunLoopMode];
        
    }
}


- (CGFloat)easeInOut:(CGFloat)time
{
    return (time < 0.5f)? 0.5f * powf(time * 2.0f, 3.0f): 0.5f * powf(time * 2.0f - 2.0f, 3.0f) + 1.0f;
}

- (CGFloat)easeOut:(CGFloat)time
{
    return 0.5f * powf(time * 2.0f - 2.0f, 3.0f) + 1.0f;
}

- (void)step
{
    [self pushAnimationState:NO];
    NSTimeInterval currentTime = CACurrentMediaTime();
    _lastTime = currentTime;
    
    if (_toggle != 0.0f) {
        NSTimeInterval toggleDuration = _startVelocity? fminf(1.0, fmaxf(0.0, 1.0 / fabsf(_startVelocity))): 1.0;
        toggleDuration = MIN_TOGGLE_DURATION + (MAX_TOGGLE_DURATION - MIN_TOGGLE_DURATION) * toggleDuration;
        NSTimeInterval time = fminf(1.0f, (currentTime - _toggleTime) / toggleDuration);
        CGFloat delta = [self easeInOut:time];
        _toggle = (_toggle < 0.0f)? (delta - 1.0f): (1.0f - delta);
        [self didScroll];
    }
    
    if (_scrolling) {
        NSTimeInterval time = fminf(1.0f, (currentTime - _startTime) / _scrollDuration);
        CGFloat delta = [self easeInOut:time];
        _scrollOffset = _startOffset + (_endOffset - _startOffset) * delta;
        [self didScroll];
        if (time == 1.0f) {
            _scrolling = NO;
            [self pushAnimationState:YES];
            [self popAnimationState];
        }
    }
    else if (_decelerating)
    {
        CGFloat time = fminf(_scrollDuration, currentTime - _startTime);
        CGFloat acceleration = -_startVelocity/_scrollDuration;
        CGFloat distance = _startVelocity * (_scrollDuration - time) + 0.5f * acceleration * powf((_scrollDuration - time), 2.0f);
        distance *= .02f;
        
        _scrollOffset = - distance;
        
        [self didScroll];
        if (time == (CGFloat)_scrollDuration) {
            _decelerating = NO;
            [self pushAnimationState:YES];
            [self popAnimationState];
            [self scrollByOffset:_scrollOffset duration:SCROLL_DURATION];
        }
    }
    else if (_toggle == 0.0f)
    {
        [self stopAnimation];
    }
    
    [self popAnimationState];
}


- (void)scrollByOffset:(CGFloat)offset duration:(NSTimeInterval)duration
{
    if (duration > 0.0) {
        _decelerating = NO;
        _scrolling = YES;
        _startTime = CACurrentMediaTime();
        _startOffset = _scrollOffset;
        _scrollDuration = duration;
        _previousItemIndex = roundf(_scrollOffset);
        _endOffset = _startOffset + offset;
        [self startAnimation];
    }
    else {
        self.scrollOffset += offset;
    }
}

- (void)stopAnimation
{
    [_timer invalidate];
    _timer = nil;
}

@end
