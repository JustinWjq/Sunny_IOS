//
//  ImagesPPTCollectionView.m
//  TICDemo
//
//  Created by 洪青文 on 2020/9/1.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import "ImagesPPTCollectionView.h"
#import "ImagesPPTCollectionViewCell.h"
#import "UIImageView+WebCache.h"
#import "QSTapGestureRecognizer.h"



static NSString  *const kPptCellCollectionViewCell = @"pptCell";

#define imageWidth self.frame.size.width/4.5
@interface ImagesPPTCollectionView ()<UICollectionViewDelegate,UICollectionViewDataSource, ImagesPPTCollectionViewCellDelegate>

@property (strong, nonatomic) UICollectionView *collectionView;

@end

@implementation ImagesPPTCollectionView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self addSubview:self.collectionView];
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
//        self.collectionView.userInteractionEnabled = YES;
//        QSTapGestureRecognizer *contentviewTap = [[QSTapGestureRecognizer alloc] initWithTarget:self action:@selector(tipClick)];
//        [self addGestureRecognizer:contentviewTap];
    }
    return self;
   
}


- (void)setImagesArray:(NSArray *)imagesArray{
    _imagesArray = imagesArray;
//    [self config];
    [_collectionView reloadData];
}


- (void)config {
//    if(!_collectionView) {
//
//        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        }];
//    }else{
//
//    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.imagesArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ImagesPPTCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kPptCellCollectionViewCell forIndexPath:indexPath];
    cell.pptNum.text = [NSString stringWithFormat:@"%ld",indexPath.row+1];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"txtBundle" ofType:@"bundle"];
    NSBundle *SDKBundle = [NSBundle bundleWithPath:path];
    [cell.pptImg sd_setImageWithURL:[NSURL URLWithString:self.imagesArray[indexPath.row]] placeholderImage:[UIImage imageNamed:@"default" inBundle:SDKBundle compatibleWithTraitCollection:nil]];
    cell.delegate = self;
    return cell;
}

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
//    return CGSizeMake(imageWidth,self.frame.size.height);
//}
//
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
//    return 5;
//}
//
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
//    return 5;
//}
//
//-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
//    return UIEdgeInsetsMake(0, 5, 0, 0);
//}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%ld",indexPath.row);
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectImage:)]) {
        [self.delegate selectImage:indexPath.row];
    }
}

- (void)collectionViewCellselectImage:(ImagesPPTCollectionViewCell *)cell {
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectImage:)]) {
        NSLog(@"%ld", [cell.pptNum.text integerValue] - 1);
        [self.delegate selectImage:[cell.pptNum.text integerValue] - 1];
    }
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        //cell间距
        flowLayout.minimumInteritemSpacing = 0;
        //cell行距
        flowLayout.minimumLineSpacing = 0;
        // 修改属性
        flowLayout.itemSize = CGSizeMake(83, 90);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.userInteractionEnabled = YES;
        [_collectionView registerClass:[ImagesPPTCollectionViewCell class] forCellWithReuseIdentifier:kPptCellCollectionViewCell];
        if (@available(iOS 10.0, *)) {
            [_collectionView setPrefetchingEnabled:NO];
        }
        if (@available(iOS 11.0, *)) {
            _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        // 设置数据源对象
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.bounces  = false;
        _collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    return _collectionView;
}

@end
