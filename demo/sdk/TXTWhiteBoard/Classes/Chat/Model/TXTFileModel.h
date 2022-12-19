//
//  TXTFileModel.h
//  TXTWhiteBoard
//
//  Created by jiangyongjian on 2022/11/22.
//  Copyright © 2022 洪青文. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TXTFileModel : NSObject
// 图片类型
/**
 TXTFileModel *fileModel = [[TXTFileModel alloc] init];
 fileModel.pics = @[@"https://wisdom-exhibition-1301905869.cos.ap-shenzhen-fsi.myqcloud.com/testdocument/0jsoaidalsh31nr2bk4c_tiw/picture/1.jpg", @"https://wisdom-exhibition-1301905869.cos.ap-shenzhen-fsi.myqcloud.com/testdocument/0jsoaidalsh31nr2bk4c_tiw/picture/2.jpg"];
 fileModel.contents = @[@"你是哈回电话阿萨德发生的",@"",@"你是哈回电话阿萨德发生的"];
 // 当没有图片关键词,数组需要传入对应的@“”空字符串
 // [[TXTManage sharedInstance] addFileToSdk:FileTypePics fileModel:fileModel];
 */
/** pics 图片数组 */
@property (nonatomic, strong) NSArray *pics;
/** contents 图片对应的提词器 */
@property (nonatomic, strong) NSArray *contents;
        
// 视频类型
/**
 TXTFileModel *fileModel = [[TXTFileModel alloc] init];
 fileModel.videoUrl = @"https://res.qcloudtiw.com/demo/tiw-vod.mp4";
 [[TXTManage sharedInstance] addFileToSdk:FileTypeVideo fileModel:fileModel];
 */
/** videoUrl */
@property (nonatomic, copy) NSString *videoUrl;

// h5类型 h5Url、name 都是必填选项
/**
 TXTFileModel *fileModel = [[TXTFileModel alloc] init];
 fileModel.h5Url = @"https://recall-sync-demo.cloud-ins.cn/mirror.html?syncid=51-cvsstest123-1&synctoken=0060490432279104e008daf9a660dfb8d2aIABaoflIqpo4-W91SrtSeG8e-QAQ5_O7_RsAQrms1PxSLJ597XwAAAAAEADKL1Dbsjd_YwEA6AOyN39j";
 fileModel.name = @"test";
 [[TXTManage sharedInstance] addFileToSdk:FileTypeH5 fileModel:fileModel];
 */
        
/** h5Url */
@property (nonatomic, copy) NSString *h5Url;
/** name */
@property (nonatomic, copy) NSString *name;
/** cookieDict缓存字典只有h5类型才能用 */
@property (nonatomic, strong) NSDictionary *cookieDict;

@end

NS_ASSUME_NONNULL_END
