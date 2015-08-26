//
//  BroadcastViewController.m
//  takemehomeagain
//
//  Created by tainan boom on 2015/8/5.
//  Copyright (c) 2015年 tainan boom. All rights reserved.
//

#import "BroadcastViewController.h"

@interface BroadcastViewController ()

@end

@implementation BroadcastViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    list1 = [[NSMutableArray alloc]init];
    [list1 addObject:@"附近走失"];
    
    list2 = [[NSMutableArray alloc]init];
    [list2 addObject:@"接收距離"];
    [list2 addObject:@"接收時間"];
    [list2 addObject:@"通知開關"];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
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
            header = @" ";
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
            
    }
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
