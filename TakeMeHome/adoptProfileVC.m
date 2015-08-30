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
#import "adoptView.h"

@interface adoptProfileVC ()
{
    NSString *getPetId;
    NSArray *getAnimailProfile;
}
@property (weak, nonatomic) IBOutlet UIView *aboutMeVC;
@property (weak, nonatomic) IBOutlet UIView *detailVC;
@property (weak, nonatomic) IBOutlet UIImageView *petImgView;

@end

@implementation adoptProfileVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _detailVC.hidden = false;
    _aboutMeVC.hidden = true;
    
    NSString *urlStr = [getAnimailProfile valueForKey:ANIMAL_ALBUM_FILE_FILTER_KEY];

    [self.petImgView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:nil];
    
//    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60.0];
//    
//    NSOperationQueue *queue = [NSOperationQueue currentQueue];
//    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
//        //
//        //NSString *content = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
//        
//        NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//        jsonArray = [jsonArray objectAtIndex:0];
//        NSString *picStr = [jsonArray valueForKey:@"album_file"];
//         //[self.petImgView sd_setImageWithURL:[NSURL URLWithString:picStr] placeholderImage:nil];
//        NSLog(@"1");
//    }];
    
   

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

- (void)getLabelID:(NSString*)Id{
    getPetId = Id;
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
        myEmbedTVC.getID = getPetId;
        [myEmbedTVC setAnimalProfile:getAnimailProfile];
        
    }
    if ([segue.identifier isEqualToString:@"aboutMeSegue"]){
        aboutMeVC *myEmbedVC = segue.destinationViewController;
        myEmbedVC.getID = getPetId;
        [myEmbedVC setAnimalProfile:getAnimailProfile];
    }
    
}


@end
