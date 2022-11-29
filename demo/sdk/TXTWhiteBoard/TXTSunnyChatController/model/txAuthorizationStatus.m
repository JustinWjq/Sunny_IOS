//
//  txAuthorizationStatus.m
//  HuiJinSDK
//
//  Created by 洪青文 on 2021/9/1.
//

#import "txAuthorizationStatus.h"

#import <PhotosUI/PhotosUI.h>
#import <CoreLocation/CLLocationManager.h>

@implementation txAuthorizationStatus

static txAuthorizationStatus *shareInstance = nil;

+(txAuthorizationStatus *)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (shareInstance == nil) {
            shareInstance = [[txAuthorizationStatus alloc] init];
        }
    });

    return shareInstance;
}

- (void)getPhotoAuthorization:(void(^)(BOOL))result{
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusAuthorized) {
        result(YES);
        return;
    }
    if (status == PHAuthorizationStatusRestricted || status == PHAuthorizationStatusDenied) {
        result(NO);
        return ;
    }
    
    if (status == PHAuthorizationStatusNotDetermined) {
        
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            // 回调是在子线程的
            NSLog(@"%@",[NSThread currentThread]);
            dispatch_async(dispatch_get_main_queue(), ^{
                if (status != PHAuthorizationStatusAuthorized) {
                    NSLog(@"未开启相册权限,请到设置中开启");
                    result(NO);
                    return ;
                }
                result(YES);
            });
            
        }];
    }
}

//检查是否有相机或麦克风权限
- (void)getAudio:(void(^)(BOOL))result{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    if (authStatus == AVAuthorizationStatusAuthorized) {
        result(YES);
    }else{
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
            if (granted) {
                result(YES);
            }else{
                result(NO);
            }
        }];
    }
}

- (void)getVideo:(void(^)(BOOL))result{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusAuthorized) {
        result(YES);
    }else{
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if (granted) {
                result(YES);
            }else{
                result(NO);
            }
        }];
    }
}

- (void)getAddressAuthorization:(void(^)(BOOL))result{
//    [CLLocationManager authorizationStatus];
    if ([CLLocationManager locationServicesEnabled] && ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized)) {

    //定位功能可用
        result(YES);
    }else if ([CLLocationManager authorizationStatus] ==kCLAuthorizationStatusDenied) {

    //定位不能用
        result(NO);
    }
}


//+ (void) requestLocalNetworkAuthorization:(void(^)(BOOL isAuth)) complete {
//
////    result = complete;
//
//    if(@available(iOS 14, *)) {
//
//        //IOS14需要进行本地网络授权
//
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//
//            const char* strc = [[AMNearbyServicesManager.sharedManager bonjourServicesName] UTF8String];
//
//            DNSServiceRef serviceRef = nil;
//
//            DNSServiceBrowse( &serviceRef, 0, 0, strc, nil, browseReply, nil);
//
//            DNSServiceProcessResult(serviceRef);
//
//            DNSServiceRefDeallocate(serviceRef);
//        });
//    }
//    else {
//       //IOS14以下默认返回yes,因为IOS14以下设备默认开启本地网络权限
//        complete(YES);
//    }
//
//}
//
/////函数回调授权结果
//static void browseReply( DNSServiceRef sdRef, DNSServiceFlags flags, uint32_t interfaceIndex, DNSServiceErrorType errorCode, const char *serviceName, const char *regtype, const char *replyDomain, void *context )
//
//{
//    //主线程返回获取结果
//    dispatch_async(dispatch_get_main_queue(), ^{
//
//        if (result) {
//
//            if (errorCode == kDNSServiceErr_PolicyDenied) {
//
//                result(NO);
//
//            }
//            else {
//                result(YES);
//            }
//
//        }
//
//    });
//}
//



@end
