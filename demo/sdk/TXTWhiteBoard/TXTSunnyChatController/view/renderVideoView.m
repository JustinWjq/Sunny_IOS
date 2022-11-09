//
//  renderVideoView.m
//  TXTWhiteBoard
//
//  Created by 洪青文 on 2022/11/3.
//  Copyright © 2022 洪青文. All rights reserved.
//

#import "renderVideoView.h"
#import "videoView.h"

#define PortraitVideoSHeight Screen_Width/5.3/7*9 //竖屏小窗口高度

@interface renderVideoView()<TXTVideoCollectionViewDelegate>

@end

@implementation renderVideoView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
//        self.backgroundColor = [UIColor colorWithHexString:@"#000000"];
        [self initUI];
    }
    return self;
}

- (void)initUI{
    UIView *backgroundView = [[UIView alloc] init];
    [self addSubview:backgroundView];
    [backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(0);
        make.left.mas_equalTo(self.mas_left).offset(0);
        make.right.mas_equalTo(self.mas_right).offset(0);
        make.bottom.mas_equalTo(self.mas_bottom).offset(0);
    }];
    backgroundView.alpha = 0.2;
    backgroundView.backgroundColor = [UIColor colorWithHexString:@"#000000"];
}

- (void)setVideoRenderNumber:(TRTCVideoRenderNumber)number mode:(TRTCVideoRenderMode)mode{
    NSLog(@"setVideoRenderNumber");
    switch (number) {
        case TRTCVideoRenderNumber1:
            [self setTRTCVideoRenderNumber1UI];
            break;
        case TRTCVideoRenderNumber2:
            [self setTRTCVideoRenderNumber2UI];
            break;
        default:
            [self setTRTCVideoRenderUI];
            break;
    }
}

- (void)setTRTCVideoRenderNumber1UI{
    TXTUserModel *model = self.renderArray[0];
    videoView *videoview = [[videoView alloc] init];
    [self addSubview:videoview];
    if (model.showVideo) {
        [videoview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top).offset(0);
            make.left.mas_equalTo(self.mas_left).offset(0);
            make.right.mas_equalTo(self.mas_right).offset(0);
            make.bottom.mas_equalTo(self.mas_bottom).offset(0);
        }];
        videoview.userModel = model;
        [videoview showVideoView];
    }else{
        [videoview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX).offset(0);
            make.centerY.mas_equalTo(self.mas_centerY).offset(0);
            make.width.mas_equalTo(Screen_Width/4);
            make.height.mas_equalTo(Screen_Width/4);
        }];
        videoview.userModel = model;
        [videoview initHideUIDirectionLeft:NO];
    }
}

- (void)setTRTCVideoRenderNumber2UI{
    TXTUserModel *model1 = self.renderArray[0];
    TXTUserModel *model2 = self.renderArray[1];
    if ( !model1.showVideo && !model2.showVideo){
        videoView *videoview1 = [[videoView alloc] init];
        [self addSubview:videoview1];
        [videoview1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX).offset(-Screen_Width/4);
            make.centerY.mas_equalTo(self.mas_centerY).offset(0);
            make.width.mas_equalTo(Screen_Width/4);
            make.height.mas_equalTo(Screen_Width/4);
        }];
        videoview1.userModel = model1;
        [videoview1 initHideUIDirectionLeft:NO];
        
        videoView *videoview2 = [[videoView alloc] init];
        [self addSubview:videoview2];
        [videoview2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX).offset(Screen_Width/4);
            make.centerY.mas_equalTo(self.mas_centerY).offset(0);
            make.width.mas_equalTo(Screen_Width/4);
            make.height.mas_equalTo(Screen_Width/4);
        }];
        videoview2.userModel = model2;
        [videoview2 initHideUIDirectionLeft:NO];
        return;
    }
    [self setTRTCVideoRenderUI];

}

//竖屏 3人及以上
- (void)setTRTCVideoRenderUI{
    self.renderViewCollectionView = [[TXTVideoCollectionView alloc] init];
    [self addSubview:self.renderViewCollectionView];
    [self.renderViewCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(videoview.mas_bottom).offset(0);
        make.left.mas_equalTo(self.mas_left).offset(0);
        make.right.mas_equalTo(self.mas_right).offset(0);
        make.bottom.mas_equalTo(self.mas_bottom).offset(0);
        make.height.mas_equalTo(PortraitVideoSHeight);
    }];
    self.renderViewCollectionView.delegate = self;
    NSMutableArray *newrenderArr = [NSMutableArray arrayWithArray:self.renderArray];
    [newrenderArr removeObjectAtIndex:0];
    self.renderViewCollectionView.renderViewsArray = newrenderArr;
    
    TXTUserModel *model1 = self.renderArray[0];
    videoView *videoview = [[videoView alloc] init];
    [self addSubview:videoview];
    if (model1.showVideo) {
        [videoview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top).offset(0);
            make.left.mas_equalTo(self.mas_left).offset(0);
            make.right.mas_equalTo(self.mas_right).offset(0);
            //-self.frame.size.height/2.5
            make.bottom.mas_equalTo(self.renderViewCollectionView.mas_bottom).offset(0);
        }];
        videoview.userModel = model1;
        [videoview showVideoView];
    }else{
        [videoview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX).offset(0);
            make.centerY.mas_equalTo(self.mas_centerY).offset(-(Screen_Height/3.5+Screen_Width/5.3/7*9)/5);
            make.width.mas_equalTo(Screen_Width/4);
            make.height.mas_equalTo(Screen_Width/4);
        }];
        videoview.userModel = model1;
        [videoview initHideUIDirectionLeft:NO];
    }
    
    
}



@end
