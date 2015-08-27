//
//  LostMoreInformationView.m
//  TakeMeHome
//
//  Created by Josh on 2015/8/18.
//  Copyright (c) 2015年 Josh. All rights reserved.
//

#import "LostMoreInformationView.h"


@interface LostMoreInformationView ()<MBProgressHUDDelegate>
{
    MBProgressHUD *HUD;

    NSMutableDictionary *lostInformationData;


}
@property (weak, nonatomic) IBOutlet UILabel *lostPetNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *lostImageFirst;
@property (weak, nonatomic) IBOutlet UIImageView *lostImageSecond;


@end

@implementation LostMoreInformationView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    //Loading圖示
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.delegate = self;
    HUD.labelText = @"Loading";
    [HUD show:YES];
    
    PFQuery *query = [PFQuery queryWithClassName:@"LostPets"];
    [query getObjectInBackgroundWithId:_objectId block:^(PFObject *lostPetsInformationData, NSError *error) {
        // Do something with the returned PFObject in the gameScore variable.
        //顯示寵物名字
        _lostPetNameLabel.text=lostPetsInformationData[@"LostPetsName"];
        _lostPetNameLabel.font = [UIFont fontWithName:@"Wawati SC" size:45];
        
        //顯示照片
        if (lostPetsInformationData[@"LostPetsPhotoFirst"]!=nil)
        {
            
            PFFile *lostPetsPhoto = lostPetsInformationData[@"LostPetsPhotoFirst"];
            [lostPetsPhoto getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error)
             {
                 if (!error) {
                     _lostImageFirst.image = [UIImage imageWithData:imageData];
                 }
             }];
        }
        
        if (lostPetsInformationData[@"LostPetsPhotoSecond"]!=nil)
        {
            
            PFFile *lostPetsPhoto = lostPetsInformationData[@"LostPetsPhotoSecond"];
            
            [lostPetsPhoto getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error)
             {
                 if (!error) {
                     _lostImageSecond.image = [UIImage imageWithData:imageData];
                 }
             }];
        }
        
        
        lostInformationData = [NSMutableDictionary dictionaryWithCapacity:12];

        [lostInformationData setObject:lostPetsInformationData[@"LostDate"]
                                forKey:@"LostDate"];
        [lostInformationData setObject:lostPetsInformationData[@"LostLocation"]
                                forKey:@"LostLocation"];
        [lostInformationData setObject:lostPetsInformationData[@"LostPetsSex"]
                                forKey:@"LostPetsSex"];
        [lostInformationData setObject:lostPetsInformationData[@"LostPetVariety"]
                                forKey:@"LostPetVariety"];
        [lostInformationData setObject:lostPetsInformationData[@"LostPetsColor"]
                                forKey:@"LostPetsColor"];
        [lostInformationData setObject:lostPetsInformationData[@"LostOther"]
                                forKey:@"LostOther"];
        [lostInformationData setObject:lostPetsInformationData[@"ContactName"]
                                forKey:@"ContactName"];
        [lostInformationData setObject:lostPetsInformationData[@"ContactEmail"]
                                forKey:@"ContactEmail"];
        [lostInformationData setObject:lostPetsInformationData[@"ContactPhoneNumber"]
                                forKey:@"ContactPhoneNumber"];
        [HUD hide:YES];

        
        NSLog(@"lostInformationData:%@",lostInformationData);
        [[NSNotificationCenter defaultCenter]
         postNotificationName: LOST_INFORMATION_DATA_NOTIFICATION
         object:lostInformationData];

        
    }];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)closeBtnPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
