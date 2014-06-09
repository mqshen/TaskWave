//
//  TodoView.h
//  ZenTask
//
//  Created by GoldRatio on 5/27/14.
//  Copyright (c) 2014 GoldRatio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TodoView : UIView

@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString* worker;
@property (nonatomic, strong) NSDate* deadline;

@end
