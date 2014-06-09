//
//  MessageViewController.h
//  ZenTask
//
//  Created by GoldRatio on 5/28/14.
//  Copyright (c) 2014 GoldRatio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ObjectAddProtocol.h"

@interface MessageViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, ObjectAddProtocol>

@property (nonatomic) long projectId;
@property (weak) UIViewController* rootViewController;

@end
