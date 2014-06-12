//
//  PanGestureDelegate.h
//  ZenTask
//
//  Created by GoldRatio on 6/11/14.
//  Copyright (c) 2014 GoldRatio. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PanGestureDelegate <NSObject>

-(void)panGestureCallback:(UIPanGestureRecognizer *)panGesture;

@end
