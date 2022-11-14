//
//  TXTEmojiView.m
//  TXTWhiteBoard
//
//  Created by jiangyongjian on 2022/11/4.
//  Copyright © 2022 洪青文. All rights reserved.
//

#import "TXTEmojiView.h"
#import "TXTEmojiCollectionViewCell.h"
#import "QSTapGestureRecognizer.h"


static NSString  *const kEmojiCollectionViewCell = @"TXTEmojiCollectionViewCell";
@interface TXTEmojiView ()<UICollectionViewDelegate, UICollectionViewDataSource>

/** collectionView */
@property (nonatomic, strong) UICollectionView *collectionView;

/** dataArray */
@property (nonatomic, strong) NSMutableArray *dataArray;

///** fromView */
//@property (nonatomic, strong) UIView *fromView;
@end

@implementation TXTEmojiView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

#pragma mark - Setup UI
/**
 *  setupUI
 */
- (void)setupUI {
    [self addSubview:self.collectionView];
//    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self);
//    }];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_safeAreaLayoutGuideLeft).offset(15);
        make.height.mas_equalTo(160);
        make.width.mas_equalTo(345);
        make.bottom.equalTo(self.mas_safeAreaLayoutGuideBottom).offset(-75 - 10 - 34);
    }];
//    QSTapGestureRecognizer *gesture = [[QSTapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
//    [self addGestureRecognizer:gesture];
    [self addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - 🍐delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    // 1. 创建一个Cell
    TXTEmojiCollectionViewCell *cell =  [collectionView dequeueReusableCellWithReuseIdentifier:kEmojiCollectionViewCell forIndexPath:indexPath];
    cell.text = self.dataArray[indexPath.row];
    // 2. 返回一个Cell
    return cell;
}

/**
 * 点击collectionView
 */
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    TXTEmojiCollectionViewCell *cell = (TXTEmojiCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if ([self.delegate respondsToSelector:@selector(emojiViewDidClickEmoji:)]) {
//        NSString *str = [cell.text stringByReplacingOccurrencesOfString:@"U+" withString:@""];
//        NSString *emojiStr = [NSString emojiWithStringCode:str];
        [self.delegate emojiViewDidClickEmoji:cell.text];
    }
}


/**
 *  显示
 */
- (void)showFromView:(UIView *)fromView {
//    self.fromView = fromView;
    // 1获得最上面的窗口
    UIWindow *window = [UIWindow getKeyWindow];
    // 2添加自己到窗口上去
    [window addSubview:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(window);
    }];
    
    // 3设置frame
//    self.frame = window.bounds;
//    QSLog(@"%@", NSStringFromCGRect(fromView.frame));
//    // 4.调整灰色图片的位置
//    // 转换坐标系
////    CGRect newFrame = [from convertRect:from.bounds toView:window];
//    CGRect newFrame = [fromView.superview convertRect:fromView.frame toView:window];
//    QSLog(@"%@", NSStringFromCGRect(newFrame));
//
//    //        make.left.equalTo(self.smallChatView);
//    //        make.height.mas_equalTo(160);
//    //        make.bottom.equalTo(self.smallChatView.mas_top).offset(-10);
//    //        make.width.mas_equalTo(345);
//    self.collectionView.frame = CGRectMake(0, 0, 345, 160);
//    self.collectionView.y = CGRectGetMinY(newFrame) - 10 - self.collectionView.height;
//    self.collectionView.x = CGRectGetMinX(newFrame);
    
//    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.mas_safeAreaLayoutGuideLeft).offset(15);
//        make.height.mas_equalTo(160);
//        make.width.mas_equalTo(345);
//        make.bottom.equalTo(self.mas_safeAreaLayoutGuideBottom).offset(-75 - 10 - 34);
//    }];
}

/**
 *  销毁
 */
- (void)dismiss {
    [self removeFromSuperview];
}

- (void)updateUI {
    
//    // 1获得最上面的窗口
//    UIWindow *window = [UIWindow getKeyWindow];
//    // 3设置frame
//    self.frame = window.bounds;
//    QSLog(@"%@", NSStringFromCGRect(self.fromView.frame));
//    // 4.调整灰色图片的位置
//    // 转换坐标系
////    CGRect newFrame = [from convertRect:from.bounds toView:window];
//    CGRect newFrame = [self.fromView.superview convertRect:self.fromView.frame toView:window];
//    QSLog(@"%@", NSStringFromCGRect(newFrame));
//
//    //        make.left.equalTo(self.smallChatView);
//    //        make.height.mas_equalTo(160);
//    //        make.bottom.equalTo(self.smallChatView.mas_top).offset(-10);
//    //        make.width.mas_equalTo(345);
//    self.collectionView.frame = CGRectMake(0, 0, 345, 160);
//    self.collectionView.y = CGRectGetMinY(newFrame) - 10 - self.collectionView.height;
//    self.collectionView.x = CGRectGetMinX(newFrame);
//    if (isPortrait) {
//
//    } else {
//
//    }
}

- (UICollectionView *)collectionView  {
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        //cell间距
        flowLayout.minimumInteritemSpacing = 0;
        //cell行距
        flowLayout.minimumLineSpacing = 0;
        
        double width = 345 / 6.0;
        double height = 160 / 3.0;
        // 修改属性
        flowLayout.itemSize = CGSizeMake(width, height);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.userInteractionEnabled = YES;
        [_collectionView registerClass:[TXTEmojiCollectionViewCell class] forCellWithReuseIdentifier:kEmojiCollectionViewCell];
        if (@available(iOS 10.0, *)) {
            [_collectionView setPrefetchingEnabled:NO];
        }
        if (@available(iOS 11.0, *)) {
            self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        // 设置数据源对象
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.bounces  = false;
        _collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.backgroundColor = [UIColor colorWithHexString:@"000000" alpha:0.74];
        _collectionView.cornerRadius = 8;
    }
    return _collectionView;
}


- (NSMutableArray *)dataArray {
    if (!_dataArray) {
//        @"U+1F604",@"U+1F923",@"U+1F602",@"U+1F606",@"U+1F914",@"U+1F631",@"U+1F625",@"U+1F62D",@"U+1F44F",@"U+1F44B",@"U+1F44D",@"U+1F91D",@"U+1F44C",@"U+1F4AA",@"U+1F64F",@"U+270A",@"U+1F919"
        self.dataArray = [NSMutableArray arrayWithArray:@[@"😄",@"🤣",@"😂",@"😆",@"🤔",@"😱",@"😥",@"😭",@"👏",@"👋",@"👍",@"🤝",@"✌️",@"👌",@"💪",@"🙏",@"✊",@"🤙"]];
    }
    return _dataArray;
}
@end
