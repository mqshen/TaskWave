//
//  TabView.h
//  ZenTask
//
//  Created by GoldRatio on 5/26/14.
//  Copyright (c) 2014 GoldRatio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TabSelectDelegate.h"

@interface TabView : UIView

@property (weak) id<TabSelectDelegate> delegate;
@property(assign) NSUInteger selected;

- (id)initWithFrame:(CGRect)frame andTabNames:(NSArray *) names;

- (void) setSelect:(NSUInteger) index;

@end
