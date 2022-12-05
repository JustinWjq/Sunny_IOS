#import <Foundation/Foundation.h>


@interface TICConfig : NSObject

@property (strong, nonatomic) NSString *sdkAppId;     //app标识，可在实时音视频控制台(https://console.cloud.tencent.com/rav)创建自己的应用生成
@property (strong, nonatomic) NSString *userId;     //用户id标识（可由业务后台自己管理）
@property (strong, nonatomic) NSString *userSig;    //用于用户鉴权，生成方法https://cloud.tencent.com/document/product/647/17275 （可由业务后台自己管理）
@property (strong, nonatomic) NSString *role;     // //owner主持人/partner参会人
@property (assign, nonatomic) BOOL enableVideo; //能否视频
@property (assign, nonatomic) BOOL enableAudio; //能否音频

+ (TICConfig *)shareInstance;

@end
