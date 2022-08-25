//
//  KKAlbumAssetModel.m
//  HeiPa
//
//  Created by liubo on 2019/3/15.
//  Copyright © 2019 gouuse. All rights reserved.
//

#import "KKAlbumAssetModel.h"
#import "NSString+KKMediaPicker.h"
#import "KKAlbumManager.h"

@implementation KKAlbumAssetModel

- (void)dealloc
{
    if ([NSString kkmp_isStringNotEmpty:self.compressfileURL.absoluteString]) {
        [NSFileManager.defaultManager removeItemAtURL:self.fileURL error:nil];
    }
}

/**
 判断本地相册是否存在对应的PHAsset资源（只判断图片） 
 @return 是否存在
 */
- (BOOL)img_isInLocal{
    
    if (_img_isInLocal) {
        return _img_isInLocal;
    }
    else{
        /* 方案一 比较费时 */
        //asset is a PHAsset object for which you want to get the information
        //        NSArray *resourceArray = [PHAssetResource assetResourcesForAsset:aAsset];
        //        BOOL bIsLocallayAvailable = [[resourceArray.firstObject valueForKey:@"locallyAvailable"] boolValue];
        //        // If this returns NO, then the asset is in iCloud and not saved locally yet
        //        return bIsLocallayAvailable;
        
        /* 方案二 费时相对好一点 */
        PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
        option.networkAccessAllowed = NO;
        option.synchronous = YES;
        
        NSString *localIdentifier = [self.asset localIdentifier];
        if ([NSString kkmp_isStringNotEmpty:localIdentifier]) {
            
            __block BOOL isInLocalAblum = YES;
            [[PHCachingImageManager defaultManager] requestImageDataForAsset:self.asset options:option resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
                
                isInLocalAblum = imageData ? YES : NO;
            }];
            
            _img_isInLocal = isInLocalAblum;
            return isInLocalAblum;
        }
        else{
            return YES;
        }
    }
}

- (BOOL)video_isInLocal{
    
    if (_video_isInLocal) {
        return _video_isInLocal;
    }
    else{
        /* 方案二 费时相对好一点 */
        PHVideoRequestOptions *option = [[PHVideoRequestOptions alloc] init];
        option.networkAccessAllowed = NO;
        
        NSString *localIdentifier = [self.asset localIdentifier];
        if ([NSString kkmp_isStringNotEmpty:localIdentifier]) {
            
            __block BOOL isInLocalAblum = YES;
            [[PHImageManager defaultManager] requestPlayerItemForVideo:self.asset options:nil resultHandler:^(AVPlayerItem * _Nullable playerItem, NSDictionary * _Nullable info) {
                
                isInLocalAblum = playerItem ? YES : NO;
                
            }];
            _video_isInLocal = isInLocalAblum;
            return isInLocalAblum;
        }
        else{
            return YES;
        }
    }
}

- (BOOL)setOriginImageInfo:(NSDictionary * _Nullable)info
                 imageData:(NSData * _Nullable)imageData
              imageDataUTI:(NSString * _Nullable)dataUTI
          imageOrientation:(UIImageOrientation)orientation
               filePathURL:(NSURL* _Nullable)aFilePathURL{

    _img_originInfo = info;
    _img_originData = imageData;
    _img_originDataSize = imageData.length;
    _img_orientation = orientation;
    _img_dataUTI = dataUTI;
    
    if (aFilePathURL) {
        BOOL saveResult = [imageData writeToURL:aFilePathURL atomically:YES];
        if (saveResult) {
            self.fileURL = aFilePathURL;
        }
        else{
            self.fileURL = nil;
        }
        return saveResult;
    }
    else{
        NSString *path = [KKAlbumManager createCachePathOfDirectory:@"KKMediaPicker"];
        NSString *fileFullPath = [path stringByAppendingPathComponent:self.fileName];
        if([_img_originData writeToFile:fileFullPath atomically:YES]){
            self.fileURL = [NSURL fileURLWithPath:fileFullPath];
            return YES;
        }
        else{
            return NO;
        }
    }
}

- (BOOL)setCompressImageData:(NSData * _Nullable)imageData
                 filePathURL:(NSURL* _Nullable)aFilePathURL{
    
    if (imageData==nil) {
        return NO;
    }
    
    _img_CompressImage = [UIImage imageWithData:imageData];
    _img_originDataSize = imageData.length;
    
    if (aFilePathURL) {
        BOOL saveResult = [imageData writeToURL:aFilePathURL atomically:YES];
        if (saveResult) {
            self.compressfileURL = aFilePathURL;
        }
        else{
            self.compressfileURL = nil;
        }
        return saveResult;
    }
    else{
        NSString *extention = [self.fileName pathExtension];
        NSString *nameShort = nil;
        if ([NSString kkmp_isStringNotEmpty:extention]) {
            NSString *extentionDel = [NSString stringWithFormat:@".%@",extention];
            nameShort = [self.fileName stringByReplacingOccurrencesOfString:extentionDel withString:@""];
        } else {
            nameShort = self.fileName;
        }
        _compressfileName = [NSString stringWithFormat:@"%@_compress.%@",nameShort,extention];
        
        NSString *path = [KKAlbumManager createCachePathOfDirectory:@"KKMediaPicker"];
        NSString *fileFullPath = [path stringByAppendingPathComponent:_compressfileName];
        if([imageData writeToFile:fileFullPath atomically:YES]){
            self.compressfileURL = [NSURL fileURLWithPath:fileFullPath];
            return YES;
        }
        else{
            return NO;
        }

    }
}


- (UIImage*_Nullable)bigImageForShowing{
    if (self.img_EditeImage) {
        return self.img_EditeImage;
    }
    else if (self.bigImage){
        return self.bigImage;
    }
    else {
        return nil;
    }
}

- (UIImage*_Nullable)smallImageForShowing{
    if (self.img_EditeImage) {
        return self.img_EditeImage;
    }
    else if (self.thumbImage){
        return self.thumbImage;
    }
    else {
        return nil;
    }
}

- (void)videoPlayDuration:(void (^_Nullable)(double dur))resultBlock{
    if (self.videoPlayDuration>0) {
        resultBlock(self.videoPlayDuration);
        return;
    }
    
    PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
    options.networkAccessAllowed = NO;
    options.version =  PHVideoRequestOptionsVersionCurrent;
    __weak   typeof(self) weakself = self;
    __block double dur = 0;
    [[PHImageManager defaultManager] requestPlayerItemForVideo:self.asset options:options resultHandler:^(AVPlayerItem *playerItem, NSDictionary *info) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (playerItem) {
                    dur = CMTimeGetSeconds(playerItem.duration);
                    //慢拍视频 playerItem.asset 是一个AVComposition的类
                    if (!isnan(dur) && dur>0) {
                        weakself.videoPlayDuration = dur;
                        resultBlock(dur);
                    } else {
                        dur =  weakself.asset.duration;
                        weakself.videoPlayDuration = dur;
                        resultBlock(dur);
                    }
                } else {
                    dur =  weakself.asset.duration;
                    weakself.videoPlayDuration = dur;
                    resultBlock(dur);
                }
            });
        }];
}

@end
