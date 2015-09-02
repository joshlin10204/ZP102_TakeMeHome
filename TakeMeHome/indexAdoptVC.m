//
//  indexAdoptVC.m
//  TakeMeHome
//
//  Created by Nigel on 2015/8/26.
//  Copyright (c) 2015年 Josh. All rights reserved.
//

#import "indexAdoptVC.h"
#import "searchOptionVC.h"
#import "adoptView.h"
#import <Parse/Parse.h>
#import "HHAlertView.h"


@interface indexAdoptVC ()
{

     UIView   *maskView;

}
@end

@implementation indexAdoptVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(UserPressedOkBtn:) name:USER_PRESSED_OK_BTN_NOTIFICATION object:nil];
    
    
}

//- (void)navigationPushView{
//    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"adopt" bundle:nil];
//    id targetViewController = [storyboard instantiateViewControllerWithIdentifier:@"adoptView"];
//    //adoptView *nextVC = targetViewController;
//    //nextVC.getUserOptionsFilterDoneStr = filterSearchDoneStr;
//    NSLog(@"will push");
//    [self.navigationController pushViewController:targetViewController animated:true];
//
//}


- (void)UserPressedOkBtn:(NSNotification*)notify{
    
    
    
    NSLog(@"notify = %@",notify);
    NSLog(@"object = %@",notify.object);
    
    NSString *content = notify.object;
    //vc.

    //do push
 //   [self performSelector:@selector(navigationPushView) withObject:nil afterDelay:5];
    
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"adopt" bundle:nil];
    id targetViewController = [storyboard instantiateViewControllerWithIdentifier:@"adoptView"];
    adoptView *nextVC = targetViewController;
    nextVC.getUserOptionsFilterDoneStr = content;
    NSLog(@"will push");
    [self.navigationController pushViewController:targetViewController animated:true];
    

    
    
}

- (void) viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)searchBtnPressed:(id)sender {
    
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"adopt" bundle:nil];
    UIViewController *targetViewController = [storyboard instantiateViewControllerWithIdentifier:@"searchVC"];
    
    targetViewController.modalPresentationStyle = UIModalPresentationOverFullScreen;
    
    [self presentViewController:targetViewController animated:true completion:nil];
    
}

- (IBAction)postBtnPressed:(id)sender {
    id targetViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"postViewVC"];
    [self.navigationController pushViewController:targetViewController animated:true];

    
    /*
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser)
    {
        // do stuff with the user
        id targetViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"postViewVC"];
        [self.navigationController pushViewController:targetViewController animated:true];
    }
    else
    {
        [self.view addSubview:self.addmaskView];
        [[HHAlertView shared]showAlertWithStyle:HHAlertStyleWraning
                                         inView:self.view
                                          Title:@"提醒"
                                         detail:@"訪客無法使用"
                                   cancelButton:@"註冊" // index = 1
                                       Okbutton:@"確定" //index = 0
                                          block:^(HHAlertButton buttonindex) {
                                              NSLog(@"%d",buttonindex);
                                              [maskView removeFromSuperview];
                                              if (buttonindex == 1) { //preseed regitst
                                                  UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"" bundle:nil];
                                                  id targetViewController = [storyboard instantiateViewControllerWithIdentifier:@""];
                                                  [self.navigationController pushViewController:targetViewController animated:true];
                                              }
                                          }
         ];
        
        
    }
*/

}

- (UIView *)addmaskView
{
    if (!maskView) {
        maskView = [[UIView alloc] initWithFrame:self.view.frame];
        [maskView setBackgroundColor:[UIColor blackColor]];
        [maskView setAlpha:0.2];
    }
    return maskView;
    
}



@end
