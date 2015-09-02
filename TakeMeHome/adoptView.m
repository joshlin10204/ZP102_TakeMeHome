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
#import <Parse/Parse.h>
#import "postDetailTVC.h"
#import "MBProgressHUD.h"


#define JSON_GET_HTTP_WEBSITE @"http://data.coa.gov.tw/Service/OpenData/AnimalOpenData.aspx"
#define DOWNLOAD_JSON_SUCCESS_NOTIFICATION @"downloadJsonSuccessNotification"
#define DOWNLOAD_PARSE_SUCCESS_NOTIFICATION @"downloadParseSuccessNotification"



@interface adoptView ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *plistArray;
    NSMutableArray *filtterArray;
    //NSString *fullFileName ;
    NSString *fullFilePathName;
    NSMutableArray * animalsArray;
    UIRefreshControl *refresh;
    MBProgressHUD *hud;

}
@property (strong, nonatomic) IBOutlet UITableView *petTableView;
@end

@implementation adoptView

- (void)viewDidLoad {
    [super viewDidLoad];
   
    //tableView settings
    [self tableControlSetting];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    //每次進來都重新抓資料
    [self downloadJsonFile:JSON_GET_HTTP_WEBSITE];
    
    //JsonFile抓好後 再抓parse file
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(downloadParseFile) name:DOWNLOAD_JSON_SUCCESS_NOTIFICATION object:nil];
    
    //parse file 抓好後  再去分析user要搜尋的條件
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showUserFilterDoneResult) name:DOWNLOAD_PARSE_SUCCESS_NOTIFICATION object:nil];
    
    
    
    //如果有存檔 就讀存檔
    //如果有更新  就提醒user要更新 <<---政府api沒有提供此功能  也許每2天重新再載
    /*
    NSFileManager *manager = [NSFileManager defaultManager];
    NSString *documentsDirectory = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    fullFileName = [documentsDirectory stringByAppendingPathComponent:SAVE_PLIST_FILE_NAME];

    if (!([manager fileExistsAtPath:fullFileName])) {
        //沒存檔  抓下來存檔
        [self downloadJsonFile:JSON_GET_HTTP_WEBSITE];
    }else{
        plistArray =[[NSArray alloc]initWithContentsOfFile:fullFileName];
        [self showUserFilterDoneResult];
    }
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(doFilter) name:DOWNLOAD_JSON_SUCCESS_NOTIFICATION object:nil];
    
    //get Parse File
    [self downloadParseFile];
    plistArray =[[NSArray alloc]initWithContentsOfFile:fullFileName];
    [self showUserFilterDoneResult];
    //
    */
}

- (void)downloadParseFile{
    //
    NSMutableArray __block *saveParseArray = [NSMutableArray new];
    NSMutableDictionary __block *saveDictionary = [NSMutableDictionary new];
    
    
    PFQuery *query = [PFQuery queryWithClassName:ADOPT_PETS_PARSE_TABLE_NAME];
   
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved %d scores.", objects.count);
            // Do something with the found objects
            for (PFObject *tmp in objects) {
                NSLog(@"%@",tmp.objectId);
                [saveDictionary setObject:tmp.objectId forKey:ANIMAL_ID_FILTER_KEY];
                [saveDictionary setObject:tmp[MIX_TYPE_PARSE_TITLE] forKey:ANIMAL_BODYTYPE_FILTER_KEY];
                [saveDictionary setObject:tmp[SEX_PARSE_TITLE] forKey:ANIMAL_SEX_FILTER_KEY];
                [saveDictionary setObject:tmp[AREA_PARSE_TITLE] forKey:ANIMAL_AREA_PKID_FILTER_KEY];
                [saveDictionary setObject:tmp[TYPE_PARSE_TITLE] forKey:ANIMAL_KIND_FILTER_KEY];
                [saveDictionary setObject:tmp[AGE_PARSE_TITLE] forKey:ANIMAL_AGE_FILTER_KEY];
                [saveDictionary setObject:tmp[COLOR_PARSE_TITLE] forKey:@"animal_colour"];
                [saveDictionary setObject:tmp[STERILIZATION_PARSE_TITLE] forKey:@"animal_sterilization"];
                [saveDictionary setObject:tmp[BACTERIN_PARSE_TITLE] forKey:@"animal_bacterin"];
                [saveDictionary setObject:tmp[FOUND_PARSE_TITLE] forKey:@"animal_foundplace"];
                [saveDictionary setObject:tmp[TRAIT_PARSE_TITLE] forKey:@"animal_remark"];
                [saveDictionary setObject:tmp[CONTACT_PARSE_TITLE] forKey:ANIMAL_CONTACT_FILTER_KEY];
                [saveDictionary setObject:tmp[HOW_TO_CONTACT_PARSE_TITLE] forKey:ANIMAL_HOW_TO_CONTACT_FILTER_KEY];
                [saveDictionary setObject:tmp[USER_ICON_PARSE_TITLE] forKey:ANIMAL_USER_POST_ICON_FILTER_KEY];
                
                [saveParseArray insertObject:saveDictionary atIndex:0];
                saveDictionary = [NSMutableDictionary new];
            }
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
        
        NSArray *analyseArray = [self analysieJsonFile:saveParseArray resource:Non_GOVERNMENT_SRC_KEY];
        //save json file
        [self saveJsonFileToPlistFile:analyseArray source:Non_GOVERNMENT_SRC_KEY];
        
        //
//        NSArray *analysieArray = [[NSArray alloc]initWithArray:saveParseArray];
//        analysieArray = [self analysieJsonFile:analysieArray resource:Non_GOVERNMENT_SRC_KEY];
        //[analysieArray writeToFile:fullFileName atomically:true];

        [[NSNotificationCenter defaultCenter]postNotificationName:DOWNLOAD_PARSE_SUCCESS_NOTIFICATION object:nil];
        
    }];
}



- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    plistArray = [[NSArray alloc]initWithContentsOfFile:fullFilePathName];
    [self showUserFilterDoneResult];
}

- (void)showUserFilterDoneResult{
    filtterArray = [self getFilterDoneArray];
    //table view reload
    [_petTableView reloadData];
}


- (void)tableControlSetting{
    refresh = [[UIRefreshControl alloc]init];
    refresh.attributedTitle = [[NSAttributedString alloc]initWithString:@"讀取最新資料..."];
    refresh.tintColor = [UIColor tangerineColor];
    [refresh addTarget:self action:@selector(pullRefresh) forControlEvents:UIControlEventValueChanged];
    [self.petTableView addSubview:refresh];
}

- (void)pullRefresh{
    [self.petTableView reloadData];
    [refresh endRefreshing];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return filtterArray.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    adoptViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"adoptViewCell" forIndexPath:indexPath];
    
    NSArray *theCellArray = [filtterArray objectAtIndex:indexPath.row];
    
   
    cell.labelName.text =[theCellArray valueForKey:ANIMAL_PLACE_FILTER_KEY];
    cell.labelSex.text = [theCellArray valueForKey:ANIMAL_SEX_FILTER_KEY];
    cell.labelType.text = [theCellArray valueForKey:ANIMAL_BODYTYPE_FILTER_KEY];
    cell.labelAge.text = [theCellArray valueForKey:ANIMAL_AGE_FILTER_KEY];
    
    NSString *imgStr = [theCellArray valueForKey:ANIMAL_ALBUM_FILE_FILTER_KEY];
    
    if ([cell.labelSex.text isEqualToString:@"M"]) {
        cell.labelSex.text = @"公";
    }else if ([cell.labelSex.text isEqualToString:@"F"]){
        cell.labelSex.text = @"母";
    }else{
        cell.labelSex.text = @"未填";
    }
    
    if ([cell.labelAge.text isEqualToString:@"CHILD"]) {
        cell.labelAge.text = @"幼年";
    }else{
        cell.labelAge.text = @"成年";
    }
    
    
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ( !([segue.identifier isEqualToString:@"searchSegue"])) {
        adoptProfileVC *nextVC = [segue destinationViewController];
        
        NSIndexPath *indexPath = [_petTableView indexPathForSelectedRow];
        
        NSArray *selectArray = [filtterArray objectAtIndex:indexPath.row];
        NSString *selectIdNum = [selectArray valueForKey:ANIMAL_ID_FILTER_KEY];
        
        for (NSArray *tmpArray in plistArray) {
            if ([[tmpArray valueForKey:ANIMAL_ID_FILTER_KEY] isEqualToString:selectIdNum]) {
                //[nextVC getLabelID:[selectArray valueForKey:ANIMAL_ID_FILTER_KEY]];
                [nextVC setAnimalProfile:tmpArray];
            }
        }
    }
}

- (void)dealloc{
    NSLog(@"die");
}

- (void)downloadJsonFile:(NSString*)urlStr{
    NSURL *url = [NSURL URLWithString:urlStr];
    NSArray __block *jsonArray;
    //     ^^^^^^^^^因為在block內呼叫 所以前面要加__block
    
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60.0];
    
    NSOperationQueue *queue = [NSOperationQueue currentQueue];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {

        if (data != nil){
            jsonArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        }else{
            NSLog(@"%@",connectionError);
        }
        
        //analyse json file （拿到的json有多筆重複 重複應刪除）
        NSArray *analyseArray = [self analysieJsonFile:jsonArray resource:GOVERNMENT_SRC_KEY];
        
        //save json file
        [self saveJsonFileToPlistFile:analyseArray source:GOVERNMENT_SRC_KEY];
        /*
        //array改為由local端讀取
        plistArray =[[NSArray alloc]initWithContentsOfFile:fullFileName];
        
        //table view 重新reload
        [_petTableView reloadData];
         */
        [[NSNotificationCenter defaultCenter]postNotificationName:DOWNLOAD_JSON_SUCCESS_NOTIFICATION object:nil];
    }];
    
}

- (NSArray*)analysieJsonFile:(NSArray*)array resource:(NSString*)rsc{
    NSMutableArray *modifyArray = [NSMutableArray new];

    for (NSMutableDictionary *animal in array) {
        NSString *getAnimalId = animal[ANIMAL_ID_FILTER_KEY];
        if (!([[modifyArray valueForKey:ANIMAL_ID_FILTER_KEY] containsObject:getAnimalId])) {
            //新增 最愛欄位
            [animal setValue:@"N" forKey:ANIMAL_FAVORITE_CUSTOMER_FILTER_KEY];
            //新增 來源欄位（民眾或是私人）
            [animal setValue:rsc forKey:ANIMAL_RESOURCE_FILTER_KEY];
            
            if ([rsc isEqualToString:GOVERNMENT_SRC_KEY]) {
                //體型改為中文
                if ([animal[ANIMAL_BODYTYPE_FILTER_KEY] isEqualToString:@"MINI"]) {
                    [animal setValue:@"迷你" forKey:ANIMAL_BODYTYPE_FILTER_KEY];
                }else if ([animal[ANIMAL_BODYTYPE_FILTER_KEY] isEqualToString:@"SMALL"]){
                    [animal setValue:@"小型" forKey:ANIMAL_BODYTYPE_FILTER_KEY];
                }else if ([animal[ANIMAL_BODYTYPE_FILTER_KEY] isEqualToString:@"MEDIUM"]){
                    [animal setValue:@"中型" forKey:ANIMAL_BODYTYPE_FILTER_KEY];
                }else if ([animal[ANIMAL_BODYTYPE_FILTER_KEY] isEqualToString:@"BIG"]){
                    [animal setValue:@"大型" forKey:ANIMAL_BODYTYPE_FILTER_KEY];
                }
            }
            [modifyArray addObject:animal];
        }
    }
       NSLog(@"%d __ %d",array.count,modifyArray.count);
    return [NSArray arrayWithArray:modifyArray];
}


- (void)saveJsonFileToPlistFile:(NSArray*)array source:(NSString*)src{
    //Get Document Path
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    //Prepare full path
    fullFilePathName = [documentsDirectory stringByAppendingPathComponent:SAVE_PLIST_FILE_NAME];
    NSMutableArray *getJsonArray = [NSMutableArray arrayWithArray:array];

    
    //如果是non gov 代表第二次拿到plistFile 所以應讀檔
    if ([src isEqualToString:Non_GOVERNMENT_SRC_KEY]) {
        NSArray *getPlistArray = [NSArray arrayWithContentsOfFile:fullFilePathName];
        [getJsonArray addObjectsFromArray:getPlistArray];
    }
    
    //save file
    [getJsonArray writeToFile:fullFilePathName atomically:true];
    plistArray = [[NSArray alloc]initWithArray:getJsonArray];
    
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
        myAnimal.animal_rsc = [[plistArray objectAtIndex:i]valueForKey:ANIMAL_RESOURCE_FILTER_KEY];
        
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
         [[filtterArray objectAtIndex:index]setValue:@"Y" forKey:ANIMAL_FAVORITE_CUSTOMER_FILTER_KEY];
        NSString *selectAnimalId = [[filtterArray objectAtIndex:index]valueForKey:ANIMAL_ID_FILTER_KEY];
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
        [[filtterArray objectAtIndex:index]setValue:@"N" forKey:ANIMAL_FAVORITE_CUSTOMER_FILTER_KEY];
        NSString *selectAnimalId = [[filtterArray objectAtIndex:index]valueForKey:ANIMAL_ID_FILTER_KEY];
        for (NSDictionary *tmp in plistArray) {
            if ([tmp[ANIMAL_ID_FILTER_KEY] isEqualToString:selectAnimalId]) {
                [tmp setValue:@"N" forKey:ANIMAL_FAVORITE_CUSTOMER_FILTER_KEY];
            }
        }
    }
    
    [plistArray writeToFile:fullFilePathName atomically:YES];
}

- (IBAction)favoriteBtnPressed:(id)sender {
    
    //load file
    plistArray =[[NSArray alloc]initWithContentsOfFile:fullFilePathName];
    filtterArray = [NSMutableArray new];
    for (NSDictionary *tmp in plistArray) {
        if ([tmp[ANIMAL_FAVORITE_CUSTOMER_FILTER_KEY] isEqualToString:@"Y"]) {
            [filtterArray addObject:tmp];
        }
    }
    [_petTableView reloadData];
}

@end
