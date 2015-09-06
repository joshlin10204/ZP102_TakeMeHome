//
//  settingIndexTVC.m
//  TakeMeHome
//
//  Created by Nigel on 2015/9/3.
//  Copyright (c) 2015年 Josh. All rights reserved.
//

#import "settingIndexTVC.h"
#import "navigationBtn.h"

#define NAVIGATION_BTN_DOG 1000
#define NAVIGATION_BTN_OWL 1001

#define NAVIGATION_IMG_DOG_NAME @"DogNavibtn.png"
#define NAVIGATION_IMG_OWL_NAME @"naviOwl.png"

@interface settingIndexTVC ()<NavigationBtnObjecterDelegate>
{
    navigationBtn *naviClass;
}
@property (weak, nonatomic) IBOutlet UISwitch *naviBtnDog;
@property (weak, nonatomic) IBOutlet UISwitch *naviBtnOwl;

@end

@implementation settingIndexTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    naviClass = [navigationBtn shareInstance];
    
}

- (IBAction)naviBtnSwitch:(UISwitch*)sender {
    
    if (sender.tag == NAVIGATION_BTN_DOG) {
        if ([sender isOn]) {
            [_naviBtnOwl setOn:NO animated:YES];
            [naviClass BtnImgSetting:NAVIGATION_IMG_DOG_NAME];
        }else{
            [_naviBtnOwl setOn:YES animated:YES];
            [naviClass BtnImgSetting:NAVIGATION_IMG_OWL_NAME];
        }
    }else{ //NAVIGATION_BTN_OWL
        if ([sender isOn]) {
            [_naviBtnDog setOn:NO animated:YES];
            [naviClass BtnImgSetting:NAVIGATION_IMG_OWL_NAME];
        }else{
            [_naviBtnDog setOn:YES animated:YES];
            [naviClass BtnImgSetting:NAVIGATION_IMG_DOG_NAME];
        }
    }

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
