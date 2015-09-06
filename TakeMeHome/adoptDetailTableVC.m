//
//  adoptDetailTableVC.m
//  TakeMeHome
//
//  Created by Nigel on 2015/8/3.
//  Copyright (c) 2015年 Josh. All rights reserved.
//

#import "adoptDetailTableVC.h"
#import "adoptView.h"

#define LABEL_TAG 1000

@interface adoptDetailTableVC ()
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *collection;

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
{

    NSArray *animalProfileArray;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([[animalProfileArray valueForKey:ANIMAL_RESOURCE_FILTER_KEY] isEqualToString:Non_GOVERNMENT_SRC_KEY]) {
        _labelId.text =@"無";
    }else{
        _labelId.text =[animalProfileArray valueForKey:ANIMAL_ID_FILTER_KEY];
    }
    _labelAge.text = [animalProfileArray valueForKey:ANIMAL_AGE_FILTER_KEY];
    _labelBodyType.text = [animalProfileArray valueForKey:ANIMAL_BODYTYPE_FILTER_KEY];
    _labelColor.text = [animalProfileArray valueForKey:@"animal_colour"];
    _labelSterilization.text = [animalProfileArray valueForKey:@"animal_sterilization"];
    _labelBacterin.text = [animalProfileArray valueForKey:@"animal_bacterin"];
    _labelFoundPlace.text = [animalProfileArray valueForKey:@"animal_foundplace"];
    _labelShelterName.text = [animalProfileArray valueForKey:@"shelter_name"];
    _labelNowPlace.text = [animalProfileArray valueForKey:@"animal_place"];
    
    
    //垃圾進垃圾出  拿到的資料居然會是2014  更新日期卻在2015  偉哉....= =
    //_labelOpendate.text = [animalProfileArray valueForKey:@"animal_opendate"];
    //_labelCloseDate.text = [animalProfileArray valueForKey:@"animal_closeddate"];

    //close在storayborad隱藏  opendate改放最後更新日
    //原有時間是yyyy MM dd HH mm ss   顯示只要日期即可
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //NSDate转NSString
    NSString *dateYMDStr = [dateFormatter stringFromDate:[animalProfileArray valueForKey:ANIMAL_DATA_UPDATE_TIME_FILTER_KEY]];
     _labelOpendate.text = dateYMDStr;
    

    
//    for (int i = LABEL_TAG ; i <= LABEL_TAG + 10 ; i++) {
//        UILabel *myLabel = (UILabel*)[self.view viewWithTag:i];
//        NSLog(@"%@",myLabel.text);
//        if ([myLabel.text isEqualToString:@""]) {
//            myLabel.text = @"未填寫";
//        }
//    }
    
    for (id view in self.collection) {
        NSLog(@"view:%@",[view class]);
        if ([view isKindOfClass:[UILabel class]]) {
            UILabel *myLabel = view;
            if ([myLabel.text isEqualToString:@""] || myLabel.text == NULL) {
                myLabel.text = @"未填寫";
            }
        }

    }
}

- (void)setAnimalProfile:(NSArray*)animalProfile{
    animalProfileArray = animalProfile;
}
@end
