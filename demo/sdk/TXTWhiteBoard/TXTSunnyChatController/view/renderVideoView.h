//
//  renderVideoView.h
//  TXTWhiteBoard
//
//  Created by 洪青文 on 2022/11/3.
//  Copyright © 2022 洪青文. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TXTUserModel.h"
#import "TICRenderView.h"
#import "TXTVideoCollectionView.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, TRTCVideoRenderMode) {
    TRTCVideoRenderModeLandscape = 0,  ///< 横屏
    TRTCVideoRenderModePortrait  = 1,  ///< 竖屏
};

typedef NS_ENUM(NSInteger, TRTCVideoRenderNumber) {
    TRTCVideoRenderNumber1 = 0,  ///< 1个人
    TRTCVideoRenderNumber2 = 1,  ///< 2个人
    TRTCVideoRenderNumber3 = 2,  ///< 3个人
    TRTCVideoRenderNumber4 = 3,  ///< 4个人
    TRTCVideoRenderNumber5 = 4,  ///< 5个人
    TRTCVideoRenderNumber6 = 5,  ///< 6个人
};

@interface renderVideoView : UIView
@property (nonatomic, strong) NSArray *renderArray;
@property (strong, nonatomic) TXTVideoCollectionView *renderViewCollectionView;

- (void)setVideoRenderNumber:(TRTCVideoRenderNumber)number mode:(TRTCVideoRenderMode)mode;
@end

NS_ASSUME_NONNULL_END
