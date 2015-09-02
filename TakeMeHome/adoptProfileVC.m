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
    
    //[self setSegmentedControlSettings];
    //[self setProfileAndAboutView];
    [self btnSettings];
    
    _detailVC.hidden = false;
    _aboutMeVC.hidden = true;
    
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
- (IBAction)segmentChange:(id)sender {
    UISegmentedControl *segmentC = sender;
    switch (segmentC.selectedSegmentIndex) {
        case 0://detail
            _detailVC.hidden = false;
            _aboutMeVC.hidden = true;
            break;
        case 1://about me
            _detailVC.hidden = true;
            _aboutMeVC.hidden = false;
            break;

    }
    
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
