//
//  renderVideoView.m
//  TXTWhiteBoard
//
//  Created by 洪青文 on 2022/11/3.
//  Copyright © 2022 洪青文. All rights reserved.
//

#import "renderVideoView.h"
#import "videoView.h"

@interface renderVideoView()<TXTVideoCollectionViewDelegate>

@end

@implementation renderVideoView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor yellowColor];
    }
    return self;
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
            break;
    }
}

- (void)setTRTCVideoRenderNumber1UI{
    TXTUserModel *model = self.renderArray[0];
    if (model.showVideo) {
        videoView *videoview = [[videoView alloc] init];
        [self addSubview:videoview];
        [videoview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top).offset(0);
            make.left.mas_equalTo(self.mas_left).offset(0);
            make.right.mas_equalTo(self.mas_right).offset(0);
            make.bottom.mas_equalTo(self.mas_bottom).offset(0);
        }];
        videoview.userModel = model;
        [videoview showVideoView];
    }
}

- (void)setTRTCVideoRenderNumber2UI{
    TXTUserModel *model1 = self.renderArray[0];
    if (model1.showVideo) {
        videoView *videoview = [[videoView alloc] init];
        [self addSubview:videoview];
        [videoview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top).offset(0);
            make.left.mas_equalTo(self.mas_left).offset(0);
            make.right.mas_equalTo(self.mas_right).offset(0);
            //-self.frame.size.height/2.5
            make.bottom.mas_equalTo(self.mas_bottom).offset(-45);
        }];
        videoview.userModel = model1;
        [videoview showVideoView];
        
        self.renderViewCollectionView = [[TXTVideoCollectionView alloc] init];
        [self addSubview:self.renderViewCollectionView];
        [self.renderViewCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(videoview.mas_safeAreaLayoutGuideBottom).offset(5);
            make.height.mas_equalTo(45);
            make.left.mas_equalTo(self.mas_left).offset(0);
            make.right.mas_equalTo(self.mas_right).offset(0);
            make.bottom.mas_equalTo(self.mas_bottom).offset(0);
        }];
        self.renderViewCollectionView.delegate = self;
        self.renderViewCollectionView.renderViewsArray = self.renderArray;
    }
   
}

//- (TXTVideoCollectionView *)renderViewCollectionView{
//    if (!_renderViewCollectionView) {
//
//        //        _renderViewCollectionView.backgroundColor = [UIColor blueColor];
//    }
//    return _renderViewCollectionView;
//}

@end
