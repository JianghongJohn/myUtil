//
//  JH_PrivateHelper.m
//  haoqibaoyewu
//
//  Created by hyjt on 2017/3/24.
//  Copyright © 2017年 jianghong. All rights reserved.
//

#import "JH_PrivateHelper.h"
@import AVFoundation;

@implementation JH_PrivateHelper

+ (BOOL)checkPhotoLibraryAuthorizationStatus
{
    if ([ALAssetsLibrary respondsToSelector:@selector(authorizationStatus)]) {
        ALAuthorizationStatus authStatus = [ALAssetsLibrary authorizationStatus];
        if (ALAuthorizationStatusDenied == authStatus ||
            ALAuthorizationStatusRestricted == authStatus) {
            [self showSettingAlertStr:@"请在iPhone的“设置->掌上行车->照片”中打开本应用的访问权限"];
            return NO;
        }
    }
    return YES;
}

+ (BOOL)checkCameraAuthorizationStatus
{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        kTipAlert(@"该设备不支持拍照");
        return NO;
    }
    
    if ([AVCaptureDevice respondsToSelector:@selector(authorizationStatusForMediaType:)]) {
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (AVAuthorizationStatusDenied == authStatus ||
            AVAuthorizationStatusRestricted == authStatus) {
            [self showSettingAlertStr:@"请在iPhone的“设置->掌上行车->相机”中打开本应用的访问权限"];
            return NO;
        }
    }
    
    return YES;
}
/**
 * 检查系统"定位服务"授权状态, 如果权限被关闭, 提示用户去隐私设置中打开.
 */
+ (BOOL)checkLocationAuthorizationStatus{
    if ([CLLocationManager locationServicesEnabled] && ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways)) {
        
        //定位功能可用
        return YES;
    }else if ([CLLocationManager authorizationStatus] ==kCLAuthorizationStatusDenied) {
        [self showSettingAlertStr:@"请在iPhone的“设置->掌上行车->定位服务”中打开本应用的访问权限"];
        //定位不能用
        return NO;
    }
    return YES;
}
/**
 * 检查系统"相机和麦克风"授权状态, 如果权限被关闭, 提示用户去隐私设置中打开.
 */
+ (void)checkServiceEnable:(void(^)(BOOL))result{
    if ([[AVAudioSession sharedInstance] respondsToSelector:@selector(requestRecordPermission:)]) {
        [[AVAudioSession sharedInstance] performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
            JHdispatch_async_main_safe(^{
                if (granted) {
                    NSString *mediaType = AVMediaTypeVideo;
                    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
                    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
                        [self showSettingAlertStr:@"请在iPhone的“设置->掌上行车->相机”中打开本应用的访问权限"];
                    }else{
                        if (result) {
                            result(YES);
                        }
                    }
                }
                else {
                    [self showSettingAlertStr:@"请在iPhone的“设置->掌上行车->麦克风”中打开本应用的访问权限"];
                }
                
            });
        }];
    }
}

/**
 检测通知是否打开
 */
+(BOOL)checkNotificationValid{
    if ([[UIApplication sharedApplication] currentUserNotificationSettings].types  == UIUserNotificationTypeNone) {
        return NO;
    }
    return YES;
}

/**
 跳转到设置APP页面
 */
+(void)jumpToSetting{
    NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    
    if([[UIApplication sharedApplication] canOpenURL:url]) {
        
        NSURL*url =[NSURL URLWithString:UIApplicationOpenSettingsURLString];
        [[UIApplication sharedApplication] openURL:url];
        
    }
}

+ (void)showSettingAlertStr:(NSString *)tipStr{
    [JHAlertControllerTool alertTitle:@"提示" mesasge:tipStr preferredStyle:1 confirmHandler:^(UIAlertAction *action) {
        [self jumpToSetting];
    } cancleHandler:^(UIAlertAction *action) {
        
    } viewController:[JH_CommonInterface presentingVC]];
}
@end
