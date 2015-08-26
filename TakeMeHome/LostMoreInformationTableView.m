//
//  LostMoreInformationTableView.m
//  TakeMeHome
//
//  Created by Josh on 2015/8/22.
//  Copyright (c) 2015年 Josh. All rights reserved.
//

#import "LostMoreInformationTableView.h"




@interface LostMoreInformationTableView ()
{
    NSMutableDictionary *lostInformationData;


}
@property (weak, nonatomic) IBOutlet UILabel *lostDateTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *lostLocalTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *lostSexTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *lostColorTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *lostVarietyTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *lostOtherTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contactNameTileLabel;
@property (weak, nonatomic) IBOutlet UILabel *contactPhoneNumberTileLabel;
@property (weak, nonatomic) IBOutlet UILabel *contactEmailTileLabel;


@property (weak, nonatomic) IBOutlet UILabel *lostDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *lostLocalLabel;
@property (weak, nonatomic) IBOutlet UILabel *lostSexLabel;
@property (weak, nonatomic) IBOutlet UILabel *lostColorLabel;
@property (weak, nonatomic) IBOutlet UILabel *lostVarietyLabel;
@property (weak, nonatomic) IBOutlet UITextView *lostOtherLabel;
@property (weak, nonatomic) IBOutlet UILabel *contactNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contactPhoneNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *contactEmailLabel;

@end

@implementation LostMoreInformationTableView

- (void)viewDidLoad {
    [super viewDidLoad];
    

    _lostDateTitleLabel.font = [UIFont fontWithName:@"Wawati SC" size:17];
    _lostLocalTitleLabel.font = [UIFont fontWithName:@"Wawati SC" size:17];
    _lostSexTitleLabel.font = [UIFont fontWithName:@"Wawati SC" size:17];
    _lostColorTitleLabel.font = [UIFont fontWithName:@"Wawati SC" size:17];
    _lostVarietyTitleLabel.font = [UIFont fontWithName:@"Wawati SC" size:17];
    _lostOtherTitleLabel.font = [UIFont fontWithName:@"Wawati SC" size:17];
    _contactNameTileLabel.font = [UIFont fontWithName:@"Wawati SC" size:17];
    _contactPhoneNumberTileLabel.font = [UIFont fontWithName:@"Wawati SC" size:17];
    _contactEmailTileLabel.font = [UIFont fontWithName:@"Wawati SC" size:17];
 
    _lostDateLabel.font = [UIFont fontWithName:@"Wawati SC" size:17];
    _lostLocalLabel.font = [UIFont fontWithName:@"Wawati SC" size:17];
    _lostSexLabel.font = [UIFont fontWithName:@"Wawati SC" size:17];
    _lostColorLabel.font = [UIFont fontWithName:@"Wawati SC" size:17];
    _lostVarietyLabel.font = [UIFont fontWithName:@"Wawati SC" size:17];
    _lostOtherLabel.font = [UIFont fontWithName:@"Wawati SC" size:17];
    _contactNameLabel.font = [UIFont fontWithName:@"Wawati SC" size:17];
    _contactPhoneNumberLabel.font = [UIFont fontWithName:@"Wawati SC" size:17];
    _contactEmailLabel.font = [UIFont fontWithName:@"Wawati SC" size:17];
    
    
    
    
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didDeviceTokenReceived:) name:LOST_INFORMATION_DATA_NOTIFICATION object:nil];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)didDeviceTokenReceived:(NSNotification*)notify
{
    lostInformationData=notify.object;
    NSLog(@"在tabeview  lostInformationData：%@",lostInformationData);
    NSString *LostDate=lostInformationData[@"LostDate"];
    NSString *LostPetsSex=lostInformationData[@"LostPetsSex"];
    NSString *LostPetsColor=lostInformationData[@"LostPetsColor"];
    NSString *LostPetVariety=lostInformationData[@"LostPetVariety"];
    NSString *LostOther=lostInformationData[@"LostOther"];
    NSString *ContactName=lostInformationData[@"ContactName"];
    NSString *ContactEmail=lostInformationData[@"ContactEmail"];
    NSString *ContactPhoneNumber=lostInformationData[@"ContactPhoneNumber"];
    
    
    //顯示地址
    PFGeoPoint *local=lostInformationData[@"LostLocation"];
    CLLocation *location=[[CLLocation alloc]initWithLatitude:local.latitude
                                                   longitude:local.longitude];
    CLGeocoder *gecorder=[CLGeocoder new];
    [gecorder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark*placemark=placemarks[0];
//        NSLog(@"%@",placemark.addressDictionary);
//        NSLog(@"%@",[placemark.addressDictionary valueForKey:@"City"]);
//        NSLog(@"%@",[placemark.addressDictionary valueForKey:@"State"]);
//        NSLog(@"%@",[placemark.addressDictionary valueForKey:@"Street"]);
//        NSLog(@"%@",[placemark.addressDictionary valueForKey:@"SubAdministrativeArea"]);
//        NSLog(@"%@",[placemark.addressDictionary valueForKey:@"Thoroughfare"]);

        NSString*Area=[placemark.addressDictionary valueForKey:@"SubAdministrativeArea"];
        NSString*city=[placemark.addressDictionary valueForKey:@"City"];
        
        
        NSString*lostAddress=[NSString stringWithFormat:@"%@,%@",Area,city];
        _lostLocalLabel.text=lostAddress;
        
    }];
    
    //顯示其他資料
    _lostDateLabel.text=LostDate;
    if (LostPetsSex.length<1)
    {
        _lostSexLabel.text=@"未知";
    }
    else
    {
        _lostSexLabel.text=LostPetsSex;
    }
    
    if (LostPetVariety.length<1)
    {
        _lostVarietyLabel.text=@"未知";
    }
    else
    {
        _lostVarietyLabel.text=LostPetVariety;
    }
    
    if (LostPetsColor.length<1)
    {
        _lostColorLabel.text=@"未知";
    }
    else
    {
        _lostColorLabel.text=LostPetsColor;
        
    }
    
    if (LostOther.length<1)
    {
        _lostOtherLabel.text=@"未知";
    }
    else
    {
        _lostOtherLabel.text=LostOther;
    
    }
    if (ContactName.length<1)
    {
        _contactNameLabel.text=@"未知";
    }
    else
    {
        _contactNameLabel.text=ContactName;
    }
    if (ContactEmail.length<1)
    {
        _contactEmailLabel.text=@"未知";
    }
    else
    {
        _contactEmailLabel.text=ContactEmail;
    }
    if (ContactPhoneNumber.length<1)
    {
        _contactPhoneNumberLabel.text=@"未知";
    }
    else
    {
        _contactPhoneNumberLabel.text=ContactPhoneNumber;
    }
    


    


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete method implementation.
//    // Return the number of rows in the section.
//    return 0;
//}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
