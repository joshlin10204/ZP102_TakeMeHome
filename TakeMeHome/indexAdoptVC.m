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


@interface indexAdoptVC ()

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

@end
