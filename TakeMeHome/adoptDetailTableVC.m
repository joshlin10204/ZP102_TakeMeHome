//
//  adoptDetailTableVC.m
//  TakeMeHome
//
//  Created by Nigel on 2015/8/3.
//  Copyright (c) 2015年 Josh. All rights reserved.
//

#import "adoptDetailTableVC.h"
#import "adoptView.h"

@interface adoptDetailTableVC ()

@property (weak, nonatomic) IBOutlet UILabel *labelId;
@property (weak, nonatomic) IBOutlet UILabel *labelBodyType;
@property (weak, nonatomic) IBOutlet UILabel *labelColor;
@property (weak, nonatomic) IBOutlet UILabel *labelSterilization;
@property (weak, nonatomic) IBOutlet UILabel *labelBacterin;
@property (weak, nonatomic) IBOutlet UILabel *labelFoundPlace;
@property (weak, nonatomic) IBOutlet UILabel *labelShelterName;
@property (weak, nonatomic) IBOutlet UILabel *labelNowPlace;
@property (weak, nonatomic) IBOutlet UILabel *labelOpendate;
@property (weak, nonatomic) IBOutlet UILabel *labelCloseDate;
@property (weak, nonatomic) IBOutlet UILabel *labelAge;




@end

@implementation adoptDetailTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.labelId.text = self.getID;
    
    
    
    //http://data.coa.gov.tw/Service/OpenData/AnimalOpenData .aspx?$top={top}&$skip={skip}&$filter={filter}
    //http://data.coa.gov.tw/Service/OpenData/AnimalOpenData.aspx?$filter=animal_id+like+10406290201003
    /*
     top   取最前筆數   如:將{top} 代換成 20
     
     skip  跳過筆數    如:將{skip} 代換成 100
     */
    NSString *urlStr = @"http://data.coa.gov.tw/Service/OpenData/AnimalOpenData.aspx?$filter=animal_id+like+";
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",urlStr,[self getID]]];
    NSData *data = [NSData dataWithContentsOfURL:url];
    NSInputStream *inStream = [[NSInputStream alloc]initWithData:data];
    [inStream open];
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithStream:inStream options:NSJSONReadingAllowFragments error:nil];
    [inStream close];
    
    //不知道為什麼會不只一筆囧...
    jsonArray = [jsonArray objectAtIndex:0];
    
    _labelBodyType.text = [jsonArray valueForKey:@"animal_bodytype"];
    _labelColor.text = [jsonArray valueForKey:@"animal_colour"];
    _labelSterilization.text = [jsonArray valueForKey:@"animal_sterilization"];
    _labelBacterin.text = [jsonArray valueForKey:@"animal_bacterin"];
    _labelFoundPlace.text = [jsonArray valueForKey:@"animal_foundplace"];
    _labelShelterName.text = [jsonArray valueForKey:@"shelter_name"];
    _labelNowPlace.text = [jsonArray valueForKey:@"animal_place"];
    _labelOpendate.text = [jsonArray valueForKey:@"animal_opendate"];
    _labelCloseDate.text = [jsonArray valueForKey:@"animal_closeddate"];
    _labelAge.text = [jsonArray valueForKey:@"animal_age"];
}

@end
