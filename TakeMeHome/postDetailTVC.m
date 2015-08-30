//
//  postDetailTVC.m
//  TakeMeHome
//
//  Created by Nigel on 2015/8/28.
//  Copyright (c) 2015年 Josh. All rights reserved.
//

#import "postDetailTVC.h"
#import "SSBouncyButton.h"
#import "UIColor+FlatUI.h"
#import "FUIAlertView.h"
#import "MBProgressHUD.h"
#import "adoptView.h"


#import <Parse/Parse.h>

@interface postDetailTVC ()
<UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate,MBProgressHUDDelegate>
{
	MBProgressHUD *HUD;
    UIPickerView *areaPickView;
    NSArray *areaArray ;
    NSString *getAreaNumStr;
    
}
@property (weak, nonatomic) IBOutlet UITextField *areaTxtField;
@property (weak, nonatomic) IBOutlet UITextField *sexTxtField;
@property (weak, nonatomic) IBOutlet UITextField *typeTxtField;
@property (weak, nonatomic) IBOutlet UITextField *ageTxtField;
@property (weak, nonatomic) IBOutlet UITextField *colorTxtField;
@property (weak, nonatomic) IBOutlet UITextField *mixTypeTxtField;
@property (weak, nonatomic) IBOutlet UITextField *sterilizationTxtField;
@property (weak, nonatomic) IBOutlet UITextField *bacterinTxtField;
@property (weak, nonatomic) IBOutlet UITextField *contactTxtField;
@property (weak, nonatomic) IBOutlet UITextField *howToContactTxtField;
@property (weak, nonatomic) IBOutlet UITextField *foundTxtFiled;
@property (weak, nonatomic) IBOutlet UITextView *traitTxtField;
@property (weak, nonatomic) IBOutlet SSBouncyButton *OKbtn;

@end

@implementation postDetailTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //btn setting
    [self BtnsSetting];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)BtnsSetting{

    _OKbtn.adjustsImageWhenHighlighted = NO;
    _OKbtn.tintColor = [UIColor turquoiseColor];
    _OKbtn.cornerRadius = SSBouncyButtonDefaultCornerRadius;
    _OKbtn.titleLabel.font = [UIFont systemFontOfSize:SSBouncyButtonDefaultTitleLabelFontSize];
    [_OKbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [_OKbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected | UIControlStateHighlighted];
    
}

- (IBAction)submitBtn:(UIButton*)button {
    button.selected = !button.selected;
    
    //必填沒填 -> 跳警告
    //必填正常 -> 上傳資料
    
    if (_areaTxtField.text.length == 0 || _sexTxtField.text.length == 0 ||
        _ageTxtField.text.length == 0 ||  _contactTxtField.text.length == 0 ||
        _howToContactTxtField.text.length == 0) {
        [self doAlert];
    }else{
        HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
        [self.navigationController.view addSubview:HUD];
        
        HUD.delegate = self;
        HUD.labelText = @"Loading";
        
        [HUD showWhileExecuting:@selector(pushDataToParse) onTarget:self withObject:nil animated:YES];
    }

}

- (void)pushDataToParse{
    PFObject *postAdopt = [PFObject objectWithClassName:ADOPT_PETS_PARSE_TABLE_NAME];
    postAdopt[AREA_PARSE_TITLE] = _areaTxtField.text;
    postAdopt[TYPE_PARSE_TITLE] = _typeTxtField.text;
    postAdopt[SEX_PARSE_TITLE] = _sexTxtField.text;
    postAdopt[AGE_PARSE_TITLE] = _ageTxtField.text;
    postAdopt[MIX_TYPE_PARSE_TITLE] = _mixTypeTxtField.text;
    postAdopt[COLOR_PARSE_TITLE] = _colorTxtField.text;
    postAdopt[STERILIZATION_PARSE_TITLE] = _sterilizationTxtField.text;
    postAdopt[BACTERIN_PARSE_TITLE] = _bacterinTxtField.text;
    postAdopt[CONTACT_PARSE_TITLE] = _contactTxtField.text;
    postAdopt[HOW_TO_CONTACT_PARSE_TITLE] = _howToContactTxtField.text;
    postAdopt[FOUND_PARSE_TITLE] = _foundTxtFiled.text;
    postAdopt[TRAIT_PARSE_TITLE] = _traitTxtField.text;

    
    
    [postAdopt saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            // push to other view
            adoptView *nextVC = [self.storyboard instantiateViewControllerWithIdentifier:@"adoptView"];
            nextVC.getUserOptionsFilterDoneStr = [NSString stringWithFormat:@"(animal_area_pkid == '%@') AND (animal_kind == '%@') AND (animal_sex == '%@') AND (animal_age == '%@')",_areaTxtField.text,_typeTxtField.text,_sexTxtField.text,_ageTxtField.text];
            [self.navigationController pushViewController:nextVC animated:true];
        } else {
            // stay here and do alert
        }
    }];
}

- (void)doAlert{
    FUIAlertView *alertView = [[FUIAlertView alloc] initWithTitle:@"請確認必填欄位"
                                                          message:nil
                                                         delegate:nil cancelButtonTitle:@"確定"
                                                otherButtonTitles:nil, nil];
    alertView.titleLabel.textColor = [UIColor cloudsColor];
    alertView.messageLabel.textColor = [UIColor cloudsColor];
    alertView.backgroundOverlay.backgroundColor = [[UIColor cloudsColor] colorWithAlphaComponent:0.8];
    alertView.alertContainer.backgroundColor = [UIColor midnightBlueColor];
    alertView.defaultButtonColor = [UIColor cloudsColor];
    alertView.defaultButtonShadowColor = [UIColor asbestosColor];
    alertView.defaultButtonTitleColor = [UIColor asbestosColor];
    [alertView show];
}

- (void)setAreaPickerVIew{
    
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
     [self.view endEditing:YES];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    switch (textField.tag) {
        case 1000://area
            [self setAreaPickerVIew];
            break;
        case 1001://sex
            [self setOptionsAlert:@"公" secondOption:@"母" txtField:_sexTxtField];
            return false;
            break;
        case 1002://age
            [self setOptionsAlert:@"幼年" secondOption:@"成年" txtField:_ageTxtField];
            return false;
            break;
        case 1010://type
            [self setOptionsAlert:@"貓" secondOption:@"狗" txtField:_typeTxtField];
            return false;
        default:
            break;
    }
    return true;
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}


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

- (void)setOptionsAlert:(NSString*)firstOption secondOption:(NSString*)secondOptions txtField:(UITextField*)txtfield{

    UIAlertController *optionsAlert=[UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *optionFirst = [UIAlertAction actionWithTitle:firstOption style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        txtfield.text = firstOption;
    }];
    
    UIAlertAction *optionSecond=[UIAlertAction actionWithTitle:secondOptions style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        txtfield.text= secondOptions;
    }];
    UIAlertAction *cancle=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    
    [optionsAlert addAction:optionFirst];
    [optionsAlert addAction:optionSecond];
    [optionsAlert addAction:cancle];
    [self presentViewController:optionsAlert animated:YES completion:nil];
}



@end
