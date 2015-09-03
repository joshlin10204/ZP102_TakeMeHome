//
//  aboutMeVC.m
//  TakeMeHome
//
//  Created by Nigel on 2015/8/3.
//  Copyright (c) 2015年 Josh. All rights reserved.
//

#import "aboutMeVC.h"
#import "adoptView.h"

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
    if ([[animalProfileArray valueForKey:ANIMAL_RESOURCE_FILTER_KEY]isEqualToString:Non_GOVERNMENT_SRC_KEY]) {
        NSString *contact = [animalProfileArray valueForKey:ANIMAL_CONTACT_FILTER_KEY];
        NSString *howToContact = [animalProfileArray valueForKey:ANIMAL_HOW_TO_CONTACT_FILTER_KEY];
        NSString *aboutMe = [animalProfileArray valueForKey:@"animal_remark"];
        _txtViewAboutMe.text = [NSString stringWithFormat:@"%@\n\n聯絡人：%@\n\n聯絡方式：%@",aboutMe,contact,howToContact];
    }else{
        _txtViewAboutMe.text = [animalProfileArray valueForKey:@"animal_remark"];
        if ([_txtViewAboutMe.text isEqualToString:@""]){
            _txtViewAboutMe.text = @"目前沒有關於我的資料\n歡迎電洽或是現場來看我哦^__^";
        }
    }
    
    
    
}


- (void)setAnimalProfile:(NSArray*)animalProfile{
    animalProfileArray = animalProfile;
}

@end
