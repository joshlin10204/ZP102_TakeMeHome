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
#define ANIMAL_FAVORITE_CUSTOMER_FILTER_KEY @"animal_favorite"
#define ANIMAL_CONTACT_FILTER_KEY @"animal_contact"
#define ANIMAL_HOW_TO_CONTACT_FILTER_KEY @"animal_how_to_contact"
#define ANIMAL_USER_POST_ICON_FILTER_KEY @"animal_user_post_icon"
#define ANIMAL_RESOURCE_FILTER_KEY @"animal_rsc"


#define GOVERNMENT_SRC_KEY @"governmentSrcKey"
#define Non_GOVERNMENT_SRC_KEY @"nonGovernmentSrcKey"

#define SAVE_PLIST_FILE_NAME @"getAdoptJsonFile.plist"



@interface adoptView : BaseViewController

@property(strong,nonatomic)NSString* getUserOptionsFilterDoneStr;

@end
