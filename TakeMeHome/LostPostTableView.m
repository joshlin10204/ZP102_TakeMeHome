//
//  LostPostTableView.m
//  TakeMeHome
//
//  Created by Josh on 2015/8/10.
//  Copyright (c) 2015年 Josh. All rights reserved.
//

#import "LostPostTableView.h"
#import "LostMapView.h"
#import "LostPostView.h"
#import "MBProgressHUD.h"
#import "LostPostLocalChoiceView.h"




@interface LostPostTableView ()<UITextFieldDelegate,MKMapViewDelegate,CLLocationManagerDelegate,MBProgressHUDDelegate>
{
    CLLocationManager *locationManager;
    CLLocation*currentLocation;
    
    UIImage *prepareLostPhotoFirst;
    UIImage *prepareLostPhotoSecond;
    
//    UIPickerView *datePicker;
    UIDatePicker*datePicker;


    MBProgressHUD *HUD;
    
    //走失地點
    BOOL checkLocal;
    NSString * lostAddress;
    
    
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

@end

@implementation LostPostTableView

- (void)viewDidLoad {
    [super viewDidLoad];
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
    
    
    
    //接收從LostPost的Notification 傳來的照片
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didDeviceTokenReceived:) name:LOST_PHOTO_FIRST_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didDeviceTokenReceived:) name:LOST_PHOTO_SECOND_NOTIFICATION object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didDeviceTokenReceived:) name:LOST_LOCALADDRESS_NOTIFICATION object:nil];

}
//取得使用者位置
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray*)locations{
    
    currentLocation=locations.lastObject;
   // NSLog(@"%@",currentLocation);
    //取得最新的位置
    
}
//將Notification的照片儲存
-(void)didDeviceTokenReceived:(NSNotification*)notify{
   
        if ([notify.name isEqualToString: LOST_PHOTO_FIRST_NOTIFICATION])
        {
            prepareLostPhotoFirst=notify.object;

            
        }
        else if ([notify.name isEqual:LOST_PHOTO_SECOND_NOTIFICATION])
        {
            prepareLostPhotoSecond=notify.object;
            
        }
        else if([notify.name isEqual:LOST_LOCALADDRESS_NOTIFICATION])
        {
            lostAddress=notify.object;
            if (lostAddress.length<1) {
                _lostLocalText.text=@"目前所在位置";
            }
            else
            {
            NSLog(@"lostAddress: %@",lostAddress);
            _lostLocalText.text=lostAddress;
            checkLocal=true;
            }
        
        }
    
}
//當結束此頁時，停止搜尋使用者位置
-(void)viewDidDisappear:(BOOL)animated
{
    [locationManager stopUpdatingLocation];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
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



//發布按鈕
- (IBAction)lostPostAddBtn:(id)sender {
    [self.view endEditing:YES];
    
    //判斷是否有必填未寫
    if (_lostPetNameText.text.length==0||_lostDateText.text.length==0) {
        UIAlertController* warningAlert=[UIAlertController alertControllerWithTitle:@"注意!" message:@"請務必填寫必填欄位" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* cancle=[UIAlertAction actionWithTitle:@"確定" style:UIAlertActionStyleDefault handler:nil];
        [warningAlert addAction:cancle];
        [self presentViewController:warningAlert animated:YES completion:nil];


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

        
    
    //儲存至Parse
    PFObject *lostPostData = [PFObject objectWithClassName:@"LostPets"];
    lostPostData[@"LostDate"] = _lostDateText.text;
    lostPostData[@"LostPetsName"] = _lostPetNameText.text;
    lostPostData[@"LostPetsSex"] = _lostPetSexText.text;
    lostPostData[@"LostPetsColor"] = _lostPetColorText.text;
    lostPostData[@"LostPetVariety"] = _lostPetVarietyText.text;
    lostPostData[@"LostOther"] = _lostOtherText.text;
    lostPostData[@"ContactName"] = _contactNameText.text;
    lostPostData[@"ContactEmail"] = _contactEmail.text;
    lostPostData[@"ContactPhoneNumber"] = _contactPhoneNumber.text;
        
    //儲存走失的位置
        if (checkLocal==false) {
            CLLocationDegrees userLocalLatitude = currentLocation.coordinate.latitude;
            CLLocationDegrees userLocalLongitude = currentLocation.coordinate.longitude;
            PFGeoPoint *point = [PFGeoPoint geoPointWithLatitude:userLocalLatitude
                                                       longitude:userLocalLongitude];
            lostPostData[@"LostLocation"] = point;
        }
        else
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
                    lostPostData[@"LostLocation"] =point;
                    }
                }];
        
        }

    //準備上傳照片
        if (prepareLostPhotoFirst!=nil) {
            NSData *imageData1 = UIImagePNGRepresentation(prepareLostPhotoFirst);
            PFFile *imageFile1 = [PFFile fileWithName:@"lostPetPhoto_01.jpeg" data:imageData1];
            lostPostData[@"LostPetsPhotoFirst"] = imageFile1;
            if (prepareLostPhotoSecond !=nil) {
                NSData *imageData2 = UIImagePNGRepresentation(prepareLostPhotoSecond);
                PFFile *imageFile2 = [PFFile fileWithName:@"lostPetPhoto_02.jpeg" data:imageData2];
                lostPostData[@"LostPetsPhotoSecond"] = imageFile2;
            }


        }


   
    
    [lostPostData saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            // The object has been saved
            [lostPostData save];
            NSLog(@"Succee!!!");
            [self performSegueWithIdentifier:@"goLostMapSeguWay" sender:nil];
            [HUD hide:YES];

            

        } else {
            UIAlertController* warningAlert=[UIAlertController alertControllerWithTitle:@"注意!" message:@"請檢查網路訊息" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* cancle=[UIAlertAction actionWithTitle:@"確定" style:UIAlertActionStyleDefault handler:nil];
            [warningAlert addAction:cancle];
            [self presentViewController:warningAlert animated:YES completion:nil];
            [HUD hide:YES];


        }
    }];
    }

}



@end
