//
//  AppDelegate.m
//  ZenTask
//
//  Created by GoldRatio on 5/25/14.
//  Copyright (c) 2014 GoldRatio. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "KeyBoardTopBar.h"
#import "CalendarViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window makeKeyAndVisible];
    
    LoginViewController *vc = [[LoginViewController alloc] init];
    //CalendarViewController *vc = [[CalendarViewController alloc] init];
    
    
    //leftMenu.view.backgroundColor = [UIColor blueColor];
	
    
    
    self.window.rootViewController = vc;
    
    
    UIColor *navigationColor = NAVBAR_COLOR;
    
    [[UINavigationBar appearance] setBarTintColor:navigationColor];
    [[UINavigationBar appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
	
    // Override point for customization after application launch.
    self.window.tintColor = [UIColor whiteColor];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardWillChange:)
//                                                 name:UIKeyboardWillChangeFrameNotification
//                                               object:nil];
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidChangeFrame:) name:UIKeyboardDidChangeFrameNotification object:nil];
    
    return YES;
}
//
//- (void) keyboardWillChange:(NSNotification *) notification
//{
//    KeyBoardTopBar *keyboardbar = [KeyBoardTopBar getInstance];
//    if (![keyboardbar isShown]) {
//        return;
//    }
//    
//    // Get the keyboard rect
//    CGRect kbBeginrect = [[[notification userInfo]
//                           objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
//    CGRect kbEndrect   = [[[notification userInfo]
//                           objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
//    NSTimeInterval duration = [[[notification userInfo]
//                                
//                                objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
//    UIViewAnimationCurve curve = (UIViewAnimationCurve)[[notification userInfo]
//                                                        objectForKey:UIKeyboardAnimationCurveUserInfoKey];
//    
//    // set animation
//    CGRect rect = keyboardbar.view.frame;
//    double height_change = kbEndrect.origin.y - kbBeginrect.origin.y ;
//    rect.origin.y += height_change;
//    
//    [UIView beginAnimations:nil context:NULL];
//    [UIView setAnimationDuration:duration];
//    [UIView setAnimationCurve:curve];
//    keyboardbar.view.frame = rect;
//
//    //[keyboardbar showBar:textView];
//}
//
//-(void)keyboardDidChangeFrame:(NSNotification*)notification
//{
//    [UIView commitAnimations];
//}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
