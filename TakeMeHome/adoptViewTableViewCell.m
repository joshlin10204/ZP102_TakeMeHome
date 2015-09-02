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
    
    self.labelType.backgroundColor = [UIColor sunflowerColor];
    self.labelType.layer.cornerRadius = 10;
    self.labelType.layer.masksToBounds = true;

    

    //圓角
    _imgViewPhoto.layer.cornerRadius = 10;
    _imgViewPhoto.layer.masksToBounds = true;
    
    _viewBound.layer.cornerRadius = 10;
    _viewBound.layer.masksToBounds = true;
    
    _imgViewIcon.layer.cornerRadius = 10;
    _imgViewIcon.layer.masksToBounds = true;
    
    _labelType.layer.cornerRadius = 10;
    _labelType.layer.masksToBounds = true;
    
    
    
    
    _btnFavirite.buttonColor = [UIColor cloudsColor];
    _btnFavirite.shadowColor = [UIColor silverColor];
    _btnFavirite.shadowHeight = 5.0f;
    _btnFavirite.cornerRadius = 10.0f;
    
    [_btnFavirite setTitleColor:[UIColor alizarinColor] forState:UIControlStateNormal];
    [_btnFavirite setTitleColor:[UIColor cloudsColor] forState:UIControlStateHighlighted];
    
    
}



@end
