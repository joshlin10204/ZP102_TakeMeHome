//
//  adoptView.h
//  TakeMeHome
//
//  Created by Nigel on 2015/8/3.
//  Copyright (c) 2015年 Josh. All rights reserved.
//

#import "BaseViewController.h"

#define ANIMAL_SEX_FILTER_KEY @"animal_sex"
#define ANIMAL_BODYTYPE_FILTER_KEY @"animal_bodytype"
#define ANIMAL_AGE_FILTER_KEY @"animal_age"
#define ANIMAL_ALBUM_FILE_FILTER_KEY @"album_file"
#define ANIMAL_AREA_PKID_FILTER_KEY @"animal_area_pkid"
#define ANIMAL_KIND_FILTER_KEY @"animal_kind"
#define ANIMAL_ID_FILTER_KEY @"animal_id"
#define ANIMAL_PLACE_FILTER_KEY @"animal_place"

@interface adoptView : BaseViewController

@property(strong,nonatomic)NSString* getUserOptionsFilterDoneStr;

@end
