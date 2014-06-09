//
//  TodoView.m
//  ZenTask
//
//  Created by GoldRatio on 5/27/14.
//  Copyright (c) 2014 GoldRatio. All rights reserved.
//

#import "TodoView.h"

#define PADDING 8

@implementation TodoView

@synthesize name = _name;
@synthesize worker = _worker;
@synthesize deadline = _deadline;

- (void) setName:(NSString *)name
{
    _name = name;
    [self setNeedsDisplay];
}

- (void) setWorker:(NSString *)worker
{
    _worker = worker;
    [self setNeedsDisplay];
}

- (void) setDeadline:(NSDate *)deadline
{
    _deadline = deadline;
    [self setNeedsDisplay];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    const CGFloat height = self.bounds.size.height;
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGContextConcatCTM(context, transform);
    
    
    UIColor *color = UNACTIVE_COLOR;
    if (self.tintColor) {
        color = self.tintColor;
    }
    CGContextSetFillColorWithColor(context, [color CGColor]);
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:TEXT_FONT, NSFontAttributeName,
                                color, NSForegroundColorAttributeName, nil];
    
    NSAttributedString * nameText = [[NSAttributedString alloc] initWithString:_name attributes: attributes];
    //
    CGFloat left = 0;
    CGFloat top = PADDING;
    CGPoint point = CGPointMake(left, top);
    [nameText drawAtPoint:point];
    NSMutableString *assignString = [[NSMutableString alloc] initWithString:@""];
    if (_worker && [_worker length] > 0) {
        [assignString appendString:_worker];
    }
    else {
        [assignString appendString:@"未指派"];
    }
    [assignString appendString:@" · "];
    if(_deadline) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:ASSIGN_DATE_FOMAT];
        [assignString appendString:[dateFormatter stringFromDate:_deadline]];
    }
    else {
        [assignString appendString:@"没有截止时间"];
    }
    NSDictionary *assignAttributes = [NSDictionary dictionaryWithObjectsAndKeys:SMALL_TEXT_FONT, NSFontAttributeName,
                                ASSIGN_TEXT_COLOR, NSForegroundColorAttributeName, nil];
    NSAttributedString * assignNameText = [[NSAttributedString alloc] initWithString:assignString
                                                                          attributes: assignAttributes];
    CGSize size = [assignNameText size];
    // Draw the checkmark if self.checked==YES
    
//    if (description  && [description length] > 0) {
//        NSDictionary *descAttributes = [NSDictionary dictionaryWithObjectsAndKeys:H2_FONT, NSFontAttributeName,
//                                        color, NSForegroundColorAttributeName, nil];
//        
//        NSAttributedString *descriptionText = [[NSAttributedString alloc] initWithString:description attributes: descAttributes];
//        CGSize descriptionSize = [descriptionText size];
//        left = left + descriptionSize.width + 5;
//        top = top + size.height - descriptionSize.height;
//        point = CGPointMake(left, top);
//        [descriptionText drawAtPoint:point];
//    }
    
    CGContextBeginPath(context);
    CGFloat assignHeight = size.height + 2;
    top = height - assignHeight - PADDING;
    CGFloat bottom = height - PADDING;
    CGFloat radius = assignHeight / 2;
    CGFloat centerHegith = top + radius;
    left = left + radius;
    CGContextMoveToPoint(context, left, bottom);
    CGContextAddArc(context, left, centerHegith, radius, M_PI_2, M_PI_2 * 3, 0);
    CGContextAddLineToPoint(context, left + size.width, top);
    CGContextAddArc(context, left + size.width , centerHegith, radius, M_PI_2 * 3, M_PI_2, 0);
    CGContextClosePath(context);
    
    CGContextSetFillColorWithColor(context, [UNACTIVE_COLOR CGColor]);
    CGContextFillPath(context);
    
    [assignNameText drawAtPoint:CGPointMake(left, top + 1)];
}

@end
