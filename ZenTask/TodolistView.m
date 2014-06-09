//
//  TodolistView.m
//  ZenTask
//
//  Created by GoldRatio on 5/27/14.
//  Copyright (c) 2014 GoldRatio. All rights reserved.
//

#import "TodolistView.h"

@implementation TodolistView

@synthesize name;
@synthesize description;
@synthesize todolistId;
@synthesize delegate;

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
    
#define HP(POINT) (POINT * height)
    
    UIColor *color = UNACTIVE_COLOR;
    if (self.tintColor) {
        color = self.tintColor;
    }
    CGContextSetFillColorWithColor(context, [color CGColor]);
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:H1_FONT, NSFontAttributeName,
                                color, NSForegroundColorAttributeName, nil];
    
    NSAttributedString * nameText = [[NSAttributedString alloc] initWithString:name attributes: attributes];
    CGSize size = [nameText size];
    CGFloat left = 10;
    CGFloat top = HP(0.5F) - size.height / 2;
    CGPoint point = CGPointMake(left, top);
    [nameText drawAtPoint:point];
    // Draw the checkmark if self.checked==YES
    
    if (description  && [description length] > 0) {
        NSDictionary *descAttributes = [NSDictionary dictionaryWithObjectsAndKeys:H2_FONT, NSFontAttributeName,
                                    color, NSForegroundColorAttributeName, nil];
        
        NSAttributedString *descriptionText = [[NSAttributedString alloc] initWithString:description attributes: descAttributes];
        CGSize descriptionSize = [descriptionText size];
        left = left + descriptionSize.width + 5;
        top = top + size.height - descriptionSize.height;
        point = CGPointMake(left, top);
        [descriptionText drawAtPoint:point];
    }
    
#undef HP
}

- (void) doAdd:(id) sender
{
    [delegate doAdd:self.todolistId];
}

@end
