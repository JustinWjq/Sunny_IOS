//
//  ImagesPPTCollectionView.h
//  TICDemo
//
//  Created by 洪青文 on 2020/9/1.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ImagesPPTCollectionViewDelegate <NSObject>

- (void)selectImage:(NSInteger)index;

@end

@interface ImagesPPTCollectionView : UIView
@property (assign, nonatomic) id<ImagesPPTCollectionViewDelegate>delegate;
@property (strong, nonatomic) NSArray *imagesArray;

@end

NS_ASSUME_NONNULL_END
