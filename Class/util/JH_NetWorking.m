//
//  JH_NetWorking.m
//  haoqibaoyewu
//
//  Created by hyjt on 16/7/22.
//  Copyright © 2016年 jianghong. All rights reserved.
//

#import "JH_NetWorking.h"
#import "UUID.h"
#import "ZSXCAppDelegate+Start.h"
#define errorMessage @"网络连接错误！"
static JH_NetWorking *afsingleton = nil;
static NSInteger timeout = 60;
@implementation JH_NetWorking

#define KuserNeedLogout [responseObject[@"error"]isEqual:kLogoutCode1]||[responseObject[@"error"]isEqual:kLogoutCode2]||[responseObject[@"error"]isEqual:kLogoutCode3]
/**
 将AFNetWoeking网络请求，分装在一个单例的方法中，重用AFHTTPSessionManager
 */
+(JH_NetWorking *)shareNetWorking{
    @synchronized (self) {
        if (afsingleton==nil) {
            afsingleton = [[super allocWithZone:nil]init];
            afsingleton.sessionManager = [AFHTTPSessionManager manager];
            afsingleton.sessionManager.requestSerializer.timeoutInterval = timeout;
//            afsingleton.sessionManager.securityPolicy = [[self class] customSecurityPolicy];
        }
    }
    return afsingleton;
}

/**
 http网络请求

 @param urlString 完整url
 @param method 请求方法
 @param showHud 是否展示进度条
 @param params 参数
 @param completionblock 成功回调
 @param errorblock 失败回调
 */
+ (void)requestData:(NSString *)urlString HTTPMethod:(HttpMethod )method  showHud:(BOOL)showHud params:(NSDictionary *)params completionHandle:(void (^)(id))completionblock errorHandle:(void (^)(NSError *))errorblock{
    if (afsingleton==nil) {
        [[self class ] shareNetWorking];
    }
    //URL编码
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //hub
    MBProgressHUD *hud;
    if (showHud) {
        
        //hub
        hud = [MBProgressHUD MBProgressShowProgressWithTitle:@"正在加载..." view:nil];
        
    }
    
    //发送异步网络请求
    afsingleton.sessionManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [afsingleton.sessionManager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept" ];
    //    [manager.requestSerializer setValue:@"application/json; charset=gb2312" forHTTPHeaderField:@"Content-Type" ];
    
    afsingleton.sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json",@"text/html", @"text/plain",nil];
    afsingleton.sessionManager.requestSerializer.timeoutInterval = timeout;
    [afsingleton.sessionManager.securityPolicy setAllowInvalidCertificates:YES];
    //设置请求头,并移除body参数
    NSMutableDictionary *finalBody = [[NSMutableDictionary alloc]initWithDictionary:params];
    if (finalBody[kdevId]) {
        
        [afsingleton.sessionManager.requestSerializer setValue: params[kdevId] forHTTPHeaderField:kdevId ];
        [finalBody removeObjectForKey:kdevId];
    }
    if (finalBody[ktime]) {
        
        [afsingleton.sessionManager.requestSerializer setValue: params[ktime] forHTTPHeaderField:ktime ];
        [finalBody removeObjectForKey:ktime];
    }
    if (finalBody[@"key"]) {
        [finalBody removeObjectForKey:@"key"];
    }
    //GET和POSTDelete分别处理
    if (method == HttpMethodGet) {
        [afsingleton.sessionManager GET:urlString parameters:finalBody progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            //hideMB
            [hud hideAnimated:YES];
            //判断是否登录过期
            if (KuserNeedLogout) {
                [[self class]goToLoginWithMessage:responseObject[@"message"]];
            } else {
                
                //block回调
                completionblock(responseObject);
            }
            
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            //hideMB
            [hud hideAnimated:YES];
            [MBProgressHUD MBProgressShowSuccess:NO WithTitle:errorMessage view:nil];
            errorblock(error);
            
        }];
        
    }
    else if(method == HttpMethodPost) {
        
        [afsingleton.sessionManager POST:urlString parameters:finalBody progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            //hideMB
            [hud hideAnimated:YES];
            //判断是否登录过期
            if (KuserNeedLogout) {
                [[self class]goToLoginWithMessage:responseObject[@"message"]];
            } else {
                
                //block回调
                completionblock(responseObject);
            }
            
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            //hideMB
            [hud hideAnimated:YES];
             [MBProgressHUD MBProgressShowSuccess:NO WithTitle:errorMessage view:nil];
            errorblock(error);
            
        }];

    }else if (method == HttpMethodDelete){
        [afsingleton.sessionManager DELETE:urlString parameters:finalBody success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            //hideMB
            [hud hideAnimated:YES];
            //判断是否登录过期
            if (KuserNeedLogout) {
                [[self class]goToLoginWithMessage:responseObject[@"message"]];
            } else {
                
                //block回调
                completionblock(responseObject);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            //hideMB
            [hud hideAnimated:YES];
            [MBProgressHUD MBProgressShowSuccess:NO WithTitle:errorMessage view:nil];
            errorblock(error);
        }];
        
    }
    
}

/**
 http网络请求（使用Json方式）
 
 @param urlString 完整url
 @param method 请求方法
 @param showHud 是否展示进度条
 @param params 参数
 @param completionblock 成功回调
 @param errorblock 失败回调
 */
+ (void)requestDataByJson:(NSString *)urlString HTTPMethod:(HttpMethod )method  showHud:(BOOL)showHud params:(NSDictionary *)params completionHandle:(void(^)(id result))completionblock errorHandle:(void(^)(NSError *error))errorblock{
    
    if (afsingleton==nil) {
        [[self class ] shareNetWorking];
    }
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //hub
    MBProgressHUD *hud;
    if (showHud) {
        
        //hub
        hud = [MBProgressHUD MBProgressShowProgressWithTitle:@"正在加载..." view:nil];
        
    }
    //发送异步网络请求
    
    [afsingleton.sessionManager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept" ];
    //    [manager.requestSerializer setValue:@"application/json; charset=gb2312" forHTTPHeaderField:@"Content-Type" ];
    afsingleton.sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    afsingleton.sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json",@"text/html", @"text/plain",nil];
    afsingleton.sessionManager.requestSerializer.timeoutInterval = timeout;
    //设置请求头,并移除body参数
    NSMutableDictionary *finalBody = [[NSMutableDictionary alloc]initWithDictionary:params];
    if (finalBody[kdevId]) {
        
        [afsingleton.sessionManager.requestSerializer setValue: params[kdevId] forHTTPHeaderField:kdevId ];
        [finalBody removeObjectForKey:kdevId];
    }
    if (finalBody[ktime]) {
        
        [afsingleton.sessionManager.requestSerializer setValue: params[ktime] forHTTPHeaderField:ktime ];
        [finalBody removeObjectForKey:ktime];
    }
    if (finalBody[@"key"]) {
        [finalBody removeObjectForKey:@"key"];
    }
    
    //GET和POST分别处理
    if (method == HttpMethodGet) {
        [afsingleton.sessionManager GET:urlString parameters:finalBody progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            //hideMB
            [hud hideAnimated:YES];
            
            //判断是否登录过期
            if (KuserNeedLogout) {
                [[self class]goToLoginWithMessage:responseObject[@"message"]];
            } else {
                
                //block回调
                completionblock(responseObject);
            }
            
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            //hideMB
            [hud hideAnimated:YES];
            [MBProgressHUD MBProgressShowSuccess:NO WithTitle:errorMessage view:nil];
            errorblock(error);
            
        }];
        
    }
    else if(method == HttpMethodPost) {
        
        [afsingleton.sessionManager POST:urlString parameters:finalBody progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            //hideMB
            [hud hideAnimated:YES];
            //判断是否登录过期
            if (KuserNeedLogout) {
                [[self class]goToLoginWithMessage:responseObject[@"message"]];
            } else {
                
                //block回调
                completionblock(responseObject);
            }
            
            
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            //hideMB
            [hud hideAnimated:YES];
            [MBProgressHUD MBProgressShowSuccess:NO WithTitle:errorMessage view:nil];
            errorblock(error);
            
        }];
        
        
    }else if (method == HttpMethodDelete){
        [afsingleton.sessionManager DELETE:urlString parameters:finalBody success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            //hideMB
            [hud hideAnimated:YES];
            //判断是否登录过期
            if (KuserNeedLogout) {
                [[self class]goToLoginWithMessage:responseObject[@"message"]];
            } else {
                
                //block回调
                completionblock(responseObject);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            //hideMB
            [hud hideAnimated:YES];
            [MBProgressHUD MBProgressShowSuccess:NO WithTitle:errorMessage view:nil];
            errorblock(error);
        }];
        
    }
}
/**
 上传附件的网络请求
 
 @param urlString 完整url
 @param method 请求方法
 @param params 参数
 @param completionblock 成功回调
 @param errorblock 失败回调
 */

+ (void)requestDataAndFormData:(NSString *)urlString HTTPMethod:(HttpMethod )method  params:(NSDictionary *)params formDataArray:(NSArray *)formDataArray completionHandle:(void(^)(id result))completionblock errorHandle:(void(^)(NSError *error))errorblock{
    if (afsingleton==nil) {
        [[self class ] shareNetWorking];
    }
    //编码
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    MBProgressHUD *hud = [MBProgressHUD MBProgressShowProgressViewWithTitle:@"正在上传..." view:nil];
    //发送异步网络请求
    
//    [afsingleton.sessionManager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept" ];
    //    [manager.requestSerializer setValue:@"application/json; charset=gb2312" forHTTPHeaderField:@"Content-Type" ];
//    afsingleton.sessionManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
//    afsingleton.sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json",@"text/html", @"text/plain",nil];
//    afsingleton.sessionManager.requestSerializer.timeoutInterval = timeout;
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    // 是否允许,NO-- 不允许无效的证书
    [securityPolicy setAllowInvalidCertificates:YES];
    [securityPolicy setValidatesDomainName:NO];
    
    afsingleton.sessionManager.securityPolicy = securityPolicy;
    //设置请求头
    //获取token、userId
    NSMutableDictionary *finalBody = [[NSMutableDictionary alloc]initWithDictionary:params];
    if (finalBody[kdevId]) {
        
        [afsingleton.sessionManager.requestSerializer setValue: params[kdevId] forHTTPHeaderField:kdevId ];
        [finalBody removeObjectForKey:kdevId];
    }
    if (finalBody[ktime]) {
        
        [afsingleton.sessionManager.requestSerializer setValue: params[ktime] forHTTPHeaderField:ktime ];
        [finalBody removeObjectForKey:ktime];
    }
    if (finalBody[@"key"]) {
        [finalBody removeObjectForKey:@"key"];
    }
    //GET和POST分别处理
    if (method == HttpMethodGet) {
        
        [afsingleton.sessionManager GET:urlString parameters:finalBody progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            //判断是否登录过期
            if (KuserNeedLogout) {
                [[self class]goToLoginWithMessage:responseObject[@"message"]];
            } else {
                
                //block回调
                completionblock(responseObject);
            }
            
            
            
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            
            errorblock(error);
            
        }];
        
    }
    else if(method == HttpMethodPost) {
        [afsingleton.sessionManager POST:urlString parameters:finalBody constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            //处理formData
            for (NSDictionary *data in formDataArray) {
                
                [formData appendPartWithFileData:data[@"fileData"] name:data[@"name"] fileName:data[@"fileName"] mimeType:data[@"mimeType"]];
            }
            
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            //必须在主线程中更新progress！！！！
            dispatch_async(dispatch_get_main_queue(), ^{
//                DebugLog(@"%f",uploadProgress.fractionCompleted);
                hud.progress = uploadProgress.fractionCompleted;
            });
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [hud hideAnimated:YES];
            //判断是否登录过期
            if (KuserNeedLogout) {
                [[self class]goToLoginWithMessage:responseObject[@"message"]];
            } else {
                
                //block回调
                completionblock(responseObject);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [hud hideAnimated:YES];
            [MBProgressHUD MBProgressShowSuccess:NO WithTitle:errorMessage view:nil];
            errorblock(error);
        }];
    }
    
}
+ (void)requestDataAndFormDataWithNoHud:(NSString *)urlString HTTPMethod:(HttpMethod )method  params:(NSDictionary *)params formDataArray:(NSArray *)formDataArray completionHandle:(void(^)(id result))completionblock errorHandle:(void(^)(NSError *error))errorblock{
    if (afsingleton==nil) {
        [[self class ] shareNetWorking];
    }
    //编码
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //发送异步网络请求

    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    // 是否允许,NO-- 不允许无效的证书
    [securityPolicy setAllowInvalidCertificates:YES];
    [securityPolicy setValidatesDomainName:NO];
    
    afsingleton.sessionManager.securityPolicy = securityPolicy;
    //设置请求头
    //获取token、userId
    NSMutableDictionary *finalBody = [[NSMutableDictionary alloc]initWithDictionary:params];
    if (finalBody[kdevId]) {
        
        [afsingleton.sessionManager.requestSerializer setValue: params[kdevId] forHTTPHeaderField:kdevId ];
        [finalBody removeObjectForKey:kdevId];
    }
    if (finalBody[ktime]) {
        
        [afsingleton.sessionManager.requestSerializer setValue: params[ktime] forHTTPHeaderField:ktime ];
        [finalBody removeObjectForKey:ktime];
    }
    if (finalBody[@"key"]) {
        [finalBody removeObjectForKey:@"key"];
    }
    //GET和POST分别处理
    if (method == HttpMethodGet) {
        
        [afsingleton.sessionManager GET:urlString parameters:finalBody progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            //判断是否登录过期
            if (KuserNeedLogout) {
                [[self class]goToLoginWithMessage:responseObject[@"message"]];
            } else {
                
                //block回调
                completionblock(responseObject);
            }
            
            
            
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            
            errorblock(error);
            
        }];
        
    }
    else if(method == HttpMethodPost) {
        [afsingleton.sessionManager POST:urlString parameters:finalBody constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            //处理formData
            for (NSDictionary *data in formDataArray) {
                
                [formData appendPartWithFileData:data[@"fileData"] name:data[@"name"] fileName:data[@"fileName"] mimeType:data[@"mimeType"]];
            }
            
        } progress:^(NSProgress * _Nonnull uploadProgress) {

        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

            //判断是否登录过期
            if (KuserNeedLogout) {
                [[self class]goToLoginWithMessage:responseObject[@"message"]];
            } else {
                
                //block回调
                completionblock(responseObject);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

            [MBProgressHUD MBProgressShowSuccess:NO WithTitle:errorMessage view:nil];
            errorblock(error);
        }];
    }
    
}
/**
 由于token过期造成的登录过期，强制退出
 */
+(void)goToLoginWithMessage:(NSString *)message{
    [ZSXCUserManager userLogin:YES];
    [JHAlertControllerTool alertTitle:@"提示" mesasge:message preferredStyle:1 confirmHandler:^(UIAlertAction *action) {
        ZSXCAppDelegate *appdelegate = (ZSXCAppDelegate *)[UIApplication sharedApplication].delegate;
        [appdelegate _setLoginVC];
    } viewController:[UIApplication sharedApplication].keyWindow.rootViewController];

    
}

//自定义安全策略
+ (AFSecurityPolicy*)customSecurityPolicy
{
    // /先导入证书
//    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"xiaoxin" ofType:@"cer"];//证书的路径
    //    NSString * cerPath = [[NSBundle mainBundle]pathForResource:@"https" ofType:@"cer"];
    
    //    NSLog(@"%@",cerPath);
//    NSData *certData = [NSData dataWithContentsOfFile:cerPath];
    //    NSLog(@"%@",certData);
    //    NSSet * certSet = [[NSSet alloc] initWithObjects:certData, nil];
    
    // AFSSLPinningModeCertificate 使用证书验证模式
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    
    // allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
    // 如果是需要验证自建证书，需要设置为YES
    securityPolicy.allowInvalidCertificates = YES;
    
    //validatesDomainName 是否需要验证域名，默认为YES；
    //假如证书的域名与你请求的域名不一致，需把该项设置为NO；如设成NO的话，即服务器使用其他可信任机构颁发的证书，也可以建立连接，这个非常危险，建议打开。
    //置为NO，主要用于这种情况：客户端请求的是子域名，而证书上的是另外一个域名。因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com，那么mail.google.com是无法验证通过的；当然，有钱可以注册通配符的域名*.google.com，但这个还是比较贵的。
    //如置为NO，建议自己添加对应域名的校验逻辑。
    securityPolicy.validatesDomainName = NO;
    
//    securityPolicy.pinnedCertificates = [NSSet setWithObjects:certData, nil];
    
    return securityPolicy;
}

/**
 MD5加密

 @param data 原始Data数据
 @return MD5字符串
 */
+(NSString *)Md5Param:(NSDictionary *)data isLogin:(BOOL)isLogin{
    
    //排序完成
    NSString *finalString = @"";
    if (isLogin) {
        //拆分dic
        NSDictionary *header = @{kdevId:data[kdevId],ktime:data[ktime],@"key":data[@"key"],};
        NSString *headerStr = [[self class]getString:header];
        NSMutableDictionary *body = [[NSMutableDictionary alloc] initWithDictionary:data];
        [body removeObjectsForKeys:@[kdevId,ktime,@"key"]];
        NSString *bodyStr = [[self class]getString:body];
        if ([bodyStr isEqualToString:@""]) {
            finalString = headerStr;
        }else{
            finalString = [NSString stringWithFormat:@"%@&%@",bodyStr,headerStr];
        }
        
    }else{
        
    }
    
    finalString = [NSString stringToMD5:finalString];
    
    return finalString;
}

/**
 排序拼接字符串
 */
+(NSString *)getString:(NSDictionary *)data{
    NSString *finalString = @"";
    NSMutableArray *dataArray =  [NSMutableArray arrayWithArray:[data allKeys]];
    //首先排序key(冒泡排序)
    for (int i = 0; i<dataArray.count; i++) {
        
        for (int j=i+1; j<dataArray.count; j++) {
            
            if ([dataArray[i]compare:dataArray[j] options:NSLiteralSearch]== NSOrderedDescending ) {
                //交换ij对应的值
                [dataArray exchangeObjectAtIndex:i withObjectAtIndex:j];
            }
            
        }
    }
    
    for (int index = 0; index<dataArray.count; index++) {
        NSString *str = dataArray[index];
        //第一个不需要&字符
        if (index!=0) {
            finalString = [finalString stringByAppendingString:@"&"];
        }
        finalString  = [NSString stringWithFormat:@"%@%@=%@",finalString,str,data[str]];
    }
    return finalString;
}
/**
 处理参数，加上本后台需求的新参数

 @param data oringin
 @param isLogin 根据是否登录区分加devid或者token、userId、orgId
 @return finalData
 */
+(NSDictionary *)addBaseKeyWithData:(NSDictionary *)data isLogin:(BOOL)isLogin{
    //每次请求都需要携带三个参数token+userId+orgId+devid,登录时需要携带devId(设备id).
    NSMutableDictionary *finalData = [[NSMutableDictionary alloc] initWithDictionary:data];
    if (isLogin) {
        //设备Id
        NSString *devid = [UUID getUUID];
        [finalData setObject:devid forKey:kdevId];
        //时间戳
        NSDate *now = [NSDate date];
        long timestamp = [now timeIntervalSince1970]*1000;
        //用户信息
        NSString *userId = [ZSXCUserManager getUserId];
        NSString *orgId = [ZSXCUserManager getOrgId];
        
        [finalData setObject:userId forKeyedSubscript:kuserId];
        [finalData setObject:orgId forKeyedSubscript:korgId];
        
        [finalData setObject:[NSString stringWithFormat:@"%ld",timestamp] forKey:ktime];
        //key
        [finalData setObject:@"123456" forKey:@"key"];
        
    }else{
        //设备Id
        NSString *devid = [UUID getUUID];
        [finalData setObject:devid forKey:kdevId];
        //时间戳
        NSDate *now = [NSDate date];
        long timestamp = [now timeIntervalSince1970]*1000;
        [finalData setObject:[NSString stringWithFormat:@"%ld",timestamp] forKey:ktime];
        //key
        [finalData setObject:@"123456" forKey:@"key"];
    }
    
    return finalData;
}

/**
 同步请求
 */
+(id)sendSynchronousRequest:(NSString *)urlString HTTPMethod:(HttpMethod )method  params:(NSDictionary *)params{
    
    //设置请求头
    //获取token、userId
    NSMutableDictionary *finalBody = [[NSMutableDictionary alloc]initWithDictionary:params];
    if (finalBody[kdevId]) {
        
        [afsingleton.sessionManager.requestSerializer setValue: params[kdevId] forHTTPHeaderField:kdevId ];
        [finalBody removeObjectForKey:kdevId];
    }
    if (finalBody[ktime]) {
        
        [afsingleton.sessionManager.requestSerializer setValue: params[ktime] forHTTPHeaderField:ktime ];
        [finalBody removeObjectForKey:ktime];
    }
    if (finalBody[@"key"]) {
        [finalBody removeObjectForKey:@"key"];
    }
    //3.处理请求参数
    //key1=value1&key2=value2
    NSMutableString *paramString = [NSMutableString string];
    
    NSArray *allKeys = finalBody.allKeys;
    
    for (NSInteger i = 0; i < finalBody.count; i++) {
        NSString *key = allKeys[i];
        NSString *value = finalBody[key];
        
        [paramString appendFormat:@"%@=%@",key,value];
        
        if (i < finalBody.count - 1) {
            [paramString appendString:@"&"];
        }
        
    }
    //编码
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    
    //2.创建网络请求
    NSMutableURLRequest *request;
    //4.GET和POST分别处理
    if (method ==HttpMethodGet) {
        
        //http://www.baidu.com?key1=value1&key2=value2
        //http://www.baidu.com?key0=value0&key1=value1&key2=value2
        
        NSString *seperate = url.query ? @"&" : @"?";
        urlString = [NSString stringWithFormat:@"%@%@%@",urlString,seperate,paramString];
        //编码
        urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        //根据拼接好的URL进行修改
        NSURL *finalUrl = [NSURL URLWithString:urlString];
        request = [[NSMutableURLRequest alloc]initWithURL:finalUrl cachePolicy:0 timeoutInterval:15];
        request.HTTPMethod = @"GET";
    }
    else if(method ==HttpMethodPost) {
        //POST请求则把参数放在请求体里
        request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:urlString] cachePolicy:0 timeoutInterval:15];
        NSData *bodyData = [paramString dataUsingEncoding:NSUTF8StringEncoding];
        request.HTTPMethod = @"POST";
        request.HTTPBody = bodyData;
    }
    
    // 发送一个同步请求(在主线程发送请求)
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    //解析JSON
    NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    return jsonDic;
}

#pragma mark - 下载数据

+(void)downloadFile:(NSString *)urlString fileName:(NSString *)fileName completionHandler:(void (^)())completionHandler{
    
    NSURL *url = [NSURL URLWithString:urlString];
    //写入数据
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    //AFN3.0+基于封住URLSession的句柄
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    //请求
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    /* 开始请求下载 */
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
 
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        //- block的返回值, 要求返回一个URL, 返回的这个URL就是文件的位置的路径
        //写入数据
        
        NSString *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
        //    DebugLog(@"%@",documentPath);
        NSString *dirPath = [documentPath stringByAppendingPathComponent:@"DICTIONARY"];
        [JH_FileManager creatDir:dirPath];
        NSString *filePath = [dirPath stringByAppendingPathComponent:fileName];
        //删除原文件，创建新文件
        [JH_FileManager deleteFile:filePath];
        return [NSURL fileURLWithPath:filePath];
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        // filePath就是你下载文件的位置，你可以解压，也可以直接拿来使用
        completionHandler();
    }];
    [downloadTask resume];
}

/**
 fastfds统一删除删除文件
 */
+(void)_deleteFileWithArray:(NSArray *)files withComplationHandle:(void(^)())completionBlock{
    NSString *filesString = [NSString DataTOjsonString:files];
    NSDictionary *baseData = @{
                               @"files":filesString
                               };
    
    NSDictionary *tempData = [JH_NetWorking addBaseKeyWithData:baseData isLogin:YES];
    //添加sign
    NSString *sign = [JH_NetWorking Md5Param:tempData isLogin:YES];
    
    NSMutableDictionary *requestData = [[NSMutableDictionary alloc] initWithDictionary:tempData];
    [requestData setObject:sign forKey:@"sign"];
    
    [JH_NetWorking requestData:[kBaseUrlStr stringByAppendingString:UTF8Char(ZSXC_api_file_delete.urlString)] HTTPMethod:ZSXC_api_file_delete.httpMethod showHud:NO params:requestData completionHandle:^(id result) {
        
        if ([result[@"error"] isEqual:@1]) {
            completionBlock();
        }else{
            
        }
    } errorHandle:^(NSError *error) {
        
    }];
}

@end
