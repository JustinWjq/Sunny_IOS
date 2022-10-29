//
//  bottomButtons.m
//  TXTWhiteBoard
//
//  Created by 洪青文 on 2022/10/24.
//  Copyright © 2022 洪青文. All rights reserved.
//

#import "bottomButtons.h"

@implementation bottomButtons

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
//        NSLog(@"bottomButtons");
        self.backgroundColor = [UIColor blackColor];
        [self setButtonUI];
    }
    return self;
}

- (void)setButtonUI{
    CGFloat btnwidth = Screen_Width/5;
    CGFloat btnheight = 90;
    self.txVideoButton = [[UIButton alloc] init];
    [self addSubview:self.txVideoButton];
    [self.txVideoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(0);
        make.left.equalTo(self.mas_left).offset(0);
        make.width.mas_equalTo(btnwidth);
        make.bottom.mas_equalTo(self.mas_bottom).offset(0);
    }];
    [self customButtonUI:self.txVideoButton ImageName:@"openCamera" ButtonName:@"摄像头"];
    [self.txVideoButton addTarget:self action:@selector(txButtonClick) forControlEvents:UIControlEventTouchDown];

    self.txMuteButton = [[UIButton alloc] init];
    [self addSubview:self.txMuteButton];
    [self.txMuteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(0);
        make.left.mas_equalTo(self.mas_left).offset(btnwidth);
        make.width.mas_equalTo(btnwidth);
        make.bottom.mas_equalTo(self.mas_bottom).offset(0);
    }];
    [self customButtonUI:self.txMuteButton ImageName:@"openMicrophone" ButtonName:@"麦克风"];
    [self.txMuteButton addTarget:self action:@selector(txMuteClick) forControlEvents:UIControlEventTouchDown];
    
    self.txShareFileButton = [[UIButton alloc] init];
    [self addSubview:self.txShareFileButton];
    [self.txShareFileButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(0);
        make.left.mas_equalTo(self.mas_left).offset(2*btnwidth);
        make.width.mas_equalTo(btnwidth);
        make.bottom.mas_equalTo(self.mas_bottom).offset(0);
    }];
    [self customButtonUI:self.txShareFileButton ImageName:@"shareFiles" ButtonName:@"共享"];
    [self.txShareFileButton addTarget:self action:@selector(txShareFileButtonClick) forControlEvents:UIControlEventTouchDown];
    
    
    self.txMembersButton = [[UIButton alloc] init];
    [self addSubview:self.txMembersButton];
    [self.txMembersButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(0);
        make.left.mas_equalTo(self.mas_left).offset(3*btnwidth);
        make.width.mas_equalTo(btnwidth);
        make.bottom.mas_equalTo(self.mas_bottom).offset(0);
    }];
    [self customButtonUI:self.txMembersButton ImageName:@"members" ButtonName:@"成员"];
    [self.txMembersButton addTarget:self action:@selector(txMembersButtonClick) forControlEvents:UIControlEventTouchDown];
    
    
    self.txShareSceneButton = [[UIButton alloc] init];
    [self addSubview:self.txShareSceneButton];
    [self.txShareSceneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(0);
        make.left.mas_equalTo(self.mas_left).offset(4*btnwidth);
        make.width.mas_equalTo(btnwidth);
        make.bottom.mas_equalTo(self.mas_bottom).offset(0);
    }];
    [self customButtonUI:self.txShareSceneButton ImageName:@"startRecord" ButtonName:@"开始录制"];
    [self.txShareSceneButton addTarget:self action:@selector(txShareSceneButtonClick) forControlEvents:UIControlEventTouchDown];
    
    
}

- (void)customButtonUI:(UIButton *)button  ImageName:(NSString *)imageName ButtonName:(NSString *)title{
    //    button.buttonStyle = image;
    UIImage *btnImage = imageName(imageName);
    button.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [button setImage:btnImage forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    
    button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    button.titleLabel.font = [UIFont systemFontOfSize:12.0];
    CGSize imageSize = button.imageView.frame.size;
    CGSize titleSize = button.titleLabel.frame.size;
    CGFloat margin = 10;
//    button.titleEdgeInsets = UIEdgeInsetsMake(0, -imageSize.width, -imageSize.height - 5, 0);
    button.titleEdgeInsets = UIEdgeInsetsMake(imageSize.height + margin/2, -imageSize.width, 0, 0);
    button.imageEdgeInsets = UIEdgeInsetsMake(-titleSize.height - margin/2 , 0, 0, -titleSize.width);
}

- (void)txButtonClick{
    if (self.delegate && [self.delegate respondsToSelector:@selector(bottomButtonClick)]){
        [self.delegate bottomButtonClick];
    }
}

- (void)txMuteClick{
    if (self.delegate && [self.delegate respondsToSelector:@selector(bottomMuteClick)]){
        [self.delegate bottomMuteClick];
    }
}

- (void)txShareFileButtonClick{
    if (self.delegate && [self.delegate respondsToSelector:@selector(bottomShareFileButtonClick)]){
        [self.delegate bottomShareFileButtonClick];
    }
}

- (void)txMembersButtonClick{
    if (self.delegate && [self.delegate respondsToSelector:@selector(bottomMembersButtonClick)]){
        [self.delegate bottomMembersButtonClick];
    }
}

- (void)txShareSceneButtonClick{
    if (self.delegate && [self.delegate respondsToSelector:@selector(bottomShareSceneButtonClick)]){
        [self.delegate bottomShareSceneButtonClick];
    }
}


@end
