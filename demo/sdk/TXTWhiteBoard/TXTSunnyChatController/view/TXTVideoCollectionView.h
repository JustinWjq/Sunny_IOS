//
//  TXTVideoCollectionView.h
//  TICDemo
//
//  Created by 洪青文 on 2020/9/8.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol TXTVideoCollectionViewDelegate <NSObject>

- (void)selectBigVideo:(NSInteger)row;

@end

@interface TXTVideoCollectionView : UIView
@property (assign, nonatomic) id<TXTVideoCollectionViewDelegate>delegate;
@property (strong, nonatomic) NSArray *renderViewsArray;
@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) NSArray *userVolumesArray;
@property (assign, nonatomic) BOOL isHorizontal;//是否水平
- (void)setUserVideoCell:(NSInteger)index;
@end

NS_ASSUME_NONNULL_END
