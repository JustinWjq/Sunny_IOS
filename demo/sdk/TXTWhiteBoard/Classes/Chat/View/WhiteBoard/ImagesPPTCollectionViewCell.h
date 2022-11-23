//
//  ImagesPPTCollectionViewCell.h
//  TICDemo
//
//  Created by 洪青文 on 2020/9/1.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class ImagesPPTCollectionViewCell;

@protocol ImagesPPTCollectionViewCellDelegate <NSObject>

- (void)collectionViewCellselectImage:(ImagesPPTCollectionViewCell *)cell;

@end

@interface ImagesPPTCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) UIImageView *pptImg;
@property (strong, nonatomic) UILabel *pptNum;

@property (assign, nonatomic) id<ImagesPPTCollectionViewCellDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
