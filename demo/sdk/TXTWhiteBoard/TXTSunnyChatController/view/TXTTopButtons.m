//
//  TXTTopButtons.m
//  TXTWhiteBoard
//
//  Created by 洪青文 on 2022/11/21.
//  Copyright © 2022 洪青文. All rights reserved.
//

#import "TXTTopButtons.h"
#import "TXTManage.h"

@implementation TXTTopButtons

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
//        NSLog(@"bottomButtons");
        self.backgroundColor = [UIColor colorWithHexString:@"#424548"];
        [self setUI];
    }
    return self;
}

- (void)setUI{
    self.titleLabel = [[UILabel alloc] init];
    [self addSubview:self.titleLabel];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(240);
        make.center.mas_equalTo(self.center).offset(0);
    }];
    self.titleLabel.text = @"远程会议";
    if([TXTCustomConfig sharedInstance].isDebug) {
        self.titleLabel.text = [NSString stringWithFormat: @"远程会议-V%@", [TXTManage sharedInstance].releaseVersion];
    }
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.font = [UIFont systemFontOfSize:16];
    
    self.speakBtn = [[UIButton alloc] init];
    [self addSubview:self.speakBtn];
    [self.speakBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(30);
        make.left.mas_equalTo(self.mas_left).offset(10);
        make.width.mas_equalTo(30);
        make.centerY.mas_equalTo(self.centerY).offset(0);
    }];
    NSString *currentRoute = [self getCurrentAudioRoute];
    if ([currentRoute isEqualToString:@"扬声器"]) {
        [self.speakBtn setImage:imageName(@"speaker") forState:UIControlStateNormal];
    }else{
        [self.speakBtn setImage:imageName(@"receiver") forState:UIControlStateNormal];
    }
    
    self.speakBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.speakBtn addTarget:self action:@selector(txSpeakClick) forControlEvents:UIControlEventTouchDown];
    
    self.switchBtn = [[UIButton alloc] init];
    [self addSubview:self.switchBtn];
    [self.switchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(30);
        make.left.mas_equalTo(self.speakBtn.mas_right).offset(20);
        make.width.mas_equalTo(30);
        make.centerY.mas_equalTo(self.centerY).offset(0);
    }];
    [self.switchBtn setImage:imageName(@"camera") forState:UIControlStateNormal];
    self.switchBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.switchBtn addTarget:self action:@selector(txSwitchClick) forControlEvents:UIControlEventTouchDown];
    
    self.quitBtn = [UIButton buttonWithTitle:@"退出" titleColor:[UIColor colorWithHexString:@"#E19797"] font:[UIFont systemFontOfSize:12] target:self action:@selector(txQuitClick)];
    [self addSubview:self.quitBtn];
    [self.quitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(30);
        make.right.mas_equalTo(self.mas_right).offset(-15);
        make.width.mas_equalTo(44);
        make.centerY.mas_equalTo(self.centerY).offset(0);
    }];
    self.quitBtn.borderColor = [UIColor colorWithHexString:@"#E19797"];
    self.quitBtn.borderWidth = 1;
    self.quitBtn.cornerRadius = 5;
   
//    [self.switchBtn setImage:imageName(@"camera") forState:UIControlStateNormal];
//    self.switchBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
//    [self.switchBtn addTarget:self action:@selector(txSwitchClick) forControlEvents:UIControlEventTouchDown];
}

- (void)txSpeakClick{
    if (self.delegate && [self.delegate respondsToSelector:@selector(txSpeakBtnClick)]) {
        [self.delegate txSpeakBtnClick];
    }
}

- (void)txSwitchClick{
    if (self.delegate && [self.delegate respondsToSelector:@selector(txSwitchBtnClick)]) {
        [self.delegate txSwitchBtnClick];
    }
}

- (void)txQuitClick{
    if (self.delegate && [self.delegate respondsToSelector:@selector(txQuitBtnClick)]) {
        [self.delegate txQuitBtnClick];
    }
}

- (void)changeSpeakBtnStatus:(BOOL)status{
    if (status) {
        UIImage *speakerImg = [UIImage imageNamed:@"speaker" inBundle:TXSDKBundle compatibleWithTraitCollection:nil];
        [self.speakBtn setImage:[speakerImg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    }else{
        UIImage *speakerImg = [UIImage imageNamed:@"receiver" inBundle:TXSDKBundle compatibleWithTraitCollection:nil];
        [self.speakBtn setImage:[speakerImg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    }
}

- (NSString *)getCurrentAudioRoute{
    AVAudioSession* myAudioSession = [AVAudioSession sharedInstance];
    NSArray *currentOutputs = myAudioSession.currentRoute.outputs;
    NSString *str = nil;
    for( AVAudioSessionPortDescription *port in currentOutputs ){
        //扬声器-Speaker
        //李小龙的AirPods Pro - Find My-BluetoothA2DPOutput
        //耳机-Headphones
        str = [NSString stringWithFormat:@"%@", port.portName];
        NSLog(@"getCurrentAudioRoute = %@-%@", port.portName,port.portType);
     
    }
    return str;
}

@end
