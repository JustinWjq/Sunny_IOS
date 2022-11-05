//
//  TXTSmallMessageCell.m
//  TXTWhiteBoard
//
//  Created by jiangyongjian on 2022/11/4.
//  Copyright © 2022 洪青文. All rights reserved.
//

#import "TXTSmallMessageCell.h"
#import "TXTCommon.h"

@interface TXTSmallMessageCell ()

/** bgView */
@property (nonatomic, strong) UIView *bgView;
/** contentLabel */
@property (nonatomic ,strong) UILabel *contentLabel;

@end

@implementation TXTSmallMessageCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    // 创建cell
    static NSString *ID = @"TXTSmallMessageCell";
    TXTSmallMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[TXTSmallMessageCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
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
    [self.contentView addSubview:self.contentLabel];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(6);
//        make.right.lessThanOrEqualTo(@(-6));
        make.width.lessThanOrEqualTo(@(252));
        make.top.mas_equalTo(11);
        make.bottom.mas_equalTo(-11);
    }];
    
    [self.contentView insertSubview:self.bgView belowSubview:self.contentLabel];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.equalTo(self.contentLabel.mas_right).offset(6);
        make.top.mas_equalTo(5);
        make.bottom.mas_equalTo(-5);
    }];
}

- (void)setText:(NSString *)text {
    _text = [text copy];
   
    NSDictionary *dict = [[TXTCommon sharedInstance] dictionaryWithJsonString:text];
    NSString *userName = dict[@"userName"];
    NSString *content = dict[@"content"];
    self.contentLabel.attributedText = [self differentStringForLable:[NSString stringWithFormat:@"%@：%@", userName, content] uintStr:content];
}

/** 不同字体*/
- (NSMutableAttributedString *)differentStringForLable:(NSString *)string uintStr:(NSString *)uintStr {
    NSString *originStr = [NSString stringWithFormat:@"%@", string];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:originStr];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"E6B980"] range:NSMakeRange(0, string.length)];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"FFFFFF"] range:[originStr rangeOfString:uintStr]];
    return str;
}


- (UIView *)bgView {
    if (!_bgView) {
        UIView *bgView = [[UIView alloc] init];
        bgView.backgroundColor = [UIColor colorWithHexString:@"282A2C" alpha:0.7];
        bgView.cornerRadius = 3;
        self.bgView = bgView;
    }
    return _bgView;
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        UILabel *contentLabel = [UILabel labelWithTitle:@"说的真好哎" color:[UIColor colorWithHexString:@"FFFFFF"] font:[UIFont qs_regularFontWithSize:12]];
        contentLabel.numberOfLines = 3;
        contentLabel.textAlignment = NSTextAlignmentLeft;
        self.contentLabel = contentLabel;
    }
    return _contentLabel;
}
@end
