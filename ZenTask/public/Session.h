//
//  Session.h
//  ZenTask
//
//  Created by GoldRatio on 5/26/14.
//  Copyright (c) 2014 GoldRatio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Session : NSObject{
    NSArray *projects;
    NSInteger teamId;
}

@property(retain) NSArray *projects;
@property(assign) NSInteger teamId;
+(Session *)getInstance;

@end
