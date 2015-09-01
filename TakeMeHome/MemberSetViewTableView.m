//
//  MemberSetViewTableView.m
//  TakeMeHome
//
//  Created by Josh on 2015/8/29.
//  Copyright (c) 2015年 Josh. All rights reserved.
//

#import "MemberSetViewTableView.h"
#import "MXSegmentedPager.h"
#import "LostInfoCell.h"
#import <Parse/Parse.h>
#import "SDWebImage/UIImageView+WebCache.h"
#import "LostInfoView.h"



@interface MemberSetViewTableView ()<MXSegmentedPagerDelegate,MXSegmentedPagerDataSource,UITableViewDelegate,UITableViewDataSource>
{
    PFUser *currentUser ;
    //走失文章資料
    NSArray * lostPostData;
    
    NSArray * choicelostPost;

}
@property (nonatomic, strong) MXSegmentedPager  * segmentedPager;
@property (nonatomic, strong) UITableView       * userInfoTableView;
@property (nonatomic, strong) UITableView       * lostInfoTableView;
@property (nonatomic, strong) UITableView       * adoptInfoTableView;
@end

@implementation MemberSetViewTableView

- (void)viewDidLoad {
    [super viewDidLoad];
    currentUser = [PFUser currentUser];
    if (currentUser) {
        // do stuff with the user
        NSLog(@"currentUser: %@ ",currentUser);
    }
    
    //Parse關聯 取得使用者PO的走失文章
    PFRelation *relation = [currentUser relationForKey:@"lostPost"];
    PFQuery *quert=[relation query];
    [quert  orderByDescending:@"createdAt"];
    //依照createdAt的最新時間排序
    [quert findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            // There was an error
            NSLog(@"error:%@",error);
        } else {
            // objects has all the Posts the current user liked.
            [[relation query]  orderByDescending:@"createdAt"];
            lostPostData=objects;
            NSLog(@"Success!! :  %@",[objects objectAtIndex:0]);
            NSLog(@"objects!! :  %@",objects[0]);
            [_lostInfoTableView reloadData];//重新載入Tableview
        }
    }];
    




    self.view.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:self.segmentedPager];
    self.segmentedPager.segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    self.segmentedPager.segmentedControl.selectionIndicatorColor = [UIColor orangeColor];
    self.segmentedPager.segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
    self.segmentedPager.segmentedControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : [UIColor orangeColor]};
    
    //Register UItableView as page
//    [self.segmentedPager.pager registerClass:[UITextView class] forPageReuseIdentifier:@"TextPage"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillLayoutSubviews {
    self.segmentedPager.frame = (CGRect){
        .origin.x       = 0.f,
        .origin.y       = 20.f,
        .size.width     = self.view.frame.size.width,
        .size.height    = self.view.frame.size.height - 20.f
    };
    [super viewWillLayoutSubviews];
}

#pragma -mark Properties

- (MXSegmentedPager *)segmentedPager {
    if (!_segmentedPager) {
        
        // Set a segmented pager
        _segmentedPager = [[MXSegmentedPager alloc] init];
        _segmentedPager.delegate    = self;
        _segmentedPager.dataSource  = self;
    }
    return _segmentedPager;
}

- (UITableView *)userInfoTableView {
    if (!_userInfoTableView)
    {
        //Add a table page
        _userInfoTableView = [[UITableView alloc] init];
        _userInfoTableView.delegate = self;
        _userInfoTableView.dataSource = self;

    }

    return _userInfoTableView;
}
- (UITableView *)adoptInfoTableView {
    
    
    if (!_adoptInfoTableView)
    {
        _adoptInfoTableView = [[UITableView alloc] init];
        _adoptInfoTableView.delegate = self;
        _adoptInfoTableView.dataSource = self;
    }
    
    
    return _adoptInfoTableView;
}
- (UITableView *)lostInfoTableView {
    
    
    if (!_lostInfoTableView)
    {
        _lostInfoTableView = [[UITableView alloc] init];
        _lostInfoTableView.delegate = self;
        _lostInfoTableView.dataSource = self;
        
    }
    
    return _lostInfoTableView;
}


#pragma -mark <MXSegmentedPagerDelegate>

- (void)segmentedPager:(MXSegmentedPager *)segmentedPager didSelectViewWithTitle:(NSString *)title {
    NSLog(@"%@ page selected.", title);
}

#pragma -mark <MXSegmentedPagerDataSource>

- (NSInteger)numberOfPagesInSegmentedPager:(MXSegmentedPager *)segmentedPager {
    return 2;
}

- (NSString *)segmentedPager:(MXSegmentedPager *)segmentedPager titleForSectionAtIndex:(NSInteger)index {
    if (index < 2) {
        return [@[@"領養文章", @"走失文章"] objectAtIndex:index];
    }
    return [NSString stringWithFormat:@"Page %li", (long) index];
}

- (UIView *)segmentedPager:(MXSegmentedPager *)segmentedPager viewForPageAtIndex:(NSInteger)index
{

        return [@[self.adoptInfoTableView, self.lostInfoTableView] objectAtIndex:index];
}

#pragma -mark <UITableViewDelegate>

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    NSInteger index = (indexPath.row % 2) + 1;
//    [self.segmentedPager scrollToPageAtIndex:index animated:YES];
    if([tableView isEqual:_adoptInfoTableView])
    {
        NSLog(@" _adoptInfoTableView 選擇 ：%ld" ,(long)indexPath.row);

    }
    else
    {
        NSLog(@" _lostInfoTableView 選擇 ：%ld" ,(long)indexPath.row);
        choicelostPost=lostPostData[indexPath.row];
        [self performSegueWithIdentifier:@"golostPostInfo" sender:nil];
        NSLog(@"choicelostPostInfo:%@",choicelostPost);
    
    }

    
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqual:@"golostPostInfo"])
    {
        id aa=segue.destinationViewController;
        [aa setValue:choicelostPost forKey:@"lostPostInfo"];
        
    }
    
}

#pragma -mark <UITableViewDataSource>

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    
    if([tableView isEqual:_adoptInfoTableView])
    {
    
        return 5;
    }
    
    else
    {
        return lostPostData.count ;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    
    static NSString *lostCellID = @"LostInfoCell";
    LostInfoCell *lostCell = [tableView dequeueReusableCellWithIdentifier:lostCellID];
    
    if([tableView isEqual:_adoptInfoTableView])
    {
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        
        cell.textLabel.text=@"adopt";
        return cell;

    
    }
    else
    {
        if (lostCell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:lostCellID owner:self options:nil];
            lostCell = [nib objectAtIndex:0];

            
        }

        _lostInfoTableView.rowHeight = lostCell.frame.size.height;
        lostCell.lostPetName.text=lostPostData[indexPath.row][@"LostPetsName"];

        PFFile *lostPetsPhoto = lostPostData[indexPath.row][@"LostPetsPhotoFirst"];
        if (lostPetsPhoto==nil) {
            
            lostCell.lostPetPhotoImage.image=[UIImage imageNamed:@"noPhotoImage"];
            
            
        }
        else
        {
            
            [lostCell.lostPetPhotoImage sd_setImageWithURL:(NSURL*)((PFFile*)lostPetsPhoto).url  placeholderImage:[UIImage imageNamed:@"noPhotoImage"]];
            
        }
        
            
            
        
        return lostCell;

    }
//    cell.textLabel.text = (indexPath.row % 2)? @"Text": @"Web";

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
