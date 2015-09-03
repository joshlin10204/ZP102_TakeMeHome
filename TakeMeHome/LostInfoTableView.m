//
//  LostInfoTableView.m
//  TakeMeHome
//
//  Created by Josh on 2015/9/1.
//  Copyright (c) 2015年 Josh. All rights reserved.
//

#import "LostInfoTableView.h"
#import "LostInfoView.h"
#import "HHAlertView.h"
#import "MBProgressHUD.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import <Parse/Parse.h>
#import "LostPostLocalChoiceView.h"
#import "SSBouncyButton.h"
#import "UIColor+FlatUI.h"


@interface LostInfoTableView ()<UITextFieldDelegate,MKMapViewDelegate,CLLocationManagerDelegate,MBProgressHUDDelegate>
{

    UIImage *prepareLostPhotoFirst;
    UIImage *prepareLostPhotoSecond;
    PFObject *prepareLostPostInfo;
    
    CLLocationManager *locationManager;
    CLLocation*currentLocation;
    //UIPickerView *datePicker;
    UIDatePicker*datePicker;
    //走失地點
    BOOL checkLocal;
    NSString * lostAddress;
    //Alert 的霧透背景
    UIView   *maskView;
    //Loading圖
    MBProgressHUD *HUD;
    
    
    


}
@property (weak, nonatomic) IBOutlet UITextField *lostDateText;
@property (weak, nonatomic) IBOutlet UITextField *lostPetNameText;
@property (weak, nonatomic) IBOutlet UITextField *lostPetSexText;
@property (weak, nonatomic) IBOutlet UITextField *lostPetColorText;
@property (weak, nonatomic) IBOutlet UITextField *lostPetVarietyText;
@property (weak, nonatomic) IBOutlet UITextView *lostOtherText;
@property (weak, nonatomic) IBOutlet UITextField *contactNameText;
@property (weak, nonatomic) IBOutlet UITextField *contactEmail;
@property (weak, nonatomic) IBOutlet UITextField *contactPhoneNumber;
@property (weak, nonatomic) IBOutlet UILabel *lostLocalText;

@property (weak, nonatomic) IBOutlet SSBouncyButton *okBtn;
@property (weak, nonatomic) IBOutlet SSBouncyButton *cancelBtn;


@end

@implementation LostInfoTableView

- (void)viewDidLoad {
    [super viewDidLoad];
  
    [self btnSettings];
    
    _lostOtherText.layer.borderWidth = 0.25;
    _lostOtherText.layer.cornerRadius=10.0f;
    _lostOtherText.layer.borderColor=[[UIColor lightGrayColor] CGColor];
    
    
    //設定點選Text，會跳出Picker 或 Alert 準備
    _lostPetSexText.delegate=self;
    _lostDateText.delegate=self;
    _lostDateText.tag=1;
    
    
    prepareLostPhotoFirst=nil;
    prepareLostPhotoSecond=nil;
    //取得位置的準備
    locationManager=[CLLocationManager new];
    
    if ([locationManager respondsToSelector:@selector(requestAlwaysAuthorization)])
    {
        [locationManager requestAlwaysAuthorization];
    }
    locationManager.desiredAccuracy=kCLLocationAccuracyBest;
    locationManager.activityType=CLActivityTypeFitness;
    locationManager.delegate=self;
    [locationManager startUpdatingLocation];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didDeviceTokenReceived:) name:LOST_POST_INFO_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didDeviceTokenReceived:) name:LOST_NEW_PHOTO_FIRST_NOTIFICATION object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didDeviceTokenReceived:) name:LOST_NEW_PHOTO_SECOND_NOTIFICATION object:nil];
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didDeviceTokenReceived:) name:LOST_LOCALADDRESS_NOTIFICATION object:nil];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}
-(void)didDeviceTokenReceived:(NSNotification*)notify
{
    if ([notify.name isEqualToString: LOST_POST_INFO_NOTIFICATION])
    {
        prepareLostPostInfo=notify.object;
        NSLog(@"prepareLostPostInfo: %@",prepareLostPostInfo);
        NSLog(@"LostPetsName: %@",prepareLostPostInfo[@"LostPetsName"]);
        NSLog(@"LostPetsName: %@",prepareLostPostInfo.objectId);
        

        _lostDateText.text=prepareLostPostInfo[@"LostDate"];
        _lostPetNameText.text=prepareLostPostInfo[@"LostPetsName"];
        _lostPetSexText.text=prepareLostPostInfo[@"LostPetsSex"];
        _lostPetColorText.text=prepareLostPostInfo[@"LostPetsColor"];
        _lostPetVarietyText.text=prepareLostPostInfo[@"LostPetVariety"];
        _lostOtherText.text=prepareLostPostInfo[@"LostOther"];
        _contactNameText.text=prepareLostPostInfo[@"ContactName"];
        _contactEmail.text=prepareLostPostInfo[@"ContactEmail"];
        _contactPhoneNumber.text=prepareLostPostInfo[@"ContactPhoneNumber"];
        if (prepareLostPostInfo[@"LostlocalAddres"]!=nil)
        {
            _lostLocalText.text=prepareLostPostInfo[@"LostlocalAddres"];
        }
        else
        {
            PFGeoPoint *local=prepareLostPostInfo[@"LostLocation"];
            CLLocation *location=[[CLLocation alloc]initWithLatitude:local.latitude
                                                           longitude:local.longitude];
            CLGeocoder *gecorder=[CLGeocoder new];
            [gecorder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
                CLPlacemark*placemark=placemarks[0];
                NSString*Area=[placemark.addressDictionary valueForKey:@"SubAdministrativeArea"];
                NSString*city=[placemark.addressDictionary valueForKey:@"City"];
                NSString*address=[NSString stringWithFormat:@"%@,%@",Area,city];
                _lostLocalText.text=address;
                
            }];
            
        }
        
        
        
        
        
    }
    else if ([notify.name isEqual:LOST_NEW_PHOTO_FIRST_NOTIFICATION])
    {
        prepareLostPhotoFirst=notify.object;
        
    }
    else if([notify.name isEqual:LOST_NEW_PHOTO_SECOND_NOTIFICATION])
    {
    
        prepareLostPhotoSecond=notify.object;
    }
    
    else if([notify.name isEqual:LOST_LOCALADDRESS_NOTIFICATION])
    {
        lostAddress=notify.object;
        if (lostAddress.length<1)
        {
            _lostLocalText.text=@"目前位置";
            checkLocal=false;


        }
        else 
        {
            NSLog(@"lostAddress: %@",lostAddress);
            _lostLocalText.text=lostAddress;
            checkLocal=true;
        }
        
        
    }




}
//取得使用者位置
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray*)locations{
    
    currentLocation=locations.lastObject;
//    NSLog(@"%@",currentLocation);
    //取得最新的位置
    
}
//當結束此頁時，停止搜尋使用者位置
-(void)viewDidDisappear:(BOOL)animated
{
    [locationManager stopUpdatingLocation];
}
//當按下textFiel 顯示
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    
    //顯示Picker 選擇日期
    if (textField.tag==1)
    {
        NSLog(@"進入選取日期");
        
        datePicker = [UIDatePicker new];
        datePicker.datePickerMode = UIDatePickerModeDate;
        [_lostDateText setInputView:datePicker];
        
        UIToolbar *toolbar=[[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
        
        UIBarButtonItem *doneBtn =[[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(chooseDate)];
        UIBarButtonItem *space =[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        [toolbar setItems:[NSArray arrayWithObjects:space,doneBtn, nil]];
        [_lostDateText setInputAccessoryView:toolbar];
        
        return true;
    }
    
    //顯示Alert 選擇性別
    else
    {
        UIAlertController* sexAlert=[UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction* choiceMale=[UIAlertAction actionWithTitle:@"公" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            _lostPetSexText.text=@"公";
            
            
        }];
        UIAlertAction* choiceFemale=[UIAlertAction actionWithTitle:@"母" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            _lostPetSexText.text=@"母";
            
            
        }];
        UIAlertAction* cancle=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
        [sexAlert addAction:choiceMale];
        [sexAlert addAction:choiceFemale];
        [sexAlert addAction:cancle];
        [self presentViewController:sexAlert animated:YES completion:nil];
        return false;
        
    }
    
}

//Picker選擇時間
- (void)chooseDate{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy/MM/dd";
    NSString *dateString = [formatter stringFromDate:datePicker.date];
    self.lostDateText.text=[NSString stringWithFormat:@"%@",dateString];
    
    //    [self textFieldShouldReturn:_lostDateText];
    [_lostDateText resignFirstResponder];
}


- (IBAction)addCompleteBtnPressed:(id)sender
{
    //收鍵盤
    [self.view endEditing:YES];

    //判斷是否有必填未寫
    if (_lostPetNameText.text.length==0||_lostDateText.text.length==0||
        _contactNameText.text.length==0||_contactPhoneNumber.text.length==0||
        _contactEmail.text.length==0)
    {
        [self.view.window addSubview:self.addmaskView];
        [[HHAlertView shared]
         showAlertWithStyle:HHAlertStyleWraning
         inView:self.view.window
         Title:@"提醒"
         detail:@"尚未填寫完必填欄位"
         cancelButton:nil
         Okbutton:@"關閉"
         block:^(HHAlertButton buttonindex) {
             [maskView removeFromSuperview];
             
         }
         ];
        
        
    }
    
    else
    {
        //顯示Loading圖示
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
        HUD.delegate = self;
        HUD.labelText = @"Loading";
        [window addSubview:HUD];
        [HUD show:YES];
        //儲存至Parse準備
        PFQuery *query = [PFQuery queryWithClassName:@"LostPets"];
        [query getObjectInBackgroundWithId:prepareLostPostInfo.objectId block:^(PFObject *info, NSError *error)
         {

            info[@"LostDate"] = _lostDateText.text;
            info[@"LostPetsName"] = _lostPetNameText.text;
            info[@"LostPetsSex"] = _lostPetSexText.text;
            info[@"LostPetsColor"] = _lostPetColorText.text;
            info[@"LostPetVariety"] = _lostPetVarietyText.text;
            info[@"LostOther"] = _lostOtherText.text;
            info[@"ContactName"] = _contactNameText.text;
            info[@"ContactEmail"] = _contactEmail.text;
            info[@"ContactPhoneNumber"] = _contactPhoneNumber.text;
            
            //上傳照片準備
            if (prepareLostPhotoFirst!=nil)
            {
                NSData *imageData1 = UIImagePNGRepresentation(prepareLostPhotoFirst);
                PFFile *imageFile1 = [PFFile fileWithName:@"lostPetPhoto_01.jpeg" data:imageData1];
                info[@"LostPetsPhotoFirst"] = imageFile1;
                if (prepareLostPhotoSecond !=nil)
                {
                    NSData *imageData2 = UIImagePNGRepresentation(prepareLostPhotoSecond);
                    PFFile *imageFile2 = [PFFile fileWithName:@"lostPetPhoto_02.jpeg" data:imageData2];
                    info[@"LostPetsPhotoSecond"] = imageFile2;
                }
                
                
            }
             
             //儲存走失位置準備
             if (checkLocal==false && [_lostLocalText.text isEqualToString:@"目前位置"])
             {
                 CLLocationDegrees userLocalLatitude = currentLocation.coordinate.latitude;
                 CLLocationDegrees userLocalLongitude = currentLocation.coordinate.longitude;
                 PFGeoPoint *point = [PFGeoPoint geoPointWithLatitude:userLocalLatitude
                                                            longitude:userLocalLongitude];
                 info[@"LostLocation"] = point;
                 [info removeObjectForKey:@"LostlocalAddres"];
                 NSLog(@"point1:%@",point);

                 
             }
            else if(checkLocal==true)
             {
                 
                 CLGeocoder *gecorder=[CLGeocoder new];
                 [gecorder geocodeAddressString:lostAddress
                              completionHandler:^(NSArray *placemarks, NSError *error) {
                                  if (error)
                                  {
                                      NSLog(@"失敗");
                                  }
                                  else
                                  {
                                      CLPlacemark* placemark=placemarks[0];
                                      NSLog(@"Lat/Lon:%f ,%f",placemark.location.coordinate.latitude,placemark.location.coordinate.longitude);
                                      PFGeoPoint *point = [PFGeoPoint geoPointWithLatitude:placemark.location.coordinate.latitude
                                                                                 longitude:placemark.location.coordinate.longitude];
                                      info[@"LostLocation"] =point;
                                      info[@"LostlocalAddres"]=_lostLocalText.text;
                                      NSLog(@"point2:%@",point);

                                      
                                  }
                              }];
                 
             }

             
             
             [info saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
              {
                  if (succeeded)
                  {
                      // The object has been saved
                      [info saveInBackground];
                      NSLog(@"Succee!!!");
//                      [self performSegueWithIdentifier:@"golostPostInfo" sender:nil];
                  }
                  else
                  {
                      [self.view.window addSubview:self.addmaskView];
                      [[HHAlertView shared]
                       showAlertWithStyle:HHAlertStyleWraning
                       inView:self.view.window
                       Title:@"注意"
                       detail:@"請檢查您的網路狀況"
                       cancelButton:nil
                       Okbutton:@"關閉"
                       block:^(HHAlertButton buttonindex) {
                           [maskView removeFromSuperview];
                           
                       }
                       ];
                  }
                  [HUD hide:YES];

              }];
        }];
    
    }
    
    
    
}



- (IBAction)cancelBtnPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:true];
}
- (UIView *)addmaskView
{
    if (!maskView) {
        CGRect screenSize = [[UIScreen mainScreen] bounds];
        maskView = [[UIView alloc] initWithFrame:screenSize];
        [maskView setBackgroundColor:[UIColor blackColor]];
        [maskView setAlpha:0.2];
        NSLog(@"New maskView");
    }
    return maskView;
}
#pragma mark - Table view data source



- (void)btnSettings{

    _okBtn.adjustsImageWhenHighlighted = NO;
    _okBtn.tintColor = [UIColor turquoiseColor];
    _okBtn.cornerRadius = SSBouncyButtonDefaultCornerRadius;
    _okBtn.titleLabel.font = [UIFont systemFontOfSize:SSBouncyButtonDefaultTitleLabelFontSize];
    [_okBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [_okBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected | UIControlStateHighlighted];
    
    _cancelBtn.adjustsImageWhenHighlighted = NO;
    _cancelBtn.tintColor = [UIColor alizarinColor];
    _cancelBtn.cornerRadius = SSBouncyButtonDefaultCornerRadius;
    _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:SSBouncyButtonDefaultTitleLabelFontSize];
    [_cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [_cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected | UIControlStateHighlighted];
}
@end
