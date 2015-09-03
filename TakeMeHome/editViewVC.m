//
//  postViewVC.m
//  TakeMeHome
//
//  Created by Nigel on 2015/8/28.
//  Copyright (c) 2015年 Josh. All rights reserved.
//

#import "editViewVC.h"
#import "editDetailTVC.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <QuartzCore/QuartzCore.h>
#import "SDWebImage/UIImageView+WebCache.h"


#define LEFT_BTN_TAG 1000
#define RIGHT_BTN_TAG 1001
#define BTN_PRESSED_TAG 2000

@interface editViewVC ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{

    UIImagePickerController *imagePicker;
    NSMutableArray* toBeSavedImages;
    UIImage *photoImg;
    NSInteger btnPressedTag;
}

@end

@implementation editViewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
   
    UIButton *btn = (UIButton*)[self.view viewWithTag:LEFT_BTN_TAG];
    PFFile *imgFie = self.adoptData[@"user_takePhoto"];
    [imgFie getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error)
     {
         if (!error)
         {
             [btn setBackgroundImage:[UIImage imageWithData:imageData] forState:UIControlStateNormal];
             btn.imageView.image = [UIImage imageWithData:imageData];
             btn.layer.cornerRadius = 10 ;
             btn.layer.masksToBounds = true ;
         }
     }];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)myPhotoImgLeft:(UIButton*)sender {

//    if ([sender isEqual:self.leftCamera]) {
//        [sender setTag:1];
//        [self userChoosePhotoType];
//    }
    if (sender.tag == LEFT_BTN_TAG) {
        [self userChoosePhotoType];
        btnPressedTag = LEFT_BTN_TAG + BTN_PRESSED_TAG;
        sender.tag = btnPressedTag;
        
    }else if (sender.tag == RIGHT_BTN_TAG){
        [self userChoosePhotoType];
        btnPressedTag = RIGHT_BTN_TAG + BTN_PRESSED_TAG;
        sender.tag = btnPressedTag;
    }
}


- (void)userChoosePhotoType{
    UIAlertController *alertController = [UIAlertController new];
    imagePicker = [UIImagePickerController new];
    
    
    //使用相機選項
    UIAlertAction *pickCamera=[UIAlertAction actionWithTitle:@"使用相機" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        //判斷是否有支援相機功能
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
            //使用相機拍照
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            imagePicker.allowsEditing=true;
            imagePicker.delegate = self;
            [self presentViewController:imagePicker animated:YES completion:nil];
        }
        
        
        
    }];
    //使用相簿裡的照片
    UIAlertAction *pickPhoto=[UIAlertAction actionWithTitle:@"從相簿選擇" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        //開啟相簿
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.mediaTypes = @[(NSString*)kUTTypeImage];
        //只開啟照片
        imagePicker.allowsEditing=true;
        //選擇完可以做編輯
        imagePicker.delegate=self;
        [self presentViewController:imagePicker animated:true completion:nil];
        
        
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        //
        UIButton *pressedBtn = (UIButton*)[self.view viewWithTag:btnPressedTag];
        pressedBtn.tag = btnPressedTag - BTN_PRESSED_TAG;
    }];
    
    [alertController addAction:pickCamera];
    [alertController addAction:pickPhoto];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}




-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage* editedImage=info[UIImagePickerControllerEditedImage];
    
    //取得照片
    
    //呈現剛剛在相簿中編輯過後的照片
    

    UIButton *pressedBtn = (UIButton*)[self.view viewWithTag:btnPressedTag];
    photoImg = editedImage;
    [pressedBtn setBackgroundImage:photoImg forState:UIControlStateNormal];
    pressedBtn.layer.cornerRadius = 10;
    pressedBtn.layer.masksToBounds = true;
    
    [[NSNotificationCenter defaultCenter]postNotificationName:USER_POST_PHOTO_NOTIFICATION object:photoImg];
    
    
    toBeSavedImages=[NSMutableArray arrayWithObjects:editedImage,nil];
    [self processSaveImage];
    pressedBtn.tag = btnPressedTag - BTN_PRESSED_TAG;
    
    [picker dismissViewControllerAnimated:true completion:nil];
    
}
-(void)processSaveImage{
    if (toBeSavedImages.count ==0) {
        return;
    }
    UIImage*targetImage=toBeSavedImages[0];
    //取出toBeSavedImages裏頭第一個資料
    [toBeSavedImages removeObjectAtIndex:0];
    //刪除第一個資料
    
    
    //儲存到手機的資料庫中
    NSString *documents=NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory,
                                                            NSUserDomainMask, true)[0];
    
    NSString *fileName=[NSString stringWithFormat:@"%ld.png",(unsigned long)targetImage.hash];
    //儲存到資料庫的檔名
    //為了不讓檔名重複，利用hash， 他會依照 targetImage 的內容算出一個數字
    NSString *fileNamePath=[documents stringByAppendingPathComponent:fileName];;
    NSData *datas=UIImagePNGRepresentation(targetImage);
    [datas writeToFile:fileNamePath atomically:false];
    
    
    ALAssetsLibrary *library=[ALAssetsLibrary new];
    [library writeImageToSavedPhotosAlbum:targetImage.CGImage
                              orientation:(ALAssetOrientation)targetImage.imageOrientation
                          completionBlock:^(NSURL *assetURL, NSError *error)
     //照片儲存需要時間，所以利用^ ，等存檔後再進行之後的動作
     //orientation 存的照片的方向（直的橫的）
     {
         if (toBeSavedImages.count>0) {
             [self processSaveImage];
             return ;
         }
         NSLog(@"已存檔");
     }];
    
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    editDetailTVC *nextVC = segue.destinationViewController;
    nextVC.adoptData = self.adoptData;
}

@end
