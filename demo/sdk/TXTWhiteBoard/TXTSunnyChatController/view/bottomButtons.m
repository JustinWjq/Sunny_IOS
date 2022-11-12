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
        self.backgroundColor = [UIColor colorWithHexString:@"#424548"];
        [self setButtonUI];
    }
    return self;
}

- (void)setButtonUI{
    CGFloat btnwidth = Screen_Width/6;
    self.txVideoButton = [[UIButton alloc] init];
    [self addSubview:self.txVideoButton];
    [self.txVideoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(0);
        make.left.equalTo(self.mas_left).offset(0);
        make.width.mas_equalTo(btnwidth);
//        make.height.mas_equalTo(30);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-15);
    }];
    [self customButtonUI:self.txVideoButton ImageName:@"openCamera" ButtonName:@"摄像头"];
    [self.txVideoButton addTarget:self action:@selector(txButtonClick) forControlEvents:UIControlEventTouchDown];
//    [self.txVideoButton setBackgroundColor:[UIColor whiteColor]];
    
//    UILabel *label = [[UILabel alloc] init];
//    [self addSubview:label];
//    [label mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.txVideoButton.mas_bottom).offset(0);
////        make.bottom.mas_equalTo(self.mas_bottom).offset(0);
//        make.width.mas_equalTo(self.txVideoButton.frame.size.width);
//        make.centerY.mas_equalTo(self.txVideoButton.mas_centerY).offset(0);
//        make.height.mas_equalTo(30);
//    }];
//    label.font = [UIFont systemFontOfSize:12.0];
//    label.textAlignment = NSTextAlignmentCenter;
//    label.text = @"摄像头";
//    label.textColor = [UIColor whiteColor];
  

    self.txMuteButton = [[UIButton alloc] init];
    [self addSubview:self.txMuteButton];
    [self.txMuteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(0);
        make.left.mas_equalTo(self.mas_left).offset(btnwidth);
        make.width.mas_equalTo(btnwidth);
//        make.height.mas_equalTo(30);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-15);
    }];
    [self customButtonUI:self.txMuteButton ImageName:@"openMicrophone" ButtonName:@"麦克风"];
    [self.txMuteButton addTarget:self action:@selector(txMuteClick) forControlEvents:UIControlEventTouchDown];
    
    self.txShareFileButton = [[UIButton alloc] init];
    [self addSubview:self.txShareFileButton];
    [self.txShareFileButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(0);
        make.left.mas_equalTo(self.mas_left).offset(2*btnwidth);
        make.width.mas_equalTo(btnwidth);
//        make.height.mas_equalTo(30);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-15);
    }];
    [self customButtonUI:self.txShareFileButton ImageName:@"shareFiles" ButtonName:@"共享"];
    [self.txShareFileButton addTarget:self action:@selector(txShareFileButtonClick) forControlEvents:UIControlEventTouchDown];
    
    
    self.txMembersButton = [[UIButton alloc] init];
    [self addSubview:self.txMembersButton];
    [self.txMembersButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(0);
        make.left.mas_equalTo(self.mas_left).offset(3*btnwidth);
        make.width.mas_equalTo(btnwidth);
//        make.height.mas_equalTo(30);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-15);
    }];
    [self customButtonUI:self.txMembersButton ImageName:@"members" ButtonName:@"成员"];
    [self.txMembersButton addTarget:self action:@selector(txMembersButtonClick) forControlEvents:UIControlEventTouchDown];
    
    
    self.txShareSceneButton = [[UIButton alloc] init];
    [self addSubview:self.txShareSceneButton];
    [self.txShareSceneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(0);
        make.left.mas_equalTo(self.mas_left).offset(4*btnwidth);
        make.width.mas_equalTo(btnwidth);
//        make.height.mas_equalTo(30);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-15);
    }];
    [self customButtonUI:self.txShareSceneButton ImageName:@"startRecord" ButtonName:@"开始录制"];
    [self.txShareSceneButton addTarget:self action:@selector(txShareSceneButtonClick) forControlEvents:UIControlEventTouchDown];
    
    self.txMoreActionButton = [[UIButton alloc] init];
    [self addSubview:self.txMoreActionButton];
    [self.txMoreActionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(0);
        make.left.mas_equalTo(self.mas_left).offset(5*btnwidth);
        make.width.mas_equalTo(btnwidth);
//        make.height.mas_equalTo(30);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-15);
    }];
    [self customButtonUI:self.txMoreActionButton ImageName:@"moreButton" ButtonName:@"更多"];
    [self.txMoreActionButton addTarget:self action:@selector(txMoreActionButtonClick) forControlEvents:UIControlEventTouchDown];
    
}

- (void)updateButtons{
    CGFloat btnwidth = Screen_Width/6;
    [self.txVideoButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(0);
        make.left.equalTo(self.mas_left).offset(0);
        make.width.mas_equalTo(btnwidth);
//        make.height.mas_equalTo(30);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-15);
    }];
    [self.txMuteButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(0);
        make.left.mas_equalTo(self.mas_left).offset(btnwidth);
        make.width.mas_equalTo(btnwidth);
//        make.height.mas_equalTo(30);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-15);
    }];
    [self.txShareFileButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(0);
        make.left.mas_equalTo(self.mas_left).offset(2*btnwidth);
        make.width.mas_equalTo(btnwidth);
//        make.height.mas_equalTo(30);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-15);
    }];
    [self.txMembersButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(0);
        make.left.mas_equalTo(self.mas_left).offset(3*btnwidth);
        make.width.mas_equalTo(btnwidth);
//        make.height.mas_equalTo(30);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-15);
    }];
    [self.txShareSceneButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(0);
        make.left.mas_equalTo(self.mas_left).offset(4*btnwidth);
        make.width.mas_equalTo(btnwidth);
//        make.height.mas_equalTo(30);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-15);
    }];
    [self.txMoreActionButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(0);
        make.left.mas_equalTo(self.mas_left).offset(5*btnwidth);
        make.width.mas_equalTo(btnwidth);
//        make.height.mas_equalTo(30);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-15);
    }];
}

- (void)customButtonUI:(UIButton *)button  ImageName:(NSString *)imageName ButtonName:(NSString *)title{
    UIImage *btnImage = imageName(imageName);
    
    [button setImage:btnImage forState:UIControlStateNormal];
    button.imageView.contentMode = UIViewContentModeScaleAspectFit;
    NSLog(@"button = %@",button);
    
//    UILabel *label = [[UILabel alloc] init];
//    [self addSubview:label];
//    [label mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(button.mas_bottom).offset(0);
//        make.bottom.mas_equalTo(self.mas_bottom).offset(0);
//        make.width.mas_equalTo(button.frame.size.width);
//        make.centerY.mas_equalTo(button.mas_centerY).offset(0);
//        make.height.mas_equalTo(30);
//    }];
//    label.font = [UIFont systemFontOfSize:12.0];
//    label.textAlignment = NSTextAlignmentCenter;
//    label.text = title;
//    label.textColor = [UIColor whiteColor];
//
//    [button setTitle:title forState:UIControlStateNormal];
//    button.titleLabel.font = [UIFont systemFontOfSize:12.0];
//    CGSize imageSize = button.imageView.frame.size;
//    CGSize titleSize = button.titleLabel.intrinsicContentSize;
//    CGFloat margin = 10;
//    button.titleEdgeInsets = UIEdgeInsetsMake(0, -imageSize.width,  -imageSize.height - 5,  0);
//    button.imageEdgeInsets = UIEdgeInsetsMake( -titleSize.height - 5,  0,  0,  -titleSize.width);
    
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

- (void)txMoreActionButtonClick{
    if (self.delegate && [self.delegate respondsToSelector:@selector(bottomMoreActionButtonClick)]){
        [self.delegate bottomShareSceneButtonClick];
    }
}

- (void)changeVideoButtonStatus:(BOOL)open{
    if (open) {
        UIImage *btnImage = imageName(@"openCamera");
        [self.txVideoButton setImage:btnImage forState:UIControlStateNormal];
    }else{
        UIImage *btnImage = imageName(@"closeCamera");
        [self.txVideoButton setImage:btnImage forState:UIControlStateNormal];
    }
   
}

- (void)changeAudioButtonStatus:(BOOL)open{
    if (open) {
        UIImage *btnImage = imageName(@"openMicrophone");
        [self.txVideoButton setImage:btnImage forState:UIControlStateNormal];
    }else{
        UIImage *btnImage = imageName(@"closeMicrophone");
        [self.txVideoButton setImage:btnImage forState:UIControlStateNormal];
    }
}

- (void)changeShareSceneStatus:(BOOL)open{
    if (open) {
        //结束录制
        UIImage *btnImage = imageName(@"endRecord");
        [self.txVideoButton setImage:btnImage forState:UIControlStateNormal];
    }else{
        //开始录制
        UIImage *btnImage = imageName(@"startRecord");
        [self.txVideoButton setImage:btnImage forState:UIControlStateNormal];
    }
}


@end
