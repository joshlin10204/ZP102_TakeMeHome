//
//  adoptViewTableViewCell.m
//  TakeMeHome
//
//  Created by Nigel on 2015/8/3.
//  Copyright (c) 2015年 Josh. All rights reserved.
//

#import "adoptViewTableViewCell.h"



#import <QuartzCore/QuartzCore.h>
@implementation adoptViewTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    
    self.labelAge.backgroundColor = [UIColor sunflowerColor];
    self.labelAge.layer.cornerRadius = 10;
    self.labelAge.layer.masksToBounds = true;
    
    self.labelSex.backgroundColor = [UIColor sunflowerColor];
    self.labelSex.layer.cornerRadius = 10;
    self.labelSex.layer.masksToBounds = true;
    
    _btnAddLove.adjustsImageWhenHighlighted = NO;
    _btnAddLove.tintColor = [UIColor alizarinColor];
    _btnAddLove.cornerRadius = SSBouncyButtonDefaultCornerRadius;
    _btnAddLove.titleLabel.font = [UIFont systemFontOfSize:SSBouncyButtonDefaultTitleLabelFontSize];
    [_btnAddLove setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [_btnAddLove setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected | UIControlStateHighlighted];

    
    [_btnAddLove setTitle:@"加入收藏" forState:UIControlStateNormal];
    [_btnAddLove setTitle:@"取消收藏" forState:UIControlStateSelected];
    [_btnAddLove addTarget:self action:@selector(btnAddLovePressed:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)btnAddLovePressed:(UIButton*)button{
    button.selected = !button.selected;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
