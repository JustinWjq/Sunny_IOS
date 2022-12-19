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

#define imageWidth Adapt(70)
//
#define imageHeight Adapt(90)
#define ReuseIdentifier @"videoCell"
@interface TXTVideoCollectionView()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@end

@implementation TXTVideoCollectionView

- (instancetype)init{
    self = [super init];
    if (self) {
        [self config];
    }
    return self;
}

- (void)setRenderViewsArray:(NSArray *)renderViewsArray{
    _renderViewsArray = renderViewsArray;
    [_collectionView reloadData];
}

- (void)setUserVolumesArray:(NSArray *)userVolumesArray renderArray:(NSArray *)array{
//    self.renderViewsArray = array;
    _userVolumesArray = userVolumesArray;
    for (TRTCVolumeInfo *info in _userVolumesArray) {
        for (int i = 0; i < array.count; i++) {
            TXTUserModel *model = array[i];
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

- (void)setUserVideoCell:(NSInteger)index renderArray:(NSArray *)array{
    if (array.count < 1) {
        return;
    }
    TXTUserModel *model = array[index];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(index) inSection:0];
    TXTVideoCollectionViewCell *cell = (TXTVideoCollectionViewCell *)[_collectionView cellForItemAtIndexPath:indexPath];
    [cell reloadVideo:model];
}


- (void)config{
    if(!_collectionView) {
        NSLog(@"config_collectionView");
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 1;
        NSString *direction = TXUserDefaultsGetObjectforKey(Direction);
        if ([direction integerValue] == TRTCVideoResolutionModePortrait) {
            layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
            _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, imageHeight) collectionViewLayout:layout];
        }else{
            layout.scrollDirection = UICollectionViewScrollDirectionVertical;
            _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, Adapt(132), Screen_Height) collectionViewLayout:layout];
        }
        [self addSubview:_collectionView];
        _collectionView.backgroundColor = [UIColor colorWithHexString:@"#222222"];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[TXTVideoCollectionViewCell class] forCellWithReuseIdentifier:ReuseIdentifier];
    }else{
        [_collectionView reloadData];
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.renderViewsArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    TXTVideoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ReuseIdentifier forIndexPath:indexPath];
    NSString *direction = TXUserDefaultsGetObjectforKey(Direction);
    if ([direction integerValue] == TRTCVideoResolutionModePortrait) {
        [cell configVideoCell:self.renderViewsArray[indexPath.row] Width:imageWidth Height:Adapt(100) VoiceVolume:self.userVolumesArray];
    }else{
        [cell configVideoCell:self.renderViewsArray[indexPath.row] Width:Adapt(132) Height:Adapt(100) VoiceVolume:self.userVolumesArray];
    }
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *direction = TXUserDefaultsGetObjectforKey(Direction);
    if ([direction integerValue] == TRTCVideoResolutionModePortrait) {
        return CGSizeMake(imageWidth,self.frame.size.height);
    }else{
        return CGSizeMake(Adapt(132),Adapt(100));
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 1;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 1;
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 1, 0, 0);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%ld",indexPath.row);
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectBigVideo:)]) {
        [self.delegate selectBigVideo:indexPath.row];
    }
}
@end
