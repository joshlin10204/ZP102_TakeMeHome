//
//  adoptProfileVC.m
//  TakeMeHome
//
//  Created by Nigel on 2015/8/3.
//  Copyright (c) 2015年 Josh. All rights reserved.
//

#import "adoptProfileVC.h"
#import "adoptDetailTableVC.h"
#import "aboutMeVC.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "HMSegmentedControl.h"
#import "FUIButton.h"
#import "UIColor+FlatUI.h"
#import "adoptView.h"

#import <QuartzCore/QuartzCore.h>

@interface adoptProfileVC ()<UIScrollViewDelegate>
{
    NSArray *getAnimailProfile;
}

@property (weak, nonatomic) IBOutlet FUIButton *closeBtn;
@property (weak, nonatomic) IBOutlet FUIButton *favoriteBtn;

@property (weak, nonatomic) IBOutlet UIView *aboutMeVC;
@property (weak, nonatomic) IBOutlet UIView *detailVC;
@property (weak, nonatomic) IBOutlet UIImageView *petImgView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) HMSegmentedControl *segmentedControl;

@end

@implementation adoptProfileVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setSegmentedControlSettings];
    [self setProfileAndAboutView];
    [self btnSettings];
    
//    _detailVC.hidden = YES;
    _aboutMeVC.hidden = false;
    
    NSString *urlStr = [getAnimailProfile valueForKey:ANIMAL_ALBUM_FILE_FILTER_KEY];

    [self.petImgView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:nil];
    
}

- (void)btnSettings{
    if ( [[getAnimailProfile valueForKey:ANIMAL_FAVORITE_CUSTOMER_FILTER_KEY] isEqualToString:@"Y"] ) {
        //已加入最愛
        _favoriteBtn.buttonColor = [UIColor alizarinColor];
        _favoriteBtn.shadowColor = [UIColor pomegranateColor];
        [_favoriteBtn setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal];
    }else{
        _favoriteBtn.buttonColor = [UIColor cloudsColor];
        _favoriteBtn.shadowColor = [UIColor silverColor];
        [_favoriteBtn setTitleColor:[UIColor alizarinColor] forState:UIControlStateNormal];
    }
    
    _favoriteBtn.shadowHeight = 5.0f;
    _favoriteBtn.cornerRadius = 10.0f;
    
    
    
    _closeBtn.buttonColor = [UIColor cloudsColor];
    _closeBtn.shadowColor = [UIColor silverColor];
    _closeBtn.shadowHeight = 5.0f;
    _closeBtn.cornerRadius = 10.0f;
    
    [_closeBtn setTitleColor:[UIColor alizarinColor] forState:UIControlStateNormal];
    [_closeBtn setTitleColor:[UIColor cloudsColor] forState:UIControlStateHighlighted];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat pageWidth = scrollView.frame.size.width;
    NSInteger page = scrollView.contentOffset.x / pageWidth;
    
    [self.segmentedControl setSelectedSegmentIndex:page animated:YES];
}


- (void)setProfileAndAboutView{
    
    NSLog(@"%f",self.scrollView.contentSize.width);
    CGFloat viewWidth = CGRectGetWidth(self.view.frame);
    CGFloat viewHeight = CGRectGetHeight(self.view.frame);
    
    
    _detailVC.frame = CGRectMake(0, 0, viewWidth, viewHeight);
    [self.scrollView addSubview:_detailVC];
    UIView * view = [[UIView alloc] initWithFrame:self.detailVC.frame];
    [view setBackgroundColor:[UIColor greenColor]];
    [view addSubview:self.detailVC];
    [self.scrollView addSubview:view];
    
    _aboutMeVC.frame = CGRectMake(viewWidth, 0, viewWidth, viewHeight);
    [self.scrollView addSubview:_aboutMeVC];
    NSLog(@"%f",self.scrollView.contentSize.width);
    
    //?????????????
}

- (void)setSegmentedControlSettings{
    CGFloat viewWidth = CGRectGetWidth(self.view.frame);
    CGFloat viewHeight = CGRectGetHeight(self.view.frame);
    self.segmentedControl = [[HMSegmentedControl alloc] initWithFrame:CGRectMake(0, viewHeight/2-20, viewWidth, 50)];
    self.segmentedControl.sectionTitles = @[@"基本資料", @"關於我"];
    self.segmentedControl.selectedSegmentIndex = 0;
    self.segmentedControl.backgroundColor = [UIColor colorWithRed:0.1 green:0.4 blue:0.8 alpha:1];
    self.segmentedControl.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    self.segmentedControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:1]};
    self.segmentedControl.selectionIndicatorColor = [UIColor colorWithRed:0.5 green:0.8 blue:1 alpha:1];
    self.segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleBox;
    self.segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    self.segmentedControl.tag = 1000;
    
    __weak typeof(self) weakSelf = self;
    [self.segmentedControl setIndexChangeBlock:^(NSInteger index) {
        [weakSelf.scrollView scrollRectToVisible:CGRectMake(viewWidth * index, 0, viewWidth, 200) animated:YES];
    }];
    
    [self.view addSubview:self.segmentedControl];
    
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, viewHeight/2+30, viewWidth, viewHeight)];
    self.scrollView.backgroundColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1];
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.contentSize = CGSizeMake(viewWidth * 2, viewHeight);
    self.scrollView.delegate = self;
    [self.scrollView scrollRectToVisible:CGRectMake(viewWidth, 0, viewWidth, viewHeight) animated:NO];
    [self.view addSubview:self.scrollView];
}


- (IBAction)segmentChange:(id)sender {
//    UISegmentedControl *segmentC = sender;
//    switch (segmentC.selectedSegmentIndex) {
//        case 0://detail
//            _detailVC.hidden = false;
//            _aboutMeVC.hidden = true;
//            break;
//        case 1://about me
//            _detailVC.hidden = true;
//            _aboutMeVC.hidden = false;
//            break;
//
//    }
    
}




- (void)setAnimalProfile:(NSArray*)animalProfileArray{
    getAnimailProfile = animalProfileArray;
}

- (IBAction)favoriteBtnPressed:(FUIButton*)button {
    NSString *documentsDirectory = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *fullFileName = [documentsDirectory stringByAppendingPathComponent:SAVE_PLIST_FILE_NAME];
    //load file
    NSArray *plistArray = [[NSArray alloc]initWithContentsOfFile:fullFileName];
    
    if (button.buttonColor == [UIColor cloudsColor]) {
        //加入最愛
        button.buttonColor = [UIColor alizarinColor];
        button.shadowColor = [UIColor pomegranateColor];
        [button setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal];
        [getAnimailProfile setValue:@"Y" forKey:ANIMAL_FAVORITE_CUSTOMER_FILTER_KEY];
        NSString *selectAnimalId = [getAnimailProfile valueForKey:ANIMAL_ID_FILTER_KEY];
        for (NSDictionary *tmp in plistArray) {
            if ([tmp[ANIMAL_ID_FILTER_KEY] isEqualToString:selectAnimalId]) {
                [tmp setValue:@"Y" forKey:ANIMAL_FAVORITE_CUSTOMER_FILTER_KEY];
            }
        }
    }else{
        //取消最愛
        button.buttonColor = [UIColor cloudsColor];
        button.shadowColor = [UIColor silverColor];
        [button setTitleColor:[UIColor alizarinColor] forState:UIControlStateNormal];
        [getAnimailProfile setValue:@"N" forKey:ANIMAL_FAVORITE_CUSTOMER_FILTER_KEY];
        NSString *selectAnimalId = [getAnimailProfile valueForKey:ANIMAL_ID_FILTER_KEY];
        for (NSDictionary *tmp in plistArray) {
            if ([tmp[ANIMAL_ID_FILTER_KEY] isEqualToString:selectAnimalId]) {
                [tmp setValue:@"N" forKey:ANIMAL_FAVORITE_CUSTOMER_FILTER_KEY];
            }
        }
    }
    
    [plistArray writeToFile:fullFileName atomically:YES];
    
}

- (IBAction)exitBtnPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
}

-(void)dealloc{
    NSLog(@"die");
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{

    if ([segue.identifier isEqualToString:@"profileSegue"]){
        adoptDetailTableVC *myEmbedTVC = segue.destinationViewController;
        [myEmbedTVC setAnimalProfile:getAnimailProfile];
        
    }
    if ([segue.identifier isEqualToString:@"aboutMeSegue"]){
        aboutMeVC *myEmbedVC = segue.destinationViewController;
        [myEmbedVC setAnimalProfile:getAnimailProfile];
    }
    
}


@end
