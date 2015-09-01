//
//  UserInfoTableView.m
//  TakeMeHome
//
//  Created by Josh on 2015/8/30.
//  Copyright (c) 2015年 Josh. All rights reserved.
//

#import "UserInfoTableView.h"
#import <Parse/Parse.h>
#import "MBProgressHUD.h"



@interface UserInfoTableView ()<MBProgressHUDDelegate>
{
    PFUser *currentUser;
    MBProgressHUD *HUD;


}
@property (weak, nonatomic) IBOutlet UITextField *userNameText;
@property (weak, nonatomic) IBOutlet UITextField *userEmailText;
@property (weak, nonatomic) IBOutlet UITextField *userPhoneText;

@end

@implementation UserInfoTableView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //判斷當前使用者
    currentUser = [PFUser currentUser];
    if (currentUser)
    {
        // do stuff with the user
        NSLog(@"currentUser: %@ ",currentUser);
        _userEmailText.text=currentUser[@"email"];

        if (currentUser[@"name"]!=nil)
        {
            _userNameText.text=currentUser[@"name"];

        }
        if (currentUser[@"userPhone"]!=nil)
        {
            _userPhoneText.text=currentUser[@"userPhone"];

        }
        
        
    }

    
    
    
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)saveBtnPressed:(id)sender {
    //Loading圖示
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.delegate = self;
    HUD.labelText = @"Loading";
    [HUD show:YES];
    
    currentUser[@"name"]=_userNameText.text;
    currentUser[@"email"]=_userEmailText.text;
    currentUser[@"userPhone"]=_userPhoneText.text;
    
    dispatch_queue_t download = dispatch_queue_create("Download", nil);
    
    dispatch_async(download, ^{
        [currentUser saveInBackground];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:true];


            [HUD hide:YES];
        });
    });


}
- (IBAction)backBtnPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:true];


}


@end
