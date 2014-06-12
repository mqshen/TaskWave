//
//  UILoopTableView.h
//  ZenTask
//
//  Created by GoldRatio on 6/4/14.
//  Copyright (c) 2014 GoldRatio. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UILoopTableView;

@protocol UILoopTableViewDelegate  <NSObject>

@optional
- (CGFloat)tableView:(UILoopTableView *)tableView heightForRowAtIndex:(NSNumber *)index;
- (NSNumber *)tableView:(UILoopTableView *)tableView willSelectRowAtIndex:(NSNumber *)index;
- (void)tableView:(UILoopTableView *)tableView didSelectRowAtIndex:(NSNumber *)index;
- (NSNumber *)tableView:(UILoopTableView *)tableView willDeselectRowAtIndex:(NSNumber *)index;
- (void)tableView:(UILoopTableView *)tableView didDeselectRowAtIndex:(NSNumber *)index;

- (void)tableView:(UILoopTableView *)tableView willBeginEditingRowAtIndex:(NSNumber *) index;
- (void)tableView:(UILoopTableView *)tableView didEndEditingRowAtIndexPath:(NSNumber *) index;
- (NSString *)tableView:(UILoopTableView *)tableView titleForDeleteConfirmationButtonForRowAtIndex:(NSNumber *) index;
- (void) tableView:(UILoopTableView *)tableView gestureDidChange:(UIPanGestureRecognizer *)panGesture;

@end

@protocol UILoopTableViewDataSource <NSObject>

@required
- (NSInteger)numberOfRowsInTableView:(UILoopTableView *)tableView;
- (UIView *)tableView:(UILoopTableView *)tableView cellForRowAtIndex:(NSInteger) index;

@optional
- (void)tableView:(UILoopTableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSNumber *)indexPath;
- (BOOL)tableView:(UILoopTableView *)tableView canEditRowAtIndexPath:(NSNumber *)indexPath;

@end

@interface UILoopTableView : UIView
- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style;
- (void)reloadData;
- (void)reloadRowsAtIndexPaths:(NSArray *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation;
- (UIView *)dequeueReusableCellWithIdentifier:(NSString *)identifier;
- (UIView *)cellForRowAtIndex:(NSNumber *)indexPath;

- (void)beginUpdates;
- (void)endUpdates;

- (void)insertSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation;
- (void)deleteSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation;

- (void)insertRowsAtIndexPaths:(NSArray *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation;	// not implemented
- (void)deleteRowsAtIndexPaths:(NSArray *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation;	// not implemented

- (NSNumber *)indexPathForSelectedRow;
- (void)deselectRowAtIndex:(NSNumber *)indexPath animated:(BOOL)animated;
- (void)selectRowAtIndex:(NSNumber *)indexPath animated:(BOOL)animated scrollPosition:(UITableViewScrollPosition)scrollPosition;

- (void)setEditing:(BOOL)editing animated:(BOOL)animate;

@property (nonatomic, readonly) UITableViewStyle style;
@property (nonatomic, assign) id<UILoopTableViewDelegate> delegate;
@property (nonatomic, assign) id<UILoopTableViewDataSource> dataSource;
@property (nonatomic) CGFloat rowHeight;
@property (nonatomic) UITableViewCellSeparatorStyle separatorStyle;
@property (nonatomic, strong) UIColor *separatorColor;
@property (nonatomic, strong) UIView *tableHeaderView;
@property (nonatomic, strong) UIView *tableFooterView;
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic) BOOL allowsSelection;
@property (nonatomic) BOOL allowsSelectionDuringEditing;	// not implemented
@property (nonatomic, getter=isEditing) BOOL editing;
@property (nonatomic, assign) CGFloat *rowHeights;

@property (nonatomic, readonly, getter = isDragging) BOOL dragging;
@property (nonatomic, readonly, getter = isDecelerating) BOOL decelerating;
@property (nonatomic, readonly, getter = isScrolling) BOOL scrolling;

@property (nonatomic, assign, getter = isVertical) BOOL vertical;
@property (nonatomic, assign) BOOL bounces;
@property (nonatomic, assign) CGFloat scrollOffset;
@property (nonatomic, readonly) NSInteger numberOfItems;
@property (nonatomic, assign) CGFloat bounceDistance;
@property (nonatomic, readonly) CGFloat offsetMultiplier;
@property (nonatomic, assign) CGFloat decelerationRate;
@property (nonatomic, assign) CGFloat scrollSpeed;
@property (nonatomic, readonly) CGFloat toggle;
@property (nonatomic, readonly) UIPanGestureRecognizer *panGestureRecognizer;

@end
