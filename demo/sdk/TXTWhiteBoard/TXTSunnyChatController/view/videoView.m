//
//  videoView.m
//  TXTWhiteBoard
//
//  Created by 洪青文 on 2022/10/21.
//  Copyright © 2022 洪青文. All rights reserved.
//

#import "videoView.h"

@implementation videoView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initHideUI];
    }
    return self;
}

- (void)initHideUI{
    [self userNameView];
    UILabel *nameLabel = [[UILabel alloc] init];
    CGFloat nameWidth = self.frame.size.width-40;
    [self addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX).offset(0);
        make.centerY.mas_equalTo(self.mas_centerY).offset(0);
        make.width.mas_equalTo(nameWidth);
        make.height.mas_equalTo(nameWidth);
    }];
    nameLabel.layer.cornerRadius = nameWidth/2;
    nameLabel.layer.masksToBounds = YES;
    NSString *showNameStr = [self.userName substringFromIndex:self.userName.length-3];
    nameLabel.text = showNameStr;
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.backgroundColor = [UIColor orangeColor];
}

- (void)userNameView{
    UIView *nameBackgroundView = [[UIView alloc] init];
    [self addSubview:nameBackgroundView];
    [nameBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.mas_bottom).offset(0);
        make.left.mas_equalTo(self.mas_left).offset(0);
        make.right.mas_equalTo(self.mas_right).offset(0);
        make.height.mas_equalTo(50);
    }];
    nameBackgroundView.backgroundColor = [UIColor blackColor];
    
    NSString *userRole = TXUserDefaultsGetObjectforKey(Agent);
    //主持人
    if ([userRole isEqualToString:@""]) {
        UIImageView *iconImage = [[UIImageView alloc] init];
        [nameBackgroundView addSubview:iconImage];
        [iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(nameBackgroundView.mas_top).offset(0);
            make.bottom.mas_equalTo(nameBackgroundView.mas_bottom).offset(0);
            make.left.mas_equalTo(nameBackgroundView.mas_left).offset(0);
            make.width.mas_equalTo(50);
        }];
        iconImage.contentMode = UIViewContentModeScaleToFill;
        [iconImage sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:nil];
    }
    
    UIImageView *voiceImage = [[UIImageView alloc] init];
    [nameBackgroundView addSubview:voiceImage];
    [voiceImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(nameBackgroundView.mas_top).offset(0);
        make.bottom.mas_equalTo(nameBackgroundView.mas_bottom).offset(0);
        if ([userRole isEqualToString:@""]) {
            make.left.mas_equalTo(nameBackgroundView.mas_right).offset(70);
        }else{
            make.left.mas_equalTo(nameBackgroundView.mas_right).offset(20);
        }
        make.width.mas_equalTo(30);
    }];
    voiceImage.contentMode = UIViewContentModeScaleToFill;
    voiceImage.image = [UIImage imageNamed:@""];
    
    UILabel *allNameLabel = [[UILabel alloc] init];
    [nameBackgroundView addSubview:allNameLabel];
    [allNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(nameBackgroundView.mas_top).offset(0);
        make.bottom.mas_equalTo(nameBackgroundView.mas_bottom).offset(0);
        make.left.mas_equalTo(voiceImage.mas_right).offset(0);
        make.right.mas_equalTo(nameBackgroundView.mas_right).offset(0);
    }];
    allNameLabel.text = self.userName;
    allNameLabel.textAlignment = NSTextAlignmentCenter;
    allNameLabel.textColor = [UIColor whiteColor];
}

- (void)showVideoView{
    [self addSubview:self.userModel.render];
    [self.userModel.render mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(0);
        make.left.mas_equalTo(self.mas_left).offset(0);
        make.right.mas_equalTo(self.mas_right).offset(0);
        make.bottom.mas_equalTo(self.mas_bottom).offset(0);
    }];
    [[[TICManager sharedInstance] getTRTCCloud] setRemoteViewFillMode:self.userModel.render.userId mode:TRTCVideoFillMode_Fill];
    [[[TICManager sharedInstance] getTRTCCloud] startRemoteView:self.userModel.render.userId view:self.userModel.render];
//    [self userNameView];
}



@end
