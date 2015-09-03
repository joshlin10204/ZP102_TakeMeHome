//
//  LostMainController.m
//  TakeMeHome
//
//  Created by Josh on 2015/7/28.
//  Copyright (c) 2015年 Josh. All rights reserved.
//

#import "LostMainController.h"
#import <Parse/Parse.h>
#import "HHAlertView.h"


@interface LostMainController ()
{
    UIView   *maskView;
    PFUser *currentUser;

}
@property (weak, nonatomic) IBOutlet UIImageView *lockImage;

@end

@implementation LostMainController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    currentUser = [PFUser currentUser];
    if (currentUser)
    {
        _lockImage.hidden=YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)lostPostBtnPressed:(id)sender
{
    if (currentUser)
    {

        [self performSegueWithIdentifier:@"goLostPost" sender:nil];
    }
    else
    {
        [self.view addSubview:self.addmaskView];
        [[HHAlertView shared]
         showAlertWithStyle:HHAlertStyleWraning
         inView:self.view
         Title:@"提醒"
         detail:@"訪客無法使用"
         cancelButton:nil
         Okbutton:@"關閉"
         block:^(HHAlertButton buttonindex) {
             [maskView removeFromSuperview];
             
         }
         ];
        
        
    }

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
