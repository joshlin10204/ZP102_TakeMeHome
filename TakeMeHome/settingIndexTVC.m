//
//  settingIndexTVC.m
//  TakeMeHome
//
//  Created by Nigel on 2015/9/3.
//  Copyright (c) 2015年 Josh. All rights reserved.
//

#import "settingIndexTVC.h"
#import "navigationBtn.h"

@interface settingIndexTVC ()<NavigationBtnObjecterDelegate>
{
    navigationBtn *naviClass;
}

@end

@implementation settingIndexTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    naviClass = [navigationBtn shareInstance];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
