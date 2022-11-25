//
//  renderVideoView.m
//  TXTWhiteBoard
//
//  Created by 洪青文 on 2022/11/3.
//  Copyright © 2022 洪青文. All rights reserved.
//

#import "renderVideoView.h"
#import "videoView.h"

//#define PortraitVideoSHeight Screen_Width/5.3/7*9 //竖屏小窗口高度
#define PortraitVideoSHeight Adapt(90) //竖屏小窗口高度
#define viewHeigth Screen_Height-Adapt(60)
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

- (void)setRenderArray:(NSArray *)renderArray{
    _renderArray = renderArray;
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
}

- (void)setVideoRenderNumber:(TRTCVideoRenderNumber)number mode:(TRTCVideoRenderMode)mode{
    NSLog(@"setVideoRenderNumber");
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    [self initUI];
    if (mode == TRTCVideoRenderModePortrait) {
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
    }else{
        switch (number) {
            case TRTCVideoRenderNumber1:
                [self setTRTCVideoRenderNumber1UI];
                break;
            case TRTCVideoRenderNumber2:
                [self setTRTCVideoRenderNumber2UILandscape];
                break;
            case TRTCVideoRenderNumber3:
                [self setTRTCVideoRenderNumber3UILandscape];
                break;
            case TRTCVideoRenderNumber4:
                [self setTRTCVideoRenderNumber4UILandscape];
                break;
            default:
                [self setTRTCVideoRenderNumber5UILandscape];
                break;
        }
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
        [videoview showVideoViewDirectionLeft:YES];
    }else{
        [videoview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX).offset(0);
            make.centerY.mas_equalTo(self.mas_centerY).offset(0);
            make.width.mas_equalTo(Adapt(100));
            make.height.mas_equalTo(Adapt(100));
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
        [videoview mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top).offset(0);
            make.left.mas_equalTo(self.mas_left).offset(0);
            make.right.mas_equalTo(self.mas_right).offset(0);
            //-self.frame.size.height/2.5
            make.bottom.mas_equalTo(self.renderViewCollectionView.mas_top).offset(0);
        }];
        videoview.userModel = model1;
        [videoview showVideoViewDirectionLeft:YES];
    }else{
        [videoview mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX).offset(0);
            //            make.centerY.mas_equalTo(self.mas_centerY).offset(-(viewHeigth/3.5+Screen_Width/5.3/7*9)/5);
            make.top.mas_equalTo(self.mas_top).offset(Adapt(72));
            make.width.mas_equalTo(Screen_Width/4);
            make.height.mas_equalTo(Screen_Width/4);
        }];
        videoview.userModel = model1;
        [videoview initHideUIDirectionLeft:NO];
    }
}

- (void)setTRTCVideoRenderNumber2UILandscape{
    TXTUserModel *model1 = self.renderArray[0];
    videoView *videoview1 = [[videoView alloc] init];
    [self addSubview:videoview1];
    
    videoview1.userModel = model1;
    if (model1.showVideo) {
        [videoview1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX).offset(-Screen_Width/4);
            make.centerY.mas_equalTo(self.mas_centerY).offset(0);
            make.width.mas_equalTo(Screen_Width/2);
            make.height.mas_equalTo(Screen_Height);
        }];
        [videoview1 showVideoViewDirectionLeft:YES];
    }else{
        [videoview1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX).offset(-Screen_Width/4);
            make.centerY.mas_equalTo(self.mas_centerY).offset(0);
            make.width.mas_equalTo(Adapt(100));
            make.height.mas_equalTo(Adapt(100));
        }];
        [videoview1 initHideUIDirectionLeft:NO];
    }
    TXTUserModel *model2 = self.renderArray[1];
    videoView *videoview2 = [[videoView alloc] init];
    [self addSubview:videoview2];
    
    videoview2.userModel = model2;
    if (model2.showVideo) {
        [videoview2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX).offset(Screen_Width/4);
            make.centerY.mas_equalTo(self.mas_centerY).offset(0);
            make.width.mas_equalTo(Screen_Width/2);
            make.height.mas_equalTo(Screen_Height);
        }];
        [videoview2 showVideoViewDirectionLeft:YES];
    }else{
        [videoview2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX).offset(Screen_Width/4);
            make.centerY.mas_equalTo(self.mas_centerY).offset(0);
            make.width.mas_equalTo(Adapt(100));
            make.height.mas_equalTo(Adapt(100));
        }];
        [videoview2 initHideUIDirectionLeft:NO];
    }
}


- (void)setTRTCVideoRenderNumber3UILandscape{
    TXTUserModel *model1 = self.renderArray[0];
    videoView *videoview1 = [[videoView alloc] init];
    [self addSubview:videoview1];
    
    videoview1.userModel = model1;
    if (model1.showVideo) {
        [videoview1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX).offset(-Screen_Width/4);
            make.centerY.mas_equalTo(self.mas_centerY).offset(0);
            make.width.mas_equalTo(Screen_Width/2);
            make.height.mas_equalTo(Screen_Height);
        }];
        [videoview1 showVideoViewDirectionLeft:YES];
    }else{
        [videoview1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX).offset(-Screen_Width/4);
            make.centerY.mas_equalTo(self.mas_centerY).offset(-Adapt(30));
            make.width.mas_equalTo(Adapt(100));
            make.height.mas_equalTo(Adapt(100));
        }];
        [videoview1 initHideUIDirectionLeft:NO];
    }
    
    TXTUserModel *model2 = self.renderArray[1];
    videoView *videoview2 = [[videoView alloc] init];
    [self addSubview:videoview2];
    videoview2.userModel = model2;
    if (model2.showVideo) {
        [videoview2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX).offset(Screen_Width/4);
            make.top.mas_equalTo(self.mas_top).offset(0);
            make.width.mas_equalTo(Screen_Width/2);
            //(Screen_Height-Adapt(60))/2
            make.height.mas_equalTo(Screen_Height/2);
        }];
        [videoview2 showVideoViewDirectionLeft:YES];
    }else{
        [videoview2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX).offset(Screen_Width/4);
            //            make.centerY.mas_equalTo(self.mas_centerY).offset(-(Screen_Height-Adapt(60))/4);
            make.top.mas_equalTo(self.mas_top).offset((Screen_Height/2-Adapt(100))/2);
            make.width.mas_equalTo(Adapt(100));
            make.height.mas_equalTo(Adapt(100));
        }];
        [videoview2 initHideUIDirectionLeft:NO];
    }
    
    TXTUserModel *model3 = self.renderArray[2];
    videoView *videoview3 = [[videoView alloc] init];
    [self addSubview:videoview3];
    videoview3.userModel = model3;
    if (model3.showVideo) {
        [videoview3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX).offset(Screen_Width/4);
            make.top.mas_equalTo(self.mas_top).offset(Screen_Height/2);
            make.width.mas_equalTo(Screen_Width/2);
            make.height.mas_equalTo(Screen_Height/2);
        }];
        [videoview3 showVideoViewDirectionLeft:YES];
    }else{
        NSLog(@"viewHeigth = %f",Screen_Height-Adapt(60));
        [videoview3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX).offset(Screen_Width/4);
            //(Screen_Height-Adapt(60))/2+10
            make.top.mas_equalTo(self.mas_top).offset(Screen_Height/2+Adapt(50));
            make.width.mas_equalTo(Adapt(100));
            make.height.mas_equalTo(Adapt(100));
        }];
        [videoview3 initHideUIDirectionLeft:NO];
    }
}

- (void)setTRTCVideoRenderNumber4UILandscape{
    TXTUserModel *model1 = self.renderArray[0];
    videoView *videoview1 = [[videoView alloc] init];
    [self addSubview:videoview1];
    
    videoview1.userModel = model1;
    if (model1.showVideo) {
        [videoview1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX).offset(-Screen_Width/4);
            make.top.mas_equalTo(self.mas_top).offset(0);
            make.width.mas_equalTo(Screen_Width/2);
            make.height.mas_equalTo(Screen_Height/2);
        }];
        [videoview1 showVideoViewDirectionLeft:YES];
    }else{
        [videoview1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX).offset(-Screen_Width/4);
            make.top.mas_equalTo(self.mas_top).offset((Screen_Height/2-Adapt(100))/2);
            make.width.mas_equalTo(Adapt(100));
            make.height.mas_equalTo(Adapt(100));
        }];
        [videoview1 initHideUIDirectionLeft:NO];
    }
    
    TXTUserModel *model2 = self.renderArray[1];
    videoView *videoview2 = [[videoView alloc] init];
    [self addSubview:videoview2];
    videoview2.userModel = model2;
    if (model2.showVideo) {
        [videoview2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX).offset(Screen_Width/4);
            make.top.mas_equalTo(self.mas_top).offset(0);
            make.width.mas_equalTo(Screen_Width/2);
            make.height.mas_equalTo(Screen_Height/2);
        }];
        [videoview2 showVideoViewDirectionLeft:YES];
    }else{
        [videoview2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX).offset(Screen_Width/4);
            make.top.mas_equalTo(self.mas_top).offset((Screen_Height/2-Adapt(100))/2);
            make.width.mas_equalTo(Adapt(100));
            make.height.mas_equalTo(Adapt(100));
        }];
        [videoview2 initHideUIDirectionLeft:NO];
    }
    
    TXTUserModel *model3 = self.renderArray[2];
    videoView *videoview3 = [[videoView alloc] init];
    [self addSubview:videoview3];
    videoview3.userModel = model3;
    if (model3.showVideo) {
        [videoview3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX).offset(-Screen_Width/4);
            make.top.mas_equalTo(self.mas_top).offset(Screen_Height/2);
            make.width.mas_equalTo(Screen_Width/2);
            make.height.mas_equalTo(Screen_Height/2);
        }];
        [videoview3 showVideoViewDirectionLeft:YES];
    }else{
        NSLog(@"viewHeigth = %f",Screen_Height-Adapt(60));
        [videoview3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX).offset(-Screen_Width/4);
            make.top.mas_equalTo(self.mas_top).offset(Screen_Height/2+Adapt(50));
            make.width.mas_equalTo(Adapt(100));
            make.height.mas_equalTo(Adapt(100));
        }];
        [videoview3 initHideUIDirectionLeft:NO];
    }
    
    TXTUserModel *model4 = self.renderArray[3];
    videoView *videoview4 = [[videoView alloc] init];
    [self addSubview:videoview4];
    videoview4.userModel = model4;
    if (model4.showVideo) {
        [videoview4 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX).offset(Screen_Width/4);
            make.top.mas_equalTo(self.mas_top).offset(Screen_Height/2);
            make.width.mas_equalTo(Screen_Width/2);
            make.height.mas_equalTo(Screen_Height/2);
        }];
        [videoview4 showVideoViewDirectionLeft:YES];
    }else{
        NSLog(@"viewHeigth = %f",Screen_Height-Adapt(60));
        [videoview4 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX).offset(Screen_Width/4);
            make.top.mas_equalTo(self.mas_top).offset(Screen_Height/2+Adapt(50));
            make.width.mas_equalTo(Adapt(100));
            make.height.mas_equalTo(Adapt(100));
        }];
        [videoview4 initHideUIDirectionLeft:NO];
    }
}

//5人和5人以上
- (void)setTRTCVideoRenderNumber5UILandscape{
    self.renderViewCollectionView = [[TXTVideoCollectionView alloc] init];
    [self addSubview:self.renderViewCollectionView];
    [self.renderViewCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.top.mas_equalTo(videoview.mas_bottom).offset(0);
        make.top.mas_equalTo(self.mas_safeAreaLayoutGuideTop).offset(0);
        make.right.mas_equalTo(self.mas_safeAreaLayoutGuideRight).offset(0);
        make.bottom.mas_equalTo(self.mas_safeAreaLayoutGuideBottom).offset(0);
        make.width.mas_equalTo(Adapt(132));
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
            make.top.mas_equalTo(self.mas_safeAreaLayoutGuideTop).offset(0);
            make.left.mas_equalTo(self.mas_safeAreaLayoutGuideLeft).offset(0);
            make.right.mas_equalTo(self.renderViewCollectionView.mas_left).offset(0);
            make.bottom.mas_equalTo(self.mas_safeAreaLayoutGuideBottom).offset(0);
        }];
        videoview.userModel = model1;
        [videoview showVideoViewDirectionLeft:YES];
    }else{
        [videoview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_safeAreaLayoutGuideLeft).offset((Screen_Width-kTopHeight- Adapt(132))/2-Adapt(100)/2);
            make.top.mas_equalTo(self.mas_safeAreaLayoutGuideTop).offset((Screen_Height-Adapt(60)-Adapt(60))/2-Adapt(100)/2);
            make.width.mas_equalTo(Adapt(100));
            make.height.mas_equalTo(Adapt(100));
        }];
        videoview.userModel = model1;
        [videoview initHideUIDirectionLeft:NO];
    }
}

- (void)changeViewNumber:(TRTCVideoRenderNumber)number mode:(TRTCVideoRenderMode)mode Index:(NSInteger)index userVolumes:(NSArray<TRTCVolumeInfo *> *)userVolumes RenderArray:(NSArray *)array{
    if (index > self.renderArray.count) {
        for (UIView *svideoView in self.subviews) {
            if ([svideoView isKindOfClass:[videoView class]]) {
                videoView *nsvideoView = (videoView *)svideoView;
                for (TRTCVolumeInfo *info in userVolumes) {
                    if ([nsvideoView.userModel.render.userId isEqualToString:info.userId] || info.userId == nil) {
                        [nsvideoView changeVoiceImage:info];
                    }
                }
            }else if([svideoView isKindOfClass:[TXTVideoCollectionView class]]){
//                NSMutableArray *newrenderArr = [NSMutableArray arrayWithArray:self.renderArray];
//                [newrenderArr removeObjectAtIndex:0];
//                self.renderViewCollectionView.renderViewsArray = newrenderArr;
                [self.renderViewCollectionView setUserVolumesArray:userVolumes renderArray:array];
            }
        }
    }else{
        for (UIView *svideoView in self.subviews) {
            if ([svideoView isKindOfClass:[videoView class]]) {
                videoView *nsvideoView = (videoView *)svideoView;
                TXTUserModel *userModel = self.renderArray[index];
                if ([nsvideoView.userModel.render.userId isEqualToString:userModel.render.userId]) {
                    for (TRTCVolumeInfo *info in userVolumes) {
                        if ([info.userId isEqualToString:userModel.render.userId] || info.userId == nil) {
                            nsvideoView.userModel = userModel;
                            [nsvideoView changeVoiceImage:info];
                        }
                    }
                    
                }
                
            }else if([svideoView isKindOfClass:[TXTVideoCollectionView class]]){
//                NSMutableArray *newrenderArr = [NSMutableArray arrayWithArray:self.renderArray];
//                [newrenderArr removeObjectAtIndex:0];
//                self.renderViewCollectionView.renderViewsArray = newrenderArr;
                [self.renderViewCollectionView setUserVolumesArray:userVolumes renderArray:array];
            }
        }
    }
    
}

- (void)changeVideoViewNumber:(TRTCVideoRenderNumber)number mode:(TRTCVideoRenderMode)mode Index:(NSInteger)index RenderArray:(NSArray *)array{
    for (UIView *svideoView in self.subviews) {
        if (mode == TRTCVideoRenderModePortrait) {
            if([svideoView isKindOfClass:[TXTVideoCollectionView class]]){
//                NSMutableArray *newrenderArr = [NSMutableArray arrayWithArray:self.renderArray];
//                [newrenderArr removeObjectAtIndex:0];
//                self.renderViewCollectionView.renderViewsArray = newrenderArr;
                [self.renderViewCollectionView setUserVideoCell:index renderArray:array];
            }
        }else{
            if ([svideoView isKindOfClass:[videoView class]]) {
                videoView *nsvideoView = (videoView *)svideoView;
                TXTUserModel *userModel = self.renderArray[index];
                if ([nsvideoView.userModel.render.userId isEqualToString:userModel.render.userId]) {
                    for (UIView *view in nsvideoView.subviews) {
                        [view removeFromSuperview];
                    }
                    if (userModel.showVideo) {
                        //判断是几个人
                        if (number == TRTCVideoRenderNumber1) {
                            [nsvideoView mas_remakeConstraints:^(MASConstraintMaker *make) {
                                make.top.mas_equalTo(self.mas_top).offset(0);
                                make.left.mas_equalTo(self.mas_left).offset(0);
                                make.right.mas_equalTo(self.mas_right).offset(0);
                                make.bottom.mas_equalTo(self.mas_bottom).offset(0);
                            }];
                            [nsvideoView showVideoViewDirectionLeft:YES];
                        }
                        else if(number == TRTCVideoRenderNumber2){
                            if (index == 0) {
                                [nsvideoView mas_remakeConstraints:^(MASConstraintMaker *make) {
                                    make.centerX.mas_equalTo(self.mas_centerX).offset(-Screen_Width/4);
                                    make.centerY.mas_equalTo(self.mas_centerY).offset(0);
                                    make.width.mas_equalTo(Screen_Width/2);
                                    make.height.mas_equalTo(Screen_Height);
                                }];
                                
                            }else if(index == 1){
                                
                                [nsvideoView mas_remakeConstraints:^(MASConstraintMaker *make) {
                                    make.centerX.mas_equalTo(self.mas_centerX).offset(Screen_Width/4);
                                    make.centerY.mas_equalTo(self.mas_centerY).offset(0);
                                    make.width.mas_equalTo(Screen_Width/2);
                                    make.height.mas_equalTo(Screen_Height);
                                }];
                            }
                            [nsvideoView showVideoViewDirectionLeft:YES];
                        }
                        else if(number == TRTCVideoRenderNumber3){
                            if (index == 0) {
                                [nsvideoView mas_remakeConstraints:^(MASConstraintMaker *make) {
                                    make.centerX.mas_equalTo(self.mas_centerX).offset(-Screen_Width/4);
                                    make.centerY.mas_equalTo(self.mas_centerY).offset(0);
                                    make.width.mas_equalTo(Screen_Width/2);
                                    make.height.mas_equalTo(Screen_Height);
                                }];
                                
                            }else if(index == 1){
                                
                                [nsvideoView mas_remakeConstraints:^(MASConstraintMaker *make) {
                                    make.centerX.mas_equalTo(self.mas_centerX).offset(Screen_Width/4);
                                    make.top.mas_equalTo(self.mas_top).offset(0);
                                    make.width.mas_equalTo(Screen_Width/2);
                                    make.height.mas_equalTo(Screen_Height/2);
                                }];
                            }else if(index == 2){
                                [nsvideoView mas_remakeConstraints:^(MASConstraintMaker *make) {
                                    make.centerX.mas_equalTo(self.mas_centerX).offset(Screen_Width/4);
                                    make.top.mas_equalTo(self.mas_top).offset(Screen_Height/2);
                                    make.width.mas_equalTo(Screen_Width/2);
                                    make.height.mas_equalTo(Screen_Height/2);
                                }];
                            }
                            [nsvideoView showVideoViewDirectionLeft:YES];
                        }
                        else if(number >= TRTCVideoRenderNumber4){
                            if (index == 0) {
                                [nsvideoView mas_remakeConstraints:^(MASConstraintMaker *make) {
                                    make.centerX.mas_equalTo(self.mas_centerX).offset(-Screen_Width/4);
                                    make.top.mas_equalTo(self.mas_top).offset(0);
                                    make.width.mas_equalTo(Screen_Width/2);
                                    make.height.mas_equalTo(Screen_Height/2);
                                }];
                                
                            }else if(index == 1){
                                
                                [nsvideoView mas_remakeConstraints:^(MASConstraintMaker *make) {
                                    make.centerX.mas_equalTo(self.mas_centerX).offset(Screen_Width/4);
                                    make.top.mas_equalTo(self.mas_top).offset(0);
                                    make.width.mas_equalTo(Screen_Width/2);
                                    make.height.mas_equalTo(Screen_Height/2);
                                }];
                            }else if(index == 2){
                                
                                [nsvideoView mas_remakeConstraints:^(MASConstraintMaker *make) {
                                    make.centerX.mas_equalTo(self.mas_centerX).offset(-Screen_Width/4);
                                    make.top.mas_equalTo(self.mas_top).offset(Screen_Height/2);
                                    make.width.mas_equalTo(Screen_Width/2);
                                    make.height.mas_equalTo(Screen_Height/2);
                                }];
                            }else if(index == 3){
                                
                                [nsvideoView mas_remakeConstraints:^(MASConstraintMaker *make) {
                                    make.centerX.mas_equalTo(self.mas_centerX).offset(Screen_Width/4);
                                    make.top.mas_equalTo(self.mas_top).offset(Screen_Height/2);
                                    make.width.mas_equalTo(Screen_Width/2);
                                    make.height.mas_equalTo(Screen_Height/2);
                                }];
                            }
                            [nsvideoView showVideoViewDirectionLeft:YES];
                        }
                        else if(number > TRTCVideoRenderNumber4){
                            if (index == 0) {
                                [nsvideoView mas_remakeConstraints:^(MASConstraintMaker *make) {
                                    make.top.mas_equalTo(self.mas_safeAreaLayoutGuideTop).offset(0);
                                    make.left.mas_equalTo(self.mas_safeAreaLayoutGuideLeft).offset(0);
                                    make.right.mas_equalTo(self.renderViewCollectionView.mas_left).offset(0);
                                    make.bottom.mas_equalTo(self.mas_safeAreaLayoutGuideBottom).offset(0);
                                }];
                                [nsvideoView showVideoViewDirectionLeft:YES];
                            }else{
//                                NSMutableArray *newrenderArr = [NSMutableArray arrayWithArray:self.renderArray];
//                                [newrenderArr removeObjectAtIndex:0];
//                                self.renderViewCollectionView.renderViewsArray = newrenderArr;
                                [self.renderViewCollectionView setUserVideoCell:index renderArray:array];
                            }
                        }
                        
                       
                    }else{
                        //判断是几个人
                        if (number == TRTCVideoRenderNumber1) {
                            [nsvideoView mas_remakeConstraints:^(MASConstraintMaker *make) {
                                make.centerX.mas_equalTo(self.mas_centerX).offset(0);
                                make.centerY.mas_equalTo(self.mas_centerY).offset(0);
                                make.width.mas_equalTo(Adapt(100));
                                make.height.mas_equalTo(Adapt(100));
                            }];
                            [nsvideoView initHideUIDirectionLeft:NO];
                        }
                        else if(number == TRTCVideoRenderNumber2){
                            if (index == 0) {
                                [nsvideoView mas_remakeConstraints:^(MASConstraintMaker *make) {
                                    make.centerX.mas_equalTo(self.mas_centerX).offset(-Screen_Width/4);
                                    make.centerY.mas_equalTo(self.mas_centerY).offset(0);
                                    make.width.mas_equalTo(Adapt(100));
                                    make.height.mas_equalTo(Adapt(100));
                                }];
                                
                            }else if(index == 1){
                                
                                [nsvideoView mas_remakeConstraints:^(MASConstraintMaker *make) {
                                    make.centerX.mas_equalTo(self.mas_centerX).offset(Screen_Width/4);
                                    make.centerY.mas_equalTo(self.mas_centerY).offset(0);
                                    make.width.mas_equalTo(Adapt(100));
                                    make.height.mas_equalTo(Adapt(100));
                                }];
                            }
                            [nsvideoView initHideUIDirectionLeft:NO];
                        }
                        else if(number == TRTCVideoRenderNumber3){
                            if (index == 0) {
                                [nsvideoView mas_remakeConstraints:^(MASConstraintMaker *make) {
                                    make.centerX.mas_equalTo(self.mas_centerX).offset(-Screen_Width/4);
                                    make.centerY.mas_equalTo(self.mas_centerY).offset(-Adapt(15));
                                    make.width.mas_equalTo(Adapt(100));
                                    make.height.mas_equalTo(Adapt(100));
                                }];
                                
                            }else if(index == 1){
                                
                                [nsvideoView mas_remakeConstraints:^(MASConstraintMaker *make) {
                                    make.centerX.mas_equalTo(self.mas_centerX).offset(Screen_Width/4);
                                    make.top.mas_equalTo(self.mas_top).offset((Screen_Height/2-Adapt(100))/2);
                                    make.width.mas_equalTo(Adapt(100));
                                    make.height.mas_equalTo(Adapt(100));
                                }];
                            }else if(index == 2){
                                
                                [nsvideoView mas_remakeConstraints:^(MASConstraintMaker *make) {
                                    make.centerX.mas_equalTo(self.mas_centerX).offset(Screen_Width/4);
                                    make.top.mas_equalTo(self.mas_top).offset(Screen_Height/2+Adapt(50));
                                    make.width.mas_equalTo(Adapt(100));
                                    make.height.mas_equalTo(Adapt(100));
                                }];
                            }
                            [nsvideoView initHideUIDirectionLeft:NO];
                        }
                        else if(number == TRTCVideoRenderNumber4){
                            if (index == 0) {
                                [nsvideoView mas_remakeConstraints:^(MASConstraintMaker *make) {
                                    make.centerX.mas_equalTo(self.mas_centerX).offset(-Screen_Width/4);
                                    make.top.mas_equalTo(self.mas_top).offset((Screen_Height/2-Adapt(100))/2);
                                    make.width.mas_equalTo(Adapt(100));
                                    make.height.mas_equalTo(Adapt(100));
                                }];
                                
                            }else if(index == 1){
                                
                                [nsvideoView mas_remakeConstraints:^(MASConstraintMaker *make) {
                                    make.centerX.mas_equalTo(self.mas_centerX).offset(Screen_Width/4);
                                    //            make.centerY.mas_equalTo(self.mas_centerY).offset(-(Screen_Height-Adapt(60))/4);
                                    make.top.mas_equalTo(self.mas_top).offset((Screen_Height/2-Adapt(100))/2);
                                    make.width.mas_equalTo(Adapt(100));
                                    make.height.mas_equalTo(Adapt(100));
                                }];
                            }else if(index == 2){
                                
                                [nsvideoView mas_remakeConstraints:^(MASConstraintMaker *make) {
                                    make.centerX.mas_equalTo(self.mas_centerX).offset(-Screen_Width/4);
                                    make.top.mas_equalTo(self.mas_top).offset(Screen_Height/2+Adapt(50));
                                    make.width.mas_equalTo(Adapt(100));
                                    make.height.mas_equalTo(Adapt(100));
                                }];
                            }else if(index == 3){
                                
                                [nsvideoView mas_remakeConstraints:^(MASConstraintMaker *make) {
                                    make.centerX.mas_equalTo(self.mas_centerX).offset(Screen_Width/4);
                                    make.top.mas_equalTo(self.mas_top).offset(Screen_Height/2+Adapt(50));
                                    make.width.mas_equalTo(Adapt(100));
                                    make.height.mas_equalTo(Adapt(100));
                                }];
                            }
                            [nsvideoView initHideUIDirectionLeft:NO];
                        } else if(number > TRTCVideoRenderNumber4){
                            if (index == 0) {
                                [nsvideoView mas_remakeConstraints:^(MASConstraintMaker *make) {
                                    make.left.mas_equalTo(self.mas_safeAreaLayoutGuideLeft).offset((Screen_Width-kTopHeight- Adapt(132))/2-Adapt(100)/2);
                                    make.top.mas_equalTo(self.mas_safeAreaLayoutGuideTop).offset((Screen_Height-Adapt(60)-Adapt(60))/2-Adapt(100)/2);
                                    make.width.mas_equalTo(Adapt(100));
                                    make.height.mas_equalTo(Adapt(100));
                                }];
                                [nsvideoView initHideUIDirectionLeft:NO];
                            }else{
//                                NSMutableArray *newrenderArr = [NSMutableArray arrayWithArray:self.renderArray];
//                                [newrenderArr removeObjectAtIndex:0];
//                                self.renderViewCollectionView.renderViewsArray = newrenderArr;
                                [self.renderViewCollectionView setUserVideoCell:index renderArray:array];
                            }
                        }
                        
                    }
                }
                
            }else if([svideoView isKindOfClass:[TXTVideoCollectionView class]]){
//                NSMutableArray *newrenderArr = [NSMutableArray arrayWithArray:self.renderArray];
//                [newrenderArr removeObjectAtIndex:0];
//                self.renderViewCollectionView.renderViewsArray = newrenderArr;
                [self.renderViewCollectionView setUserVideoCell:index renderArray:array];
            }
        }
       
    }
}

@end
