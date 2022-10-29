//
//  AFNHTTPSessionManager.h
//  Dingsun
//
//  Created by 洪青文 on 2017/4/22.
//  Copyright © 2017年 hongqingwen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@protocol AFNetworkModuleDelegate <NSObject>
//-(void)netPresentQueueView:(NSString *)netWarning;
-(void)netPresentCallView:(NSString *)netWarning;

@end
typedef void (^ AFNHTTPSessionManagerBlock)(NSError *error, id response);

@interface AFNHTTPSessionManager :AFHTTPSessionManager

@property(nonatomic, weak) id<AFNetworkModuleDelegate> delegate;
+(AFNHTTPSessionManager *)shareInstance;

-(void)requestURL:(NSString *)url
       RequestWay:(NSString *)way
           Header:(NSString *)header
             Body:(NSDictionary *)body
           params:(NSDictionary *)params
       isFormData:(BOOL)isFormData
          success:(AFNHTTPSessionManagerBlock)success
          failure:(AFNHTTPSessionManagerBlock)failure;

-(void)request_file_URL:(NSString *)url
             RequestWay:(NSString *)way
                 Header:(NSString *)header
                   File:(UIImage *)file
                 params:(NSDictionary *)params
             isFormData:(BOOL)isFormData
                success:(AFNHTTPSessionManagerBlock)success
                failure:(AFNHTTPSessionManagerBlock)failure;

- (NSString *)reachability;
- (UIViewController *)getCurrentVC;

@end
