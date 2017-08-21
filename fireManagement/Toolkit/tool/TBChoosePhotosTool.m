//
//  TBChoosePhotosTool.m
//  Telecom
//
//  Created by 王小腊 on 2016/12/12.
//  Copyright © 2016年 王小腊. All rights reserved.
//

#import "TBChoosePhotosTool.h"
#import "ZYQAssetPickerController.h"
#import "ZZCameraController.h"
#import "PhotoViewController.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"
#import "ZZCamera.h"
#import "ZKNavigationController.h"
@interface TBChoosePhotosTool ()<ZYQAssetPickerControllerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,PhotoViewControllerDelegate>

@property (nonatomic, strong) NSMutableArray *imageArray;

@property (nonatomic, strong) UIViewController *controller;

@end

@implementation TBChoosePhotosTool

- (NSMutableArray *)imageArray
{
    if (!_imageArray)
    {
        _imageArray = [NSMutableArray array];
    }
    return _imageArray;
}
- (void)photoToChoosStyleIndex:(NSInteger)row;
{
    [self.imageArray removeAllObjects];
    /**   **/
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *localAlert = [UIAlertAction actionWithTitle:@"本地相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
        
        [self showLocalPickeIndex:row];
    }];
    
    
    UIAlertAction *shootingAler = [UIAlertAction actionWithTitle:@"现场拍摄" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self showCameraIndex:row];
        
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取 消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        [alert dismissViewControllerAnimated:YES completion:^{
            
        }];
    }];
    
    [alert addAction:shootingAler];
    [alert addAction:localAlert];
    [alert addAction:cancel];
    
    [[ZKUtil getPresentedViewController] presentViewController:alert animated:YES completion:nil];
    
}
- (void)showPhotosIndex:(NSInteger)number;
{
    self.controller = nil;
    [self photoToChoosStyleIndex:number];
}

/**
 弹出本地相册
 
 @param row 可以选择几张
 */
- (void)showLocalPickeIndex:(NSInteger)row
{
    ZYQAssetPickerController *picker = [[ZYQAssetPickerController alloc] init];
    picker.maximumNumberOfSelection = row;
    picker.assetsFilter = ZYQAssetsFilterAllAssets;
    picker.showEmptyGroups = NO;
    picker.delegate = self;
    picker.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        
        if ([(ZYQAsset*)evaluatedObject mediaType]==ZYQAssetMediaTypeVideo) {
            NSTimeInterval duration = [(ZYQAsset*)evaluatedObject duration];
            return duration >= row;
        } else {
            return YES;
        }
        
        
    }];
    
    [[ZKUtil getPresentedViewController]  presentViewController:picker animated:YES completion:^{
        
    }];
    
    
}

/**
 弹出照相机
 
 @param row 可以拍摄几张
 */
- (void)showCameraIndex:(NSInteger)row
{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        hudShowError(@"该设备不支持相机拍摄");
        return;
    }
        AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (status == AVAuthorizationStatusNotDetermined) {
        //相机进行授权
        /* * * 第一次安装应用时直接进行这个判断进行授权 * * */
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if (granted) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self showCameraIndex:row];
                });
            }
        }];
    }else if (status == AVAuthorizationStatusAuthorized){

        if (row == 1)
        {
            UIImagePickerController *imagePicker = [UIImagePickerController new];
            imagePicker.delegate = self;
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [[ZKUtil getPresentedViewController] presentViewController:imagePicker animated:YES completion:nil];
        }
        else
        {
            ZZCameraController *cameraController = [[ZZCameraController alloc]init];
            cameraController.takePhotoOfMax = row;
            
            cameraController.isSaveLocal = NO;
            TBWeakSelf
            [cameraController showIn:[ZKUtil getPresentedViewController] result:^(id responseObject){
                
                [weakSelf.imageArray addObjectsFromArray:(NSArray *)responseObject];
                if ([weakSelf.delegate respondsToSelector:@selector(choosePhotosArray:)]&&weakSelf.imageArray.count > 0) {
                    [weakSelf.delegate choosePhotosArray:weakSelf.imageArray];
                }
            }];
        }

        
    }else if (status == AVAuthorizationStatusRestricted || status == AVAuthorizationStatusDenied){
        [self showAlertViewToController:[ZKUtil getPresentedViewController]];
    }


}

-(void)showAlertViewToController:(UIViewController *)controller
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // app名称
    NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提醒" message:[NSString stringWithFormat:@"请在iPhone的“设置->隐私->照片”开启%@访问你的相机",app_Name] preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
        
    }];
    
    [alert addAction:action1];
    [controller presentViewController:alert animated:YES completion:nil];
}

/**
 头像图片选择（裁剪）
 
 @param controller vc
 */
- (void)showHeadToChooseViewController:(UIViewController *)controller;
{
    self.controller = controller;
    [self photoToChoosStyleIndex:1];
    
}
- (void)showPreviewPhotosArray:(NSArray *)array baseView:(UIImageView*)view selected:(NSInteger)num;
{
    [self.imageArray removeAllObjects];
    
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        MJPhoto *photo = [[MJPhoto alloc] init];
        photo.srcImageView = view; // 来源于哪个UIImageView
        if ([obj isKindOfClass:[UIImage class]])
        {
            photo.image = obj; // 图片路径
        }
        else
        {
            NSString *url = obj;
            if (![url containsString:IMAGE_URL]) {
                url = [NSString stringWithFormat:@"%@%@",IMAGE_URL,url];
            }
            photo.url = [NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]; // 图片路径
        }
        [self.imageArray addObject:photo];
    }];
    
    // 2.显示相册
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.currentPhotoIndex = num; // 弹出相册时显示的第一张图片是？
    browser.photos = self.imageArray; // 设置所有的图片
    browser.isDelete = YES;
    [browser show];
}

#pragma mark - ZYQAssetPickerController Delegate

-(void)assetPickerController:(ZYQAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets{
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        if (assets.count > 0)
        {
            hudShowLoading(@"编辑中...");
        }
        
        [assets enumerateObjectsUsingBlock:^(ZYQAsset *asset, NSUInteger idx, BOOL * _Nonnull stop) {
            TBWeakSelf
            [asset setGetFullScreenImage:^(UIImage *result) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [weakSelf.imageArray addObject:result];
                    
                    if (weakSelf.imageArray.count == picker.indexPathsForSelectedItems.count)
                    {
                        hudDismiss();
                        if (weakSelf.controller&&weakSelf.imageArray.count == 1) {
                            [self imageTailoringController:picker image:weakSelf.imageArray.firstObject];
                            
                        }
                        else
                        {
                            if ([self.delegate respondsToSelector:@selector(choosePhotosArray:)]&&weakSelf.imageArray.count>0) {
                                [self.delegate choosePhotosArray:weakSelf.imageArray];
                            }
                            
                        }
                        
                    }
                });
                
            }];
        }];
        
    });
    
}
-(void)assetPickerControllerDidMaximum:(ZYQAssetPickerController *)picker{
    hudShowInfo(@"不能再选择相片了");
}
#pragma mark --UIImagePickerController--
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    [self.imageArray addObject:image];
    [[ZKUtil getPresentedViewController] dismissViewControllerAnimated:NO completion:nil];
    
    if (self.controller&&self.imageArray.count == 1) {
        [self imageTailoringController:nil image:self.imageArray.firstObject];
        
    }
    else
    {
        if ([self.delegate respondsToSelector:@selector(choosePhotosArray:)]&&self.imageArray.count > 0) {
            [self.delegate choosePhotosArray:self.imageArray];
        }
        
    }
    
}
#pragma mark ----
/**
 裁剪
 
 @param picker ZYQAssetPickerController
 @param image image
 */
-(void)imageTailoringController:(ZYQAssetPickerController *)picker image:(UIImage *)image
{
    PhotoViewController *cropPictureController = [[PhotoViewController alloc] init];
    cropPictureController.oldImage = image;
    cropPictureController.mode = PhotoMaskViewModeCircle;
    cropPictureController.isDark = YES;
    cropPictureController.cropWidth = _SCREEN_WIDTH - 80;
    cropPictureController.delegate = self;
    [self.controller presentViewController:cropPictureController animated:YES completion:nil];
}
#pragma mark - photoViewControllerDelegate
- (void)imageCropper:(PhotoViewController *)cropperViewController didFinished:(UIImage *)editedImage
{
    [self.controller dismissViewControllerAnimated:YES completion:^{
        if ([self.delegate respondsToSelector:@selector(choosePhotosArray:)]) {
            [self.delegate choosePhotosArray:@[editedImage]];
        }
    }];
}

- (void)imageCropperDidCancel:(PhotoViewController *)cropperViewController
{
    [self.controller dismissViewControllerAnimated:YES completion:nil];
    
}
@end
