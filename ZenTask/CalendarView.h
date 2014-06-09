//
//  CalendarView.h
//  ZenTask
//
//  Created by GoldRatio on 6/6/14.
//  Copyright (c) 2014 GoldRatio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalendarView : UIView

@property (strong) NSDate *date;
@property (strong, nonatomic) NSArray *todos;
@property (strong, nonatomic) NSArray *events;


@end
