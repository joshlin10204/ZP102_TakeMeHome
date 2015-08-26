//
//  ViewController.m
//  TakeMeHome
//
//  Created by Josh on 2015/7/23.
//  Copyright (c) 2015年 Josh. All rights reserved.
//

#import "ViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <Parse/Parse.h>
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *accoundText;
@property (weak, nonatomic) IBOutlet UITextField *passwordText;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.


    
}
-(void)viewDidAppear:(BOOL)animated
{
    //檢查判斷是否已登入
    if ([FBSDKAccessToken currentAccessToken]) {
        // User is logged in, do work such as go to next view controller.
        NSLog(@"viewDidAppear 已登入");
        [self performSegueWithIdentifier:@"goMain" sender:nil];
        
    }
    

}

//按下訪客按鈕
- (IBAction)visitLogInPressed:(id)sender {
     [self performSegueWithIdentifier:@"goMain" sender:nil];
}

//按下臉書按鈕
- (IBAction)fblogInPressed:(id)sender {

    FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
    
    if ([FBSDKAccessToken currentAccessToken]) {
        // User is logged in, do work such as go to next view controller.
        NSLog(@"FBSDKAccessToken 已登入");
        
        //轉至其它畫面...
        [self performSegueWithIdentifier:@"goMain" sender:nil];

        
    }else{
        
        //未登入
        [loginManager logInWithReadPermissions:@[@"public_profile",@"email"] handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
            //當出現錯誤
            if (error)
            {
                NSLog(@"Error");
            }
            //當使用者按下取消
            else if (result.isCancelled)
            {
                NSLog(@"Cancelled");
            }
            //當使用者按下同意
            else{

            [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields":@"email,name,gender,locale"}]
             startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, NSDictionary *results, NSError *error) {
                 NSLog(@"results: %@",results);
                 NSLog(@"email:%@",[results objectForKey:@"email"]);
                 
                 [self performSegueWithIdentifier:@"goMain" sender:nil];
                 
             }];
            }
            
        }];
        }
    
//    [PFFacebookUtils logInInBackgroundWithReadPermissions:@[@"public_profile",@"email"] block:^(PFUser *user, NSError *error) {
//        if (!user) {
//            NSLog(@"Uh oh. The user cancelled the Facebook login.");
//        } else if (user.isNew) {
//            NSLog(@"User signed up and logged in through Facebook!");
//        } else {
//            NSLog(@"User logged in through Facebook!");
//        }
//    }];

}

//FB按鈕例外（不加會不認得SDk）
- (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [FBSDKLoginButton class];
    [FBSDKProfilePictureView class];
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//LogIn 按鈕
- (IBAction)loginBtnPressed:(id)sender {
    
    [PFUser logInWithUsernameInBackground:_accoundText.text
                                 password:_passwordText.text
                                    block:^(PFUser *user, NSError *error) {
                                    if (user)
                                    {
                                            // Do stuff after successful login.
                                        [self performSegueWithIdentifier:@"goMain" sender:nil];

                                            
                                    }
                                    else
                                    {
                                            // The login failed. Check error to see why.

                                            NSLog(@"登入失敗：%@",error);
                                            
                                        }
                                    }];
}



@end
