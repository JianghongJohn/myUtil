//
//  Cache_Util.m
//  haoqibaoyewu
//
//  Created by hyjt on 16/9/23.
//  Copyright © 2016年 jianghong. All rights reserved.
//

#import "Cache_Util.h"
/**
    缓存的处理
 */

@implementation Cache_Util
/**
    获取缓存大小
 */

#pragma mark - 获取缓存大小
+(CGFloat )getCacheSize{
    //获取沙盒路径
    NSString *filePath = NSHomeDirectory();
//    NSLog(@"%@",filePath);
    /*
    
     */
    NSArray *filePaths = @[[NSString stringWithFormat:@"%@/%@",filePath,@"Library/Caches/default"],
                           [NSString stringWithFormat:@"%@/%@",filePath,@"Library/Caches/WebKit"],
                           [NSString stringWithFormat:@"%@/%@",filePath,@"Library/WebKit/WebsiteData"],
                           [NSString stringWithFormat:@"%@/%@",filePath,@"Library/Caches/com.haoqikj.app.zsxc"],
                           [NSString stringWithFormat:@"%@/%@",filePath,@"tmp/WebKit"],
                           [NSString stringWithFormat:@"%@/%@",filePath,@"tmp/videos"]
                           ];
    //文件操作
    NSFileManager *manager = [NSFileManager defaultManager];
    long long fileSize = 0;
    for (NSString *path in filePaths) {
      NSArray *fileNames = [manager subpathsOfDirectoryAtPath:path error:nil];
        for (NSString *file in fileNames) {
            //拼接路径
            NSString *lastFilePath = [NSString stringWithFormat:@"%@/%@",path,file];
            NSDictionary *data = [manager attributesOfItemAtPath:lastFilePath error:nil];
            
            fileSize += data.fileSize;
        }
        
    }
    return fileSize;
}
/**data格式
 {
 NSFileCreationDate = "2016-09-23 07:18:22 +0000";
 NSFileExtensionHidden = 1;
 NSFileGroupOwnerAccountID = 20;
 NSFileGroupOwnerAccountName = staff;
 NSFileModificationDate = "2016-09-23 07:18:54 +0000";
 NSFileOwnerAccountID = 501;
 NSFilePosixPermissions = 420;
 NSFileReferenceCount = 1;
 NSFileSize = 6148;
 NSFileSystemFileNumber = 4752679;
 NSFileSystemNumber = 16777220;
 NSFileType = NSFileTypeRegular;
 }
 */

/**
    清除缓存
 */

#pragma mark - 清除缓存
+(void)clearCache{
    MBProgressHUD *hud = [MBProgressHUD MBProgressShowTextViewWithTitle:@"正在清理..." view:nil];
//    //获取沙盒路径
    NSString *filePath = NSHomeDirectory();
    /*
     1.Library/Caches
     2.tmp
     */
    NSArray *filePaths = @[[NSString stringWithFormat:@"%@/%@",filePath,@"Library/Caches/default"],
                           [NSString stringWithFormat:@"%@/%@",filePath,@"Library/Caches/WebKit"],
                           [NSString stringWithFormat:@"%@/%@",filePath,@"Library/WebKit/WebsiteData"],
                           [NSString stringWithFormat:@"%@/%@",filePath,@"Library/Caches/com.haoqikj.app.zsxc"],
                           [NSString stringWithFormat:@"%@/%@",filePath,@"tmp/WebKit"],
                           [NSString stringWithFormat:@"%@/%@",filePath,@"tmp/videos"]
                           ];
    //文件操作
    NSFileManager *manager = [NSFileManager defaultManager];
    
    for (NSString *path in filePaths) {
        NSArray *fileNames = [manager subpathsOfDirectoryAtPath:path error:nil];
        for (NSString *file in fileNames) {
            //拼接路径
            NSString *lastFilePath = [NSString stringWithFormat:@"%@/%@",path,file];
            [manager removeItemAtPath:lastFilePath error:nil];
        }
        
    }
    
    hud.label.text = @"清理成功";
    
}
#pragma mark - 获取设备内存大小

@end
