//
//  KKCameraCaptureDataModel.m
//  BM
//
//  Created by 刘波 on 2020/3/16.
//  Copyright © 2020 bm. All rights reserved.
//

#import "KKCameraCaptureDataModel.h"
#import "NSString+KKMediaPicker.h"

@implementation KKCameraCaptureDataModel

- (instancetype)init{
    self = [super init];
    if (self) {
        [self deleteSelfClassCacheFilePath];
        
        self.helper = [[KKCameraHelper alloc] init];

        [self reset];
    }
    return self;
}

#pragma mark ==================================================
#pragma mark == 数据复位
#pragma mark ==================================================
- (void)reset{
    [self deleteSelfClassCacheFilePath];

    /* 公共的 */
    _fileName = nil;
    _fileName = [NSString kkmp_randomString:10];

    /* 视频mov */
    _movFileFullPath = nil;

    /* 视频mP4 */
    _mp4FileFullPath = nil;

    /* 图片 */
    _imageFilePath = nil;
    _imageEditFilePath = nil;
}

#pragma mark ==================================================
#pragma mark == getter
#pragma mark ==================================================
- (NSString *)movFileFullPath{
    if (_movFileFullPath==nil) {
        NSString *movFullName = [NSString stringWithFormat:@"%@.mov",_fileName];
        _movFileFullPath = [[self selfClassCacheFilePath] stringByAppendingPathComponent:movFullName];
    }
    return _movFileFullPath;
}

- (NSString *)mp4FileFullPath{
    if (_mp4FileFullPath==nil) {
        NSString *mp4FullName = [NSString stringWithFormat:@"%@.mp4",_fileName];
        _mp4FileFullPath = [[self selfClassCacheFilePath] stringByAppendingPathComponent:mp4FullName];
    }
    return _mp4FileFullPath;
}

- (NSString *)imageFilePath{
    if (_imageFilePath==nil) {
        NSString *imgFullName = [NSString stringWithFormat:@"%@.png",_fileName];
        _imageFilePath = [[self selfClassCacheFilePath] stringByAppendingPathComponent:imgFullName];
    }
    return _imageFilePath;
}

- (NSString *)imageEditFilePath{
    if (_imageEditFilePath==nil) {
        NSString *imgEditFullName = [NSString stringWithFormat:@"%@_Edit.png",_fileName];
        _imageEditFilePath = [[self selfClassCacheFilePath] stringByAppendingPathComponent:imgEditFullName];
    }
    return _imageEditFilePath;
}

- (NSString*)selfClassCacheFilePath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *selfClassPath = [documentsDirectory stringByAppendingPathComponent:NSStringFromClass([self class])];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    if(![fileManager contentsOfDirectoryAtPath:selfClassPath error:&error]){
        BOOL result = [fileManager createDirectoryAtPath:selfClassPath withIntermediateDirectories:YES attributes:nil error:&error];
        if (!result) {
            NSLog(@"❌KKCameraCaptureDataModel：创建文件夹失败：%@",[error localizedDescription]);
            return @"";
        }
    }

    return selfClassPath;
}

- (void)deleteSelfClassCacheFilePath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *selfClassPath = [documentsDirectory stringByAppendingPathComponent:NSStringFromClass([self class])];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:selfClassPath error:nil];
}

#pragma mark ==================================================
#pragma mark == 陀螺定位设备方向
#pragma mark ==================================================
- (void)startMotionManager{
    [self.helper startMotionManager];
}

- (void)stopMotionManager{
    [self.helper stopMotionManager];
}

- (UIImage*) movSnipImageWithURL:(NSURL*)aURL{
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:aURL options:nil];
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    gen.appliesPreferredTrackTransform = YES;
    gen.requestedTimeToleranceAfter = kCMTimeZero;
    gen.requestedTimeToleranceBefore = kCMTimeZero;
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    NSError *error = nil;
    CMTime actualTime;
    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    UIImage *img = [[UIImage alloc] initWithCGImage:image];
    CGImageRelease(image);
    return img;
}


@end
