//
//  TabCell.m
//  ZenTask
//
//  Created by GoldRatio on 5/26/14.
//  Copyright (c) 2014 GoldRatio. All rights reserved.
//

#import "TabCell.h"

#define STROKE_SIZE 5.0f

@implementation TabCell
{
    UIColor *_tintColor;
    UIColor *_textColor;
}

@synthesize name;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (UIColor*)tintColor
{
    // On iOS 7, forward to the super (UIView).
    if ([[super superclass] instancesRespondToSelector:@selector(tintColor)])
        return [super tintColor];
    else
        return _tintColor;
}



//| ----------------------------------------------------------------------------
//! Manual implementation of the setter for the 'tintColor' property.
//
//  The setter for this property is implemented to forward invcations to the
//  super if the device is running iOS 7.
//
- (void)setTintColor:(UIColor *)tintColor
{
    // On iOS 7, forward to the super (UIView).
    if ([[super superclass] instancesRespondToSelector:@selector(setTintColor:)])
        return [super setTintColor:tintColor];
    else
        _tintColor = tintColor;
}


- (UIColor*)textColor
{
    return _textColor;
}


- (void)setTextColor:(UIColor *)textColor
{
    _textColor = textColor;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    const CGFloat width = self.bounds.size.width;
    const CGFloat height = self.bounds.size.height;
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGContextConcatCTM(context, transform);
    
#define WP(POINT) (POINT * width)
#define HP(POINT) (POINT * height)
    
   
    
    UIColor *color = UNACTIVE_COLOR;
    UIColor *textColor = UNACTIVE_COLOR;
    if (self.checked) {
        if (self.tintColor) {
            color = self.tintColor;
            textColor = self.textColor;
        }
    }
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:H1_FONT, NSFontAttributeName,
                                textColor, NSForegroundColorAttributeName, nil];

    NSAttributedString * nameText = [[NSAttributedString alloc] initWithString:name attributes: attributes];
    CGSize size = [nameText size];
    CGFloat left = WP(0.5f) - size.width / 2;
    CGFloat top = HP(0.5F) - (size.height - STROKE_SIZE) / 2;
    CGPoint point = CGPointMake(left, top);
    [nameText drawAtPoint:point];
    // Draw the checkmark if self.checked==YES
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextSetStrokeColorWithColor(context, [color CGColor]);
    
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, WP(0.f), HP(1.f));
    CGContextAddLineToPoint(context, WP(1.f), HP(1.f));
    
    CGContextSetLineWidth(context, STROKE_SIZE);
    
    CGContextStrokePath(context);
#undef WP
#undef HP
}

- (void)setChecked:(BOOL)checked
{
    if (checked != _checked) {
        _checked = checked;
        // Flag ourself as needing to be redrawn.
        [self setNeedsDisplay];
        UIAccessibilityPostNotification(UIAccessibilityLayoutChangedNotification, nil);
    }
}
@end
