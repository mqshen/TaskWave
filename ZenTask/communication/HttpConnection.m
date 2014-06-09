//
//  HttpConnection.m
//  WeChat
//
//  Created by GoldRatio on 3/7/14.
//  Copyright (c) 2014 GoldRatio. All rights reserved.
//


#import "HttpConnection.h"
#import "Reachability.h"

#define HTTPREQUESTTIMEOUT 10.f

@interface  HttpConnection ()

@property (nonatomic, retain) NSTimer *timer;

//检查 设备是否 连接网络

@end

@implementation HttpConnection

static NSUInteger hudCount = 0;
static MBProgressHUD *hud;


+ (void)initWithRequestURL:(NSString *)urlString
                httpMethod: (NSString *) httpMethod
               requestDate:(NSDictionary *)reqParams
           successAction:(void (^)(id response)) handler
{
    
        if ([self connectedToNetwork]) {
            
            id<UIApplicationDelegate> appwindow = [UIApplication sharedApplication].delegate;
            
            if(hudCount++ == 0) {
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:appwindow.window animated:YES];
                hud.labelText = @"Loading";
            }
            NSString *urlRequestString = [SERVER_ADD stringByAppendingString:urlString];
            
            
            
            NSMutableString *dataString = [[NSMutableString alloc] initWithString:@""];
            if (reqParams != nil) {
                for (NSString *keyString in [reqParams allKeys]) {
                    id requestValue = [reqParams objectForKey:keyString];
                    if ([requestValue isKindOfClass:([NSArray class])]) {
                        NSArray *requestArray = (NSArray *)requestValue;
                        for (NSDictionary *deatil in requestArray) {
                            for (NSString *deatilKeyString in [deatil allKeys]) {
                                NSString *value = [deatil objectForKey:deatilKeyString];
                                NSString *keyAndValue = [NSString stringWithFormat:@"%@.%@=%@&", keyString, deatilKeyString, value];
                                [dataString appendString:keyAndValue];
                            }
                        }
                    }
                    else {
                        NSString *value = [reqParams objectForKey:keyString];
                        NSString *keyAndValue = [NSString stringWithFormat:@"%@=%@&",keyString,value];
                        [dataString appendString:keyAndValue];
                    }
                }
                /*
                 NSRange range = {0,[dataString length] -1};
                 NSString *postString = [dataString substringWithRange:range];
                 [dataString release];
                 */
            }
           
            if([httpMethod compare:@"get"] == 0) {
                urlRequestString = [[urlRequestString stringByAppendingString:@"?" ] stringByAppendingString:dataString];
            }
            
            NSURL *reqURL = [NSURL URLWithString:urlRequestString];
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:reqURL
                                                                   cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                               timeoutInterval:60.0];
            
            [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
            request.HTTPMethod = httpMethod;
            
            if ([httpMethod compare:@"post"] == 0) {
                if (reqParams != nil) {
                    NSData *requestBodyData = [dataString dataUsingEncoding:NSUTF8StringEncoding];
                    request.HTTPBody = requestBodyData;
                }
            }
            
            [NSURLConnection sendAsynchronousRequest:request
                                               queue:[NSOperationQueue mainQueue] 
                                   completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                                       if (--hudCount == 0) {
                                           [MBProgressHUD hideHUDForView:appwindow.window animated:YES];
                                       }
                                       if (data) {
                                           NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:data
                                                                                                       options:NSJSONReadingMutableContainers
                                                                                                         error:nil];
                                           NSString* newStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                           
                                           NSLog(@"response:%@", newStr);
                                           if([responseDic objectForKey:@"teamId"] == 0)
                                               handler([responseDic objectForKey:@"content"]);
                                       }
                                   }];
            
        }
        else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                                message:@"网络未连接,请检查您的网络。"
                                                               delegate:nil
                                                      cancelButtonTitle:nil
                                                      otherButtonTitles:@"确定", nil];
            [alertView show];
        }
        
}


- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    
    if (error) {
        NSString *errorString = [error localizedDescription];
        
        UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:nil message:errorString delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [errorAlertView show];
    }
}

- (void) showAlert:(NSString *)errorMsg
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:errorMsg delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alertView show];
}

+ (BOOL) connectedToNetwork
{
    //创建零地址，0.0.0.0的地址表示查询本机的网络连接状态
    struct sockaddr_in zeroAddress;
    
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    
    // Recover reachability flags
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    
    //获得连接的标志
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    
    CFRelease(defaultRouteReachability);
    
    //如果不能获取连接标志，则不能连接网络，直接返回
    if (!didRetrieveFlags)
    {
        return NO;
    }
    
    //根据获得的连接标志进行判断
    BOOL isReachable = flags & kSCNetworkFlagsReachable;
    BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
    return (isReachable && !needsConnection) ? YES : NO;
}

//add for https certif
- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
    return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust])
        //if ([trustedHosts containsObject:challenge.protectionSpace.host])
        [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust]
             forAuthenticationChallenge:challenge];
    
    [challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
}

@end