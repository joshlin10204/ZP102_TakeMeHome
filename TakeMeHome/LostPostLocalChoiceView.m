//
//  LostPostLocalChoiceView.m
//  TakeMeHome
//
//  Created by Josh on 2015/8/25.
//  Copyright (c) 2015年 Josh. All rights reserved.
//

#import "LostPostLocalChoiceView.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>


@interface LostPostLocalChoiceView ()<MKMapViewDelegate,CLLocationManagerDelegate>
{
    CLLocationManager *locationManager;
    CLLocation*currentLocation;

    
    NSString* lostAddress;

    BOOL isFirstLocationReceived;

}
@property (weak, nonatomic) IBOutlet MKMapView *lostMapView;
@property (weak, nonatomic) IBOutlet UITextField *lostAddressText;



@end

@implementation LostPostLocalChoiceView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    //lostMapView 使用delegate
    locationManager=[CLLocationManager new];
    if ([locationManager respondsToSelector:@selector(requestAlwaysAuthorization)])
    {
        [locationManager requestAlwaysAuthorization];
    }
    //準備 locationMAnager
    locationManager.desiredAccuracy=kCLLocationAccuracyBest;
    locationManager.activityType=CLActivityTypeFitness;
    locationManager.delegate=self;
    [locationManager startUpdatingLocation];
   
    _lostMapView.delegate=self;

    
    


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)searchLocalBtnPressed:(id)sender {
    
    
    lostAddress=_lostAddressText.text;
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
        
            MKCoordinateRegion region=_lostMapView.region;
            //定義地圖的縮放及位置
            region.center=placemark.location.coordinate;
            //將現在的位置顯示於地圖中間
            region.span.latitudeDelta=0.04;
            region.span.longitudeDelta=0.04;
            [_lostMapView setRegion:region animated:true];

            MKPointAnnotation *annotation=[MKPointAnnotation new];
            //MKPointAnnotation
            annotation.coordinate=placemark.location.coordinate;
            annotation.title=@"遺失地點";
            annotation.subtitle=@"他是一隻狗";
            [_lostMapView addAnnotation: annotation ];
        }
    
    
    
    }];
}
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray*)locations{
    
    currentLocation=locations.lastObject;
    //取得最新的位置
    
    if (isFirstLocationReceived==false) {
        MKCoordinateRegion region=_lostMapView.region;
        //定義地圖的縮放及位置
        region.center=currentLocation.coordinate;
        //將現在的位置顯示於地圖中間
        region.span.latitudeDelta=0.04;
        region.span.longitudeDelta=0.04;
        //顯示地圖的範圍
        //透過span 設定經緯度 ，會影響顯示出來的大小，數字越大顯示的範圍越大，數字越小顯示的範圍越小
        [_lostMapView setRegion:region animated:true];
        
        isFirstLocationReceived=true;
        
        
    }
    
    
    
    
    
}
-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation

{
    if (annotation==mapView.userLocation){
        return nil;
    }
    
    
    MKPinAnnotationView * resultView=(MKPinAnnotationView*)
    [mapView dequeueReusableAnnotationViewWithIdentifier:@"s"];
    
    if (resultView==nil) {
        resultView=[[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"s"];
    }
    
    else
        //如果有回收的大頭針，取出沒在使用的大頭針
    {
        resultView.annotation=annotation;
    }
    resultView.animatesDrop=true;
    return resultView;
    
}
- (IBAction)sendLocalBtnPressed:(id)sender {

    [self dismissViewControllerAnimated:true completion:^{
    
    
    [[NSNotificationCenter defaultCenter]postNotificationName:LOST_LOCALADDRESS_NOTIFICATION object:lostAddress];
    
    
    }];
    

    
}
- (IBAction)cancelBtnPressed:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
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
