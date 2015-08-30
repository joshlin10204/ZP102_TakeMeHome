//
//  aboutMeVC.m
//  TakeMeHome
//
//  Created by Nigel on 2015/8/3.
//  Copyright (c) 2015年 Josh. All rights reserved.
//

#import "aboutMeVC.h"

@interface aboutMeVC ()
@property (weak, nonatomic) IBOutlet UITextView *txtViewAboutMe;

@end

@implementation aboutMeVC
{

    NSArray *animalProfileArray;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    _txtViewAboutMe.text = [animalProfileArray valueForKey:@"animal_remark"];
    if ([_txtViewAboutMe.text isEqualToString:@""]){
        _txtViewAboutMe.text = @"目前沒有關於我的資料  歡迎電洽或是現場來看我哦^__^";
    }
}


- (void)setAnimalProfile:(NSArray*)animalProfile{
    animalProfileArray = animalProfile;
}

@end
