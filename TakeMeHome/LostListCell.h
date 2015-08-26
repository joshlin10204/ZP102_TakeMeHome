//
//  LostListCell.h
//  TakeMeHome
//
//  Created by Josh on 2015/8/3.
//  Copyright (c) 2015年 Josh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LostListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *locationButton;
@property (weak, nonatomic) IBOutlet UIButton *moreInformationButton;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UIImageView *lostPetPhoto;
@property (weak, nonatomic) IBOutlet UILabel *lostDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *lostDistanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *lostDateTitle;
@property (weak, nonatomic) IBOutlet UILabel *lostDistanceTitle;

@end
