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
{

    NSArray *animalProfileArray;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
        
    _labelId.text =[animalProfileArray valueForKey:ANIMAL_ID_FILTER_KEY];
    _labelBodyType.text = [animalProfileArray valueForKey:ANIMAL_BODYTYPE_FILTER_KEY];
    _labelColor.text = [animalProfileArray valueForKey:@"animal_colour"];
    _labelSterilization.text = [animalProfileArray valueForKey:@"animal_sterilization"];
    _labelBacterin.text = [animalProfileArray valueForKey:@"animal_bacterin"];
    _labelFoundPlace.text = [animalProfileArray valueForKey:@"animal_foundplace"];
    _labelShelterName.text = [animalProfileArray valueForKey:@"shelter_name"];
    _labelNowPlace.text = [animalProfileArray valueForKey:@"animal_place"];
    _labelOpendate.text = [animalProfileArray valueForKey:@"animal_opendate"];
    _labelCloseDate.text = [animalProfileArray valueForKey:@"animal_closeddate"];
    _labelAge.text = [animalProfileArray valueForKey:ANIMAL_AGE_FILTER_KEY];
}

- (void)setAnimalProfile:(NSArray*)animalProfile{
    animalProfileArray = animalProfile;
}
@end
