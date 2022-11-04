//
//  TXTVideoCollectionView.m
//  TICDemo
//
//  Created by 洪青文 on 2020/9/8.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import "TXTVideoCollectionView.h"
#import "TXTVideoCollectionViewCell.h"
#import "TICRenderView.h"
#import "TXTUserModel.h"

#define imageWidth self.frame.size.width/4.2
@interface TXTVideoCollectionView()<UICollectionViewDelegate,UICollectionViewDataSource>

@end

@implementation TXTVideoCollectionView

- (instancetype)init{
    self = [super init];
    if (self) {
//        _collectionView = [[UICollectionView alloc] init];
//        [self config];
    }
    return self;
}

- (void)setRenderViewsArray:(NSArray *)renderViewsArray{
    _renderViewsArray = renderViewsArray;
    [self config];
//    [_collectionView reloadData];
}

- (void)setUserVolumesArray:(NSArray *)userVolumesArray{
//    NSLog(@"setUserVolumesArray");
    _userVolumesArray = userVolumesArray;
    for (TRTCVolumeInfo *info in _userVolumesArray) {
        for (int i = 0; i < self.renderViewsArray.count; i++) {
            TXTUserModel *model = self.renderViewsArray[i];
            TICRenderView *render = model.render;
           if ([info.userId isEqualToString:render.userId]) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                TXTVideoCollectionViewCell *cell = (TXTVideoCollectionViewCell *)[_collectionView cellForItemAtIndexPath:indexPath];
                [cell reloadAudio:info Model:model];
            }else if (info.userId == nil && [model.userRole isEqualToString:@"owner"]){
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                TXTVideoCollectionViewCell *cell = (TXTVideoCollectionViewCell *)[_collectionView cellForItemAtIndexPath:indexPath];
                [cell reloadAudio:info Model:model];
            }
        }
    }
}


- (void)config{
    if(!_collectionView) {
        NSLog(@"config_collectionView");
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 1;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) collectionViewLayout:layout];
        [self addSubview:_collectionView];
        _collectionView.backgroundColor = [UIColor orangeColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
//        NSString *path = [[NSBundle mainBundle] pathForResource:@"txtBundle" ofType:@"bundle"];
//        NSBundle *SDKBundle = [NSBundle bundleWithPath:path];
//        [_collectionView registerNib:[UINib nibWithNibName:@"TXTVideoCollectionViewCell" bundle:SDKBundle] forCellWithReuseIdentifier:@"videoCell"];
//        TXTVideoCollectionViewCell *cell = [[TXTVideoCollectionViewCell alloc] init];
        [_collectionView registerClass:[TXTVideoCollectionViewCell class] forCellWithReuseIdentifier:@"videoCell"];
    }else{
        [_collectionView reloadData];
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.renderViewsArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    TXTVideoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"videoCell" forIndexPath:indexPath];
    [cell configVideoCell:self.renderViewsArray[indexPath.row] Width:imageWidth Height:self.frame.size.height VoiceVolume:self.userVolumesArray];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
//    NSLog(@"collectionView == %f",self.frame.size.height);
    return CGSizeMake(imageWidth,self.frame.size.height);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 5;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 5;
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 5, 0, 0);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%ld",indexPath.row);
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectBigVideo:)]) {
        [self.delegate selectBigVideo:indexPath.row];
    }
}
@end
