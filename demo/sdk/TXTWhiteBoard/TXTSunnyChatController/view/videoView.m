//
//  videoView.m
//  TXTWhiteBoard
//
//  Created by 洪青文 on 2022/10/21.
//  Copyright © 2022 洪青文. All rights reserved.
//

#import "videoView.h"

#define nameWidth Screen_Width/7
@implementation videoView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
//        [self initHideUI];
//        self.backgroundColor = [UIColor whiteColor];
       
    }
    return self;
}

- (void)initHideUIDirectionLeft:(BOOL)directionLeft{
    [self userNameView:directionLeft];
    
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
    NSString *showNameStr = [self.userModel.userName substringFromIndex:self.userModel.userName.length-2];
    nameLabel.text = showNameStr;
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.backgroundColor = [UIColor colorWithHexString:@"#E6B980"];
    nameLabel.font = [UIFont systemFontOfSize:15];
}

- (void)userNameView:(BOOL)directionLeft{
    NSString *userRole = self.userModel.userRole;
    //主持人
    if ([userRole isEqualToString:@"owner"]) {
        UIImageView *iconImage = [[UIImageView alloc] init];
        [self addSubview:iconImage];
        [iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.mas_bottom).offset(0);
            make.left.mas_equalTo(self.mas_left).offset(0);
//            make.right.mas_equalTo(self.mas_right).offset(0);
            make.height.mas_equalTo(nameWidth/2.5);
            make.width.mas_equalTo(nameWidth/2.5);
        }];
        iconImage.contentMode = UIViewContentModeScaleAspectFit;
        [iconImage sd_setImageWithURL:[NSURL URLWithString:self.userModel.userIcon] placeholderImage:nil];
    }
    
    UIView *nameBackgroundView = [[UIView alloc] init];
    [self addSubview:nameBackgroundView];
    [nameBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.mas_bottom).offset(0);
        if ([userRole isEqualToString:@"owner"]) {
            make.left.mas_equalTo(self.mas_left).offset(nameWidth/2.5);
            if (directionLeft) {
                make.width.mas_equalTo(Screen_Width/5);
            }else{
                make.right.mas_equalTo(self.mas_right).offset(0);
            }
            
        }else{
            make.centerX.mas_equalTo(self.mas_centerX).offset(0);
            make.width.mas_equalTo(nameWidth+8);
        }
        
        make.height.mas_equalTo(nameWidth/2.5);
    }];
    nameBackgroundView.backgroundColor = [UIColor colorWithHexString:@"#000000"];
    nameBackgroundView.alpha = 0.7;
    
    UIImageView *voiceImage = [[UIImageView alloc] init];
    [nameBackgroundView addSubview:voiceImage];
    [voiceImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(nameBackgroundView.mas_top).offset(0);
        make.bottom.mas_equalTo(nameBackgroundView.mas_bottom).offset(0);
        make.left.mas_equalTo(nameBackgroundView.mas_left).offset(5);
        make.width.mas_equalTo(nameWidth/2/2);
    }];
    voiceImage.contentMode = UIViewContentModeScaleAspectFit;
    voiceImage.image = imageName(@"closeMicrophone_s");
    
    UILabel *allNameLabel = [[UILabel alloc] init];
    [nameBackgroundView addSubview:allNameLabel];
    [allNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(nameBackgroundView.mas_top).offset(0);
        make.bottom.mas_equalTo(nameBackgroundView.mas_bottom).offset(0);
        make.left.mas_equalTo(voiceImage.mas_right).offset(2);
        make.right.mas_equalTo(nameBackgroundView.mas_right).offset(0);
    }];
    allNameLabel.text = self.userModel.userName;
    allNameLabel.textAlignment = NSTextAlignmentLeft;
    allNameLabel.textColor = [UIColor whiteColor];
    allNameLabel.font = [UIFont systemFontOfSize:12];
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
    [self userNameView:YES];
}



@end
