//
//  LostInfoView.h
//  TakeMeHome
//
//  Created by Josh on 2015/9/1.
//  Copyright (c) 2015年 Josh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "BaseViewController.h"


@interface LostInfoView : BaseViewController
@property(weak,nonatomic)PFObject *lostPostInfo;
#define LOST_NEW_PHOTO_FIRST_NOTIFICATION @"LOST_PHOTO_FIRST_NOTIFICATION"
#define LOST_NEW_PHOTO_SECOND_NOTIFICATION @"LOST_PHOTO_SECOND_NOTIFICATION"
#define LOST_POST_INFO_NOTIFICATION @"LOST_POST_INFO_NOTIFICATION"

@end
