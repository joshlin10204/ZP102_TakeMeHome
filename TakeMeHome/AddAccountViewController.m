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
#import "HHAlertView.h"





@interface AddAccountViewController ()<MBProgressHUDDelegate,UITextFieldDelegate>
{
    UIView   *maskView;
    MBProgressHUD *HUD;
}
@property (weak, nonatomic) IBOutlet UITextField *userAccountText;
@property (weak, nonatomic) IBOutlet UITextField *userPassWordText;
@property (weak, nonatomic) IBOutlet UITextField *checkPassTextWord;

@end

@implementation AddAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _userAccountText.delegate=self;
    _userPassWordText.delegate=self;
    _checkPassTextWord.delegate=self;
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
    user.username = _userAccountText.text;
    user.password = _userPassWordText.text;
    user[@"email"] = _userAccountText.text;
    NSString*password=_userPassWordText.text;
    NSString*checkPassword=_checkPassTextWord.text;
    // other fields can be set just like with PFObject
    
    if(![self validateEmail:_userAccountText.text]) {
        // user entered invalid email address
        NSLog(@"");
        
        [self.view addSubview:self.addmaskView];
        [[HHAlertView shared]
         showAlertWithStyle:HHAlertStyleWraning
         inView:self.view
         Title:@"提醒"
         detail:@"信箱不正確唷！"
         cancelButton:nil
         Okbutton:@"關閉"
         block:^(HHAlertButton buttonindex) {
             [maskView removeFromSuperview];
             
         }
         ];
        [HUD hide:YES];
        
    }
    else if (_userPassWordText.text.length<6)
    {
        
        [self.view addSubview:self.addmaskView];
        [[HHAlertView shared]
         showAlertWithStyle:HHAlertStyleWraning
         inView:self.view
         Title:@"提醒"
         detail:@"密碼至少六位數"
         cancelButton:nil
         Okbutton:@"關閉"
         block:^(HHAlertButton buttonindex) {
             [maskView removeFromSuperview];
             
         }
         ];
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
                    [self.view addSubview:self.addmaskView];
                    [[HHAlertView shared]
                     showAlertWithStyle:HHAlertStyleOk
                     inView:self.view
                     Title:@"註冊成功"
                     detail:@"完成註冊！"
                     cancelButton:nil
                     Okbutton:@"登入"
                     block:^(HHAlertButton buttonindex) {
                         [maskView removeFromSuperview];
                         [self performSegueWithIdentifier:@"goMain" sender:nil];
                         
                     }
                     ];

                    [HUD hide:YES];

                }
  
                else
                {
                    NSNumber *errorString = [error userInfo][@"code"];
                    NSNumber *error202= [NSNumber numberWithInt:202];
                    NSNumber *error100= [NSNumber numberWithInt:100];
                    if ([errorString isEqual:error202])
                    {
                        NSLog(@"error code：%@",[error userInfo][@"code"]);
                        [self.view addSubview:self.addmaskView];
                        [[HHAlertView shared]
                         showAlertWithStyle:HHAlertStyleWraning
                         inView:self.view
                         Title:@"提醒"
                         detail:@"此帳號已被申請，請換一個帳號"
                         cancelButton:nil
                         Okbutton:@"關閉"
                         block:^(HHAlertButton buttonindex) {
                             [maskView removeFromSuperview];
                             
                         }
                         ];

                    }
                    else if ([errorString isEqual:error100])
                    {

                        [self.view addSubview:self.addmaskView];
                        [[HHAlertView shared]
                         showAlertWithStyle:HHAlertStyleError
                         inView:self.view
                         Title:@"注意"
                         detail:@"請檢查您的網路狀態"
                         cancelButton:nil
                         Okbutton:@"關閉"
                         block:^(HHAlertButton buttonindex) {
                             [maskView removeFromSuperview];
                             
                         }
                         ];

                        
                    }
                    else
                    {
                        [self.view addSubview:self.addmaskView];
                        [[HHAlertView shared]
                         showAlertWithStyle:HHAlertStyleError
                         inView:self.view
                         Title:@"注意"
                         detail:@"註冊失敗"
                         cancelButton:nil
                         Okbutton:@"關閉"
                         block:^(HHAlertButton buttonindex) {
                             [maskView removeFromSuperview];
                             
                         }
                         ];
 
                        
                    }
                    [HUD hide:YES];
                }
            }];
        }
        else
        {

            [self.view addSubview:self.addmaskView];
            [[HHAlertView shared]
             showAlertWithStyle:HHAlertStyleWraning
             inView:self.view
             Title:@"提醒"
             detail:@"兩次密碼不相同"
             cancelButton:nil
             Okbutton:@"關閉"
             block:^(HHAlertButton buttonindex) {
                 [maskView removeFromSuperview];
                 
             }
             ];

            [HUD hide:YES];
        }
    }

    
}
-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    //當有如按下Return key 的時候
    [textField resignFirstResponder];
    //使用著第一個點取的元件 稱之為FirstResponder
    //resignFirstResponder, 當使用者點選的元件是可以輸入文字的時候
    return false;
}
//判斷email格式
- (BOOL)validateEmail:(NSString *)emailStr {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:emailStr];
}
//建立一個霧透的背景
- (UIView *)addmaskView
{
    if (!maskView) {
        maskView = [[UIView alloc] initWithFrame:self.view.bounds];
        [maskView setBackgroundColor:[UIColor blackColor]];
        [maskView setAlpha:0.2];
        NSLog(@"New maskView");
    }
    return maskView;
}

//返回按鈕
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
