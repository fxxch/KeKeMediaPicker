//
//  KKAlbumImagePickerController.h
//  HeiPa
//
//  Created by liubo on 2019/3/12.
//  Copyright © 2019 gouuse. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KKMediaPickerDefine.h"
#import "KKAlbumImagePickerManager.h"
#import "KKMediaPickerBaseNavigationController.h"

@interface KKAlbumImagePickerController : KKMediaPickerBaseNavigationController


/// 初始化
/// @param aDelegate 代理
/// @param aNumberOfPhotosNeedSelected 可以选择的照片的最大数量
/// @param aCropEnable 是否需要裁剪，仅在拍摄数量为1的时候有效（即numberOfPhotosNeedSelected为1的时候有效）
/// @param aCropSize 图片的裁剪大小，仅在拍摄数量为1的时候有效（即numberOfPhotosNeedSelected为1的时候有效）
/// @param aMediaType 选择资源类型
- (instancetype)initWithDelegate:(id<KKAlbumImagePickerDelegate>)aDelegate
      numberOfPhotosNeedSelected:(NSInteger)aNumberOfPhotosNeedSelected
                      cropEnable:(BOOL)aCropEnable
                        cropSize:(CGSize)aCropSize
                  assetMediaType:(KKAssetMediaType)aMediaType;

@end
