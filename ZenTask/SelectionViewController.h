//
//  SelectionViewController.h
//  ZenTask
//
//  Created by GoldRatio on 5/30/14.
//  Copyright (c) 2014 GoldRatio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataSelectionViewControllerDelegate.h"

@interface SelectionViewController : UIViewController

@property (weak) id<DataSelectionViewControllerDelegate> delegate;

@property (weak) UIViewController *rootViewController;

@property (nonatomic, strong) UIView *backgroundView;

@property (assign, nonatomic) BOOL disableBouncingWhenShowing;

@property (nonatomic, strong) id selectedData;

@property (nonatomic, strong) UIView *dataPicketContainer;

- (void) show;

@end
