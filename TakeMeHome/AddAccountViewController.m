//
//  AddAccountViewController.m
//  TakeMeHome
//
//  Created by Josh on 2015/8/25.
//  Copyright (c) 2015年 Josh. All rights reserved.
//

#import "AddAccountViewController.h"
#import <Parse/Parse.h>
#import "MBProgressHUD.h"
#import <ParseFacebookUtilsV4/PFFacebookUtils.h>



@interface AddAccountViewController ()<MBProgressHUDDelegate>
{
    MBProgressHUD *HUD;
}
@property (weak, nonatomic) IBOutlet UITextField *userNameText;
@property (weak, nonatomic) IBOutlet UITextField *userEmailText;
@property (weak, nonatomic) IBOutlet UITextField *userPassWordText;
@property (weak, nonatomic) IBOutlet UITextField *checkPassWord;

@end

@implementation AddAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)addAccountBtnPressed:(id)sender {
    
    //Loading圖示
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.delegate = self;
    HUD.labelText = @"Loading";
    [HUD show:YES];
    
    
    
    PFUser *user = [PFUser user];
    user.username = _userNameText.text;
    user.password = _userPassWordText.text;
    user.email =_userEmailText.text;
    NSString*password=_userPassWordText.text;
    NSString*checkPassword=_checkPassWord.text;
    // other fields can be set just like with PFObject
    
    if (_userPassWordText.text.length<6)
    {
        NSLog(@"密碼至少6位數");
        [HUD hide:YES];
        
    }
    
    else
    {
    
        if ([password isEqualToString:checkPassword]) {
            [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (!error)
                {
                    // Hooray! Let them use the app now.
                    [self dismissViewControllerAnimated:true completion:nil];
                    NSLog(@"註冊成功");

                    [HUD hide:YES];

                }
                else
                {
                    NSString *errorString = [error userInfo][@"error"];
                    NSLog(@"%@",errorString);
                    // Show the errorString somewhere and let the user try again.
                    [HUD hide:YES];
                }
            }];
        }
        else
        {
            NSLog(@"密碼不同");
            [HUD hide:YES];
        }
    }

    
}
- (IBAction)backBtnPressed:(id)sender {
 [self.navigationController popViewControllerAnimated:true];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
