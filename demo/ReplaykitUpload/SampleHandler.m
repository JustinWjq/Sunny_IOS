//
//  SampleHandler.m
//  ReplaykitUpload
//
//  Created by 洪青文 on 2020/9/22.
//  Copyright © 2020 Tencent. All rights reserved.
//


#import "SampleHandler.h"
@import TXLiteAVSDK_ReplayKitExt;

#define APPGROUP @"group.com.tx.txWhiteBoard.ReplaykitUpload"

@interface SampleHandler() <TXReplayKitExtDelegate>
@end

@implementation SampleHandler
// 注意：此处的 APPGROUP 需要改成上文中的创建的 App Group Identifier。
- (void)broadcastStartedWithSetupInfo:(NSDictionary<NSString *,NSObject *> *)setupInfo {
    [[TXReplayKitExt sharedInstance] setupWithAppGroup:APPGROUP delegate:self];
}

- (void)broadcastPaused {
    NSLog(@"broadcastPaused");
    // User has requested to pause the broadcast. Samples will stop being delivered.
}

- (void)broadcastResumed {
    NSLog(@"broadcastResumed");
    // User has requested to resume the broadcast. Samples delivery will resume.
}

- (void)broadcastFinished {
    NSLog(@"broadcastFinished");
    [[TXReplayKitExt sharedInstance] finishBroadcast];
    // User has requested to finish the broadcast.
}


// 接收通知
- (void)receiveNotification {
        CFNotificationCenterRef notification = CFNotificationCenterGetDarwinNotifyCenter ();
        CFNotificationCenterAddObserver(notification, (__bridge const void *)(self), observerMethod,CFSTR("endShare"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
}

void observerMethod (CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo)
{
    // Your custom work
    [[TXReplayKitExt sharedInstance] finishBroadcast];
}
#pragma mark - TXReplayKitExtDelegate
- (void)boradcastFinished:(TXReplayKitExt *)broadcast reason:(TXReplayKitExtReason)reason
{
    NSString *tip = @"";
    switch (reason) {
        case TXReplayKitExtReasonRequestedByMain:
            tip = @"屏幕共享已结束";
            break;
        case TXReplayKitExtReasonDisconnected:
            tip = @"应用断开";
            break;
        case TXReplayKitExtReasonVersionMismatch:
            tip = @"集成错误（SDK 版本号不相符合）";
            break;
    }

    NSError *error = [NSError errorWithDomain:NSStringFromClass(self.class)
                                         code:0
                                     userInfo:@{
                                         NSLocalizedFailureReasonErrorKey:tip
                                     }];
    [self finishBroadcastWithError:error];
}

- (void)processSampleBuffer:(CMSampleBufferRef)sampleBuffer withType:(RPSampleBufferType)sampleBufferType {
    switch (sampleBufferType) {
        case RPSampleBufferTypeVideo:
            [[TXReplayKitExt sharedInstance] sendVideoSampleBuffer:sampleBuffer];
            break;
        case RPSampleBufferTypeAudioApp:
            // Handle audio sample buffer for app audio
            break;
        case RPSampleBufferTypeAudioMic:
            // Handle audio sample buffer for mic audio
            break;

        default:
            break;
    }
}
@end
