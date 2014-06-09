//
//  TabView.m
//  ZenTask
//
//  Created by GoldRatio on 5/26/14.
//  Copyright (c) 2014 GoldRatio. All rights reserved.
//

#import "TabView.h"
#import "TabCell.h"

@interface TabView ()

@property(nonatomic, strong) NSMutableArray *tabs;

@end

@implementation TabView

@synthesize delegate;
@synthesize selected = _selected;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame andTabNames:(NSArray *) names
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.tabs = [[NSMutableArray alloc] initWithCapacity:[names count]];
        CGFloat width = frame.size.width / [names count];
        for (NSUInteger i = 0; i < [names count]; ++i) {
            CGRect rect = CGRectMake(i * width, 0, width, frame.size.height);
            TabCell *cell = [[TabCell alloc] initWithFrame:rect];
            cell.name = [names objectAtIndex:i];
            cell.tintColor = ACTIVE_BACKGROUND_COLOR;
            cell.textColor = ACTIVE_COLOR;
            [self addSubview:cell];
            [self.tabs addObject:cell];
            UITapGestureRecognizer* gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(select:)];
            [self addGestureRecognizer: gesture];
            self.selected = [names count];
        }
    }
    return self;
}

- (void) select:(UITapGestureRecognizer*) recognizer
{
    CGPoint point = [recognizer locationInView:self];
    CGFloat width = self.frame.size.width / [self.tabs count];
    NSUInteger index = point.x / width;
    [self setSelect:index];
}

- (void) setSelect:(NSUInteger) index
{
    if (_selected != index) {
        [delegate tabselect:index];
        if(_selected < [self.tabs count]) {
            TabCell *tabCell = [self.tabs objectAtIndex:self.selected];
            tabCell.checked = NO;
        }
        TabCell *newTabCell = [self.tabs objectAtIndex:index];
        newTabCell.checked = YES;
        
        self.selected = index;
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
