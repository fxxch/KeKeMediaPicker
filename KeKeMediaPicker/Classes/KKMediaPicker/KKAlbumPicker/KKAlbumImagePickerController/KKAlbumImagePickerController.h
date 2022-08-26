//
//  KKAlbumImagePickerController.h
//  HeiPa
//
//  Created by liubo on 2019/3/12.
//  Copyright © 2019 gouuse. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KKMediaPickerBaseNavigationController.h"
#import "KKAlbumManager.h"

@class KKAlbumAssetModel;

@protocol KKAlbumImagePickerDelegate <NSObject,UINavigationControllerDelegate>
@optional

/// 选择图片之后，可自定义保存的路径，不过实现该方法（不自定义），内部会自动存储在一个地方
/// @param fileName 文件名 eg: happy.jpg
/// @param aExtentionName 文件扩展名 ex: jpg
- (NSURL*)KKAlbumImagePicker_fileURLForSave:(NSString*)fileName
                          fileExtentionName:(NSString*)aExtentionName;


/// 对已经选择的图片进行压缩的时候，可自定义保存的路径，不过实现该方法（不自定义），内部会自动存储在一个地方
/// @param fileName 文件名 eg: happy.jpg
/// @param aExtentionName 文件扩展名 ex: jpg
- (NSURL*)KKAlbumImagePicker_fileURLForCompress:(NSString*)fileName
                              fileExtentionName:(NSString*)aExtentionName;

- (void)KKAlbumImagePicker_didFinishedPickImages:(NSArray<KKAlbumAssetModel*>*)aImageArray;

@end

@interface KKAlbumImagePickerController : KKMediaPickerBaseNavigationController<KKAlbumImagePickerDelegate>


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
