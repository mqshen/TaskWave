//
//  ProjectViewController.h
//  ZenTask
//
//  Created by GoldRatio on 5/26/14.
//  Copyright (c) 2014 GoldRatio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TabSelectDelegate.h"
#import "ObjectAddProtocol.h"

@interface ProjectViewController : UIViewController<TabSelectDelegate, ObjectAddProtocol>

@property (nonatomic) int projectId;


@end
