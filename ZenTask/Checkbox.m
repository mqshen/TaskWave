//
//  Checkbox.m
//  doudou
//
//  Created by GoldRatio on 5/1/14.
//  Copyright (c) 2014 GoldRatio. All rights reserved.
//

#import "Checkbox.h"

@implementation Checkbox
{
    // This variable is only used on iOS 6.  On iOS 7, calls to read/write the
    // tintColor property are forwarded to the super (UIView).
    //
    // We must manually define it because we've manually implemented both the
    // getter and setter for the 'tintColor' property.
    UIColor *_tintColor;
}

//| ----------------------------------------------------------------------------
- (void)tintColorDidChange
{
    [self setNeedsDisplay];
}


//| ----------------------------------------------------------------------------
//! Manual implementation of the getter for the 'tintColor' property.
//
//  The getter for this property is implemented to forward invcations to the
//  super if the device is running iOS 7.
//
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


//| ----------------------------------------------------------------------------
//  This method is overridden to draw the control using Quartz2D.
//
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    const CGFloat size = MIN(self.bounds.size.width, self.bounds.size.height);
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    // Account for non-square frames.
    if (self.bounds.size.width < self.bounds.size.height) {
        // Vertical Center
        transform = CGAffineTransformMakeTranslation(0, (self.bounds.size.height - size)/2);
    } else if (self.bounds.size.width > self.bounds.size.height) {
        // Horizontal Center
        transform = CGAffineTransformMakeTranslation((self.bounds.size.width - size)/2, 0);
    }
    
    // Draw the checkbox
    
    
    // Draw the checkmark if self.checked==YES
    if (self.checked) {
        //CGContextSetGrayFillColor(context, 0.0f, 1.0f);
        if (self.tintColor) {
            CGContextSetFillColorWithColor(context, self.tintColor.CGColor);
        }
    }
    else {
        CGContextSetFillColorWithColor(context, [UNACTIVE_COLOR CGColor]);
    }
    
    {
#define P(POINT) (POINT * size)
    CGContextConcatCTM(context, transform);
    
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, P(0.267f), P(0.5));
    CGContextAddLineToPoint(context, P(0.417f), P(0.65f));
    CGContextAddLineToPoint(context, P(0.717f), P(0.367f));
    CGContextAddLineToPoint(context, P(0.667f), P(0.317f));
    CGContextAddLineToPoint(context, P(0.417f), P(0.55f));
    CGContextAddLineToPoint(context, P(0.333f), P(0.467f));
    
    CGContextClosePath(context);
    
    CGContextFillPath(context);
    
#undef P
    }
    
}

#pragma mark -
#pragma mark Control

//| ----------------------------------------------------------------------------
//! Custom implementation of the setter for the 'checked' property.
//
- (void)setChecked:(BOOL)checked
{
    if (checked != _checked) {
        _checked = checked;
        
        // Flag ourself as needing to be redrawn.
        [self setNeedsDisplay];
        
        UIAccessibilityPostNotification(UIAccessibilityLayoutChangedNotification, nil);
    }
}


//| ----------------------------------------------------------------------------
//! Sends action messages for the given control events along with the UIEvent
//! which triggered them.
//
//  UIControl provides the -sendActionsForControlEvents: method to send action
//  messages associated with controlEvents.  A limitation of
//  -sendActionsForControlEvents is that it does not include the UIEvent that
//  triggered the controlEvents with the action messages.
//
//  AccessoryViewController and CustomAccessoryViewController rely on receiving
//  the underlying UIEvent when their associated IBActions are invoked.
//  This method functions identically to -sendActionsForControlEvents:
//  but accepts a UIEvent that is sent with the action messages.
//
- (void)sendActionsForControlEvents:(UIControlEvents)controlEvents withEvent:(UIEvent*)event
{
    NSSet *allTargets = [self allTargets];
    
    for (id target in allTargets) {
        
        NSArray *actionsForTarget = [self actionsForTarget:target forControlEvent:controlEvents];
        
        // Actions are returned as NSString objects, where each string is the
        // selector for the action.
        for (NSString *action in actionsForTarget) {
            SEL selector = NSSelectorFromString(action);
            [self sendAction:selector to:target forEvent:event];
        }
    }
}


//| ----------------------------------------------------------------------------
//  If you override one of the touch event callbacks, you should override all of
//  them.
//
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{ }


//| ----------------------------------------------------------------------------
//  If you override one of the touch event callbacks, you should override all of
//  them.
//
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{ }

//| ----------------------------------------------------------------------------
//  This is the touch callback we are interested in.  If there is a touch inside
//  our bounds, toggle our checked state and notify our target of the change.
//
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([[touches anyObject] tapCount] == 1) {
        // Toggle our state.
        self.checked = !self.checked;
        
        // Notify our target (if we have one) of the change.
        [self sendActionsForControlEvents:UIControlEventValueChanged withEvent:event];
    }
}


//| ----------------------------------------------------------------------------
//  If you override one of the touch event callbacks, you should override all of
//  them.
//
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{ }

#pragma mark -
// If you implement a custom control, you should put in the extra work to
// make it accessible.  Your users will appreciate it.
#pragma mark Accessibility

//| ----------------------------------------------------------------------------
//  Declare that this control is accessible element to assistive applications.
//
- (BOOL)isAccessibilityElement
{
    return YES;
}

// Note: accessibilityHint and accessibilityLabel should be configured
//       elsewhere because this control does not know its purpose
//       as it relates to the program as a whole.


//| ----------------------------------------------------------------------------
- (UIAccessibilityTraits)accessibilityTraits
{
    // Always combine our accessibilityTraits with the super's
    // accessibilityTraits
    return super.accessibilityTraits | UIAccessibilityTraitButton;
}


//| ----------------------------------------------------------------------------
- (NSString*)accessibilityValue
{
    return self.checked ? @"Enabled" : @"Disabled";
}

@end
