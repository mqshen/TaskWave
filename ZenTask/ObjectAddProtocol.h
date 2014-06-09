//
//  ObjectAddProtocol.h
//  ZenTask
//
//  Created by GoldRatio on 5/31/14.
//  Copyright (c) 2014 GoldRatio. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum {
    TODO,
    TODO_LIST,
    MESSAGE,
    COMMENT
} ObjectType;

@protocol ObjectAddProtocol <NSObject>

-(void) addObject:(id) object withType:(ObjectType) type;

-(void) updateObject:(id) object withType:(ObjectType) type;

@end
