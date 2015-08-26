//
//  navigationBtn.h
//  testDelegateDragBtn
//
//  Created by Nigel on 2015/7/29.
//  Copyright (c) 2015年 Nigel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CTPopOutMenu.h"

@protocol NavigationBtnObjecterDelegate <NSObject>
//- (BOOL)NavigationBtnObjecterShoudDisplay:(UIViewController*)VC;
//- (void)buttonDidPress;
- (UIViewController*)attachedViewController;
@end
@interface navigationBtn : NSObject <NavigationBtnObjecterDelegate,CTPopoutMenuDelegate>
@property (weak,nonatomic)id<NavigationBtnObjecterDelegate>delegate;
@property (nonatomic)CTPopoutMenu *popMenu;
@property (nonatomic)UIButton* naviBtn;

@property (strong,nonatomic)UIViewController* parentVC;
+(instancetype)shareInstance;



@end
