//
//  TabCell.h
//  ZenTask
//
//  Created by GoldRatio on 5/26/14.
//  Copyright (c) 2014 GoldRatio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TabCell : UIControl

@property(strong) NSString *name;
@property (nonatomic, readwrite, getter = isChecked) BOOL checked;
@property (nonatomic, strong) UIColor *tintColor;
@property (nonatomic, strong) UIColor *textColor;

@end
