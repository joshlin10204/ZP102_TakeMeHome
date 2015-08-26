//
//  searchTVC.h
//  TakeMeHome
//
//  Created by Nigel on 2015/8/12.
//  Copyright (c) 2015年 Josh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface containerSearchTVC : UITableViewController
@property (strong, nonatomic) IBOutlet UITextField *txtFieldArea;
@property (strong , nonatomic) NSString *txtFieldAreaNum;

@property (strong, nonatomic) IBOutlet UIButton *btnCat;
@property (strong, nonatomic) IBOutlet UIButton *btnDog;


@property (strong, nonatomic) IBOutlet UIButton *btnChild;
@property (strong, nonatomic) IBOutlet UIButton *btnAdult;


@property (strong, nonatomic) IBOutlet UIButton *btnPersonal;
@property (strong, nonatomic) IBOutlet UIButton *btnGov;


@end
