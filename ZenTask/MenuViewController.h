//
//  MenuViewController.h
//  doudou
//
//  Created by GoldRatio on 4/24/14.
//  Copyright (c) 2014 GoldRatio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewControllerChangeDelegate.h"

@interface MenuViewController : UIViewController {
}

@property(nonatomic,assign)    id <ViewControllerChangeDelegate> delegate;

@end
