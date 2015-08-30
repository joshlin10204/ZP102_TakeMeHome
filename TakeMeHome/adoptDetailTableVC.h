//
//  adoptDetailTableVC.h
//  TakeMeHome
//
//  Created by Nigel on 2015/8/3.
//  Copyright (c) 2015年 Josh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "adoptView.h"

@interface adoptDetailTableVC : UITableViewController

@property (strong, nonatomic)NSString *getID;

- (void)setAnimalProfile:(NSArray*)animalProfile;

@end
