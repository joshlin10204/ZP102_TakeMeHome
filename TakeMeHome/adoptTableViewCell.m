//
//  adoptTableViewCell.m
//  TakeMeHome
//
//  Created by Nigel on 2015/9/2.
//  Copyright (c) 2015年 Josh. All rights reserved.
//

#import "adoptTableViewCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation adoptTableViewCell

- (void)awakeFromNib {
    // Initialization code
    _imgView.layer.cornerRadius = 10 ;
    _imgView.layer.masksToBounds = true;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
