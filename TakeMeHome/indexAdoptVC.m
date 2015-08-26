//
//  indexAdoptVC.m
//  TakeMeHome
//
//  Created by Nigel on 2015/8/26.
//  Copyright (c) 2015年 Josh. All rights reserved.
//

#import "indexAdoptVC.h"
#import "searchOptionVC.h"


@interface indexAdoptVC ()

@end

@implementation indexAdoptVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

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
