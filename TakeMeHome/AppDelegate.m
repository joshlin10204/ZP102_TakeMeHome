//
//  AppDelegate.m
//  TakeMeHome
//
//  Created by Josh on 2015/7/23.
//  Copyright (c) 2015年 Josh. All rights reserved.
//

#import "AppDelegate.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <Parse/Parse.h>
#import <ParseFacebookUtilsV4/PFFacebookUtils.h>
#import "UIColor+FlatUI.h"


@interface AppDelegate ()
{

    UILabel * alertLabel;

}


@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    //return YES;
    
    [Parse enableLocalDatastore];
    
    [Parse setApplicationId:@"ZKL6eUpTZej0mt97yRNHnVGC8rNdir77sncvTMcs"
                  clientKey:@"UU0cvcAMlp3mRKAG8MP9QlF3wSgHsGiDMLDIUNzR"];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
        [PFFacebookUtils initializeFacebookWithApplicationLaunchOptions:launchOptions];
    
    [self registerAPNS];
    
    
    if(googleReach==nil)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkReachabilityChanged:) name:kReachabilityChangedNotification object:nil];
        
        googleReach=[Reachability reachabilityWithHostName:@"google.com"] ;
        [googleReach startNotifier];
    }
    
    
//    [Parse setApplicationId:@"parseAppId" clientKey:@"parseClientKey"];
//    [PFFacebookUtils initializeFacebookWithApplicationLaunchOptions:launchOptions];


    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                    didFinishLaunchingWithOptions:launchOptions];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.

    [FBSDKAppEvents activateApp];

}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation];
}


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Store the deviceToken in the current installation and save it to Parse.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    [currentInstallation saveInBackground];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [PFPush handlePush:userInfo];
}


- (void) registerAPNS{
    UIApplication *app = [UIApplication sharedApplication];
    //請問支援這個方法嗎？
    if ([app respondsToSelector:@selector(registerForRemoteNotificationTypes:)]) {
        
        //iOS8 and latter
        UIUserNotificationType type =
        UIUserNotificationTypeAlert |  // | 就是or的意思 與||的差別在於 ||為運算符號的or
        UIUserNotificationTypeBadge |
        UIUserNotificationTypeSound ;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:type categories:nil];
        
        [app registerUserNotificationSettings:settings];
        [app registerForRemoteNotifications];
        
    }else{
        //Before iOS8
        
        UIRemoteNotificationType type =
        UIRemoteNotificationTypeAlert |  // | 就是or的意思 與||的差別在於 ||為邏輯運算符號的or
        UIRemoteNotificationTypeBadge |
        UIRemoteNotificationTypeSound ;
        //有黃色警告是因為此方法apple已經停用了
        //但是為了ios7的user 所以仍要使用
        
        [app registerForRemoteNotifications];
      
    }
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    NSLog(@"APNS Register Fail : %@" ,error.description);
    
}

- (void) networkReachabilityChanged:(NSNotification*)note
{
    //Reachability *curReach=[note object];
    
    NetworkStatus netStatus = [[note object] currentReachabilityStatus];
    
    NSLog(@"Net Status: %d",netStatus);
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.height;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.width;
    
    
    if (!alertLabel) {
        alertLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0 , screenWidth, screenHeight/5)];
        alertLabel.backgroundColor = [UIColor alizarinColor];
        alertLabel.text = @"請確認您的網路狀態哦!!";
        //alertLabel.alignmentRectInsets = ;
    }
    
    UIView *test =  self.window.subviews.lastObject;
   
    NSLog(@"TEST = %@",test);
    
    
    
    switch (netStatus) {
        case NotReachable:
             [test addSubview:alertLabel];
            NSLog(@"no");
            break;
        case ReachableViaWiFi:
            [alertLabel removeFromSuperview];
            NSLog(@"WIFI");
            break;
        case ReachableViaWWAN:
            [alertLabel removeFromSuperview];
            NSLog(@"3G");
            break;
            
        default:
            break;
    }
    
    
}


@end
