//
//  TXTEmojiCollectionViewCell.m
//  TXTWhiteBoard
//
//  Created by jiangyongjian on 2022/11/4.
//  Copyright © 2022 洪青文. All rights reserved.
//

#import "TXTEmojiCollectionViewCell.h"
#import "NSString+Emoji.h"

@interface TXTEmojiCollectionViewCell ()

/** titleLabel */
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation TXTEmojiCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.contentView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
}

- (void)setText:(NSString *)text {
    _text = [text copy];
    NSString *str = [text stringByReplacingOccurrencesOfString:@"U+" withString:@""];
    self.titleLabel.text = [NSString emojiWithStringCode:str];
}


- (UILabel *)titleLabel {
    if (!_titleLabel) {
        UILabel *titleLabel = [UILabel labelWithTitle:@"" color:[UIColor colorWithHexString:@"1D2333"] font:[UIFont qs_semiFontWithSize:22]];
        self.titleLabel = titleLabel;
    }
    return _titleLabel;
}


@end

