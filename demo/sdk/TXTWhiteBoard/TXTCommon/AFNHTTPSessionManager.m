  //
 //  AFNHTTPSessionManager.m
 //  Dingsun
 //
 //  Created by 洪青文 on 2017/4/22.
 //  Copyright © 2017年 hongqingwen. All rights reserved.
 //

 #import "AFNHTTPSessionManager.h"
#import "TXTCustomConfig.h"
// #import "txDefine.h"
// #import "Utils.h"
// #import "UIAlertUtil.h"

 static AFNHTTPSessionManager *instance;
 @implementation AFNHTTPSessionManager

 +(AFNHTTPSessionManager *)shareInstance
 {
     if (instance == nil) {
         instance = [super manager];
         instance.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
         instance.securityPolicy.allowInvalidCertificates = YES;
         [instance.securityPolicy setValidatesDomainName:NO];
         
     };
     return instance;

 }

 -(void)requestURL:(NSString *)url
        RequestWay:(NSString *)way
            Header:(NSString *)header
              Body:(NSDictionary *)body
            params:(NSDictionary *)params
        isFormData:(BOOL)isFormData
           success:(AFNHTTPSessionManagerBlock)success
           failure:(AFNHTTPSessionManagerBlock)failure {
     NSString *urlstr = @"";
     if(isFormData){
         urlstr = [NSString stringWithFormat:@"%@",url];
     }else{
         NSString *environment = TXUserDefaultsGetObjectforKey(Environment);
         if ([environment isEqualToString:@"1"]) {
             urlstr = [NSString stringWithFormat:@"%@%@",@"https://video-sells-test.ikandy.cn",url];
         }else if([environment isEqualToString:@"2"]) {
             urlstr = [NSString stringWithFormat:@"%@%@",@"https://sig.cloud-ins.cn",url];
         }else{
             urlstr = [NSString stringWithFormat:@"%@%@",@"https://dev1.ikandy.cn:60312",url];
         }
         
     }
     NSLog(@"%@",urlstr);
     urlstr = [urlstr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
     NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer]requestWithMethod:way URLString:urlstr parameters:nil error:nil];
     request.timeoutInterval = 10;
     [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
     [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
     
     if (header && ![header isEqualToString:@""]) {
          [request setValue:header forHTTPHeaderField:@"access-token"];
     }
     
     if ([way isEqualToString:@"POST"] || [way isEqualToString:@"PUT"]|| [way isEqualToString:@"DELETE"])
     {
         NSData *data1 = [NSJSONSerialization dataWithJSONObject:body options:0 error:nil];
         NSString *jsonstr = [[NSString alloc] initWithData:data1 encoding:NSUTF8StringEncoding];
         [request setHTTPBody:[jsonstr dataUsingEncoding:NSUTF8StringEncoding]];
     }
         [[instance dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
             
             if (!error) {
                 
                 [self parseResponse:responseObject error:error success:success failure:failure];
                 
             }
             else
             {
                 //      [self parseResponse:response error:error success:success failure:failure];
                 if([TXTCustomConfig sharedInstance].isDebugConsole) {
                     NSLog(@"AFNHTTPSessionManager === %@", [error localizedDescription]);
                 }
                 failure(error,responseObject);
             }
         }] resume];
 }


-(void)request_file_URL:(NSString *)url
       RequestWay:(NSString *)way
           Header:(NSString *)header
             File:(UIImage *)file
           params:(NSDictionary *)params
       isFormData:(BOOL)isFormData
          success:(AFNHTTPSessionManagerBlock)success
          failure:(AFNHTTPSessionManagerBlock)failure {
    NSString *urlstr = @"";
    NSString *environment = TXUserDefaultsGetObjectforKey(Environment);
    if ([environment isEqualToString:@"1"]) {
        urlstr = [NSString stringWithFormat:@"%@%@",@"https://video-sells-test.ikandy.cn",url];
    }else if([environment isEqualToString:@"2"]) {
        urlstr = [NSString stringWithFormat:@"%@%@",@"https://sig.cloud-ins.cn",url];
    }else{
        urlstr = [NSString stringWithFormat:@"%@%@",@"https://developer.ikandy.cn:60312",url];
    }
//    urlstr = [NSString stringWithFormat:@"%@%@",URL_ROOT,url];
    urlstr = [urlstr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer]requestWithMethod:way URLString:urlstr parameters:nil error:nil];
    request.timeoutInterval = 10;
    [request setValue:@"multipart/form-data" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
//    NSDictionary *bodyDict = @{@"agent":TXUserDefaultsGetObjectforKey(Agent)};
//    NSData *data1 = [NSJSONSerialization dataWithJSONObject:bodyDict options:0 error:nil];
//    NSString *jsonstr = [[NSString alloc] initWithData:data1 encoding:NSUTF8StringEncoding];
//    [request setHTTPBody:[jsonstr dataUsingEncoding:NSUTF8StringEncoding]];

    NSData *data = UIImageJPEGRepresentation(file, 0.1);
//    NSDictionary *agentDic = @{@"agent":@"hqw"};
//     NSData *jsonData = [NSJSONSerialization dataWithJSONObject:@"hqw" options:NSJSONWritingPrettyPrinted error:nil];
//    NSDictionary *fileDic = @{@"file":data};
//    NSData *fileJsonData = [NSJSONSerialization dataWithJSONObject:fileDic options:NSJSONWritingPrettyPrinted error:nil];
    [instance POST:urlstr parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        //当提交一张图片或一个文件的时候 name 可以随便设置，服务端直接能拿到，如果服务端需要根据name去取不同文件的时候，则appendPartWithFileData 方法中的 name 需要根据form的中的name一一对应
//        [formData appendPartWithFormData:jsonData name:@"agent"];
        [formData appendPartWithFileData:data name:@"file" fileName:@"imagefile" mimeType:@"image/jpg"];
//        [formData appendPartWithFormData:data name:@"file"];
        [formData appendPartWithFormData:[@"hqw" dataUsingEncoding:NSUTF8StringEncoding] name:@"agent"];
//        [formData appendPartWithHeaders:nil body:data1];

    } progress:^(NSProgress * _Nonnull uploadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

       [self parseResponse:responseObject error:nil success:success failure:failure];

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error,nil);
        
        if([TXTCustomConfig sharedInstance].isDebugConsole) {
            NSLog(@"AFNHTTPSessionManager === %@", [error localizedDescription]);
        }
    }];
}




 - (void)parseResponse:(id)response
                  error:(NSError *)error
               success:(AFNHTTPSessionManagerBlock)success
               failure:(AFNHTTPSessionManagerBlock)failure {
     if (error) {
         if([TXTCustomConfig sharedInstance].isDebugConsole) {
             NSLog(@"AFNHTTPSessionManager === %@", [error localizedDescription]);
         }
         
         failure(error,[NSDictionary dictionaryWithObjects:@[[error description]] forKeys:@[@"errInfo"]]);
         
     } else {
         //        NSLog(@"success...... = %@",task.response);
         NSDictionary *responseDict = (NSDictionary *)response;
         
         //        NSLog(@"%@",responseDict);
        
             if (success) {
                 success(error, responseDict);
                 return;
             }
         
             if (failure) {
                 failure(error, responseDict);
                 return;
             }
         
     }
 }

 - (void)parseResponse1:(id)response
                 error:(NSError *)error
               success:(AFNHTTPSessionManagerBlock)success
               failure:(AFNHTTPSessionManagerBlock)failure {
     if (error) {
         
         if([TXTCustomConfig sharedInstance].isDebugConsole) {
             NSLog(@"AFNHTTPSessionManager === %@", [error localizedDescription]);
         }
         
         failure(error,[NSDictionary dictionaryWithObjects:@[[error description]] forKeys:@[@"errInfo"]]);
         
     } else {
         //        NSLog(@"success...... = %@",task.response);
         NSString *responseDict = (NSString *)response;
         
         //        NSLog(@"%@",responseDict);
         
         if (success) {
             success(error, responseDict);
             return;
         }
         
         if (failure) {
             failure(error, responseDict);
             return;
         }
         
     }
 }

 - (NSString *)reachability
 {
     // 1.获得网络监控的管理者
     AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager sharedManager];
     NSString * __block managerMessage = @"";
     
     
     // 2.设置网络状态改变后的处理
     [mgr setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
         // 当网络状态改变了, 就会调用这个block
         switch (status) {
             case AFNetworkReachabilityStatusUnknown: // 未知网络
                 NSLog(@"未知网络");
                 managerMessage = @"现在有未知网络";
                 break;
             case AFNetworkReachabilityStatusNotReachable: // 没有网络(断网)
                 NSLog(@"没有网络(断网)");
                 managerMessage = @"当前没有网络连接";
                 break;
             case AFNetworkReachabilityStatusReachableViaWWAN: // 手机自带网络
                 NSLog(@"手机自带网络");
                 managerMessage = @"当前为3/4G网络环境";
                 break;
             case AFNetworkReachabilityStatusReachableViaWiFi: // WIFI
                 NSLog(@"WIFI");
                 managerMessage = @"当前为WIFI环境";
                 break;
         }
         
         if (self.delegate && [self.delegate respondsToSelector:@selector(netPresentCallView:)]) {
             [self.delegate netPresentCallView:managerMessage];
         }
 //        if (self.delegate && [self.delegate respondsToSelector:@selector(netPresentQueueView:)]) {
 //            [self.delegate netPresentQueueView:managerMessage];
 //        }
     }];
     
     // 3.开始监控
     [mgr startMonitoring];
     
     return managerMessage;
 }


 //获取当前屏幕显示的viewcontroller
 - (UIViewController *)getCurrentVC
 {
     UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
     
     UIViewController *currentVC = [self getCurrentVCFrom:rootViewController];
     
     return currentVC;
 }

 - (UIViewController *)getCurrentVCFrom:(UIViewController *)rootVC
 {
     UIViewController *currentVC;
     
     if ([rootVC presentedViewController]) {
         // 视图是被presented出来的
         
         rootVC = [rootVC presentedViewController];
     }
     
     if ([rootVC isKindOfClass:[UITabBarController class]]) {
         // 根视图为UITabBarController
         
         currentVC = [self getCurrentVCFrom:[(UITabBarController *)rootVC selectedViewController]];
         
     } else if ([rootVC isKindOfClass:[UINavigationController class]]){
         // 根视图为UINavigationController
         
         currentVC = [self getCurrentVCFrom:[(UINavigationController *)rootVC visibleViewController]];
         
     } else {
         // 根视图为非导航类
         
         currentVC = rootVC;
     }
     
     return currentVC;
 }





 @end
