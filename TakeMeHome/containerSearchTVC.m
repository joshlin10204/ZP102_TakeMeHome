//
//  searchTVC.m
//  TakeMeHome
//
//  Created by Nigel on 2015/8/12.
//  Copyright (c) 2015年 Josh. All rights reserved.
//

#import "containerSearchTVC.h"
#import "TPKeyboardAvoidingTableView.h"

@interface containerSearchTVC ()<UIPickerViewDelegate,UIPickerViewDataSource>
{

    UIPickerView *addPickView;
    NSArray *addArray ;

}
@property (weak, nonatomic) IBOutlet TPKeyboardAvoidingTableView *optionTableView;
@end

@implementation containerSearchTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setAreaPicker];
    
    
    _optionTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (IBAction)btnPressed:(UIButton*)sender{
    
    
    if (sender.selected){
        //sender.backgroundColor = [UIColor lightGrayColor];
        sender.selected = false;
    }else{
        //sender.backgroundColor = [UIColor whiteColor];
        sender.selected = true;
    }
    
    
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    return addArray.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    
    return [addArray objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.txtFieldAreaNum = [NSString stringWithFormat:@"%d",row+2];
    _txtFieldArea.text = [addArray objectAtIndex:row];
}


- (void)setAreaPicker{

    addPickView = [UIPickerView new];
    addPickView.delegate = self;
    
    
    
    [self.txtFieldArea setInputView:addPickView];
    [addPickView setBackgroundColor:[UIColor colorWithRed: 1.0 green: 1.0 blue: 1.0 alpha: 1.0]];
    
    addArray = [NSArray arrayWithObjects:
                @"臺北市",@"新北市",@"基隆市",@"宜蘭縣",@"桃園縣",@"新竹縣",@"新竹市",@"苗栗縣",
                @"臺中市",@"彰化縣",@"南投縣",@"雲林縣",@"嘉義縣",@"嘉義市",@"臺南市",@"臺南市",
                @"高雄市",@"屏東縣",@"花蓮縣",@"臺東縣",@"澎湖縣",@"金門縣",@"連江縣",nil];
    
    
    CGFloat screenWidth = self.view.frame.size.width;
    UIToolbar *toolBar= [[UIToolbar alloc] initWithFrame:CGRectMake(0,0,screenWidth,44)];
    [toolBar setBarStyle:UIBarStyleBlackOpaque];
    UIBarButtonItem *barButtonDone = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                      style:UIBarButtonItemStyleDone target:self action:nil];
    toolBar.items = [[NSArray alloc] initWithObjects:barButtonDone,nil];
    barButtonDone.tintColor=[UIColor blackColor];
    [addPickView addSubview:toolBar];
    
}


@end



