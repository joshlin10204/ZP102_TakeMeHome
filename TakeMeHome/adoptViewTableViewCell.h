//
//  adoptViewTableViewCell.h
//  TakeMeHome
//
//  Created by Nigel on 2015/8/3.
//  Copyright (c) 2015年 Josh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIColor+FlatUI.h"
#import "SSBouncyButton.h"

@interface adoptViewTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIView *viewBound;
@property (strong, nonatomic) IBOutlet UIImageView *imgViewIcon;
@property (strong, nonatomic) IBOutlet UIImageView *imgViewPhoto;
@property (strong, nonatomic) IBOutlet UILabel *labelName;
@property (strong, nonatomic) IBOutlet UILabel *labelSex;
@property (strong, nonatomic) IBOutlet UILabel *labelAge;
@property (strong, nonatomic) IBOutlet UILabel *labelType;
@property (strong, nonatomic) IBOutlet SSBouncyButton *btnAddLove;




@end
