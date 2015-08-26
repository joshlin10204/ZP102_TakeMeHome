//
//  adoptProfileVC.h
//  TakeMeHome
//
//  Created by Nigel on 2015/8/3.
//  Copyright (c) 2015年 Josh. All rights reserved.
//

#import "BaseViewController.h"

@interface adoptProfileVC : BaseViewController
@property (strong, nonatomic) IBOutlet UILabel *labelName;


- (void)getLabelID:(NSString*)Id;
@end
