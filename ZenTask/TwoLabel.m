//
//  TwoLabel.m
//  ZenTask
//
//  Created by GoldRatio on 6/1/14.
//  Copyright (c) 2014 GoldRatio. All rights reserved.
//

#import "TwoLabel.h"

@implementation TwoLabel

@synthesize name;
@synthesize description;

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
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    const CGFloat height = self.bounds.size.height;
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGContextConcatCTM(context, transform);
    
    
    UIColor *color = UNACTIVE_COLOR;
    if (self.tintColor) {
        color = self.tintColor;
    }
    CGContextSetFillColorWithColor(context, [color CGColor]);
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:SMALL_TEXT_FONT, NSFontAttributeName,
                                color, NSForegroundColorAttributeName, nil];
    
    NSAttributedString * nameText = [[NSAttributedString alloc] initWithString:name attributes: attributes];
    //
    CGFloat left = 0;
    CGFloat top = (height - nameText.size.height) / 2;
    CGPoint point = CGPointMake(left, top);
    [nameText drawAtPoint:point];
    left += nameText.size.width + 5;
    
    
    attributes = [NSDictionary dictionaryWithObjectsAndKeys:SMALL_TEXT_FONT, NSFontAttributeName,
                                UNACTIVE_COLOR, NSForegroundColorAttributeName, nil];
    
    nameText = [[NSAttributedString alloc] initWithString:description attributes: attributes];
    
    point = CGPointMake(left, top);
    [nameText drawAtPoint:point];
}
@end
