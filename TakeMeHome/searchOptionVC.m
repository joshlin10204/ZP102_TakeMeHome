//
//  searchOptionVC.m
//  TakeMeHome
//
//  Created by Nigel on 2015/8/22.
//  Copyright (c) 2015年 Josh. All rights reserved.
//

#import "indexAdoptVC.h"

#import "searchOptionVC.h"
#import "adoptView.h"

#import "FUIButton.h"
#import "FUIAlertView.h"
#import "UIColor+FlatUI.h"
#import "UIFont+FlatUI.h"
#import "UIColor+Hex.h"
#import "SSBouncyButton.h"

#import <QuartzCore/QuartzCore.h>

#define LABEL_TAG 1000
#define BUTTON_OPTIONS_TAG 2000
#define BUTTON_OPTIONS_SHADOW_HEIGHT 5.0f


@interface searchOptionVC ()<UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate>
{

    UIPickerView *areaPickView;
    NSArray *areaArray ;
    NSString *getAreaNumStr;
    NSString *filterSearchDoneStr;
}

@property (weak, nonatomic) IBOutlet FUIButton *dogBtn;
@property (weak, nonatomic) IBOutlet FUIButton *catBtn;
@property (weak, nonatomic) IBOutlet FUIButton *maleBtn;
@property (weak, nonatomic) IBOutlet FUIButton *femaleBtn;
@property (weak, nonatomic) IBOutlet FUIButton *adultBtn;
@property (weak, nonatomic) IBOutlet FUIButton *childBtn;
@property (weak, nonatomic) IBOutlet FUIButton *personalBtn;
@property (weak, nonatomic) IBOutlet FUIButton *govBtn;

@property (weak, nonatomic) IBOutlet SSBouncyButton *okBtn;
@property (weak, nonatomic) IBOutlet SSBouncyButton *cencelBtn;

@property (weak, nonatomic) IBOutlet UIView *myView;

@property (weak, nonatomic) IBOutlet UILabel *areaLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *sexLabel;
@property (weak, nonatomic) IBOutlet UILabel *sourceLabel;

@property (weak, nonatomic) IBOutlet UITextField *areaTxtField;

@end


@implementation searchOptionVC




- (void)viewDidLoad{
    [super viewDidLoad];

    _myView.layer.cornerRadius = 10;
    [self setLabelSettings];
    [self setOptionsBtnSettings];
    [self setOkDelBtnSettings];
    [self setAreaPickerView];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    return areaArray.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    
    return [areaArray objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    getAreaNumStr = [NSString stringWithFormat:@"%d",row + 1] ;//編碼起始號碼為2號
    _areaTxtField.text = [areaArray objectAtIndex:row];
}


- (void)setLabelSettings{
    for (int i = LABEL_TAG ; i < 5 + LABEL_TAG; i++) {
        UILabel *tmpLabel;
        tmpLabel = (UILabel*)[self.view viewWithTag:i];
        tmpLabel.backgroundColor = [UIColor sunflowerColor];
        tmpLabel.layer.cornerRadius = 20;
        tmpLabel.layer.masksToBounds = YES;
        tmpLabel.font = [UIFont iconFontWithSize:17];
    }
}

- (void)setOptionsBtnSettings{
    for (int i = BUTTON_OPTIONS_TAG ; i < 8 + BUTTON_OPTIONS_TAG ; i++) {
        FUIButton *tmpBtn ;
        tmpBtn = (FUIButton*)[self.view viewWithTag:i];
        
        //left = blue , right = red
        if (i % 2 == 0) {
            //left
            tmpBtn.buttonColor = [UIColor peterRiverColor];
            tmpBtn.shadowColor = [UIColor belizeHoleColor];
        }else{
            //right
            tmpBtn.buttonColor = [UIColor alizarinColor];
            tmpBtn.shadowColor = [UIColor pomegranateColor];
        }
        tmpBtn.shadowHeight = BUTTON_OPTIONS_SHADOW_HEIGHT;
        tmpBtn.cornerRadius = 6.0f;
        tmpBtn.titleLabel.font = [UIFont boldFlatFontOfSize:16];
        [tmpBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [tmpBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [tmpBtn addTarget:self action:@selector(optionsBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    }

}

- (void)optionsBtnPressed:(UIButton*)button{
    NSString *btnTxt = button.titleLabel.text;
    if ([btnTxt containsString:@"✔︎"] ) {
        btnTxt = [btnTxt stringByReplacingOccurrencesOfString:@"✔︎ " withString:@""];
    }else{
        btnTxt = [NSString stringWithFormat:@"✔︎ %@",btnTxt];
    }

    [button setTitle:btnTxt forState:UIControlStateNormal];
}

- (void)setOkDelBtnSettings{
    //OK
    _okBtn.adjustsImageWhenHighlighted = NO;
    _okBtn.tintColor = [UIColor colorWithHex:SSBouncyButtonDefaultTintColor];
    _okBtn.cornerRadius = SSBouncyButtonDefaultCornerRadius;
    _okBtn.titleLabel.font = [UIFont systemFontOfSize:SSBouncyButtonDefaultTitleLabelFontSize];
    [_okBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [_okBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected | UIControlStateHighlighted];
    
    [_okBtn setTitle:@"OK" forState:UIControlStateNormal];
    [_okBtn setTitle:@"OK" forState:UIControlStateSelected];
    [_okBtn addTarget:self action:@selector(OkBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    //Cancel
    _cencelBtn.adjustsImageWhenHighlighted = NO;
    _cencelBtn.tintColor = [UIColor pumpkinColor];
    _cencelBtn.cornerRadius = SSBouncyButtonDefaultCornerRadius;
    _cencelBtn.titleLabel.font = [UIFont systemFontOfSize:SSBouncyButtonDefaultTitleLabelFontSize];
    [_cencelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [_cencelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected | UIControlStateHighlighted];
    
    [_cencelBtn setTitle:@"Cancel" forState:UIControlStateNormal];
    [_cencelBtn setTitle:@"Cancel" forState:UIControlStateSelected];
    [_cencelBtn addTarget:self action:@selector(cancelBtnPressed:) forControlEvents:UIControlEventTouchUpInside];

}

- (void)cancelBtnPressed:(UIButton*)button{
    //dissmiss
    [self.parentViewController dismissViewControllerAnimated:true completion:nil];
}

- (void)OkBtnPressed:(UIButton*)button{

    //do segue
    
    //判斷user選項是否正確點選 並取得user選項
    NSString* getUserOptionStr = [self judgeUserOptins];
    
    if (getUserOptionStr != nil) {
        //使用者輸入正確
        
        //解出正確的NSPredicate語法
        filterSearchDoneStr = [self analyseUserOption:getUserOptionStr];

        //do segue push to next view
        [self.parentViewController dismissViewControllerAnimated:false completion:^{
            
            [[NSNotificationCenter defaultCenter]postNotificationName:USER_PRESSED_OK_BTN_NOTIFICATION object:filterSearchDoneStr];
            
        }];

        
    }
}



- (void)dealloc{
    NSLog(@"searchOptionVC die");
}

- (NSString*)analyseUserOption:(NSString*)options{
    
    //地區可能為1碼或2碼  +  選項共8碼

    NSLog(@"%@",options);
    
    NSString *filterDoneStr ;
    NSString *areaStr;
    NSString *typeStr;
    NSString *sexStr;
    NSString *ageStr;
    
    NSInteger searchIndex;
    
    //地區  種類  性別  年齡  來源

    //區碼1位 or 區碼2位
    if (options.length == 9) {
        areaStr = [NSString stringWithFormat:@"(%@ == '%@')",ANIMAL_AREA_PKID_FILTER_KEY,[options substringToIndex:1]];
         searchIndex = 1;
    }else if (options.length == 10){
        areaStr = [NSString stringWithFormat:@"(%@ == '%@')",ANIMAL_AREA_PKID_FILTER_KEY,[options substringToIndex:2]];
        searchIndex = 2;
    }
    
    
    for (int i = searchIndex ; i <= (options.length - 2); i+=2) {
        NSString *subStr = [options substringWithRange:NSMakeRange(i, 2)];
        NSString *firstStr = [subStr substringWithRange:NSMakeRange(0, 1)];
        NSString *secondStr = [subStr substringWithRange:NSMakeRange(1, 1)];
        
        //種類
        if ([subStr containsString:@"貓"] || [subStr containsString:@"狗"]) {
            typeStr = [NSString stringWithFormat:@"((%@ == '%@') OR (%@ == '%@'))",ANIMAL_KIND_FILTER_KEY,firstStr,ANIMAL_KIND_FILTER_KEY,secondStr ];
        
        //性別
        }else if([subStr containsString:@"公"] || [subStr containsString:@"母"]){
            if ([firstStr isEqualToString:@"公"]) {
                firstStr = @"M";
            }
            if([secondStr isEqualToString:@"母"]) {
                secondStr = @"F";
            }
            
            //除了公、母兩種  該api也有提供"N"這個"未輸入"的選項...
            if ([firstStr isEqualToString:@"M"] && [secondStr isEqualToString:@"F"] ){
                sexStr = [NSString stringWithFormat:@"((%@ == '%@') OR (%@ == '%@') OR (%@ == 'N'))",ANIMAL_SEX_FILTER_KEY,firstStr,ANIMAL_SEX_FILTER_KEY,secondStr,ANIMAL_SEX_FILTER_KEY];
            }else{
                sexStr = [NSString stringWithFormat:@"((%@ == '%@') OR (%@ == '%@'))",ANIMAL_SEX_FILTER_KEY,firstStr,ANIMAL_SEX_FILTER_KEY,secondStr];
            }
            
           
           
        //年齡
        }else if ([subStr containsString:@"成"] || [subStr containsString:@"幼"]){
            if ([firstStr isEqualToString:@"成"]) {
                firstStr = @"ADULT";
            }
            if([secondStr isEqualToString:@"幼"]) {
                secondStr = @"CHILD";
            }
            ageStr = [NSString stringWithFormat:@"((%@ == '%@') OR (%@ == '%@'))",ANIMAL_AGE_FILTER_KEY,firstStr,ANIMAL_AGE_FILTER_KEY,secondStr];
        }
    }

    filterDoneStr = [NSString stringWithFormat:@"%@ AND %@ AND %@ AND %@",areaStr,typeStr,sexStr,ageStr];
    return filterDoneStr;
}


- (NSString*)judgeUserOptins{
    
    UIButton *tmpBtn;
    NSMutableArray *getUserOptionsArray = [NSMutableArray new];
    NSInteger noInputCount = 0;
    NSString *userOptionsStr = [NSString new];
    if ([getAreaNumStr isEqualToString:@"1"] || getAreaNumStr == nil) {
        [self showAlertView:@"請確認地區"];
        return false;
    }else{
        [getUserOptionsArray addObject:getAreaNumStr];
    }
    userOptionsStr = [NSString stringWithFormat:@"%@%@",userOptionsStr,[getUserOptionsArray objectAtIndex:0]];
    
    for (int i = BUTTON_OPTIONS_TAG; i < 8 + BUTTON_OPTIONS_TAG; i++) {
        tmpBtn = (UIButton*)[self.view viewWithTag:i];
        //兩個btn為一組 一定要至少選一個選項
        if ( i % 2 == 0){
            noInputCount = 0;
        }
        if ([tmpBtn.titleLabel.text containsString:@"✔︎"]) {
            NSString *optionStr = [tmpBtn.titleLabel.text stringByReplacingOccurrencesOfString:@"✔︎ " withString:@""];
            [getUserOptionsArray addObject:[optionStr substringToIndex:1]];
        }else{
            [getUserOptionsArray addObject:@(0)];
            noInputCount++;
        }
        
        if (noInputCount >= 2) {
            [self showAlertView:@"請確認種類、性別、年齡跟來源"];
            return false;
        }
        userOptionsStr = [NSString stringWithFormat:@"%@%@",userOptionsStr,[getUserOptionsArray objectAtIndex:i - BUTTON_OPTIONS_TAG + 1]];
        
        
    }
    
    
    return userOptionsStr;
}

- (void)showAlertView:(NSString*)msg{
    FUIAlertView *alertView = [[FUIAlertView alloc] initWithTitle:@"有資料沒填到哦"
                                                          message:msg
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles: nil];
    alertView.titleLabel.textColor = [UIColor cloudsColor];
    alertView.titleLabel.font = [UIFont boldFlatFontOfSize:16];
    alertView.messageLabel.textColor = [UIColor cloudsColor];
    alertView.messageLabel.font = [UIFont flatFontOfSize:14];
    alertView.backgroundOverlay.backgroundColor = [[UIColor cloudsColor] colorWithAlphaComponent:0.8];
    alertView.alertContainer.backgroundColor = [UIColor midnightBlueColor];
    alertView.defaultButtonColor = [UIColor cloudsColor];
    alertView.defaultButtonShadowColor = [UIColor asbestosColor];
    alertView.defaultButtonFont = [UIFont boldFlatFontOfSize:16];
    alertView.defaultButtonTitleColor = [UIColor asbestosColor];
    [alertView show];
}

- (void)setAreaPickerView{
    
    areaPickView = [UIPickerView new];
    areaPickView.delegate = self;
    
    
    
    [self.areaTxtField setInputView:areaPickView];
    [areaPickView setBackgroundColor:[UIColor colorWithRed: 1.0 green: 1.0 blue: 1.0 alpha: 1.0]];
    
    areaArray = [NSArray arrayWithObjects:
                @"",@"臺北市",@"新北市",@"基隆市",@"宜蘭縣",@"桃園縣",@"新竹縣",@"新竹市",@"苗栗縣",
                @"臺中市",@"彰化縣",@"南投縣",@"雲林縣",@"嘉義縣",@"嘉義市",@"臺南市",@"臺南市",
                @"高雄市",@"屏東縣",@"花蓮縣",@"臺東縣",@"澎湖縣",@"金門縣",@"連江縣",nil];
    
    CGFloat screenWidth = self.view.frame.size.width;
    UIToolbar *toolBar= [[UIToolbar alloc] initWithFrame:CGRectMake(0,0,screenWidth,44)];
    [toolBar setBarStyle:UIBarStyleBlackOpaque];
    UIBarButtonItem *cancelBarBtn =[[UIBarButtonItem alloc]
                                    initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                 target:self
                                                                                 action:@selector(barBtnItemPressed:)];
    
    UIBarButtonItem *spanBarBtn = [[UIBarButtonItem alloc]
                                   initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                               target:self
                                                                               action:nil];
    
    UIBarButtonItem *doneBarBtn = [[UIBarButtonItem alloc]
                                   initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                target:self
                                                                                action:@selector(barBtnItemPressed:)];
    
    toolBar.items = [[NSArray alloc] initWithObjects:cancelBarBtn,spanBarBtn, doneBarBtn,nil];
    cancelBarBtn.tintColor=[UIColor blackColor];
    doneBarBtn.tintColor=[UIColor blackColor];
    self.areaTxtField.inputAccessoryView = toolBar;
}

- (void)barBtnItemPressed:(UIBarButtonItem*)sender{
    [self.areaTxtField resignFirstResponder];
}

@end