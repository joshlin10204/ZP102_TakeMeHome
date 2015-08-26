//
//  LostMoreInformationView.h
//  TakeMeHome
//
//  Created by Josh on 2015/8/18.
//  Copyright (c) 2015年 Josh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LostMapView.h"
#import "MBProgressHUD.h"


#define LOST_INFORMATION_DATA_NOTIFICATION @"LOST_INFORMATION_DATA_NOTIFICATION"

@interface LostMoreInformationView : UIViewController
@property (weak, nonatomic) NSString *objectId;


@end
