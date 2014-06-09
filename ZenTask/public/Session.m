//
//  Session.m
//  ZenTask
//
//  Created by GoldRatio on 5/26/14.
//  Copyright (c) 2014 GoldRatio. All rights reserved.
//

#import "Session.h"


@implementation Session

@synthesize projects;
@synthesize teamId;

//获取单例
+(Session *)getInstance
{
    static Session *instance = nil;
    @synchronized(self) {
        if (instance == nil)
            instance = [[self alloc] init];
    }
    return instance;
}


@end
