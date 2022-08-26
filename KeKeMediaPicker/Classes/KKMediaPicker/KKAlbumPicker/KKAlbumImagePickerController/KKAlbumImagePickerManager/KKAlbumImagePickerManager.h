//
//  KKAlbumImagePickerManager.h
//  HeiPa
//
//  Created by liubo on 2019/3/15.
//  Copyright © 2019 gouuse. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KKAlbumManager.h"
#import "KKAlbumImagePickerController.h"

UIKIT_EXTERN NSNotificationName const NotificationName_KKAlbumImagePickerSelectModel;
UIKIT_EXTERN NSNotificationName const NotificationName_KKAlbumImagePickerUnSelectModel;
UIKIT_EXTERN NSNotificationName const NotificationName_KKAlbumManagerLoadSourceFinished;
UIKIT_EXTERN NSNotificationName const NotificationName_KKAlbumManagerDataSourceChanged;
UIKIT_EXTERN NSNotificationName const NotificationName_KKAlbumManagerIsSelectOriginChanged;
UIKIT_EXTERN NSNotificationName const NotificationName_KKAlbumAssetModelEditImageFinished;

@interface KKAlbumImagePickerManager : NSObject

/* 选取的照片最大数量 */
@property (nonatomic,assign)NSInteger numberOfPhotosNeedSelected;

/* 是否需要裁剪，仅在拍摄数量为1的时候有效（即numberOfPhotosNeedSelected为1的时候有效） */
@property (nonatomic,assign)BOOL cropEnable;

/* 图片的裁剪大小，仅在拍摄数量为1的时候有效（即numberOfPhotosNeedSelected为1的时候有效） */
@property (nonatomic,assign)CGSize cropSize;

/* 选择的类型 */
@property (nonatomic,assign)KKAssetMediaType mediaType;

/* 是否选择原图 */
@property (nonatomic,assign)BOOL isSelectOrigin;

///* KKAlbumImagePickerDelegate */
@property(nonatomic,weak)id<KKAlbumImagePickerDelegate> delegate;

+ (KKAlbumImagePickerManager*)defaultManager;

- (void)finishedWithNavigationController:(UINavigationController*)aNavigationController;

#pragma mark ==================================================
#pragma mark == 选择
#pragma mark ==================================================
- (void)selectAssetModel:(KKAlbumAssetModel*)aModel;

- (void)deselectAssetModel:(KKAlbumAssetModel*)aModel;

- (BOOL)isSelectAssetModel:(KKAlbumAssetModel*)aModel;

- (void)clearAllObjects;

- (NSArray*)allSource;

@end
