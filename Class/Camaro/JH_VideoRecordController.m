//
//  JH_VideoRecordController.m
//  JHVideoRecordTest
//
//  Created by hyjt on 2017/7/20.
//  Copyright © 2017年 haoyungroup. All rights reserved.
//

#import "JH_VideoRecordController.h"


@interface JH_VideoRecordController ()

@end

@implementation JH_VideoRecordController

- (void)dealloc {
    _recordEngine = nil;

}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.allowRecord = YES;
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    if (_recordEngine == nil) {
        [self.recordEngine previewLayer].frame = [UIScreen mainScreen].bounds;
        [self.view.layer insertSublayer:[self.recordEngine previewLayer] atIndex:0];
    }
    [self.recordEngine startUp];
}

//根据状态调整view的展示情况
- (void)adjustViewFrame {
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        if (self.recordBt.selected) {
            self.topViewTop.constant = -64;
            [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
        }else {
            [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
            self.topViewTop.constant = 0;
        }
        
        [self.view layoutIfNeeded];
    } completion:nil];
}

#pragma mark - set、get方法
- (WCLRecordEngine *)recordEngine {
    if (_recordEngine == nil) {
        _recordEngine = [[WCLRecordEngine alloc] init];
        _recordEngine.delegate = self;
    }
    return _recordEngine;
}

- (UIImagePickerController *)moviePicker {
    if (_moviePicker == nil) {
        _moviePicker = [[UIImagePickerController alloc] init];
        _moviePicker.delegate = self;
        _moviePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        _moviePicker.mediaTypes = @[(NSString *)kUTTypeMovie];
    }
    return _moviePicker;
}


#pragma mark - WCLRecordEngineDelegate
- (void)recordProgress:(CGFloat)progress {
    if (progress >= 1) {
        [self recordAction:self.recordBt];
        self.allowRecord = NO;
    }
    self.progressView.progress = progress;
}

#pragma mark - 各种点击事件
//返回点击事件
- (IBAction)dismissAction:(id)sender {
        [self.recordEngine shutdown];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [self.navigationController popViewControllerAnimated:YES];
}

//开关闪光灯
- (IBAction)flashLightAction:(id)sender {
    if (self.changeCameraBT.selected == NO) {
        self.flashLightBT.selected = !self.flashLightBT.selected;
        if (self.flashLightBT.selected == YES) {
            [self.recordEngine openFlashLight];
        }else {
            [self.recordEngine closeFlashLight];
        }
    }
}

//切换前后摄像头
- (IBAction)changeCameraAction:(id)sender {
    self.changeCameraBT.selected = !self.changeCameraBT.selected;
    if (self.changeCameraBT.selected == YES) {
        //前置摄像头
        [self.recordEngine closeFlashLight];
        self.flashLightBT.selected = NO;
        [self.recordEngine changeCameraInputDeviceisFront:YES];
    }else {
        [self.recordEngine changeCameraInputDeviceisFront:NO];
    }
}

//录制下一步点击事件
- (IBAction)recordNextAction:(id)sender {
    if (_recordEngine.videoPath.length > 0) {
        
        [self.recordEngine stopCaptureHandler:^(UIImage *movieImage) {
            
            //获取视频数据
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:_recordEngine.recordEncoder.path]];
            
            if ([self.videoDelegate respondsToSelector:@selector(JH_VideoRecordDidFinish:videoImage:)]) {
                [self.videoDelegate JH_VideoRecordDidFinish:data videoImage:movieImage];
            }
            [self dismissAction:nil];
        }];
    }else {
        NSLog(@"请先录制视频~");
    }
}


//开始和暂停录制事件
- (IBAction)recordAction:(UIButton *)sender {
    if (self.allowRecord) {
        self.videoStyle = VideoRecord;
        self.recordBt.selected = !self.recordBt.selected;
        if (self.recordBt.selected) {
            if (self.recordEngine.isCapturing) {
                [self.recordEngine resumeCapture];
            }else {
                [self.recordEngine startCapture];
            }
        }else {
            [self.recordEngine pauseCapture];
        }
        [self adjustViewFrame];
    }
}


@end
