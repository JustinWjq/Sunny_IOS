//
//  TXTMemberView.h
//  TXTWhiteBoard
//
//  Created by jiangyongjian on 2022/11/5.
//  Copyright © 2022 洪青文. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol TXTMemberViewDelegate <NSObject>

@optional

/// 点击关闭
- (void)memberViewDidClickCloseBtn:(UIButton *)closeBtn;
@end

@interface TXTMemberView : UIView

/** delegate */
@property (nonatomic, weak) id<TXTMemberViewDelegate> delegate;

/** dataArray */
@property (nonatomic, strong) NSMutableArray *manageMembersArr;

- (void)updateUI:(BOOL)isPortrait;

@end

NS_ASSUME_NONNULL_END
