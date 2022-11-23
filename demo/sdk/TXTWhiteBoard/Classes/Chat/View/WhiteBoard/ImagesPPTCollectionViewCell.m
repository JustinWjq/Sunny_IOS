//
//  ImagesPPTCollectionViewCell.m
//  TICDemo
//
//  Created by 洪青文 on 2020/9/1.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import "ImagesPPTCollectionViewCell.h"

@implementation ImagesPPTCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    [self.contentView addSubview:self.pptImg];
    [self.pptImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    [self.contentView addSubview:self.pptNum];
    [self.pptNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(self.contentView);
        make.width.mas_equalTo(28);
        make.height.mas_equalTo(17);
    }];
}

/// pptImgClick
- (void)pptImgClick {
    if ([self.delegate respondsToSelector:@selector(collectionViewCellselectImage:)]) {
        [self.delegate collectionViewCellselectImage:self];
    }
}

- (UIImageView *)pptImg {
    if (!_pptImg) {
        UIImageView *pptImg = [[UIImageView alloc] init];
        pptImg.userInteractionEnabled = YES;
        [pptImg addTarget:self action:@selector(pptImgClick)];
        self.pptImg = pptImg;
    }
    return _pptImg;
}

- (UILabel *)pptNum {
    if (!_pptNum) {
        UILabel *pptNum = [UILabel labelWithTitle:@"" color:[UIColor colorWithHexString:@"FFFFFF"] font:[UIFont qs_regularFontWithSize:12]];
        pptNum.backgroundColor = [UIColor colorWithHexString:@"6B92E4"];
        self.pptNum = pptNum;
    }
    return _pptNum;
}

@end
