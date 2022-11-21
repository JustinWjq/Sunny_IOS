//
//  TXTStatusBar.m
//  TXTWhiteBoard
//
//  Created by 洪青文 on 2022/11/21.
//  Copyright © 2022 洪青文. All rights reserved.
//

#import "TXTStatusBar.h"

@implementation TXTStatusBar

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
    ///创建顶部工具栏
    UIView *topToolView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width,80)];
    UIImage *shadowImage = [UIImage imageNamed:@"top_shadow"];
    topToolView.layer.contents = (id)shadowImage.CGImage;
    [self addSubview:topToolView];
    
    /// 时间
    UILabel *dateLabel = [[UILabel alloc]init];
    dateLabel.bounds = CGRectMake(0, 0, 100, 16);
    dateLabel.center = CGPointMake(self.bounds.size.width*0.5, 12);
    dateLabel.textColor = [UIColor whiteColor];
    dateLabel.font = [UIFont boldSystemFontOfSize:12];
    dateLabel.textAlignment = NSTextAlignmentCenter;
    [topToolView addSubview:dateLabel];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[NSLocale currentLocale]];
    [formatter setDateStyle:NSDateFormatterNoStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    NSString *dateString = [formatter stringFromDate:[NSDate date]];
    if(self.is24H == YES){ // 24H制，直接显示
        dateLabel.text = dateString;
    }else{
        NSRange amRange = [dateString rangeOfString:[formatter AMSymbol]];
        dateString = [dateString substringToIndex:dateString.length-3];
        if(amRange.location == NSNotFound){ // 显示 下午 hh:mm
            dateLabel.text = [NSString stringWithFormat:@"下午 %@",dateString];
        }else{ // 显示 上午 hh:mm
            dateLabel.text = [NSString stringWithFormat:@"上午 %@",dateString];
        }
    }
    
    /// 电池
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(self.bounds.size.width-35, 7, 20, 10) cornerRadius:2.5];
    CAShapeLayer *lineLayer = [CAShapeLayer layer];
    lineLayer.lineWidth = 1;
    lineLayer.strokeColor = [[UIColor whiteColor] colorWithAlphaComponent:0.4].CGColor;
    lineLayer.path = bezierPath.CGPath;
    lineLayer.fillColor = nil; // 默认为blackColor
    [topToolView.layer addSublayer:lineLayer];
    // 正极小玩意
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(self.bounds.size.width-35+20+2, 7.5+3, 1, 3) byRoundingCorners:(UIRectCornerTopRight|UIRectCornerBottomRight) cornerRadii:CGSizeMake(2, 2)];
    CAShapeLayer *lineLayer2 = [CAShapeLayer layer];
    lineLayer2.lineWidth = 0.5;
    lineLayer2.strokeColor = [[UIColor whiteColor] colorWithAlphaComponent:0.4].CGColor;
    lineLayer2.path = path.CGPath;
    lineLayer2.fillColor = lineLayer.strokeColor; // 默认为blackColor
    [topToolView.layer addSublayer:lineLayer2];
    
    // 当前的电池电量
    [UIDevice currentDevice].batteryMonitoringEnabled = YES;
    CGFloat batteryLevel = [UIDevice currentDevice].batteryLevel;
    
    // 是否在充电
    UIImageView *batteryImg = [[UIImageView alloc]init];
    batteryImg.bounds = CGRectMake(0, 0, 8, 12);
    batteryImg.center = CGPointMake(self.bounds.size.width-35+10, 7+5);
    batteryImg.image = [UIImage imageNamed:@"lightning"];
    
    
    
    UIColor *batteryColor;
    UIDeviceBatteryState batteryState = [UIDevice currentDevice].batteryState;
    if(batteryState == UIDeviceBatteryStateCharging || batteryState == UIDeviceBatteryStateFull){ // 在充电 绿色
        batteryColor = [UIColor colorWithHexString:@"#37CB46"];
    }else{
        if(batteryLevel <= 0.2){ // 电量低
            if([NSProcessInfo processInfo].lowPowerModeEnabled){ // 开启低电量模式 黄色
                batteryColor = [UIColor colorWithHexString:@"#F9CF0E"];
            }else{ // 红色
                batteryColor = [UIColor colorWithHexString:@"#F02C2D"];
            }
        }else{ // 电量正常 白色
            batteryColor = [UIColor whiteColor];
        }
        batteryImg.hidden = YES;
    }
    
    UIBezierPath *batteryPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(self.bounds.size.width-35+1.5, 7+1.5, (20-3)*batteryLevel, 10-3) cornerRadius:2];
    CAShapeLayer *batteryLayer = [CAShapeLayer layer];
    batteryLayer.lineWidth = 1;
    batteryLayer.strokeColor = [UIColor clearColor].CGColor;
    batteryLayer.path = batteryPath.CGPath;
    batteryLayer.fillColor = batteryColor.CGColor; // 默认为blackColor
    [topToolView.layer addSublayer:batteryLayer];
    
    [topToolView addSubview:batteryImg];
    
    UILabel *batteryLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.bounds.size.width-35-50-2, 4, 50, 16)];
    batteryLabel.text = [NSString stringWithFormat:@"%.0f%%",batteryLevel*100];
    batteryLabel.textColor = [UIColor whiteColor];
    batteryLabel.font = [UIFont systemFontOfSize:12];
    batteryLabel.textAlignment = NSTextAlignmentRight;
    [topToolView addSubview:batteryLabel];
}


- (BOOL)is24H{
    if(!_is24H){
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setLocale:[NSLocale currentLocale]];
        [formatter setDateStyle:NSDateFormatterNoStyle];
        [formatter setTimeStyle:NSDateFormatterShortStyle];
        NSString *dateString = [formatter stringFromDate:[NSDate date]];
        NSRange amRange = [dateString rangeOfString:[formatter AMSymbol]];
        NSRange pmRange = [dateString rangeOfString:[formatter PMSymbol]];
        _is24H = (amRange.location == NSNotFound && pmRange.location == NSNotFound);
    }
    return _is24H;
}


@end
