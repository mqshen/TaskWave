//
//  SlideNavViewController.h
//  doudou
//
//  Created by GoldRatio on 4/24/14.
//  Copyright (c) 2014 GoldRatio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "SlideNavigationContorllerAnimator.h"

@interface SlideNavViewController : UIViewController<UINavigationControllerDelegate>

@property (nonatomic, strong) id <SlideNavigationContorllerAnimator> menuRevealAnimator;

-(id)initWithCenterViewController:(UIViewController *)centerViewController leftViewController:(UIViewController *)leftViewController;

- (void) openMenu;

@end
