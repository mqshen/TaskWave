//
//  TodolistViewController.h
//  ZenTask
//
//  Created by GoldRatio on 5/27/14.
//  Copyright (c) 2014 GoldRatio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ObjectAddProtocol.h"

@interface TodolistViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, ObjectAddProtocol>

@property (nonatomic) long projectId;
@property (weak) UIViewController* rootViewController;

@end
