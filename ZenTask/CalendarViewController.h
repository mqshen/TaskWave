//
//  CalendarViewController.h
//  ZenTask
//
//  Created by GoldRatio on 6/6/14.
//  Copyright (c) 2014 GoldRatio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PanGestureDelegate.h"

@interface CalendarViewController : UIViewController

@property (strong, nonatomic) id<PanGestureDelegate> delegate;

@end
