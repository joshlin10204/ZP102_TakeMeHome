//
//  BaseViewController.m
//  TakeMeHome
//
//  Created by Nigel on 2015/7/31.
//  Copyright (c) 2015年 Josh. All rights reserved.
//

#import "BaseViewController.h"
#import "navigationBtn.h"

@interface BaseViewController ()<NavigationBtnObjecterDelegate>
{
    navigationBtn *naviClass;
}


@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    naviClass = [navigationBtn shareInstance];
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:false];
    [self NavigationBtnObjecterShoudDisplay:self];
    [naviClass setDelegate:self];    
}

-(UIViewController *)attachedViewController
{
    return self;
}
- (BOOL)NavigationBtnObjecterShoudDisplay:(UIViewController*)VC{
    naviClass.parentVC = VC;
    return  true;
}


@end
