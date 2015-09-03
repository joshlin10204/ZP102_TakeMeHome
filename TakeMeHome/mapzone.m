//
//  ViewController.m
//  PROJECTTAKEMEHOME
//
//  Created by tainan boom on 2015/7/27.
//  Copyright (c) 2015年 tainan boom. All rights reserved.
//

#import "mapzone.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "mkav.h"

//   subway_station




@interface MapzoneViewController ()<CLLocationManagerDelegate,MKMapViewDelegate>

{
    CLLocationManager *locationManager;
    BOOL firstLocationReceived;
    MKPointAnnotation *popoint;
    NSMutableArray *AnnotationArray;
    
}

@property (weak, nonatomic) IBOutlet MKMapView *theMapView;
@property (nonatomic) CGFloat lat;
@property (nonatomic) CGFloat lon;

-(id)initWithLocation:(CLLocationCoordinate2D)coord;

@end

@implementation MapzoneViewController


- (IBAction)Trainstation1:(id)sender {
    
    [self.theMapView removeAnnotations:AnnotationArray];
    
    NSString * urlString = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=%.6f,%.6f&radius=800000&types=train_station&key=AIzaSyBkqRBy38Oogx5EzaUcjhPaO1b74ItIrt0",self.lat,self.lon];
    
    NSURL * url = [NSURL URLWithString:urlString];
    
    NSURLRequest * urlRequest = [NSURLRequest requestWithURL:url];
    NSURLSession * urlSession = [NSURLSession sharedSession];
    NSURLSessionTask * task =
    [urlSession dataTaskWithRequest:urlRequest
     
                  completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                      
                      NSMutableDictionary  *dictionaryr =
                      [NSJSONSerialization JSONObjectWithData:data
                                                      options:NSJSONReadingMutableContainers
                                                        error:nil];
                      
                      NSMutableArray *resultArr = [[NSMutableArray alloc]initWithArray:dictionaryr[@"results"]];
                      
                      AnnotationArray = [NSMutableArray new];
                      
                      for (NSDictionary *geoDictionary in resultArr) {
                          NSDictionary *getGeo = [[NSDictionary alloc]initWithDictionary:geoDictionary[@"geometry"]];
                          NSDictionary *getLoc = getGeo[@"location"];
                          NSString *lat = getLoc[@"lat"];
                          NSString *lng = getLoc[@"lng"];
                          
                          CLLocationCoordinate2D myCoordinate = {[lat doubleValue], [lng doubleValue]};
                          
                          popoint = [MKPointAnnotation new];
                          
                          popoint.title = geoDictionary[@"name"];
                          popoint.subtitle = geoDictionary[@"vicinity"];
                          popoint.coordinate = myCoordinate;
                          
                          [self.theMapView addAnnotation:popoint];
                          
                          [AnnotationArray addObject:popoint];
                      }
                      
                  }];
    [task resume];
}


    


- (IBAction)Parking2:(id)sender {
    
    [self.theMapView removeAnnotations:AnnotationArray];
    
    NSString * urlString = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=%.6f,%.6f&radius=800000&types=parking&key=AIzaSyBkqRBy38Oogx5EzaUcjhPaO1b74ItIrt0",self.lat,self.lon];
    
    NSURL * url = [NSURL URLWithString:urlString];
    
    NSURLRequest * urlRequest = [NSURLRequest requestWithURL:url];
    NSURLSession * urlSession = [NSURLSession sharedSession];
    NSURLSessionTask * task =
    [urlSession dataTaskWithRequest:urlRequest
     
    completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                      
    NSMutableDictionary  *dictionaryr =
        [NSJSONSerialization JSONObjectWithData:data
                                        options:NSJSONReadingMutableContainers
                                          error:nil];
                      
                      NSMutableArray *resultArr = [[NSMutableArray alloc]initWithArray:dictionaryr[@"results"]];
                      
                      AnnotationArray = [NSMutableArray new];
                      
                      for (NSDictionary *geoDictionary in resultArr) {
                          NSDictionary *getGeo = [[NSDictionary alloc]initWithDictionary:geoDictionary[@"geometry"]];
                          NSDictionary *getLoc = getGeo[@"location"];
                          NSString *lat = getLoc[@"lat"];
                          NSString *lng = getLoc[@"lng"];
                          
                          CLLocationCoordinate2D myCoordinate = {[lat doubleValue], [lng doubleValue]};
                          
                          popoint = [MKPointAnnotation new];
                          
                          popoint.title = geoDictionary[@"name"];
                          popoint.subtitle = geoDictionary[@"vicinity"];
                          popoint.coordinate = myCoordinate;
                          
                          [self.theMapView addAnnotation:popoint];
                          
                          [AnnotationArray addObject:popoint];
                      }
                  }];
    [task resume];
}


- (IBAction)Park3:(id)sender {

    [self.theMapView removeAnnotations:AnnotationArray];
    
    NSString * urlString = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=%.6f,%.6f&radius=800000&types=park&key=AIzaSyBkqRBy38Oogx5EzaUcjhPaO1b74ItIrt0",self.lat,self.lon];
    
    NSURL * url = [NSURL URLWithString:urlString];
    
    NSURLRequest * urlRequest = [NSURLRequest requestWithURL:url];
    NSURLSession * urlSession = [NSURLSession sharedSession];
    NSURLSessionTask * task =
    [urlSession dataTaskWithRequest:urlRequest
     
                  completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                      
                      NSMutableDictionary  *dictionaryr = [NSJSONSerialization JSONObjectWithData:data
                                                                                          options:NSJSONReadingMutableContainers
                                                                                            error:nil];
                      
                      NSMutableArray *resultArr = [[NSMutableArray alloc]initWithArray:dictionaryr[@"results"]];
                      
                      AnnotationArray = [NSMutableArray new];
                      
                      for (NSDictionary *geoDictionary in resultArr) {
                          NSDictionary *getGeo = [[NSDictionary alloc]initWithDictionary:geoDictionary[@"geometry"]];
                          NSDictionary *getLoc = getGeo[@"location"];
                          NSString *lat = getLoc[@"lat"];
                          NSString *lng = getLoc[@"lng"];
                          
                          CLLocationCoordinate2D myCoordinate = {[lat doubleValue], [lng doubleValue]};
                          
                          popoint = [MKPointAnnotation new];
                          
                          popoint.title = geoDictionary[@"name"];
                          popoint.subtitle = geoDictionary[@"vicinity"];
                          popoint.coordinate = myCoordinate;
                          
                          [self.theMapView addAnnotation:popoint];
                          
                          [AnnotationArray addObject:popoint];
                      }
                  }];
    [task resume];
}


- (IBAction)Hospital4:(id)sender {
    
    
    [self.theMapView removeAnnotations:AnnotationArray];
    
    NSString * keyword = @"動物";
    NSString * keywordEscape = [keyword stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString * urlString = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=%.6f,%.6f&radius=800000&types=veterinary_care&name=%@&key=AIzaSyBkqRBy38Oogx5EzaUcjhPaO1b74ItIrt0",self.lat,self.lon,keywordEscape];
    
    NSURL * url = [NSURL URLWithString:urlString];
    
    NSURLRequest * urlRequest = [NSURLRequest requestWithURL:url];
    NSURLSession * urlSession = [NSURLSession sharedSession];
    NSURLSessionTask * task =
    [urlSession dataTaskWithRequest:urlRequest
     
    completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                      
    NSMutableDictionary  *dictionaryr =
    [NSJSONSerialization JSONObjectWithData:data
                                    options:NSJSONReadingMutableContainers
                                      error:nil];
                      
        NSMutableArray *resultArr = [[NSMutableArray alloc]initWithArray:dictionaryr[@"results"]];
                      
                      AnnotationArray = [NSMutableArray new];
                      
                      for (NSDictionary *geoDictionary in resultArr) {
                          NSDictionary *getGeo = [[NSDictionary alloc]initWithDictionary:geoDictionary[@"geometry"]];
                          NSDictionary *getLoc = getGeo[@"location"];
                          NSString *lat = getLoc[@"lat"];
                          NSString *lng = getLoc[@"lng"];
                          
                          CLLocationCoordinate2D myCoordinate = {[lat doubleValue], [lng doubleValue]};
                          
                          popoint = [MKPointAnnotation new];
                          
                          popoint.title = geoDictionary[@"name"];
                          popoint.subtitle = geoDictionary[@"vicinity"];
                          popoint.coordinate = myCoordinate;
                          
                          [self.theMapView addAnnotation:popoint];
                          
                          [AnnotationArray addObject:popoint];
                      }
                  }];
    [task resume];
}

- (IBAction)Beautysalon5:(id)sender {

    [self.theMapView removeAnnotations:AnnotationArray];
    
    NSString * keyword = @"寵物";
    NSString * keywordEscape = [keyword stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString * urlString = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=%.6f,%.6f&radius=800000&types=beauty_salon&name=%@&key=AIzaSyBkqRBy38Oogx5EzaUcjhPaO1b74ItIrt0",self.lat,self.lon,keywordEscape];
    
    NSURL * url = [NSURL URLWithString:urlString];
    
    NSURLRequest * urlRequest = [NSURLRequest requestWithURL:url];
    NSURLSession * urlSession = [NSURLSession sharedSession];
    NSURLSessionTask * task =
    [urlSession dataTaskWithRequest:urlRequest
     
    completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                      
    NSMutableDictionary  *dictionaryr =
        [NSJSONSerialization JSONObjectWithData:data
                                        options:NSJSONReadingMutableContainers
                                          error:nil];
                      
        NSMutableArray *resultArr = [[NSMutableArray alloc]initWithArray:dictionaryr[@"results"]];
                      
                      AnnotationArray = [NSMutableArray new];
                      
                      for (NSDictionary *geoDictionary in resultArr) {
                          NSDictionary *getGeo = [[NSDictionary alloc]initWithDictionary:geoDictionary[@"geometry"]];
                          NSDictionary *getLoc = getGeo[@"location"];
                          NSString *lat = getLoc[@"lat"];
                          NSString *lng = getLoc[@"lng"];
                          
                          CLLocationCoordinate2D myCoordinate = {[lat doubleValue], [lng doubleValue]};
                          
                          popoint = [MKPointAnnotation new];
                          
                          popoint.title = geoDictionary[@"name"];
                          popoint.subtitle = geoDictionary[@"vicinity"];
                          popoint.coordinate = myCoordinate;
                          
                          [self.theMapView addAnnotation:popoint];
                          
                          [AnnotationArray addObject:popoint];
                      }
                  }];
    [task resume];
}


- (IBAction)Petlodging6:(id)sender {
    
    [self.theMapView removeAnnotations:AnnotationArray];
    
    NSString * keyword = @"物";
    NSString * keywordEscape = [keyword stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString * urlString = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=%.6f,%.6f&radius=800000&name=%@&key=AIzaSyBkqRBy38Oogx5EzaUcjhPaO1b74ItIrt0",self.lat,self.lon,keywordEscape];
    
    NSURL * url = [NSURL URLWithString:urlString];
    
    NSURLRequest * urlRequest = [NSURLRequest requestWithURL:url];
    NSURLSession * urlSession = [NSURLSession sharedSession];
    NSURLSessionTask * task =
    [urlSession dataTaskWithRequest:urlRequest
     
                  completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                      
                      NSMutableDictionary  *dictionaryr = [NSJSONSerialization JSONObjectWithData:data
                                                                                          options:NSJSONReadingMutableContainers
                                                                                            error:nil];
                      
                      NSMutableArray *resultArr = [[NSMutableArray alloc]initWithArray:dictionaryr[@"results"]];
                      
                      AnnotationArray = [NSMutableArray new];
                      
                      for (NSDictionary *geoDictionary in resultArr) {
                          NSDictionary *getGeo = [[NSDictionary alloc]initWithDictionary:geoDictionary[@"geometry"]];
                          NSDictionary *getLoc = getGeo[@"location"];
                          NSString *lat = getLoc[@"lat"];
                          NSString *lng = getLoc[@"lng"];
                          
                          CLLocationCoordinate2D myCoordinate = {[lat doubleValue], [lng doubleValue]};
                          
                          popoint = [MKPointAnnotation new];
                          
                          popoint.title = geoDictionary[@"name"];
                          popoint.subtitle = geoDictionary[@"vicinity"];
                          popoint.coordinate = myCoordinate;
                          
                          [self.theMapView addAnnotation:popoint];
                          
                          [AnnotationArray addObject:popoint];
                      }
                  }];
    [task resume];
}


- (IBAction)Store7:(id)sender {
    
    [self.theMapView removeAnnotations:AnnotationArray];
    
    NSString * keyword = @"寵物";
    NSString * keywordEscape = [keyword stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString * urlString = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=%.6f,%.6f&radius=8000000&types=pet_store&name=%@&key=AIzaSyBkqRBy38Oogx5EzaUcjhPaO1b74ItIrt0",self.lat,self.lon,keywordEscape];
    
    NSURL * url = [NSURL URLWithString:urlString];
    
    NSURLRequest * urlRequest = [NSURLRequest requestWithURL:url];
    NSURLSession * urlSession = [NSURLSession sharedSession];
    NSURLSessionTask * task =
    [urlSession dataTaskWithRequest:urlRequest
     
                  completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                      
                      NSMutableDictionary  *dictionaryr = [NSJSONSerialization JSONObjectWithData:data
                                                                                          options:NSJSONReadingMutableContainers
                                                                                            error:nil];
                      
                      NSMutableArray *resultArr = [[NSMutableArray alloc]initWithArray:dictionaryr[@"results"]];
                      
                      AnnotationArray = [NSMutableArray new];
                      
                      for (NSDictionary *geoDictionary in resultArr) {
                          NSDictionary *getGeo = [[NSDictionary alloc]initWithDictionary:geoDictionary[@"geometry"]];
                          NSDictionary *getLoc = getGeo[@"location"];
                          NSString *lat = getLoc[@"lat"];
                          NSString *lng = getLoc[@"lng"];
                          
                          CLLocationCoordinate2D myCoordinate = {[lat doubleValue], [lng doubleValue]};
                          
                          popoint = [MKPointAnnotation new];
                          
                          popoint.title = geoDictionary[@"name"];
                          popoint.subtitle = geoDictionary[@"vicinity"];
                          popoint.coordinate = myCoordinate;
                          
                          [self.theMapView addAnnotation:popoint];
                          
                          [AnnotationArray addObject:popoint];
                      }
                  }];
    [task resume];
}

- (IBAction)Restraunt8:(id)sender {
    
    [self.theMapView removeAnnotations:AnnotationArray];
    
    
    NSString * keyword = @"寵物";
    NSString * keywordEscape = [keyword stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString * urlString = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=%.6f,%.6f&radius=800000&types=restaurant&name=%@&key=AIzaSyBkqRBy38Oogx5EzaUcjhPaO1b74ItIrt0",self.lat,self.lon,keywordEscape];
    
    NSURL * url = [NSURL URLWithString:urlString];
    
    NSURLRequest * urlRequest = [NSURLRequest requestWithURL:url];
    NSURLSession * urlSession = [NSURLSession sharedSession];
    NSURLSessionTask * task =
    [urlSession dataTaskWithRequest:urlRequest
     
                  completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                      
                      NSMutableDictionary  *dictionaryr = [NSJSONSerialization JSONObjectWithData:data
                                                                                          options:NSJSONReadingMutableContainers
                                                                                            error:nil];
                      
                      NSMutableArray *resultArr = [[NSMutableArray alloc]initWithArray:dictionaryr[@"results"]];
                      
                      AnnotationArray = [NSMutableArray new];
                      
                      for (NSDictionary *geoDictionary in resultArr) {
                          NSDictionary *getGeo = [[NSDictionary alloc]initWithDictionary:geoDictionary[@"geometry"]];
                          NSDictionary *getLoc = getGeo[@"location"];
                          NSString *lat = getLoc[@"lat"];
                          NSString *lng = getLoc[@"lng"];
                          
                          CLLocationCoordinate2D myCoordinate = {[lat doubleValue], [lng doubleValue]};
                          
                          popoint = [MKPointAnnotation new];
                          
                          popoint.title = geoDictionary[@"name"];
                          popoint.subtitle = geoDictionary[@"vicinity"];
                          popoint.coordinate = myCoordinate;
                          
                          [self.theMapView addAnnotation:popoint];
                          
                          [AnnotationArray addObject:popoint];
                      }
                  }];
    [task resume];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    locationManager=[CLLocationManager new];
    
    NSMutableArray *array = [NSMutableArray new];
    
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.activityType = CLActivityTypeAutomotiveNavigation;
    locationManager.delegate = self;
    [locationManager requestWhenInUseAuthorization];
    [locationManager startUpdatingLocation];
    
    //    self.theMapView.delegate = self;
    
    _theMapView.userTrackingMode=MKUserTrackingModeFollow;
    [self.theMapView setShowsUserLocation:YES];
    
    //MKPointAnnotation *popoint;
    
    //    [self.theMapView removeAnnotation:popoint];
    
    //=24.5000,121.1400&
    //https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=24.5000,121.1400&radius=800000&types=pet_store&key=AIzaSyBkqRBy38Oogx5EzaUcjhPaO1b74ItIrt0
    
}

- (void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    CLLocation *newLocation = locations.lastObject;
    
    self.lat = newLocation.coordinate.latitude;
    self.lon = newLocation.coordinate.longitude;
    
    NSLog(@"Current Location: %.6f,%.6f",newLocation.coordinate.latitude,newLocation.coordinate.longitude);
}

-(void)viewDidAppear:(BOOL)animated{
    //    self.theMapView.centerCoordinate = CLLocationCoordinate2DIsValid (25.0335, 121.5651);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end















































