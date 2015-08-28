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
#import <ParseFacebookUtilsV4/PFFacebookUtils.h>
#import "HHAlertView.h"
#import "MBProgressHUD.h"




@interface ViewController ()<MBProgressHUDDelegate>
{
    UIView   *maskView;
    MBProgressHUD *HUD;

}
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
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser) {
        // do stuff with the user
        NSLog(@"currentUser: %@ ",currentUser);
        [self performSegueWithIdentifier:@"goMain" sender:nil];
    }

}

//按下訪客按鈕
- (IBAction)visitLogInPressed:(id)sender {
     [self performSegueWithIdentifier:@"goMain" sender:nil];
}

//按下臉書按鈕
- (IBAction)fblogInPressed:(id)sender {
    
    
    [PFFacebookUtils logInInBackgroundWithReadPermissions:@[@"public_profile",@"email"] block:^(PFUser *user, NSError *error) {
        if (!user)
        {
            NSLog(@"Uh oh. The user cancelled the Facebook login.");
        }
        else if (user.isNew)
        {
            NSLog(@"User signed up and logged in through Facebook!");
            
            [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields":@"email,name,gender,locale, picture.type(large)"}]
             startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, NSDictionary *results, NSError *error) {
                 
                 NSURL *profilePictureURL = [NSURL URLWithString: results[@"picture"][@"data"][@"url"]];
                 NSData *profilePictureData = [NSData dataWithContentsOfURL:profilePictureURL];
                 PFFile *userPhoto = [PFFile fileWithName:@"userPhoto.jpeg" data:profilePictureData];
                 user.username=[results objectForKey:@"email"];
                 user[@"name"]=[results objectForKey:@"name"];
                 user[@"userPhoto"]=userPhoto;
                 
                 
                [user saveInBackground];
                [self performSegueWithIdentifier:@"goMain" sender:nil];
                 
                 
             }];
        
        }
        else {
            NSLog(@"User logged in through Facebook!");
            [self performSegueWithIdentifier:@"goMain" sender:nil];

        }
    }];

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
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.delegate = self;
    HUD.labelText = @"Loading";
    [HUD show:YES];
    
    [PFUser logInWithUsernameInBackground:_accoundText.text
                                 password:_passwordText.text
                                    block:^(PFUser *user, NSError *error) {
                                    if (user)
                                    {
                                        [HUD hide:YES];
                                            // Do stuff after successful login.
                                        [self performSegueWithIdentifier:@"goMain" sender:nil];

                                            
                                    }
                                    else
                                    {
                                            // The login failed. Check error to see why.
                                        NSLog(@"登入失敗：%@",error);
                                        [HUD hide:YES];
                                        
                                        [self.view addSubview:self.addmaskView];
                                        [[HHAlertView shared]
                                         showAlertWithStyle:HHAlertStyleError
                                         inView:self.view
                                         Title:@"登入失敗"
                                         detail:@"帳號或密碼有錯唷！"
                                         cancelButton:nil
                                         Okbutton:@"關閉"
                                         block:^(HHAlertButton buttonindex) {
                                             [maskView removeFromSuperview];

                                        }
                                         ];

                                        }
                                    }];
}

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




@end
