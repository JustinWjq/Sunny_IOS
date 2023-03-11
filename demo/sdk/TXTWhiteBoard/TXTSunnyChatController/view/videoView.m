//
//  videoView.m
//  TXTWhiteBoard
//
//  Created by 洪青文 on 2022/10/21.
//  Copyright © 2022 洪青文. All rights reserved.
//

#import "videoView.h"

//Screen_Width/7
//Screen_Width > Screen_Height ? Screen_Width/12 : Screen_Width/7
#define nameWidth Adapt(55)
//#define nameWidth Screen_Width > Screen_Height ? Adapt(132) : Adapt(70)
@implementation videoView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
//        [self initHideUI];
//        self.backgroundColor = [UIColor whiteColor];
//        [self.userModel addObserver:self forKeyPath:@"userModel" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

- (void)initHideUIDirectionLeft:(BOOL)directionLeft{
    [self userNameView:directionLeft];
    
    if(self.userModel.userHead != nil && [self.userModel.userHead hasPrefix:@"https://"]) {
        UIImageView *iconImage = [[UIImageView alloc] init];
        [self addSubview:iconImage];
        [iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX).offset(0);
            make.top.mas_equalTo(self.mas_top).offset(10);
            make.width.mas_equalTo(nameWidth);
            make.height.mas_equalTo(nameWidth);
        }];
        iconImage.contentMode = UIViewContentModeScaleAspectFill;
        iconImage.layer.cornerRadius = nameWidth/2;
        iconImage.layer.masksToBounds = YES;
        [iconImage sd_setImageWithURL:[NSURL URLWithString:self.userModel.userHead] placeholderImage:nil];
    } else {
        UILabel *nameLabel = [[UILabel alloc] init];
        [self addSubview:nameLabel];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX).offset(0);
            make.top.mas_equalTo(self.mas_top).offset(10);
            make.width.mas_equalTo(nameWidth);
            make.height.mas_equalTo(nameWidth);
        }];
        nameLabel.layer.cornerRadius = nameWidth/2;
        nameLabel.layer.masksToBounds = YES;
        if (self.userModel.userName.length < 2) {
            nameLabel.text = self.userModel.userName;
        }else{
            NSString *showNameStr = [self.userModel.userName substringFromIndex:self.userModel.userName.length-2];
            nameLabel.text = showNameStr;
        }
        
        nameLabel.textColor = [UIColor whiteColor];
        nameLabel.textAlignment = NSTextAlignmentCenter;
        nameLabel.backgroundColor = [UIColor colorWithHexString:@"#E6B980"];
        nameLabel.font = [UIFont systemFontOfSize:15];
    }

}

- (void)userNameView:(BOOL)directionLeft{
    NSString *userRole = self.userModel.userRole;
    //主持人
    if ([userRole isEqualToString:@"owner"]) {
        UIImageView *iconImage = [[UIImageView alloc] init];
        [self addSubview:iconImage];
        [iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
            if (directionLeft) {
                make.bottom.mas_equalTo(self.mas_bottom).offset(0);
            }else{
                make.centerY.mas_equalTo(self.mas_centerY).offset(nameWidth/2+5);
            }
            make.left.mas_equalTo(self.mas_left).offset(0);
            make.height.mas_equalTo(nameWidth/2.5);
            make.width.mas_equalTo(nameWidth/2.5);
        }];
        iconImage.contentMode = UIViewContentModeScaleAspectFit;
        [iconImage sd_setImageWithURL:[NSURL URLWithString:self.userModel.userIcon] placeholderImage:nil];
    }
    
    self.nameBackgroundView = [[UIView alloc] init];
    [self addSubview:self.nameBackgroundView];
    [self.nameBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (directionLeft) {
            make.bottom.mas_equalTo(self.mas_bottom).offset(0);
        }else{
            make.centerY.mas_equalTo(self.mas_centerY).offset(nameWidth/2+5);
        }
        
        if ([userRole isEqualToString:@"owner"]) {
            make.left.mas_equalTo(self.mas_left).offset(nameWidth/2.5);
            if (directionLeft) {
//                make.width.mas_equalTo(nameWidth+10);
                make.right.mas_equalTo(self.mas_right).offset(0);
            }else{
                make.right.mas_equalTo(self.mas_right).offset(0);
            }
            
        }else{
            if (directionLeft) {
                make.left.mas_equalTo(self.mas_left).offset(0);
                make.right.mas_equalTo(self.mas_right).offset(0);
            }else{
                make.centerX.mas_equalTo(self.mas_centerX).offset(0);
                make.width.mas_equalTo(nameWidth+10);
            }
            
        }
        
        make.height.mas_equalTo(nameWidth/2.5);
    }];
    self.nameBackgroundView.backgroundColor = [UIColor colorWithHexString:@"#000000"];
    self.nameBackgroundView.alpha = 0.7;
    
    UIImageView *voiceImage = [[UIImageView alloc] init];
    [self.nameBackgroundView addSubview:voiceImage];
    [voiceImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nameBackgroundView.mas_top).offset(0);
        make.bottom.mas_equalTo(self.nameBackgroundView.mas_bottom).offset(0);
        make.left.mas_equalTo(self.nameBackgroundView.mas_left).offset(2);
        make.width.mas_equalTo(nameWidth/2/2);
    }];
    voiceImage.contentMode = UIViewContentModeScaleAspectFit;
    voiceImage.image = imageName(@"closeMicrophone_s");
    voiceImage.tag = 8089;
    
    UILabel *allNameLabel = [[UILabel alloc] init];
    [self.nameBackgroundView addSubview:allNameLabel];
    [allNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nameBackgroundView.mas_top).offset(0);
        make.bottom.mas_equalTo(self.nameBackgroundView.mas_bottom).offset(0);
        make.left.mas_equalTo(voiceImage.mas_right).offset(2);
        make.right.mas_equalTo(self.nameBackgroundView.mas_right).offset(0);
    }];
    allNameLabel.text = self.userModel.userName;
    allNameLabel.textAlignment = NSTextAlignmentLeft;
    allNameLabel.textColor = [UIColor whiteColor];
    allNameLabel.font = [UIFont systemFontOfSize:12];
}

- (void)showVideoViewDirectionLeft:(BOOL)directionLeft{
//    self = self.userModel.render;
    [self addSubview:self.userModel.render];
    [self.userModel.render mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(0);
        make.left.mas_equalTo(self.mas_left).offset(0);
        make.right.mas_equalTo(self.mas_right).offset(0);
        make.bottom.mas_equalTo(self.mas_bottom).offset(0);
    }];
    [[[TICManager sharedInstance] getTRTCCloud] setRemoteViewFillMode:self.userModel.render.userId mode:TRTCVideoFillMode_Fit];
    [[[TICManager sharedInstance] getTRTCCloud] startRemoteView:self.userModel.render.userId view:self.userModel.render];
    [self userNameView:directionLeft];
}


- (void)changeVoiceImage:(TRTCVolumeInfo *)info{
    for (__strong UIView *view in self.nameBackgroundView.subviews) {
        if (view.tag == 8089) {
            view = [self configWithMute:0 subView:(UIImageView *)view];
            if (self.userModel.showAudio) {
                view = [self configWithMute:info.volume subView:(UIImageView *)view];
            }else{
                UIImageView *imageview = (UIImageView *)view;
                imageview.image = [UIImage imageNamed:@"volumeno" inBundle:TXSDKBundle compatibleWithTraitCollection:nil];
            }
        }
    }
}

- (UIImageView *)configWithMute:(NSInteger)voice subView:(UIImageView *)imageview{
  
    NSInteger level = voice/20;
    switch (level) {
        case 0:
            imageview.image = [UIImage imageNamed:@"volume0" inBundle:TXSDKBundle compatibleWithTraitCollection:nil];
            break;
        case 1:
            imageview.image = [UIImage imageNamed:@"volume20" inBundle:TXSDKBundle compatibleWithTraitCollection:nil];
            break;
        case 2:
            imageview.image = [UIImage imageNamed:@"volume40" inBundle:TXSDKBundle compatibleWithTraitCollection:nil];
            break;
        case 3:
            imageview.image = [UIImage imageNamed:@"volume60" inBundle:TXSDKBundle compatibleWithTraitCollection:nil];
            break;
        case 4:
            imageview.image = [UIImage imageNamed:@"volume80.png" inBundle:TXSDKBundle compatibleWithTraitCollection:nil];
            break;
        case 5:
            imageview.image = [UIImage imageNamed:@"volume100.png" inBundle:TXSDKBundle compatibleWithTraitCollection:nil];
            break;
            
        default:
            imageview.image = [UIImage imageNamed:@"volumeno.png" inBundle:TXSDKBundle compatibleWithTraitCollection:nil];
            break;
    }
    return imageview;
    
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    NSLog(@"keyPath=%@,object=%@,change=%@,context=%@",keyPath,object,change,context);
}



@end
