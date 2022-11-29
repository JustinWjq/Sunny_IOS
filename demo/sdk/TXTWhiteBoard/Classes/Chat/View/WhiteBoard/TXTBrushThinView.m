//
//  TXTBrushThinView.m
//  TXTWhiteBoard
//
//  Created by jiangyongjian on 2022/11/8.
//  Copyright © 2022 洪青文. All rights reserved.
//

#import "TXTBrushThinView.h"

static NSInteger const kColorTag = 10000;
static NSInteger const kThinTag = 12500;

@interface TXTBrushThinView ()

/** bgView */
@property (nonatomic, strong) UIView *bgView;

/** iconView */
@property (nonatomic, strong) UIImageView *iconView;

/** divider */
@property (nonatomic, strong) UIView *divider;

@property (nonatomic, strong) NSMutableArray *colorsArr;

@property (nonatomic, strong) NSMutableArray *thinsArr;

/** selectedSamllColorBtn */
@property (nonatomic, strong) UIButton *selectedSamllColorBtn;
/** selectedThinBtn */
@property (nonatomic, strong) UIButton *selectedThinBtn;
@end

@implementation TXTBrushThinView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self initUI];
    }
    return self;
}

- (void)initUI {
    [self addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.bottom.equalTo(self.mas_bottom).offset(-6);
    }];
    
    [self addSubview:self.iconView];
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.bgView.mas_bottom).offset(-1);
        make.width.mas_equalTo(14);
        make.width.mas_equalTo(14.5);
    }];
    
    CGFloat leftColorMargin = 7.5;
    CGFloat colorMargin = 0;
    CGFloat colorBtnW = 25;
    for (int i=0; i<self.colorsArr.count; i++) {
        UIButton *colorBtn = [UIButton buttonWithTitle:@"" titleColor:[UIColor colorWithHexString:@"D70110"] font:[UIFont qs_regularFontWithSize:15] target:self action:@selector(colorBtnClick:)];
        colorBtn.backgroundColor = [UIColor clearColor];
        colorBtn.tag = i + kColorTag;
        [self.bgView addSubview:colorBtn];
        [colorBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(leftColorMargin + (colorBtnW + colorMargin) * i);
            make.width.height.mas_equalTo(25);
            make.top.mas_equalTo(58);
        }];
        
        UIButton *samllColorBtn = [UIButton buttonWithTitle:@"" titleColor:[UIColor colorWithHexString:@"D70110"] font:[UIFont qs_regularFontWithSize:15] target:self action:nil];
        samllColorBtn.userInteractionEnabled = NO;
        samllColorBtn.backgroundColor = self.colorsArr[i];
        samllColorBtn.tag = i + 2 * kColorTag;
        [samllColorBtn setImage:[UIImage imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
        [samllColorBtn setImage:[UIImage imageNamed:@"white_icon_colorCheck" inBundle:TXTSDKBundle compatibleWithTraitCollection:nil] forState:UIControlStateSelected];
        [colorBtn addSubview:samllColorBtn];
        [samllColorBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.centerY.equalTo(colorBtn);
            make.width.height.mas_equalTo(15);
        }];
        samllColorBtn.cornerRadius = 2;
        if (i == 0) {
            samllColorBtn.selected = YES;
            self.selectedSamllColorBtn = samllColorBtn;
        }
    }
    CGFloat thinBtnW = 30;
    CGFloat thinMargin = 18;
    for (int i=0; i<self.thinsArr.count; i++) {
        UIButton *thinBtn = [UIButton buttonWithTitle:@"" titleColor:[UIColor colorWithHexString:@"D70110"] font:[UIFont qs_regularFontWithSize:15] target:self action:@selector(thinBtnClick:)];
        [thinBtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"white_icon_lineNormal%d", i + 1] inBundle:TXTSDKBundle compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
        [thinBtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"white_icon_lineSelected%d", i + 1] inBundle:TXTSDKBundle compatibleWithTraitCollection:nil] forState:UIControlStateSelected];
        thinBtn.tag = i + kThinTag;
        [self.bgView addSubview:thinBtn];
        [thinBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(thinBtnW);
            make.left.mas_equalTo(20 + (thinBtnW + thinMargin) * i);
            make.top.mas_equalTo(8);
        }];
        if (i == 0) {
            thinBtn.selected = YES;
            self.selectedThinBtn = thinBtn;
        }
    }
    
    [self.bgView addSubview:self.divider];
    [self.divider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(7.5);
        make.right.mas_equalTo(-7.5);
        make.height.mas_equalTo(1);
        make.top.mas_equalTo(45);
    }];
}

/// thinBtnClick
- (void)thinBtnClick:(UIButton *)btn {
    for (int i=0; i<self.thinsArr.count; i++) {
        UIButton *btn = [self viewWithTag:i + kThinTag];
        btn.selected = NO;
    }
    btn.selected = YES;
    [[[TICManager sharedInstance] getBoardController] setBrushThin:[self.thinsArr[btn.tag - kThinTag] intValue]];
}

/// colorBtnClick
- (void)colorBtnClick:(UIButton *)btn {
    for (int i=0; i<self.colorsArr.count; i++) {
        UIButton *btn = [self viewWithTag:i + 2 * kColorTag];
        btn.selected = NO;
    }
    UIButton *findBtn = [self viewWithTag:btn.tag + kColorTag];
    findBtn.selected = YES;
    
    [[[TICManager sharedInstance] getBoardController] setBrushColor:self.colorsArr[btn.tag - kColorTag]];
}

- (BOOL)compareRGBAColor1:(UIColor *)color1 color2:(UIColor *)color2 {
    CGFloat red1,red2,green1,green2,blue1,blue2,alpha1,alpha2;
    //取出color1的背景颜色的RGBA值
    [color1 getRed:&red1 green:&green1 blue:&blue1 alpha:&alpha1];
    //取出color2的背景颜色的RGBA值
    [color2 getRed:&red2 green:&green2 blue:&blue2 alpha:&alpha2];
    if ((fabs(red1 - red2) < 0.00001)&&(fabs(green1 - green2) < 0.00001)&&(fabs(blue1 - blue2) < 0.00001)&&(fabs(alpha1 - alpha2) < 0.00001)) {
        return YES;
    } else {
        return NO;
    }
}

- (void)setType:(TXTBrushThinViewType)type {
//    if (type == TXTBrushThinViewTypeArrow) {
    UIColor *arrowColor = [[[TICManager sharedInstance] getBoardController] getBrushColor];
    for (int i=0; i<self.colorsArr.count; i++) {
        UIColor *color =  self.colorsArr[i];
//        if (CGColorEqualToColor(arrowColor.CGColor, color.CGColor)) {
        if ([self compareRGBAColor1:arrowColor color2:color]) {
            self.selectedSamllColorBtn.selected = NO;
            UIButton *findBtn = [self viewWithTag:i + 2 * kColorTag];
            findBtn.selected = YES;
            break;
        }
    }
    
    int thin = [[[TICManager sharedInstance] getBoardController] getBrushThin];
    for (int j=0; j<self.thinsArr.count; j++) {
        NSString *thinStr = self.thinsArr[j];
        if (thin == [thinStr intValue]) {
            self.selectedThinBtn.selected = NO;
            UIButton *findBtn = [self viewWithTag:j + kThinTag];
            findBtn.selected = YES;
            break;
        }
    }
       
//    } else if (type == TXTBrushThinViewTypePaint) {
//        UIColor *arrowColor = [[[TICManager sharedInstance] getBoardController] getBrushColor];
//    }
}



- (UIImageView *)iconView {
    if (!_iconView) {
        UIImageView *iconView = [[UIImageView alloc] init];
        iconView.image = [UIImage imageNamed:@"white_icon_down" inBundle:TXTSDKBundle compatibleWithTraitCollection:nil];
        self.iconView = iconView;
    }
    return _iconView;
}

- (UIView *)bgView {
    if (!_bgView) {
        UIView *bgView = [[UIView alloc] init];
        bgView.backgroundColor = [UIColor colorWithHexString:@"FFFFFF"];
        bgView.layer.cornerRadius = 7;
        bgView.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.1500].CGColor;
        bgView.layer.shadowOffset = CGSizeMake(0,0);
        bgView.layer.shadowOpacity = 1;
        bgView.layer.shadowRadius = 5;
        self.bgView = bgView;
    }
    return _bgView;
}

- (UIView *)divider {
    if (!_divider) {
        UIView *divider = [[UIView alloc] init];
        divider.backgroundColor = [[UIColor colorWithHexString:@"E6E6E6"] colorWithAlphaComponent:0.8];
        self.divider = divider;
    }
    return _divider;
}
- (NSMutableArray *)colorsArr {
    if (!_colorsArr) {
        self.colorsArr = [NSMutableArray arrayWithArray:@[[UIColor colorWithHexString:@"#333333"],[UIColor colorWithHexString:@"#FF4848"],[UIColor colorWithHexString:@"#1AD27C"],[UIColor colorWithHexString:@"#FDC126"],[UIColor colorWithHexString:@"#9F2DFF"],[UIColor colorWithHexString:@"#4085FF"]]];
    }
    return _colorsArr;
}

- (NSMutableArray *)thinsArr {
    if (!_thinsArr) {
        self.thinsArr = [NSMutableArray arrayWithArray:@[@"50",@"100",@"150"]];
    }
    return _thinsArr;
}
@end
