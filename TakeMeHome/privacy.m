//
//  settingIndex.m
//  TakeMeHome
//
//  Created by Nigel on 2015/9/3.
//  Copyright (c) 2015年 Josh. All rights reserved.
//

#import "privacy.h"

@interface privacy ()

@end

@implementation privacy

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)okBtnPressed:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}


@end
