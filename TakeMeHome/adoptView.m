//
//  adoptView.m
//  TakeMeHome
//
//  Created by Nigel on 2015/8/3.
//  Copyright (c) 2015年 Josh. All rights reserved.
//

#import "adoptView.h"
#import "adoptViewTableViewCell.h"
#import "adoptProfileVC.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "Animal.h"

#import <QuartzCore/QuartzCore.h>

#define cellDistance 50
#define JSON_GET_HTTP_WEBSITE @"http://data.coa.gov.tw/Service/OpenData/AnimalOpenData.aspx"
#define DOWNLOAD_JSON_SUCCESS_NOTIFICATION @"downloadJsonSuccessNotification"


@interface adoptView ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *plistArray;
    NSMutableArray *filtterArray;
    NSString *fullFileName ;
    NSMutableArray * animalsArray;

}
@property (weak, nonatomic) IBOutlet UITableView *petTableView;
@end

@implementation adoptView

- (void)viewDidLoad {
    [super viewDidLoad];
   
    //如果有存檔 就讀存檔
    //如果有更新  就提醒user要更新 <<---政府api沒有提供此功能  也許每2天重新再載
    NSFileManager *manager = [NSFileManager defaultManager];
    NSString *documentsDirectory = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    fullFileName = [documentsDirectory stringByAppendingPathComponent:SAVE_PLIST_FILE_NAME];

    if (!([manager fileExistsAtPath:fullFileName])) {
        //沒存檔  抓下來存檔
        [self linkJsonFile:JSON_GET_HTTP_WEBSITE];
    }else{
        plistArray =[[NSArray alloc]initWithContentsOfFile:fullFileName];
        [self showUserFilterDoneResult];
    }
    

    
}

- (void)showUserFilterDoneResult{
    filtterArray = [self getFilterDoneArray];
    //table view reload
    [_petTableView reloadData];
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return filtterArray.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    adoptViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"adoptViewCell" forIndexPath:indexPath];
    
    NSArray *theCellArray = [filtterArray objectAtIndex:indexPath.row];
    
   
    cell.labelName.text =[theCellArray valueForKey:ANIMAL_PLACE_FILTER_KEY];
    cell.labelSex.text = [theCellArray valueForKey:ANIMAL_SEX_FILTER_KEY];
    cell.labelType.text = [theCellArray valueForKey:ANIMAL_BODYTYPE_FILTER_KEY];
    cell.labelAge.text = [theCellArray valueForKey:ANIMAL_AGE_FILTER_KEY];
    
    NSString *imgStr = [theCellArray valueForKey:ANIMAL_ALBUM_FILE_FILTER_KEY];
    
    cell.btnFavirite.tag = indexPath.row;
    if ([[theCellArray valueForKey:ANIMAL_FAVORITE_CUSTOMER_FILTER_KEY]isEqualToString:@"N"]) {
        //預設
        cell.btnFavirite.buttonColor = [UIColor cloudsColor];
        cell.btnFavirite.shadowColor = [UIColor silverColor];
        [cell.btnFavirite setTitleColor:[UIColor alizarinColor] forState:UIControlStateNormal];
    }else{
        //加入最愛後
        cell.btnFavirite.buttonColor = [UIColor alizarinColor];
        cell.btnFavirite.shadowColor = [UIColor pomegranateColor];
        [cell.btnFavirite setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal];

    }
    
    
    cell.imgViewIcon.image = [UIImage imageNamed:@"taiwanFlag.png"];
    
    
    [cell.imgViewPhoto sd_setImageWithURL:[NSURL URLWithString:imgStr]
                             placeholderImage:[UIImage imageNamed:@"placeholder.png"]];



    /*
    //要在背景執行抓圖
    //[cell.imgViewPhoto setImage:nil];
    dispatch_queue_t downloadQueue = dispatch_queue_create("Download", nil);
    
    dispatch_async(downloadQueue, ^{
        NSString *imgStr = [theCellArray valueForKey:@"album_file"];
        //NSData *imgData = [NSData dataWithContentsOfURL:imgUrl];
        //UIImage *img = [UIImage imageWithData:imgData];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            //[cell.imgViewPhoto setImage:img];
            //[cell.imgViewPhoto loadImgWithURL:imgUrl];
            [cell.imgViewPhoto sd_setImageWithURL:[NSURL URLWithString:imgStr]
                            placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
        });
        
    });
     */

    return cell;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGSize bounds = self.view.bounds.size;
    return bounds.height * 2/3;
  }


- (IBAction)backToAdoptView:(UIStoryboardSegue*)segue{
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ( !([segue.identifier isEqualToString:@"searchSegue"])) {
        adoptProfileVC *nextVC = [segue destinationViewController];
        
        NSIndexPath *indexPath = [_petTableView indexPathForSelectedRow];
        
        NSArray *selectArray = [filtterArray objectAtIndex:indexPath.row];
        NSString *selectIdNum = [selectArray valueForKey:ANIMAL_ID_FILTER_KEY];
        
        for (NSArray *tmpArray in plistArray) {
            if ([[tmpArray valueForKey:ANIMAL_ID_FILTER_KEY] isEqualToString:selectIdNum]) {
                [nextVC getLabelID:[selectArray valueForKey:ANIMAL_ID_FILTER_KEY]];
                [nextVC setAnimalProfile:tmpArray];
            }
        }
        
        
        
      
        
    }
   
}

- (void)dealloc{
    NSLog(@"die");
}

- (void)linkJsonFile:(NSString*)urlStr{
    NSURL *url = [NSURL URLWithString:urlStr];
    NSArray __block *jsonArray;
    //     ^^^^^^^^^因為在block內呼叫 所以前面要加__block
    
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60.0];
    
    NSOperationQueue *queue = [NSOperationQueue currentQueue];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        //
        
        if (data != nil){
            jsonArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        }else{
            NSLog(@"%@",connectionError);
        }
        
        //analyse json file （拿到的json有多筆重複 重複應刪除）
        NSArray *analyseArray = [self analysieJsonFile:jsonArray];
        
        //save json file
        [self saveJsonFileToPlistFile:analyseArray];
        
        //array改為由local端讀取
        plistArray =[[NSArray alloc]initWithContentsOfFile:fullFileName];
        
        
        
        
        //table view 重新reload
        [_petTableView reloadData];
    }];
    
}

- (NSArray*)analysieJsonFile:(NSArray*)array{
    NSMutableArray *modifyArray = [NSMutableArray new];

    for (NSMutableDictionary *animal in array) {
        NSString *getAnimalId = animal[ANIMAL_ID_FILTER_KEY];
        if (!([[modifyArray valueForKey:ANIMAL_ID_FILTER_KEY] containsObject:getAnimalId])) {
            //新增 最愛欄位
            [animal setValue:@"N" forKey:ANIMAL_FAVORITE_CUSTOMER_FILTER_KEY];
            [modifyArray addObject:animal];
        }
    }
       NSLog(@"%d __ %d",array.count,modifyArray.count);
    return [NSArray arrayWithArray:modifyArray];
}


- (void)saveJsonFileToPlistFile:(NSArray*)array{
    //Get Document Path
   
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    //Prepare full path
    NSString *fullFilePathName = [documentsDirectory stringByAppendingPathComponent:SAVE_PLIST_FILE_NAME];
    NSMutableArray *getJsonArray = [NSMutableArray arrayWithArray:array];
    
    //save file
    [getJsonArray writeToFile:fullFilePathName atomically:true];
    
    NSLog(@"HOME: %@",NSHomeDirectory());
}



- (NSMutableArray *)getFilterDoneArray{
    animalsArray = [NSMutableArray array];
    for (int i = 0 ; i < plistArray.count ; i++) {
        Animal * myAnimal = [[Animal alloc] init];
        myAnimal.animal_area_pkid = [[plistArray objectAtIndex:i]valueForKey:ANIMAL_AREA_PKID_FILTER_KEY];
        myAnimal.animal_bodytype = [[plistArray objectAtIndex:i]valueForKey:ANIMAL_BODYTYPE_FILTER_KEY];
        myAnimal.animal_age = [[plistArray objectAtIndex:i]valueForKey:ANIMAL_AGE_FILTER_KEY];
        myAnimal.animal_sex = [[plistArray objectAtIndex:i]valueForKey:ANIMAL_SEX_FILTER_KEY];
        myAnimal.animal_id = [[plistArray objectAtIndex:i]valueForKey:ANIMAL_ID_FILTER_KEY];
        myAnimal.album_file = [[plistArray objectAtIndex:i]valueForKey:ANIMAL_ALBUM_FILE_FILTER_KEY];
        myAnimal.animal_kind = [[plistArray objectAtIndex:i]valueForKey:ANIMAL_KIND_FILTER_KEY];
        myAnimal.animal_place = [[plistArray objectAtIndex:i]valueForKey:ANIMAL_PLACE_FILTER_KEY];
        myAnimal.animal_favorite = [[plistArray objectAtIndex:i]valueForKey:ANIMAL_FAVORITE_CUSTOMER_FILTER_KEY];
        
        [animalsArray addObject:myAnimal];
        //myAnimal.resourceStr = [[plistArray objectAtIndex:i]valueForKey:@"animal_age"];
    }
    
   // for (Animal * animal in animals) {
   //     NSLog(@"animal :%@",animal.sexStr);
   // }

    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:self.getUserOptionsFilterDoneStr];
    NSArray *filterDoneArray = [NSArray new];
    
    NSLog(@"%@",self.getUserOptionsFilterDoneStr);
//    for (Animal *animal in animalsArray) {
//        if ([predicate evaluateWithObject:animal]) {
//            [filterDoneArray addObject:animal];
//        }
//    }
    
    filterDoneArray = [animalsArray filteredArrayUsingPredicate:predicate];
    
    return (NSMutableArray*)filterDoneArray;
    
    
    
    
}

- (IBAction)addFavoriteBtnPressed:(FUIButton *)button {
    UIColor *btnColor = button.buttonColor;
    
    NSInteger index = button.tag;
    
    if (btnColor == [UIColor cloudsColor]) {
        //加入最愛
        button.buttonColor = [UIColor alizarinColor];
        button.shadowColor = [UIColor pomegranateColor];
        [button setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal];
        [[plistArray objectAtIndex:index]setValue:@"Y" forKey:ANIMAL_FAVORITE_CUSTOMER_FILTER_KEY];
         [[filtterArray objectAtIndex:index]setValue:@"Y" forKey:ANIMAL_FAVORITE_CUSTOMER_FILTER_KEY];
    }else{
        //取消最愛
        button.buttonColor = [UIColor cloudsColor];
        button.shadowColor = [UIColor silverColor];
        [button setTitleColor:[UIColor alizarinColor] forState:UIControlStateNormal];
        [[plistArray objectAtIndex:index]setValue:@"N" forKey:ANIMAL_FAVORITE_CUSTOMER_FILTER_KEY];
        [[filtterArray objectAtIndex:index]setValue:@"N" forKey:ANIMAL_FAVORITE_CUSTOMER_FILTER_KEY];    }
    [plistArray writeToFile:SAVE_PLIST_FILE_NAME atomically:YES];
    
/*
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

 */

}


@end
