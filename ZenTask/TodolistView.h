//
//  TodolistView.h
//  ZenTask
//
//  Created by GoldRatio on 5/27/14.
//  Copyright (c) 2014 GoldRatio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OperationProtocol.h"

@interface TodolistView : UIView

@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString* description;
@property (assign) NSInteger todolistId;
@property (weak) id<OperationProtocol> delegate;

@end
