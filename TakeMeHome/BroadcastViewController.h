//
//  BroadcastViewController.h
//  takemehomeagain
//
//  Created by tainan boom on 2015/8/5.
//  Copyright (c) 2015年 tainan boom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface BroadcastViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>

{
    NSMutableArray *list1;
    NSMutableArray *list2;

}
@end
