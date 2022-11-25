//
//  TXTVideoCollectionViewCell.m
//  TICDemo
//
//  Created by 洪青文 on 2020/9/8.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import "TXTVideoCollectionViewCell.h"
#import "UIImageView+WebCache.h"
#import "videoView.h"

#define COLOR_WITH_HEX(hexValue) [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16)) / 255.0 green:((float)((hexValue & 0xFF00) >> 8)) / 255.0 blue:((float)(hexValue & 0xFF)) / 255.0 alpha:1.0f]


@implementation TXTVideoCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]){
//        [self setUI];
    }
    return self;
}

- (void)setUI{
    self.backgroundColor = COLOR_WITH_HEX(0x464950);
    UIImageView *defaultImage = [[UIImageView alloc] initWithFrame:self.frame];
    defaultImage.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:defaultImage];
    defaultImage.image = [UIImage imageNamed:@"noVideo" inBundle:TXSDKBundle compatibleWithTraitCollection:nil];
}

- (void)configVideoCell:(TXTUserModel *)model Width:(CGFloat)width Height:(CGFloat)height VoiceVolume:(NSArray<TRTCVolumeInfo *> *)userVolumes{
    [self setcell:model Width:width Height:height VoiceVolume:userVolumes];
}

- (void)setcell:(TXTUserModel *)model Width:(CGFloat)width Height:(CGFloat)height VoiceVolume:(NSArray<TRTCVolumeInfo *> *)userVolumes{
//    for (UIView *view in [self.videoView subviews]) {
//        [view removeFromSuperview];
//    }
    NSLog(@"setcell");
    videoView *videoview = [[videoView alloc] init];
    [self addSubview:videoview];
    [videoview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(0);
        make.left.mas_equalTo(self.mas_left).offset(0);
        make.right.mas_equalTo(self.mas_right).offset(0);
        make.bottom.mas_equalTo(self.mas_bottom).offset(0);
    }];
    videoview.userModel = model;
    if (model.showVideo) {
        [videoview showVideoViewDirectionLeft:NO];
    }else{
        [videoview initHideUIDirectionLeft:NO];
    }
    
//    UIImageView *muteImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, height-20, 10, 20)];
//
//    muteImageView.image = [UIImage imageNamed:@"mute_0@2x.png" inBundle:TXSDKBundle compatibleWithTraitCollection:nil];
//    muteImageView.contentMode = UIViewContentModeScaleAspectFit;
//    muteImageView.tag = 1234;
//    [self addSubview:muteImageView];
//    if (model.showAudio) {
////        NSLog(@"2222222222222");
//        for (TRTCVolumeInfo *info in userVolumes) {
//            NSLog(@"=======++++++++++++++====%@==%@",info.userId,render.userId);
//            if ([info.userId isEqualToString:render.userId]) {
//                NSLog(@"进入%@-%d",info.userId,info.volume);
//                NSInteger level = info.volume/20;
//                switch (level) {
//                    case 0:
//                        muteImageView.image = [UIImage imageNamed:@"mute_0@2x.png" inBundle:TXSDKBundle compatibleWithTraitCollection:nil];
//                        break;
//                    case 1:
//                        muteImageView.image = [UIImage imageNamed:@"mute_20@2x.png" inBundle:TXSDKBundle compatibleWithTraitCollection:nil];
//                        break;
//                    case 2:
//                        muteImageView.image = [UIImage imageNamed:@"mute_40@2x.png" inBundle:TXSDKBundle compatibleWithTraitCollection:nil];
//                        break;
//                    case 3:
//                        muteImageView.image = [UIImage imageNamed:@"mute_60@2x.png" inBundle:TXSDKBundle compatibleWithTraitCollection:nil];
//                        break;
//                    case 4:
//                        muteImageView.image = [UIImage imageNamed:@"mute_80@2x.png" inBundle:TXSDKBundle compatibleWithTraitCollection:nil];
//                        break;
//                    case 5:
//                        muteImageView.image = [UIImage imageNamed:@"mute_100@2x.png" inBundle:TXSDKBundle compatibleWithTraitCollection:nil];
//                        break;
//
//                    default:
//                        muteImageView.image = [UIImage imageNamed:@"mute_0@2x.png" inBundle:TXSDKBundle compatibleWithTraitCollection:nil];
//                        break;
//                }
//            }else{
//                if (info.userId == nil && [model.userRole isEqualToString:@"owner"]) {
//                    NSLog(@"进入%@-%d",info.userId,info.volume);
//                    NSInteger level = info.volume/20;
//                    switch (level) {
//                        case 0:
//                            muteImageView.image = [UIImage imageNamed:@"mute_0@2x.png" inBundle:TXSDKBundle compatibleWithTraitCollection:nil];
//                            break;
//                        case 1:
//                            muteImageView.image = [UIImage imageNamed:@"mute_20@2x.png" inBundle:TXSDKBundle compatibleWithTraitCollection:nil];
//                            break;
//                        case 2:
//                            muteImageView.image = [UIImage imageNamed:@"mute_40@2x.png" inBundle:TXSDKBundle compatibleWithTraitCollection:nil];
//                            break;
//                        case 3:
//                            muteImageView.image = [UIImage imageNamed:@"mute_60@2x.png" inBundle:TXSDKBundle compatibleWithTraitCollection:nil];
//                            break;
//                        case 4:
//                            muteImageView.image = [UIImage imageNamed:@"mute_80@2x.png" inBundle:TXSDKBundle compatibleWithTraitCollection:nil];
//                            break;
//                        case 5:
//                            muteImageView.image = [UIImage imageNamed:@"mute_100@2x.png" inBundle:TXSDKBundle compatibleWithTraitCollection:nil];
//                            break;
//
//                        default:
//                            muteImageView.image = [UIImage imageNamed:@"mute_0@2x.png" inBundle:TXSDKBundle compatibleWithTraitCollection:nil];
//                            break;
//                    }
//                }else{
//
//                }
//            }
//
//        }
//
//    }else{
////        NSLog(@"==================%@",render.userId);
//        muteImageView.image = [UIImage imageNamed:@"mute_no@2x.png" inBundle:TXSDKBundle compatibleWithTraitCollection:nil];
//    }
    [CATransaction commit];
}

//- (UIImageView *)configWithMute:(NSInteger)voice subView:(UIImageView *)imageview{
//
//    NSInteger level = voice/20;
//    switch (level) {
//        case 0:
//            imageview.image = [UIImage imageNamed:@"mute_0@2x.png" inBundle:TXSDKBundle compatibleWithTraitCollection:nil];
//            break;
//        case 1:
//            imageview.image = [UIImage imageNamed:@"mute_20@2x.png" inBundle:TXSDKBundle compatibleWithTraitCollection:nil];
//            break;
//        case 2:
//            imageview.image = [UIImage imageNamed:@"mute_40@2x.png" inBundle:TXSDKBundle compatibleWithTraitCollection:nil];
//            break;
//        case 3:
//            imageview.image = [UIImage imageNamed:@"mute_60@2x.png" inBundle:TXSDKBundle compatibleWithTraitCollection:nil];
//            break;
//        case 4:
//            imageview.image = [UIImage imageNamed:@"mute_80@2x.png" inBundle:TXSDKBundle compatibleWithTraitCollection:nil];
//            break;
//        case 5:
//            imageview.image = [UIImage imageNamed:@"mute_100@2x.png" inBundle:TXSDKBundle compatibleWithTraitCollection:nil];
//            break;
//
//        default:
//            imageview.image = [UIImage imageNamed:@"mute_no@2x.png" inBundle:TXSDKBundle compatibleWithTraitCollection:nil];
//            break;
//    }
//    return imageview;
//
//}

- (void)reloadAudio:(TRTCVolumeInfo *)info Model:(TXTUserModel *)model{
    for (UIView *svideoView in self.subviews) {
        if ([svideoView isKindOfClass:[videoView class]]) {
            videoView *nsvideoView = (videoView *)svideoView;
            if ([nsvideoView.userModel.render.userId isEqualToString:model.render.userId]) {
                nsvideoView.userModel = model;
                [nsvideoView changeVoiceImage:info];
            }
            
        }
    }
}

- (void)reloadVideo:(TXTUserModel *)model{
    for (UIView *svideoView in self.subviews) {
        if ([svideoView isKindOfClass:[videoView class]]) {
            videoView *nsvideoView = (videoView *)svideoView;
            if ([nsvideoView.userModel.render.userId isEqualToString:model.render.userId]) {
                for (UIView *view in nsvideoView.subviews) {
                    [view removeFromSuperview];
                }
                [nsvideoView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(self.mas_top).offset(0);
                    make.left.mas_equalTo(self.mas_left).offset(0);
                    make.right.mas_equalTo(self.mas_right).offset(0);
                    make.bottom.mas_equalTo(self.mas_bottom).offset(0);
                }];
                nsvideoView.userModel = model;
                if (model.showVideo) {
                    [nsvideoView showVideoViewDirectionLeft:YES];
                }else{
                    [nsvideoView initHideUIDirectionLeft:NO];
                }
            }
            
        }
    }
}

@end
