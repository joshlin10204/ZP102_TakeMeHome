//
//  LostInfoCell.m
//  TakeMeHome
//
//  Created by Josh on 2015/8/30.
//  Copyright (c) 2015年 Josh. All rights reserved.
//

#import "LostInfoCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation LostInfoCell

- (void)awakeFromNib {
    // Initialization code
    _lostPetPhotoImage.layer.cornerRadius = 10;
    _lostPetPhotoImage.layer.masksToBounds = true;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
