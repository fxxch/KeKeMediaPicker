//
//  KKAlbumImagePickerManager.m
//  HeiPa
//
//  Created by liubo on 2019/3/15.
//  Copyright © 2019 gouuse. All rights reserved.
//

#import "KKAlbumImagePickerManager.h"
#import "KKMediaPickerWatingView.h"
#import "UIWindow+KKMediaPicker.h"
#import "UIImage+KKMediaPicker.h"
#import "NSString+KKMediaPicker.h"
#import "KKAlbumManager.h"

NSNotificationName const NotificationName_KKAlbumImagePickerSelectModel  = @"NotificationName_KKAlbumImagePickerSelectModel";
NSNotificationName const NotificationName_KKAlbumImagePickerUnSelectModel  = @"NotificationName_KKAlbumImagePickerUnSelectModel";
NSNotificationName const NotificationName_KKAlbumManagerLoadSourceFinished  = @"NotificationName_KKAlbumManagerLoadSourceFinished";
NSNotificationName const NotificationName_KKAlbumManagerDataSourceChanged  = @"NotificationName_KKAlbumManagerDataSourceChanged";
NSNotificationName const NotificationName_KKAlbumManagerIsSelectOriginChanged  = @"NotificationName_KKAlbumManagerIsSelectOriginChanged";
NSNotificationName const NotificationName_KKAlbumAssetModelEditImageFinished  = @"NotificationName_KKAlbumAssetModelEditImageFinished";

@interface KKAlbumImagePickerManager ()

@property (nonatomic,weak)UINavigationController *navigationController;

/* 选中的图片 */
@property(nonatomic,strong)NSMutableArray *selectDataSource;

@end


@implementation KKAlbumImagePickerManager

+ (KKAlbumImagePickerManager *)defaultManager{
    static KKAlbumImagePickerManager *KKAlbumImagePickerManager_default = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        KKAlbumImagePickerManager_default = [[self alloc] init];
    });
    return KKAlbumImagePickerManager_default;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.selectDataSource = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)finishedWithNavigationController:(UINavigationController*)aNavigationController{
    
    self.navigationController = aNavigationController;
    
    [self exportData];
    
}

/*
①导出图片
*/
- (void)exportData{

    [KKMediaPickerWatingView showInView:[UIWindow kkmp_currentKeyWindow] blackBackground:YES];

    dispatch_group_t group = dispatch_group_create();
    
    for (NSInteger i = 0; i < [self.selectDataSource count]; i++) {
        
        KKAlbumAssetModel *assetModel = [self.selectDataSource objectAtIndex:i];
        if (assetModel.fileURL==nil) {
            dispatch_group_enter(group);
            dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                if (assetModel.asset.mediaType==PHAssetMediaTypeImage) {
                    if (assetModel.img_EditeImage) {
                        NSURL *filePathURL = nil;
                        if (self.delegate && [self.delegate respondsToSelector:@selector(KKAlbumImagePicker_fileURLForSave:fileExtentionName:)]) {
                            filePathURL = [self.delegate KKAlbumImagePicker_fileURLForSave:assetModel.fileName fileExtentionName:assetModel.fileName.pathExtension];
                        }
                        [assetModel setOriginImageInfo:nil
                                             imageData:UIImageJPEGRepresentation(assetModel.img_EditeImage, 1.0)
                                          imageDataUTI:nil
                                      imageOrientation:UIImageOrientationUp
                                           filePathURL:filePathURL];
                        if (assetModel.fileURL) {
                            NSLog(@"KKAlbumImagePickerManager A图片任务处理结束%ld:【成功】",(long)i);
                        }
                        else{
                            NSLog(@"KKAlbumImagePickerManager B图片任务处理结束%ld:【失败】",(long)i);
                        }
                        dispatch_group_leave(group);

                    } else {
                        NSLog(@"KKAlbumImagePickerManager 图片任务处理开始%ld",(long)i);
                        __weak   typeof(self) weakself = self;
                        [KKAlbumManager startExportImageWithPHAsset:assetModel.asset
                                                        resultBlock:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
                            if (imageData) {
                                NSURL *filePathURL = nil;

                                if (weakself.delegate && [weakself.delegate respondsToSelector:@selector(KKAlbumImagePicker_fileURLForSave:fileExtentionName:)]) {
                                    filePathURL = [weakself.delegate KKAlbumImagePicker_fileURLForSave:assetModel.fileName fileExtentionName:assetModel.fileName.pathExtension];
                                }
                                [assetModel setOriginImageInfo:info
                                                     imageData:imageData
                                                  imageDataUTI:dataUTI
                                              imageOrientation:orientation
                                                   filePathURL:filePathURL];

                                if (assetModel.fileURL) {
                                    NSLog(@"KKAlbumImagePickerManager A图片任务处理结束%ld:【成功】",(long)i);
                                }
                                else{
                                    NSLog(@"KKAlbumImagePickerManager B图片任务处理结束%ld:【失败】",(long)i);
                                }
                            }
                            else{
                                NSLog(@"KKAlbumImagePickerManager C图片任务处理结束%ld:【失败】",(long)i);
                            }

                            dispatch_group_leave(group);
                        }];
                    }
                }
                else{
                    NSLog(@"KKAlbumImagePickerManager 视频任务处理开始%ld",(long)i);

                    NSURL *filePathURL = nil;
                    
                    if (self.delegate && [self.delegate respondsToSelector:@selector(KKAlbumImagePicker_fileURLForSave:fileExtentionName:)]) {
                        filePathURL = [self.delegate KKAlbumImagePicker_fileURLForSave:assetModel.fileName fileExtentionName:assetModel.fileName.pathExtension];
                    }

                    [KKAlbumManager startExportVideoWithPHAsset:assetModel.asset
                                                    filePathURL:filePathURL
                                                    resultBlock:^(NSURL * _Nullable fileURL) {
                       
                        if (fileURL) {
                            assetModel.fileURL = fileURL;
                            assetModel.video_originDataSize = [KKAlbumManager fileSizeAtPath:[fileURL path]];
                            
                            NSLog(@"KKAlbumImagePickerManager A视频任务处理结束%ld：【成功】",(long)i);
                        }
                        else{
                            NSLog(@"KKAlbumImagePickerManager B视频任务处理结束%ld：【失败】",(long)i);
                        }
                        dispatch_group_leave(group);
                    }];
                }

                
            });
        }
        else{
            NSLog(@"KKAlbumImagePickerManager 图片存在%ld",(long)i);
        }
    }
    
    dispatch_notify(group, dispatch_get_main_queue(), ^{
        
        NSLog(@"KKAlbumImagePickerManager All所有任务处理完成");
        
        [self compressDataFinished];

    });
    
}

/*
②压缩图片
*/
- (void)compressDataFinished{
    [KKMediaPickerWatingView hideForView:[UIWindow kkmp_currentKeyWindow] animation:YES];
    
    __block NSMutableArray *resultArray = [NSMutableArray array];
    for (KKAlbumAssetModel *model in self.selectDataSource) {
        if (model.fileURL) {
            [resultArray addObject:model];
        }
    }
        
    __block NSMutableDictionary *returnArray = [[NSMutableDictionary alloc] init];
    //压缩图片
    [KKMediaPickerWatingView showInView:[UIWindow kkmp_currentKeyWindow] blackBackground:YES];

    __weak   typeof(self) weakself = self;
    dispatch_group_t group = dispatch_group_create();
    
    for (NSInteger i = 0; i < [resultArray count]; i++) {
        
        __block KKAlbumAssetModel *assetModel = [resultArray objectAtIndex:i];
        //非图片不用压缩
        if (assetModel.asset.mediaType!=PHAssetMediaTypeImage) {
            [returnArray setObject:assetModel forKey:[NSString stringWithFormat:@"%ld",i]];
        }
        else {
            //发送原图 不用压缩
            if (KKAlbumImagePickerManager.defaultManager.isSelectOrigin) {
                [returnArray setObject:assetModel forKey:[NSString stringWithFormat:@"%ld",i]];
                continue;
            }
            
            __block UIImage *willProcessImage = assetModel.img_EditeImage;
            if (willProcessImage==nil) {
                willProcessImage = [[UIImage imageWithData:assetModel.img_originData] kkmp_fixOrientation];
            }
            
            if (willProcessImage) {
                dispatch_group_enter(group);
                dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

                    //300KB
                    [KKAlbumManager convertImage:@[willProcessImage]
                                      toDataSize:300
                                    oneCompleted:^(NSData * _Nullable imageData, NSInteger index) {
                        
                        NSString *extention = [assetModel.fileName pathExtension];
                        NSString *nameShort = nil;
                        if ([NSString kkmp_isStringNotEmpty:extention]) {
                            NSString *extentionDel = [NSString stringWithFormat:@".%@",extention];
                            nameShort = [assetModel.fileName stringByReplacingOccurrencesOfString:extentionDel withString:@""];
                        } else {
                            nameShort = assetModel.fileName;
                        }

                        NSString *compressfileName = [NSString stringWithFormat:@"%@.%@",nameShort,extention];
                        NSURL *filePathURL = nil;
                        if (weakself.delegate && [weakself.delegate respondsToSelector:@selector(KKAlbumImagePicker_fileURLForCompress:fileExtentionName:)]) {
                            assetModel.compressfileName = compressfileName;
                            filePathURL = [weakself.delegate KKAlbumImagePicker_fileURLForCompress:compressfileName fileExtentionName:compressfileName.pathExtension];
                        }
                        [assetModel setCompressImageData:imageData filePathURL:filePathURL];
                        if (assetModel.compressfileURL) {
                            [returnArray setObject:assetModel forKey:[NSString stringWithFormat:@"%ld",i]];
                            NSLog(@"KKAlbumImagePickerManager【图片压缩】 处理结束%ld:【成功】",(long)i);
                        }
                        else{
                            NSLog(@"KKAlbumImagePickerManager【图片压缩】 处理结束%ld:【失败】",(long)i);
                        }
                                                
                        dispatch_group_leave(group);
                        
                    } allCompletedBlock:^{

                    }];
                    
                });

            }
        }
    }
    
    dispatch_notify(group, dispatch_get_main_queue(), ^{
        
        NSLog(@"KKAlbumImagePickerManager All所有【图片压缩】任务处理完成");
        
        NSArray *keys = returnArray.allKeys;
        NSMutableArray *sortKeys = [NSMutableArray array];
        [sortKeys addObjectsFromArray:keys];
        [sortKeys sortUsingComparator:^NSComparisonResult(id _Nonnull obj1, id _Nonnull obj2) {
            if ([obj1 integerValue] < [obj2 integerValue]){
                return NSOrderedAscending;
            }else{
                return NSOrderedDescending;
            }
        }];
        
        NSMutableArray *rArray = [[NSMutableArray alloc] init];
        for (NSInteger i=0; i<[sortKeys count]; i++) {
            NSString *keyT = [sortKeys objectAtIndex:i];
            if ([returnArray objectForKey:keyT]) {
                [rArray addObject:[returnArray objectForKey:keyT]];
            }
        }
        
        [self processDataFinishedWithArray:rArray];

    });

}

/*
③代理返回结果
*/
- (void)processDataFinishedWithArray:(NSArray*)aArray{
    [KKMediaPickerWatingView hideForView:[UIWindow kkmp_currentKeyWindow] animation:YES];

    if (self.delegate && [self.delegate  respondsToSelector:@selector(KKAlbumImagePicker_didFinishedPickImages:)]) {
        [self.delegate KKAlbumImagePicker_didFinishedPickImages:aArray];
    }
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark ==================================================
#pragma mark == 选择
#pragma mark ==================================================
- (void)selectAssetModel:(KKAlbumAssetModel*)aModel{
    if (self.mediaType==KKAssetMediaType_Video) {
        if (aModel.video_originDataSize>1000) {
//            if (aModel.video_originDataSize>(1024*1024*30)) {
//                [KKToastView showInView:[UIWindow currentKeyWindow] text:KKLocalization(@"chat.file.video.maxSize.tips") image:nil alignment:KKToastViewAlignment_Center];
//            } else {
//                [self private_selectAssetModel:aModel];
//            }
            [self private_selectAssetModel:aModel];
        }
        else{
            __weak   typeof(self) weakself = self;
            [KKAlbumManager loadPHAssetFileSize_withPHAsset:aModel.asset resultBlock:^(long long fileSize) {
                aModel.video_originDataSize = fileSize;
//            if (aModel.video_originDataSize>(1024*1024*30)) {
//                [KKToastView showInView:[UIWindow currentKeyWindow] text:KKLocalization(@"chat.file.video.maxSize.tips") image:nil alignment:KKToastViewAlignment_Center];
//            } else {
//                [weakself private_selectAssetModel:aModel];
//            }
                [weakself private_selectAssetModel:aModel];
            }];
        }
    }
    else{
        [self private_selectAssetModel:aModel];
    }
}

- (void)private_selectAssetModel:(KKAlbumAssetModel*)aModel{
    if ([self isSelectAssetModel:aModel]) {
        return;
    }
    [self.selectDataSource addObject:aModel];
    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationName_KKAlbumImagePickerSelectModel object:aModel];
    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationName_KKAlbumManagerDataSourceChanged object:nil];
}

- (void)deselectAssetModel:(KKAlbumAssetModel*)aModel{
    if ([self isSelectAssetModel:aModel]) {
        [self.selectDataSource removeObject:aModel];
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationName_KKAlbumImagePickerUnSelectModel object:aModel];
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationName_KKAlbumManagerDataSourceChanged object:nil];
    }
}

- (BOOL)isSelectAssetModel:(KKAlbumAssetModel*)aModel{
    return [self.selectDataSource containsObject:aModel];
}

- (void)clearAllObjects{
    [self.selectDataSource removeAllObjects];
    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationName_KKAlbumManagerDataSourceChanged object:nil];
}

- (NSArray*)allSource{
    return self.selectDataSource;
}

@end

