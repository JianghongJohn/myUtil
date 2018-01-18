//
//  JHDownLoadFile.m
//  carFinance
//
//  Created by hyjt on 2017/4/20.
//  Copyright © 2017年 haoyungroup. All rights reserved.
//

#import "JHDownLoadFile.h"
@implementation JHDownLoadFile

/**
 初始化下载数据
 */
+(void)_loadBaseData{
    //开始下载
    NSDictionary *tempData = [JH_NetWorking addBaseKeyWithData:@{} isLogin:NO];
    //添加sign
    NSString *sign = [JH_NetWorking Md5Param:tempData isLogin:YES];
    
    NSMutableDictionary *requestData = [[NSMutableDictionary alloc] initWithDictionary:tempData];
    [requestData setObject:sign forKey:@"sign"];
    
    [JH_NetWorking requestData:[kBaseUrlStr stringByAppendingString:UTF8Char(ZSXC_api_file_getFileInfo.urlString) ] HTTPMethod:ZSXC_api_file_getFileInfo.httpMethod showHud:NO params:requestData completionHandle:^(id result) {
        
        if ([result[@"error"] isEqual:@1]) {
            //先将基础信息存入
            [JHDownLoadFile addDictionaryToLocal:kFileInfo data:result[@"rows"]];
            [self compareAndDownLoad:result[@"rows"]];
            
        }else{
            [MBProgressHUD MBProgressShowSuccess:NO WithTitle:result[@"message"] view:nil];
        }
    } errorHandle:^(NSError *error) {
        
        //        [self setNeedsFocusUpdate];
    }];
    
}

/**
 对比数据并下载
 */
+(void)compareAndDownLoad:(NSArray *)newFiles{
    //获取之前的数据
    
    for (NSDictionary *file in newFiles) {
        NSString *fileName = file[@"file"];
        
        __block NSDictionary *newData = file;
        
        //对老文件进行md5
        NSString *filePath = [self getPathByKey:fileName];
        
        NSString *oldFileMd5 = [NSString fileMD5:filePath];
//        DLog(@"\n%@\n%@",oldFileMd5,newData[@"fileMD5"]);
        //对比md5,不同则执行下载
        if (![newData[@"fileMD5"] isEqualToString:oldFileMd5]) {
            //获取url
            NSString *urlString = newData[@"url"];
            //切割URlString
            NSArray *byEqualArr = [urlString componentsSeparatedByString:@"="];
            NSString *tempGroup = byEqualArr[1];
            NSString *path = byEqualArr[2];
            NSArray *ByAndArr = [tempGroup componentsSeparatedByString:@"&"];
            NSString *group = ByAndArr[0];
            [JH_NetWorking downloadFile:[NSString stringWithFormat:@"%@%@/%@",kBaseNginxUrlStr,group,path] fileName:fileName completionHandler:^{
                //轮播图下载完毕刷新首页
                if ([fileName isEqualToString:kBanner]) {
                    [[NSNotificationCenter defaultCenter]postNotificationName:kNotiRefreshHomeBanner object:nil];
                }
            }];
        }
        
    }
    
}

/**
 获取数据json字典,并添加到本地
 @param resullt block
 */
+(void)getDicByKey:(NSString *)key :(void(^)(id result))resullt{
    NSDictionary *tempData = [JH_NetWorking addBaseKeyWithData:@{@"key":key} isLogin:NO];
    //添加sign
    NSString *sign = [JH_NetWorking Md5Param:tempData isLogin:YES];
    
    NSMutableDictionary *requestData = [[NSMutableDictionary alloc] initWithDictionary:tempData];
    [requestData setObject:sign forKey:@"sign"];
    
    [JH_NetWorking requestData:[kBaseUrlStr stringByAppendingString:@""] HTTPMethod:HttpMethodPost showHud:NO params:requestData completionHandle:^(id result) {
        if ([result[@"error"]isEqual:@1]) {
            [[self class]addDictionaryToLocal:key data:result[@"rows"]];
            resullt(result);
        }else{
            
        }
        
    } errorHandle:^(NSError *error) {
        
    }];
}

/**
 将数据添加到本地
 */
+(void)addDictionaryToLocal:(NSString *)key data:(NSArray *)data{
    NSDictionary *json_dic = @{@"rows":data};//key为arr value为arr数组的字典
    
    //封包数据
    NSData *json_data = [NSJSONSerialization dataWithJSONObject:json_dic options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString *fileName = [self getPathByKey:key];
    //判断是否文件存在
    if ([[NSFileManager defaultManager] fileExistsAtPath:fileName]){
        [JH_FileManager deleteFile:fileName];
    }
    //写入文件
    [json_data writeToFile:fileName atomically:YES];
    
}

/**
 数据字典专属根据id查找页面展示的方法
 
 @param key 数据字典类型
 @param dicId id
 @return 描述
 */
+(NSString *)getDictionTextByKey:(NSString *)key withId:(NSString *)dicId{
    
    NSString *fileName = [self getPathByKey:key];
    //判断是否文件存在
    if ([[NSFileManager defaultManager] fileExistsAtPath:fileName]){
        
        NSData *data = [NSData dataWithContentsOfFile:fileName];//获取指定路径的data文件
        
        id json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil]; //获取到json文件的跟数据（字典）
        
        NSArray *array = [json objectForKey:@"rows"];//获取指定key值的value，是一个数组
        for (NSDictionary *dic in array) {
            //匹配id
            if ([[NSString stringWithFormat:@"%@",dic[kkeyword]]isEqualToString:dicId]) {
                return dic[kkeyValue];
            }
        }
        return @"";
    }else{
        //        kTipAlert(@"数据字典获取失败，请重新登录或者与管理员联系！");
        return @"";
    }
}
/**
 根据key将数据返回
 
 @return nsarray
 */
+(NSArray *)getArrayByKey:(NSString *)key{
    
    NSString *fileName = [self getPathByKey:key];
    
    //判断是否文件存在
    if ([[NSFileManager defaultManager] fileExistsAtPath:fileName]){
        
        NSData *data = [NSData dataWithContentsOfFile:fileName];//获取指定路径的data文件
        
        id json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil]; //获取到json文件的跟数据（字典）
        NSArray *array;
        @try {
            array = [json objectForKey:@"rows"];//获取指定key值的value，是一个数组
        } @catch (NSException *exception) {
            return @[];
        } @finally {
            
        }
        
        return array;
    }
    return @[];
}

/**
 路径拼接

 @param key 文件名
 @return 完整路劲
 */
+(NSString *)getPathByKey:(NSString *)key{
    NSString *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    //    DebugLog(@"%@",documentPath);
    NSString *dirPath = [NSString stringWithFormat:@"%@/DICTIONARY",documentPath];
    [JH_FileManager creatDir:dirPath];
    NSString *fileName = [NSString stringWithFormat:@"%@/%@",dirPath,key];
    return fileName;
}
@end
