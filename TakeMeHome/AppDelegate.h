//
//  AppDelegate.h
//  TakeMeHome
//
//  Created by Josh on 2015/7/23.
//  Copyright (c) 2015年 Josh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{

    Reachability *googleReach;

}

@property (strong, nonatomic) UIWindow *window;


@end

