//
//  JH_VideoRecordController.h
//  JHVideoRecordTest
//
//  Created by hyjt on 2017/7/20.
//  Copyright © 2017年 haoyungroup. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WCLRecordEngine.h"
#import "WCLRecordProgressView.h"
#import <MobileCoreServices/MobileCoreServices.h>
typedef NS_ENUM(NSUInteger, UploadVieoStyle) {
    VideoRecord = 0,
    VideoLocation,
};
@protocol JH_VideoRecordFinishDelegate <NSObject>
/**
 完成视频录制并返回
 */
-(void)JH_VideoRecordDidFinish:(NSData *)videoData videoImage:(UIImage *)image;

@end
@interface JH_VideoRecordController : UIViewController<WCLRecordEngineDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *flashLightBT;
@property (weak, nonatomic) IBOutlet UIButton *changeCameraBT;
@property (weak, nonatomic) IBOutlet UIButton *recordNextBT;
@property (weak, nonatomic) IBOutlet UIButton *recordBt;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewTop;
@property (weak, nonatomic) IBOutlet WCLRecordProgressView *progressView;
@property (strong, nonatomic) WCLRecordEngine         *recordEngine;
@property (assign, nonatomic) BOOL                    allowRecord;//允许录制
@property (assign, nonatomic) UploadVieoStyle         videoStyle;//视频的类型
@property (strong, nonatomic) UIImagePickerController *moviePicker;//视频选择器

@property (weak, nonatomic) id<JH_VideoRecordFinishDelegate>  videoDelegate;
@end
