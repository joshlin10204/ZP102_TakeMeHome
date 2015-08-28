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
#import "SCLAlertView.h"



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
            
            [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields":@"email,name,gender,locale"}]
             startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, NSDictionary *results, NSError *error) {
                 NSLog(@"results: %@",results);
                 NSLog(@"email:%@",[results objectForKey:@"email"]);
                 NSLog(@"name:%@",[results objectForKey:@"name"]);

                 user.username=[results objectForKey:@"email"];
                 user[@"name"]=[results objectForKey:@"name"];

                 [user save];
                 
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

                                        SCLAlertView *alert = [[SCLAlertView alloc] init];
                                        
                                        [alert showSuccess:self title:@"Hello World" subTitle:@"This is a more descriptive text." closeButtonTitle:@"Done" duration:0.0f];
                                        
                                        // Alternative alert types
                                        [alert showError:self title:@"Hello Error" subTitle:@"This is a more descriptive error text." closeButtonTitle:@"OK" duration:0.0f];
                                        }
                                    }];
}



@end
