//
//  SunnyChatViewController.h
//  TXTWhiteBoard
//
//  Created by 洪青文 on 2022/10/21.
//  Copyright © 2022 洪青文. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TXTManage.h"
#import "TXTFileModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SunnyChatViewController : UIViewController

/**
 *  fileType 文件类型
 *  fileModel 文件数据
 */
- (void)addFile:(FileType)fileType fileModel:(TXTFileModel *)fileModel;

- (void)hideShareScreenWebView;

- (void)doRotate:(BOOL)isLandscape;

@end

NS_ASSUME_NONNULL_END
