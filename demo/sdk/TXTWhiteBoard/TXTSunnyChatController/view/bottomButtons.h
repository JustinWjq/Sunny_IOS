//
//  bottomButtons.h
//  TXTWhiteBoard
//
//  Created by 洪青文 on 2022/10/24.
//  Copyright © 2022 洪青文. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol bottomButtonsDelegate <NSObject>

- (void)bottomButtonClick;
- (void)bottomMuteClick;
- (void)bottomShareFileButtonClick;
- (void)bottomMembersButtonClick;
- (void)bottomShareSceneButtonClick;
- (void)bottomMoreActionButtonClick;

@end

@interface bottomButtons : UIView
@property (weak, nonatomic) id<bottomButtonsDelegate>delegate;
@property (strong, nonatomic) UIButton *txVideoButton;//摄像头
@property (strong, nonatomic) UIButton *txMuteButton;//麦克风
@property (strong, nonatomic) UIButton *txShareFileButton;//共享
@property (strong, nonatomic) UIButton *txMembersButton;//成员
@property (strong, nonatomic) UIButton *txShareSceneButton;//录制
@property (strong, nonatomic) UIButton *txMoreActionButton;//更多

- (void)changeVideoButtonStatus:(BOOL)open;
- (void)changeAudioButtonStatus:(BOOL)open;
@end


