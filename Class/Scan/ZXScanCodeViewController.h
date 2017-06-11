//
//  ZXScanCodeViewController.h
//  Coding_iOS
//
//  Created by Ease on 15/7/2.
//  Copyright (c) 2015年 Coding. All rights reserved.
//

#import "BaseVC.h"
#import <AVFoundation/AVFoundation.h>

@interface ZXScanCodeViewController : BaseVC
@property (strong, nonatomic, readonly) AVCaptureVideoPreviewLayer *videoPreviewLayer;
- (BOOL)isScaning;
- (void)startScan;
- (void)stopScan;

@property (copy, nonatomic) void(^scanResultBlock)(ZXScanCodeViewController *vc, NSString *resultStr);

@end
