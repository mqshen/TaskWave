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

+ (void)initWithRequestURL:(NSString *)url
           successAction:(void (^)(NSString* response)) successHandler;

//- (id)initWithRequestURL:(NSString *)url params:(NSDictionary *)reqDic target:(id)__target successAction:(SEL)action
//            failedAction:(SEL)failedAction withSession:(BOOL)sessionFlag withWait:(BOOL)waitFlag;

@end
