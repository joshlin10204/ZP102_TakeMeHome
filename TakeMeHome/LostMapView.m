//
//  LostMapView.m
//  TakeMeHome
//
//  Created by Josh on 2015/8/3.
//  Copyright (c) 2015年 Josh. All rights reserved.
//

#import "LostMapView.h"
#import "SDWebImage/UIImageView+WebCache.h"

@interface LostMapView ()<UITableViewDelegate, UITableViewDataSource,MKMapViewDelegate,CLLocationManagerDelegate,MBProgressHUDDelegate>
{
    
    MBProgressHUD *HUD;
    
    //取得使用者的位置
    CLLocationManager *locationManager;
    BOOL isFirstLocationReceived;
    //使用者位置
    CLLocation*currentLocation;
    
    //lostPin的變數
    MKPointAnnotation *lostPin;

    
    //取得資料庫資料
    NSArray *locationData;

    
    //以下是為了移動lostTableView 以及mapView 的準備
    CGPoint point;
    CGFloat viewWidth;
    CGFloat viewHeight;
    CGFloat buttonHeigh;
    CGFloat lostTableViewHight;
    
    //判斷搜尋範圍
    NSInteger choiceSeachRange;
    
    NSString *objectId;


}
@property (strong, nonatomic) IBOutlet UIView *lostListView;
@property (weak, nonatomic) IBOutlet UIButton *showLostListButton;
@property (weak, nonatomic) IBOutlet MKMapView *lostMapView;
@property (weak, nonatomic) IBOutlet UITableView *lostTableView;

@end

@implementation LostMapView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    choiceSeachRange=0;
    
    
    //Loading圖示
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.delegate = self;
    HUD.labelText = @"Loading";
    [HUD show:YES];
    
    
    //lostPin的準備
     lostPin=[MKPointAnnotation new];
    
    //lostMapView 使用delegate
    _lostMapView.delegate=self;

    
    //取得使用者的位置授權
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
    
   
    //以下是為了移動lostTableView 以及mapView 的準備
    [self.view setTranslatesAutoresizingMaskIntoConstraints:YES];
    //讓view 無視Constraints
    viewWidth=self.view.frame.size.width;
    viewHeight=self.view.frame.size.height;
    //取得view的寬高
    buttonHeigh=self.showLostListButton.frame.size.height;
    //showLostListButton 的高
    lostTableViewHight=self.lostTableView.frame.size.height;
    //取得lostTableView的高
    //手勢 （收放TableView）
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
    [_showLostListButton addGestureRecognizer:pan];
    
    self.lostTableView.delegate = self;
    self.lostTableView.dataSource=self;
    
}
//當離開此頁面時 關閉更新使用者位置
-(void)viewDidDisappear:(BOOL)animated
{
    [locationManager stopUpdatingLocation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//實作手勢讓lostTableView可以上下移動
- (void)panAction:(UIPanGestureRecognizer *)pan{
    point = [pan locationInView:self.view];
    CGFloat ponintY=point.y;

    
    CGRect frame = self.lostListView.frame;
    if (ponintY>=(viewHeight*3/7)&& ponintY<=viewHeight) {
        frame.origin.y = ponintY;
        [self.lostListView setFrame:frame];
        [self.lostMapView setFrame:CGRectMake(0, 0, viewWidth, ponintY+(viewHeight*4/7*1/5*1/2))];
        if (pan.state==UIGestureRecognizerStateEnded) {
            [self showLostListBtnPressed:nil];
        }
    
    }
}


//收放lostTableView的按鈕
- (IBAction)showLostListBtnPressed:(id)sender {
    [UIView beginAnimations:@"animation" context:nil];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    
    CGRect listframe=self.lostListView.frame;
    CGFloat listViewHeigh=listframe.size.height;
    
    //向下收起
    if (listframe.origin.y==(viewHeight-listViewHeigh)) {
        //將list往外推
        listframe.origin.y=viewHeight-(viewHeight*4/7*1/5);
        //放大map
        [self.lostMapView setFrame:CGRectMake(0, 0, viewWidth, viewHeight)];
        
        NSLog(@"下1");
        _lostListView.frame=listframe;

    }
    else if (listframe.origin.y!=(viewHeight-listViewHeigh)||
             listframe.origin.y!=viewHeight-(viewHeight*4/7*1/5))
    {
        //將list推回原來的外置
        listframe.origin.y =(viewHeight-listViewHeigh);
        //縮小map
        [self.lostMapView setFrame:CGRectMake(0, 0, viewWidth, viewHeight/2)];
        NSLog(@"上2");
        _lostListView.frame=listframe;
    
    }
    
    else {
        //將list推回原來的外置
        listframe.origin.y =(viewHeight-listViewHeigh);
        //縮小map
        [self.lostMapView setFrame:CGRectMake(0, 0, viewWidth, viewHeight/2)];
        NSLog(@"上1");
        _lostListView.frame=listframe;


        
        
    }
    
    [UIView commitAnimations];
    

}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return locationData.count;    
    
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath

{
    
    LostListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"lostCell" forIndexPath:indexPath];
    cell.tag = indexPath.row;

    //顯示寵物名字
    cell.locationLabel.text=locationData[indexPath.row][@"LostPetsName"];
    cell.locationLabel.font = [UIFont fontWithName:@"Wawati SC" size:36];
    cell.locationLabel.minimumScaleFactor=.1f;
    //顯示走失時間
    cell.lostDateTitle.font = [UIFont fontWithName:@"Wawati SC" size:17];
    cell.lostDateTitle.minimumScaleFactor=.1f;
    cell.lostDateLabel.text=locationData[indexPath.row][@"LostDate"];
    cell.lostDateLabel.font = [UIFont fontWithName:@"Wawati SC" size:17];
    cell.lostDateLabel.minimumScaleFactor=.1f;

    //顯示寵物照片
    PFFile *lostPetsPhoto = locationData[indexPath.row][@"LostPetsPhotoFirst"];
    if (lostPetsPhoto==nil) {

        cell.lostPetPhoto.image=[UIImage imageNamed:@"noPhotoImage"];


    }
    else
    {

        [cell.lostPetPhoto sd_setImageWithURL:(NSURL*)((PFFile*)lostPetsPhoto).url  placeholderImage:[UIImage imageNamed:@"noPhotoImage"]];
        
    }
    
    //顯示距離
    cell.lostDistanceTitle.font = [UIFont fontWithName:@"Wawati SC" size:17];
    cell.lostDistanceTitle.minimumScaleFactor=.1f;
    cell.lostDistanceLabel.font = [UIFont fontWithName:@"Wawati SC" size:17];
    cell.lostDistanceLabel.minimumScaleFactor=.1f;
    
    PFGeoPoint *local=locationData[indexPath.row][@"LostLocation"];
    CLLocation *lostLocation = [[CLLocation alloc] initWithLatitude:local.latitude
                                                          longitude:local.longitude];
    CLLocation *userLocation = [[CLLocation alloc] initWithLatitude:currentLocation.coordinate.latitude
                                                      longitude:currentLocation.coordinate.longitude];    
    int distanceMeters = [lostLocation distanceFromLocation:userLocation];
    if (distanceMeters<1000) {
        NSString *lostDistance= [NSString stringWithFormat:@"%d 公尺",distanceMeters];
        cell.lostDistanceLabel.text=lostDistance;
    }
    else if (distanceMeters>=1000) {
        NSString *lostDistance= [NSString stringWithFormat:@"%d.%d 公里",distanceMeters/1000,distanceMeters%1000];
        cell.lostDistanceLabel.text=lostDistance;
    }
    
    
    
    
    //當按下位置按鈕時後會到locationBtnPressed 執行
    [cell.locationButton addTarget:self
                            action:@selector(locationBtnPressed:)
                  forControlEvents:UIControlEventTouchUpInside];
    
    
//    [cell.moreInformationButton  addTarget:self
//                                    action:@selector(prepareForSegue:)
//                          forControlEvents:UIControlEventTouchUpInside];
    return cell;
}


//按下寵物位置的按鈕
-(void)locationBtnPressed:(UIButton*)button{
 

    //取得第幾個cell
    LostListCell *lostCell=(LostListCell*)button.superview.superview.superview;
    PFGeoPoint *local=locationData[lostCell.tag][@"LostLocation"];
    
    if (lostPin!=nil) {
                    //移除掉在地圖上的lostPin
                    [self.lostMapView removeAnnotation:lostPin] ;
    }
    
    
    //使用者位置經緯度
    CLLocationDegrees deltaLon = currentLocation.coordinate.longitude-local.longitude;
    CLLocationDegrees deltaLat = currentLocation.coordinate.latitude-local.latitude;
    //地圖顯示中心跟範圍
    MKCoordinateRegion region=_lostMapView.region;
    region.center=CLLocationCoordinate2DMake
    ((currentLocation.coordinate.latitude+local.latitude)/2,
     (currentLocation.coordinate.longitude+local.longitude)/2);
    region.span.longitudeDelta=fabs(deltaLon)*1.8;
    region.span.latitudeDelta=fabs(deltaLat)*1.8;
    [_lostMapView setRegion:region animated:true];
    
    //插上大頭針

    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(local.latitude, local.longitude);
    lostPin.coordinate=coordinate;
    lostPin.title=@"地點2";
    lostPin.subtitle=@"貓";
    [_lostMapView addAnnotation:lostPin];

}

//取得位置
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
        
        [self downloadParse];
    }
    
}
// 設定大頭針
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

//選擇搜尋範圍
- (IBAction)choiceSeachRangeBtnPressed:(id)sender {
    NSInteger targetIndex=[sender selectedSegmentIndex];
    
    switch (targetIndex) {
        case 0:
            choiceSeachRange=0;
            NSLog(@"choiceSeachRange:%ld",(long)choiceSeachRange);
            [self downloadParse];
            [HUD show:YES];
            break;

            
        case 1:
            choiceSeachRange=1;
            NSLog(@"choiceSeachRange:%ld",(long)choiceSeachRange);
            [self downloadParse];
            [HUD show:YES];

            break;

            
        case 2:
            choiceSeachRange=2;
            NSLog(@"choiceSeachRange:%ld",(long)choiceSeachRange);
            [self downloadParse];
            [HUD show:YES];

            break;



    }

}

//Parse 資料取得
-(void)downloadParse{
    
    
    //PFQuery *Data = [PFQuery queryWithClassName:@"LostPets"];
    //locationData=[Data findObjects];
    PFGeoPoint *userGeoPoint = [PFGeoPoint geoPointWithLocation:currentLocation];
    PFQuery *Data = [PFQuery queryWithClassName:@"LostPets"];
    
    [Data findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
        if(!error)
        {
            dispatch_queue_t download = dispatch_queue_create("Download", nil);
            
            dispatch_async(download, ^{
                if (choiceSeachRange==1)
                {
                    [Data whereKey:@"LostLocation"
                      nearGeoPoint:userGeoPoint
                  withinKilometers:8];
                    locationData = [Data findObjects];
                }
                
                else if (choiceSeachRange==2)
                {
                    [Data whereKey:@"LostLocation"
                      nearGeoPoint:userGeoPoint];
                    locationData = [Data findObjects];
                }
            
                else
                {

                    [Data whereKey:@"LostLocation"
                      nearGeoPoint:userGeoPoint
                  withinKilometers:3];
                    locationData = [Data findObjects];
                }
         
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_lostTableView reloadData];
                    [HUD hide:YES];
                    NSLog(@"locationData:%@",locationData);
                });
            });
        }
        else
        {
            NSLog(@"下載資料失敗");
            UIAlertController* warningAlert=[UIAlertController alertControllerWithTitle:@"注意!" message:@"請檢查網路訊息" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* cancle=[UIAlertAction actionWithTitle:@"確定" style:UIAlertActionStyleDefault handler:nil];
            [warningAlert addAction:cancle];
            [self presentViewController:warningAlert animated:YES completion:nil];
            [HUD hide:YES];
            NSLog(@"something happens :%@",[error userInfo]);
        }
        
    }];
    
}
//當按下更多資訊的按鈕，傳送objectId 到LostMoreInformationView
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(UIButton*)sender
{
    if ([segue.identifier isEqualToString:@"goMoreInformation"]) {
        
        
        
        LostListCell *lostCell=(LostListCell*)sender.superview.superview.superview;
        PFObject *choiceLostCell=locationData[lostCell.tag];
        objectId=choiceLostCell.objectId;
       id target=segue.destinationViewController;
       [target setValue:objectId forKey:@"objectId"];
        
    }
}

-(IBAction)backLostMapView:(UIStoryboardSegue*)segue
{
    NSLog(@"backLostMapView");
    }



@end
