//
//  Checkbox.h
//  doudou
//
//  Created by GoldRatio on 5/1/14.
//  Copyright (c) 2014 GoldRatio. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CheckBoxTappedProtocol <NSObject>

- (void) checkBoxTapped:(id)sender forEvent:(UIEvent*)event;

@end

@interface Checkbox : UIControl

//! The control state.
@property (nonatomic, readwrite, getter = isChecked) BOOL checked;

//! The color of the box surrounding the tappable area of the Checkbox control.
//!
//! In iOS 7, all views have a tintColor property.  We redeclare that property
//! here to accommodate tint color customization for iOS 6 devices.
@property (nonatomic, strong) UIColor *tintColor;

@end
