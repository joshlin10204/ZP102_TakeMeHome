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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSString *urlStr = @"http://data.coa.gov.tw/Service/OpenData/AnimalOpenData.aspx?$filter=animal_id+like+";
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",urlStr,[self getID]]];
    NSData *data = [NSData dataWithContentsOfURL:url];
    NSInputStream *inStream = [[NSInputStream alloc]initWithData:data];
    [inStream open];
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithStream:inStream options:NSJSONReadingAllowFragments error:nil];
    [inStream close];
    
    //不知道為什麼會不只一筆囧...
    jsonArray = [jsonArray objectAtIndex:0];
    _txtViewAboutMe.text = [jsonArray valueForKey:@"animal_remark"];
    if ([_txtViewAboutMe.text isEqualToString:@""]){
        _txtViewAboutMe.text = @"目前沒有關於我的資料  歡迎電洽或是現場來看我哦^__^";
    }
}


@end
