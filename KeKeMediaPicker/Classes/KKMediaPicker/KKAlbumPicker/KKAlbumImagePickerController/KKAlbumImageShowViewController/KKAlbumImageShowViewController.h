//
//  KKAlbumImageShowViewController.h
//  HeiPa
//
//  Created by liubo on 2019/3/16.
//  Copyright © 2019 gouuse. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KKMediaPickerDefine.h"
#import "KKAlbumImagePickerManager.h"
#import "KKMediaPickerBaseViewController.h"

#pragma mark ==================================================
#pragma mark == KKAlbumImageShowViewControllerDelegate
#pragma mark ==================================================
@protocol KKAlbumImageShowViewControllerDelegate <NSObject>
@required

- (void)KKAlbumImageShowViewController_ClickedModal:(KKAlbumAssetModal*)aModal;

@end



@interface KKAlbumImageShowViewController : KKMediaPickerBaseViewController

@property (nonatomic , weak) id<KKAlbumImageShowViewControllerDelegate> delegate;

/* 初始化 */
- (instancetype)initWithArray:(NSArray*)aImageArray
                  selectIndex:(NSInteger)aIndex;

@end
