//
//  mkav.m
//  PROJECTTAKEMEHOME
//
//  Created by tainan boom on 2015/9/1.
//  Copyright (c) 2015年 tainan boom. All rights reserved.
//

#import "mkav.h"


@implementation mkav

- (id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    
    UIImage *image = [UIImage imageNamed:@"pointRed.png"];
    self.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    
    UIImageView *imageView=[[UIImageView alloc] initWithImage:image];
    
    [self addSubview:imageView];
    
    return self;
}

@end
