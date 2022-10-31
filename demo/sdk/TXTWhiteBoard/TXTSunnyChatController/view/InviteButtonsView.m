//
//  InviteButtonsView.m
//  TICDemo
//
//  Created by 洪青文 on 2020/9/14.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import "InviteButtonsView.h"
#import "TXTDefine.h"

#define height self.frame.size.height
@implementation InviteButtonsView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
//        self.inviteNumber = @"0";
    }
    return self;
}

- (void)initUI{
    UILabel *inviteLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, Screen_Width, 20)];
//    inviteLabel1.text = [NSString stringWithFormat:@"最多只能邀请%@位客户进入会话,",TXUserDefaultsGetObjectforKey(MaxRoomUser)];
    [self addSubview:inviteLabel1];
    inviteLabel1.textAlignment = NSTextAlignmentCenter;
    inviteLabel1.textColor = COLOR_WITH_HEX(0x101010);
    NSMutableAttributedString *hintstring = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"会议中支持%@位成员同时在线,",TXUserDefaultsGetObjectforKey(MaxRoomUser)]];
    NSRange range =[[hintstring string] rangeOfString:TXUserDefaultsGetObjectforKey(MaxRoomUser)];
    [hintstring addAttribute:NSForegroundColorAttributeName value:COLOR_WITH_HEX(0xFF0000) range:range];
    inviteLabel1.attributedText = hintstring;
    
    UILabel *inviteLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 35, Screen_Width, 20)];
    inviteLabel2.text = @"超出数量后，后面成员将无法进入会话!";
    [self addSubview:inviteLabel2];
    inviteLabel2.textAlignment = NSTextAlignmentCenter;
    
    UIButton *weChatButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 55, Screen_Width/3, 100)];
    [weChatButton setImage:[UIImage imageNamed:@"wechat" inBundle:TXTSDKBundle compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
    [weChatButton addTarget:self action:@selector(chooseWeChat) forControlEvents:UIControlEventTouchDown];
    [self addSubview:weChatButton];
    
    UIButton *cloudUserButton = [[UIButton alloc] initWithFrame:CGRectMake(Screen_Width/3, 55, Screen_Width/3, 100)];
    [cloudUserButton setImage:[UIImage imageNamed:@"assistant" inBundle:TXTSDKBundle compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
    [cloudUserButton addTarget:self action:@selector(chooseCloudUser) forControlEvents:UIControlEventTouchDown];
    [self addSubview:cloudUserButton];
    
    UIButton *messageButton = [[UIButton alloc] initWithFrame:CGRectMake(Screen_Width/3*2, 55, Screen_Width/3, 100)];
    [messageButton setImage:[UIImage imageNamed:@"message" inBundle:TXTSDKBundle compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
    [messageButton addTarget:self action:@selector(chooseMessage) forControlEvents:UIControlEventTouchDown];
    [self addSubview:messageButton];
    
//    UILabel *lineLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 160, Screen_Width, 1)];
//    lineLab.backgroundColor = [UIColor lightGrayColor];
//    [self addSubview:lineLab];
    
    UIButton *cancleButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 160, Screen_Width, 50)];
    [cancleButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancleButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [cancleButton addTarget:self action:@selector(cancle) forControlEvents:UIControlEventTouchDown];
    [self addSubview:cancleButton];
    cancleButton.layer.borderWidth = 1.0;
    cancleButton.layer.borderColor = COLOR_WITH_HEX(0xCCCCCC).CGColor;
}

- (void)chooseWeChat{
    if (self.delegate &&[self.delegate respondsToSelector:@selector(chooseWeChat)]) {
        [self.delegate chooseWeChat];
    }
}

- (void)chooseCloudUser{
    if (self.delegate &&[self.delegate respondsToSelector:@selector(chooseCloudUser)]) {
        [self.delegate chooseCloudUser];
    }
}

- (void)chooseMessage{
    if (self.delegate &&[self.delegate respondsToSelector:@selector(chooseMessage)]) {
        [self.delegate chooseMessage];
    }
}

- (void)cancle{
    if (self.delegate &&[self.delegate respondsToSelector:@selector(cancle)]) {
        [self.delegate cancle];
    }
}
@end
