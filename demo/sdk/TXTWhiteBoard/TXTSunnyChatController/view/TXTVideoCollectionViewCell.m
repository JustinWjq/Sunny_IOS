//
//  TXTVideoCollectionViewCell.m
//  TICDemo
//
//  Created by 洪青文 on 2020/9/8.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import "TXTVideoCollectionViewCell.h"
#import "UIImageView+WebCache.h"

#define COLOR_WITH_HEX(hexValue) [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16)) / 255.0 green:((float)((hexValue & 0xFF00) >> 8)) / 255.0 blue:((float)(hexValue & 0xFF)) / 255.0 alpha:1.0f]


@implementation TXTVideoCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

//- (void)testCellWidth:(CGFloat)width Height:(CGFloat)height{
//    UIImageView *defaultImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
//    defaultImage.contentMode = UIViewContentModeScaleAspectFit;
//    //0x464950
//    self.backgroundColor = COLOR_WITH_HEX(0x464950);
//    [self addSubview:defaultImage];
//    defaultImage.image = [UIImage imageNamed:@"noVideo" inBundle:TXSDKBundle compatibleWithTraitCollection:nil];
//}

- (void)configVideoCell:(TXTUserModel *)model Width:(CGFloat)width Height:(CGFloat)height VoiceVolume:(NSArray<TRTCVolumeInfo *> *)userVolumes{
    [self setcell:model Width:width Height:height VoiceVolume:userVolumes];
}

- (void)setcell:(TXTUserModel *)model Width:(CGFloat)width Height:(CGFloat)height VoiceVolume:(NSArray<TRTCVolumeInfo *> *)userVolumes{
//    for (UIView *view in [self.videoView subviews]) {
//        [view removeFromSuperview];
//    }
    NSLog(@"setcell");
    TICRenderView *render = model.render;
    if (model.showVideo) {
        render.frame = CGRectMake(0, 0, width, height);
        [self addSubview:render];
        [[[TICManager sharedInstance] getTRTCCloud] startRemoteView:render.userId view:render];
        [[[TICManager sharedInstance] getTRTCCloud] setRemoteViewFillMode:render.userId mode:TRTCVideoFillMode_Fill];
    }else{
        self.backgroundColor = COLOR_WITH_HEX(0x464950);
        UIImageView *defaultImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        defaultImage.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:defaultImage];
//        [[[TICManager sharedInstance] getTRTCCloud] stopRemoteView:render.userId];
        //videoing@2x.png
        if (model.useShare) {
            [[[TICManager sharedInstance] getTRTCCloud] startRemoteView:render.userId view:render];
            [[[TICManager sharedInstance] getTRTCCloud] setRemoteViewFillMode:render.userId mode:TRTCVideoFillMode_Fill];
            defaultImage.image = [UIImage imageNamed:@"videoing" inBundle:TXSDKBundle compatibleWithTraitCollection:nil];
        }else{
            [[[TICManager sharedInstance] getTRTCCloud] stopRemoteView:render.userId];
            defaultImage.image = [UIImage imageNamed:@"noVideo" inBundle:TXSDKBundle compatibleWithTraitCollection:nil];
        }
    }
    
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, height-20, width, 20)];
    bgView.backgroundColor = [UIColor blackColor];
    bgView.alpha = 0.6;
    //    txViewRadius(bgView, 20/2);
    [self addSubview:bgView];
    
    //[self.fileImage sd_setImageWithURL:[NSURL URLWithString:[dict valueForKey:@"url"]] placeholderImage:[UIImage imageNamed:@"default" inBundle:SDKBundle compatibleWithTraitCollection:nil]];
    if ([model.userRole isEqualToString:@"owner"] || [model.userRole isEqualToString:@"assistant"]) {
        UIImageView *ownerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, height-20, 10, 20)];
        ownerImageView.contentMode = UIViewContentModeScaleAspectFit;
        [ownerImageView sd_setImageWithURL:[NSURL URLWithString:model.userIcon] placeholderImage:nil];
//        ownerImageView.image = [UIImage imageNamed:@"ownerHeader@2x.png" inBundle:TXSDKBundle compatibleWithTraitCollection:nil];
        [self addSubview:ownerImageView];
    }
    
    //CGRectMake(25, height-25, width-25, 20)
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, height-20, width-25, 20)];
//    if ([model.userRole isEqualToString:@"owner"]) {
//        nameLabel.text = @"业务员";
//    }else{
//        nameLabel.text = model.userName;
//    }
    nameLabel.text = model.userName;
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.font = [UIFont systemFontOfSize:13.0];
    [self addSubview:nameLabel];
    
    UIImageView *muteImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, height-20, 10, 20)];
   
    muteImageView.image = [UIImage imageNamed:@"mute_0@2x.png" inBundle:TXSDKBundle compatibleWithTraitCollection:nil];
    muteImageView.contentMode = UIViewContentModeScaleAspectFit;
    muteImageView.tag = 1234;
    [self addSubview:muteImageView];
    if (model.showAudio) {
//        NSLog(@"2222222222222");
        for (TRTCVolumeInfo *info in userVolumes) {
            NSLog(@"=======++++++++++++++====%@==%@",info.userId,render.userId);
            if ([info.userId isEqualToString:render.userId]) {
                NSLog(@"进入%@-%d",info.userId,info.volume);
                NSInteger level = info.volume/20;
                switch (level) {
                    case 0:
                        muteImageView.image = [UIImage imageNamed:@"mute_0@2x.png" inBundle:TXSDKBundle compatibleWithTraitCollection:nil];
                        break;
                    case 1:
                        muteImageView.image = [UIImage imageNamed:@"mute_20@2x.png" inBundle:TXSDKBundle compatibleWithTraitCollection:nil];
                        break;
                    case 2:
                        muteImageView.image = [UIImage imageNamed:@"mute_40@2x.png" inBundle:TXSDKBundle compatibleWithTraitCollection:nil];
                        break;
                    case 3:
                        muteImageView.image = [UIImage imageNamed:@"mute_60@2x.png" inBundle:TXSDKBundle compatibleWithTraitCollection:nil];
                        break;
                    case 4:
                        muteImageView.image = [UIImage imageNamed:@"mute_80@2x.png" inBundle:TXSDKBundle compatibleWithTraitCollection:nil];
                        break;
                    case 5:
                        muteImageView.image = [UIImage imageNamed:@"mute_100@2x.png" inBundle:TXSDKBundle compatibleWithTraitCollection:nil];
                        break;
                        
                    default:
                        muteImageView.image = [UIImage imageNamed:@"mute_0@2x.png" inBundle:TXSDKBundle compatibleWithTraitCollection:nil];
                        break;
                }
            }else{
                if (info.userId == nil && [model.userRole isEqualToString:@"owner"]) {
                    NSLog(@"进入%@-%d",info.userId,info.volume);
                    NSInteger level = info.volume/20;
                    switch (level) {
                        case 0:
                            muteImageView.image = [UIImage imageNamed:@"mute_0@2x.png" inBundle:TXSDKBundle compatibleWithTraitCollection:nil];
                            break;
                        case 1:
                            muteImageView.image = [UIImage imageNamed:@"mute_20@2x.png" inBundle:TXSDKBundle compatibleWithTraitCollection:nil];
                            break;
                        case 2:
                            muteImageView.image = [UIImage imageNamed:@"mute_40@2x.png" inBundle:TXSDKBundle compatibleWithTraitCollection:nil];
                            break;
                        case 3:
                            muteImageView.image = [UIImage imageNamed:@"mute_60@2x.png" inBundle:TXSDKBundle compatibleWithTraitCollection:nil];
                            break;
                        case 4:
                            muteImageView.image = [UIImage imageNamed:@"mute_80@2x.png" inBundle:TXSDKBundle compatibleWithTraitCollection:nil];
                            break;
                        case 5:
                            muteImageView.image = [UIImage imageNamed:@"mute_100@2x.png" inBundle:TXSDKBundle compatibleWithTraitCollection:nil];
                            break;
                            
                        default:
                            muteImageView.image = [UIImage imageNamed:@"mute_0@2x.png" inBundle:TXSDKBundle compatibleWithTraitCollection:nil];
                            break;
                    }
                }else{
                    
                }
            }
            
        }
        
    }else{
//        NSLog(@"==================%@",render.userId);
        muteImageView.image = [UIImage imageNamed:@"mute_no@2x.png" inBundle:TXSDKBundle compatibleWithTraitCollection:nil];
    }
    [CATransaction commit];
}

- (UIImageView *)configWithMute:(NSInteger)voice subView:(UIImageView *)imageview{
  
    NSInteger level = voice/20;
    switch (level) {
        case 0:
            imageview.image = [UIImage imageNamed:@"mute_0@2x.png" inBundle:TXSDKBundle compatibleWithTraitCollection:nil];
            break;
        case 1:
            imageview.image = [UIImage imageNamed:@"mute_20@2x.png" inBundle:TXSDKBundle compatibleWithTraitCollection:nil];
            break;
        case 2:
            imageview.image = [UIImage imageNamed:@"mute_40@2x.png" inBundle:TXSDKBundle compatibleWithTraitCollection:nil];
            break;
        case 3:
            imageview.image = [UIImage imageNamed:@"mute_60@2x.png" inBundle:TXSDKBundle compatibleWithTraitCollection:nil];
            break;
        case 4:
            imageview.image = [UIImage imageNamed:@"mute_80@2x.png" inBundle:TXSDKBundle compatibleWithTraitCollection:nil];
            break;
        case 5:
            imageview.image = [UIImage imageNamed:@"mute_100@2x.png" inBundle:TXSDKBundle compatibleWithTraitCollection:nil];
            break;
            
        default:
            imageview.image = [UIImage imageNamed:@"mute_no@2x.png" inBundle:TXSDKBundle compatibleWithTraitCollection:nil];
            break;
    }
    return imageview;
    
}

- (void)reloadAudio:(TRTCVolumeInfo *)info Model:(TXTUserModel *)model{
    for (__strong UIView *view in [self subviews]) {
        if (view.tag == 1234) {
            if ([info.userId isEqualToString:model.render.userId] ) {
//                view = [self configWithMute:info.volume subView:(UIImageView *)view];
                if (model.showAudio) {
                    view = [self configWithMute:info.volume subView:(UIImageView *)view];
                }else{
//                    NSLog(@"+++++++++++++++++++1");
                    UIImageView *imageview = (UIImageView *)view;
                    imageview.image = [UIImage imageNamed:@"mute_no@2x.png" inBundle:TXSDKBundle compatibleWithTraitCollection:nil];
                }
            }else{
                if(info.userId == nil && [model.userRole isEqualToString:@"owner"]){
//                    view = [self configWithMute:info.volume subView:(UIImageView *)view];
                    if (model.showAudio) {
                        view = [self configWithMute:info.volume subView:(UIImageView *)view];
                    }else{
//                        NSLog(@"+++++++++++++++++++2");
                       
                        UIImageView *imageview = (UIImageView *)view;
                        imageview.image = [UIImage imageNamed:@"mute_no@2x.png" inBundle:TXSDKBundle compatibleWithTraitCollection:nil];
                    }
                }
                
            }
            
        }
    }
}

@end
