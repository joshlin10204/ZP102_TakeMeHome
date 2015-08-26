//
//  myFavoriteVC.m
//  TakeMeHome
//
//  Created by Nigel on 2015/8/4.
//  Copyright (c) 2015年 Josh. All rights reserved.
//

#import "myFavoriteVC.h"
#import "adoptViewTableViewCell.h"
@interface myFavoriteVC ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation myFavoriteVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    adoptViewTableViewCell *mycell = [tableView dequeueReusableCellWithIdentifier:@"myFavoriteCell" forIndexPath:indexPath];
    
 
    NSInteger num = indexPath.row;
    
    if (num % 2 ==0) {
        UIImage *img = [UIImage imageNamed:@"theDog2.jpg"];
        [mycell.imageView setImage:img];
    }

    
    return mycell;
}

@end
