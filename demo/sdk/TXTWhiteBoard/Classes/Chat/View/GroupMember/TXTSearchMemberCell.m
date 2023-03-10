//
//  TXTSearchMemberCell.m
//  TXTWhiteBoard
//
//  Created by jiangyongjian on 2022/11/5.
//  Copyright © 2022 洪青文. All rights reserved.
//

#import "TXTSearchMemberCell.h"

@interface TXTSearchMemberCell ()
/** icon */
@property (nonatomic, strong) UIImageView *icon;
/** iconLabel */
@property (nonatomic, strong) UILabel *iconLabel;
/** nameLabel */
@property (nonatomic, strong) UILabel *nameLabel;
/** voiceBtn */
@property (nonatomic, strong) UIButton *voiceBtn;
/** videoBtn */
@property (nonatomic, strong) UIButton *videoBtn;
@end

@implementation TXTSearchMemberCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    // 创建cell
    static NSString *ID = @"TXTSearchMemberCell";
    TXTSearchMemberCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[TXTSearchMemberCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    [self.contentView addSubview:self.icon];
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(13);
        make.width.height.mas_equalTo(30);
        make.centerY.equalTo(self.contentView);
    }];
    self.icon.layer.cornerRadius = 30 / 2;
    self.icon.clipsToBounds = YES;
//    self.icon.layer.masksToBounds = NO;
    [self.icon addSubview:self.iconLabel];
    [self.iconLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.icon);
    }];
    
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.icon.mas_right).offset(10);
        make.centerY.equalTo(self.icon);
        make.right.equalTo(self.contentView.mas_right).offset(-90);
    }];
    
    [self.contentView addSubview:self.videoBtn];
    [self.videoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-20);
        make.width.height.mas_equalTo(25);
        make.centerY.equalTo(self.icon);
    }];
    [self.contentView addSubview:self.voiceBtn];
    [self.voiceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.videoBtn.mas_left).offset(-15);
        make.width.height.mas_equalTo(25);
        make.centerY.equalTo(self.icon);
    }];
}

- (void)setModel:(TXTUserModel *)model {
    _model = model;
    
    NSString *oregionUserName = model.userName;
    
    self.nameLabel.text = oregionUserName;
    
//    if (self.nameLabel.text.length > 10) {
//        oregionUserName = [NSString stringWithFormat:@"%@...", [NSString stringWithFormat:@"%@...", [NSString subStringWithEmoji:self.nameLabel.text limitLength:10]]];
//    }
    
//    if (self.keyWord) {
//        NSRange range = [userName rangeOfString:self.keyWord];
//        NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:[model.userRole isEqualToString:@"owner"] ? [NSString stringWithFormat:@"%@（主持人、我）", model.userName] : model.userName];
//        [attribute addAttribute:NSFontAttributeName value:[UIFont qs_regularFontWithSize:15] range:range];
//        [attribute addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"E6B980"] range:range];
//        self.nameLabel.attributedText = attribute;
//    } else {
        self.nameLabel.text = [model.userRole isEqualToString:@"owner"] ? [NSString stringWithFormat:@"%@（主持人、我）", oregionUserName] : oregionUserName;
//    }

    
//    [self.icon sd_setImageWithURL:[NSURL URLWithString:model.userIcon] placeholderImage:[UIImage imageNamed:@"HeadPortrait_s" inBundle:TXTSDKBundle compatibleWithTraitCollection:nil] completed:nil];
    
    NSString *userName = model.userName;
    self.iconLabel.text = userName;
    if (self.iconLabel.text.length >= 2) {
//        self.iconLabel.text = [self.iconLabel.text substringFromIndex:self.iconLabel.text.length - 2];
        self.iconLabel.text = [NSString subStrWithStr:userName fromIndex:userName.length - 2];
    }
    self.videoBtn.selected = model.showVideo;
    self.voiceBtn.selected = model.showAudio;
}

/// voiceBtnClick
- (void)voiceBtnClick {
    if ([self.delegate respondsToSelector:@selector(searchMemberCell:didClickVoiceBtn:)]) {
        [self.delegate searchMemberCell:self didClickVoiceBtn:self.voiceBtn];
    }
}

/// videoBtnClick
- (void)videoBtnClick {
    if ([self.delegate respondsToSelector:@selector(searchMemberCell:didClickVideoBtn:)]) {
        [self.delegate searchMemberCell:self didClickVideoBtn:self.videoBtn];
    }
}

/** icon */
- (UIImageView *)icon {
    if (!_icon) {
        UIImageView *icon = [[UIImageView alloc] init];
//        icon.image = [UIImage imageNamed:@"" inBundle:TXTSDKBundle compatibleWithTraitCollection:nil];
        icon.backgroundColor = [UIColor colorWithHexString:@"E6B980"];
        self.icon = icon;
    }
    return _icon;
}
- (UILabel *)iconLabel {
    if (!_iconLabel) {
        UILabel *iconLabel = [UILabel labelWithTitle:@"" color:[UIColor colorWithHexString:@"FFFFFF"] font:[UIFont qs_regularFontWithSize:10]];
        self.iconLabel = iconLabel;
    }
    return _iconLabel;
}
/** nameLabel */
- (UILabel *)nameLabel {
    if (!_nameLabel) {
        UILabel *nameLabel = [UILabel labelWithTitle:@"" color:[UIColor colorWithHexString:@"333333"] font:[UIFont qs_regularFontWithSize:15]];
        
        nameLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
        nameLabel.textAlignment = NSTextAlignmentLeft;
        nameLabel.numberOfLines = 1;
        
        self.nameLabel = nameLabel;
    }
    return _nameLabel;
}
/** voiceBtn */
- (UIButton *)voiceBtn {
    if (!_voiceBtn) {
        UIButton *voiceBtn = [UIButton buttonWithTitle:@"" titleColor:[UIColor colorWithHexString:@"D70110"] font:[UIFont qs_regularFontWithSize:15] target:self action:@selector(voiceBtnClick)];
        [voiceBtn setImage:[UIImage imageNamed:@"member_icon_voiceClose" inBundle:TXTSDKBundle compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
        [voiceBtn setImage:[UIImage imageNamed:@"member_icon_voiceOpen" inBundle:TXTSDKBundle compatibleWithTraitCollection:nil] forState:UIControlStateSelected];
        voiceBtn.userInteractionEnabled = NO;
        self.voiceBtn = voiceBtn;
    }
    return _voiceBtn;
}
/** videoBtn */
- (UIButton *)videoBtn {
    if (!_videoBtn) {
        UIButton *videoBtn = [UIButton buttonWithTitle:@"" titleColor:[UIColor colorWithHexString:@"D70110"] font:[UIFont qs_regularFontWithSize:15] target:self action:@selector(videoBtnClick)];
        [videoBtn setImage:[UIImage imageNamed:@"member_icon_videoClose" inBundle:TXTSDKBundle compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
        [videoBtn setImage:[UIImage imageNamed:@"member_icon_videoOpen" inBundle:TXTSDKBundle compatibleWithTraitCollection:nil] forState:UIControlStateSelected];
        videoBtn.userInteractionEnabled = NO;
        self.videoBtn = videoBtn;
    }
    return _videoBtn;
}
@end
