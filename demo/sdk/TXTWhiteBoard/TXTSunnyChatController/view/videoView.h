//
//  videoView.h
//  TXTWhiteBoard
//
//  Created by 洪青文 on 2022/10/21.
//  Copyright © 2022 洪青文. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TXTUserModel.h"
#import "TICRenderView.h"

NS_ASSUME_NONNULL_BEGIN

@interface videoView : UIView
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) TXTUserModel *userModel;
@property (nonatomic, strong) UIView *nameBackgroundView;
- (void)initHideUIDirectionLeft:(BOOL)directionLeft;
- (void)showVideoViewDirectionLeft:(BOOL)directionLeft;
- (void)changeVoiceImage:(TRTCVolumeInfo *)info;
@end

NS_ASSUME_NONNULL_END
