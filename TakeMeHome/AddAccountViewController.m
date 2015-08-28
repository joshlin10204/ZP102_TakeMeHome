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




@interface AddAccountViewController ()<MBProgressHUDDelegate,UITextFieldDelegate>
{
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
    NSString*password=_userPassWordText.text;
    NSString*checkPassword=_checkPassTextWord.text;
    // other fields can be set just like with PFObject
    
    if(![self validateEmail:_userAccountText.text]) {
        // user entered invalid email address
        NSLog(@"信箱有錯");
        [HUD hide:YES];
        
    }
    else if (_userPassWordText.text.length<6)
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
-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    //當有如按下Return key 的時候
    [textField resignFirstResponder];
    //使用著第一個點取的元件 稱之為FirstResponder
    //resignFirstResponder, 當使用者點選的元件是可以輸入文字的時候
    return false;
}
- (BOOL)validateEmail:(NSString *)emailStr {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:emailStr];
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
