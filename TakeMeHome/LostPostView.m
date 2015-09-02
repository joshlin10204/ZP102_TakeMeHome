//
//  LostPostView.m
//  TakeMeHome
//
//  Created by Josh on 2015/8/10.
//  Copyright (c) 2015年 Josh. All rights reserved.
//

#import "LostPostView.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <AssetsLibrary/AssetsLibrary.h>


@interface LostPostView ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    UIImagePickerController *imagePicker;
    NSMutableArray* toBeSavedImages;
    UIImage *lostPhoto1;
    UIImage *lostPhoto2;
 

    NSInteger lostPhotoBtnTag;


}
@property (weak, nonatomic) IBOutlet UIButton *addPhotoButton1;
@property (weak, nonatomic) IBOutlet UIButton *addPhotoButton2;
@end

@implementation LostPostView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addPhotoBtnPressed:(id)sender {
    
    lostPhotoBtnTag=((UIView*)sender).tag;
    
    
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
    UIAlertAction *pickPhoto=[UIAlertAction actionWithTitle:@"從選擇相簿" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        //開啟相簿
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.mediaTypes = @[(NSString*)kUTTypeImage];
        //只開啟照片
        imagePicker.allowsEditing=true;
        //選擇完可以做編輯
        imagePicker.delegate=self;
        [self presentViewController:imagePicker animated:true completion:nil];

        
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
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
    if (lostPhotoBtnTag ==1||lostPhoto1==nil) {
        lostPhoto1=editedImage;

        //將Button上的背景改成剛剛，所選擇的照片
        [_addPhotoButton1 setBackgroundImage:lostPhoto1 forState:UIControlStateNormal];
        
        //發布NSNotification 給LostPostTableView
        [[NSNotificationCenter defaultCenter]postNotificationName: LOST_PHOTO_FIRST_NOTIFICATION object:lostPhoto1];

    }

    else
    {
        lostPhoto2=editedImage;

        [_addPhotoButton2 setBackgroundImage:lostPhoto2 forState:UIControlStateNormal];
        [[NSNotificationCenter defaultCenter]postNotificationName: LOST_PHOTO_SECOND_NOTIFICATION object:lostPhoto2];


    }
    
    
    toBeSavedImages=[NSMutableArray arrayWithObjects:editedImage,nil];
    [self processSaveImage];
    
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




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
