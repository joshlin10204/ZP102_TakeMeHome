//
//  settingIndexVC.m
//  takemehomeagain
//
//  Created by tainan boom on 2015/8/5.
//  Copyright (c) 2015年 tainan boom. All rights reserved.
//

#import "settingIndexVC.h"

@interface settingIndexVC ()

@end

@implementation settingIndexVC



- (void)viewDidLoad {
    [super viewDidLoad];
    
    list1 = [[NSMutableArray alloc]init];
    [list1 addObject:@"設定"];
    
    list2 = [[NSMutableArray alloc]init];
    [list2 addObject:@"附近走失"];
    [list2 addObject:@"失主通知"];
    
    list3 = [[NSMutableArray alloc]init];
    [list3 addObject:@"貓"];
    [list3 addObject:@"狗"];
    [list3 addObject:@"其他"];
    
    list4 = [[NSMutableArray alloc]init];
    [list4 addObject:@"會員"];
    [list4 addObject:@"訪客"];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSInteger n;
    
    switch (section) {
        case 0:
            n = [list1 count];
            break;
            
            
        case 1:
            n = [list2 count];
            break;
            
        case 2:
            n = [list3 count];
            break;
            
        case 3:
            n = [list4 count];
            break;
            
            //        case 4:
            //            n = [];
            //            break;
            
            
    }
    return n;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    NSString *header;
    
    switch (section) {
        case 0:
            header = @" ";
            break;
            
        case 1:
            header = @"推播通知";
            break;
            
        case 2:
            header = @"吉祥物";
            break;
            
        case 3:
            header = @"會員/訪客";
            break;
    }
    return header;
}

-(UITableViewCell *)tableView:(UITableView *)
tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *indicator = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indicator];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:
                UITableViewCellStyleDefault reuseIdentifier:indicator];
    }
    
    
    switch (indexPath.section) {
        case 0:
            cell.textLabel.text = [list1 objectAtIndex:indexPath.row];
            
            break;
            
        case 1:
            cell.textLabel.text = [list2 objectAtIndex:indexPath.row];
            break;
            
        case 2:
            cell.textLabel.text = [list3 objectAtIndex:indexPath.row];
            break;
            
        case 3:
            cell.textLabel.text = [list4 objectAtIndex:indexPath.row];
            break;
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UILabel *myLabel = [[UILabel alloc] init];
    myLabel.frame = CGRectMake(20, 8, 160, 20);
    myLabel.font = [UIFont boldSystemFontOfSize:18];
    myLabel.text = [self tableView:tableView titleForHeaderInSection:section];
    
    UIView *headerView = [[UIView alloc] init];
    [headerView addSubview:myLabel];
    
    return headerView;
}
//-(UITableViewCell *)tableView:(UITableView *)
//tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//
//    static NSString *indicator = @"Cell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indicator];
//
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault
//                                     reuseIdentifier:indicator];
//
//    }
//
//    switch (indexPath.section) {
//        case 0:
//
//            break;
//
//        case 1:
//
//            break;
//    }
//}
/*
 -(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
 {
 [tableView deselectRowAtIndexPath:indexPath animated:YES];
 if (indexPath.row == 0) {
 
 }if (indexPath.row == 1) {
 
 }if (indexPath.row == 2) {
 
 }if (indexPath.row == 3) {
 
 }
 }
 */
//cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//break;



@end
