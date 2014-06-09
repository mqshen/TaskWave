//
//  HttpConnection.h
//  WeChat
//
//  Created by GoldRatio on 3/7/14.
//  Copyright (c) 2014 GoldRatio. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"
#import <arpa/inet.h>

@interface HttpConnection : NSObject <NSURLConnectionDelegate,NSURLConnectionDataDelegate,MBProgressHUDDelegate>
{
}

+ (void)initWithRequestURL:(NSString *)urlString
                httpMethod: (NSString *) httpMethod
               requestDate:(NSDictionary *)reqParams
             successAction:(void (^)(id response)) handler;
//- (id)initWithRequestURL:(NSString *)url params:(NSDictionary *)reqDic target:(id)__target successAction:(SEL)action
//            failedAction:(SEL)failedAction withSession:(BOOL)sessionFlag withWait:(BOOL)waitFlag;

@end
