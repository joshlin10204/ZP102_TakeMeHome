//
//  postViewVC.m
//  TakeMeHome
//
//  Created by Nigel on 2015/8/28.
//  Copyright (c) 2015年 Josh. All rights reserved.
//

#import "postViewVC.h"

@interface postViewVC ()

@end

@implementation postViewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)myPhotoImgLeft:(UIButton*)sender {
    if (sender.tag == 1000) {//left btn
        //do select take photo or switch photo
        NSLog(@"left");
    }else{//right btn
        NSLog(@"right");
    }
}



@end
