//
//  LostInfoView.m
//  TakeMeHome
//
//  Created by Josh on 2015/9/1.
//  Copyright (c) 2015年 Josh. All rights reserved.
//

#import "LostInfoView.h"
#import "MemberSetViewTableView.h"


@interface LostInfoView ()

@end

@implementation LostInfoView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSLog(@"接收 ：%@",_lostPostInfo);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
