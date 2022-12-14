#import "TICConfig.h"

@implementation TICConfig
+ (TICConfig *)shareInstance
{
    static TICConfig *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[TICConfig alloc] init];
        [instance parseLoginInfoConfig];
    });
    return instance;
}

- (void)parseLoginInfoConfig
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"config" ofType:@"json"];
    if(![[NSFileManager defaultManager] fileExistsAtPath:filePath]){
        return;
    }
    NSData *json = [NSData dataWithContentsOfFile:filePath];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingAllowFragments error:nil];
    self.sdkAppId = dic[@"sdkappid"];
    self.userId = dic[@"userId"];
    self.userSig = dic[@"userToken"];
}

@end
