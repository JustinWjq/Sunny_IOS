//
//  TXTVideoCollectionViewCell.h
//  TICDemo
//
//  Created by 洪青文 on 2020/9/8.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TICRenderView.h"
#import "TICManager.h"
#import "TXTUserModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TXTVideoCollectionViewCell : UICollectionViewCell
- (void)configVideoCell:(TXTUserModel *)model Width:(CGFloat)width Height:(CGFloat)height VoiceVolume:(NSArray<TRTCVolumeInfo *> *)userVolumes;
- (void)reloadAudio:(TRTCVolumeInfo *)info Model:(TXTUserModel *)model;
- (void)testCellWidth:(CGFloat)width Height:(CGFloat)height;
//@property (weak, nonatomic) IBOutlet UIView *videoView;
@end

NS_ASSUME_NONNULL_END
