//
//  KKMediaPickerAuthorization.m
//  ChervonIot
//
//  Created by edward lannister on 2022/05/19.
//  Copyright © 2022 ts. All rights reserved.
//

#import "KKMediaPickerAuthorization.h"
#import <Photos/PHPhotoLibrary.h>
#import <AVFoundation/AVFoundation.h>

@interface KKMediaPickerAuthorization ()

@property (nonatomic , copy) KKMediaPickerAuthorizationFinishedBlock completeBlock;

@end

@implementation KKMediaPickerAuthorization

+ (KKMediaPickerAuthorization *)defaultManager{
    static KKMediaPickerAuthorization *KKMediaPickerAuthorization_default = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        KKMediaPickerAuthorization_default = [[self alloc] init];
    });
    return KKMediaPickerAuthorization_default;
}

- (void)isAlbumAuthorized:(KKMediaPickerAuthorizationFinishedBlock)block{
    
    if (@available(iOS 14, *)) {
        PHAuthorizationStatus author = [PHPhotoLibrary authorizationStatusForAccessLevel:PHAccessLevelReadWrite];
        if (author == PHAuthorizationStatusNotDetermined) {
            self.completeBlock = block;
            __weak   typeof(self) weakself = self;
            [PHPhotoLibrary requestAuthorizationForAccessLevel:PHAccessLevelReadWrite handler:^(PHAuthorizationStatus status) {
                if (status==PHAuthorizationStatusAuthorized) {
                    if (weakself.completeBlock) {
                        weakself.completeBlock(YES);
                        weakself.completeBlock = nil;
                    }
                } else if (status==PHAuthorizationStatusLimited) {
                    if (weakself.completeBlock) {
                        weakself.completeBlock(YES);
                        weakself.completeBlock = nil;
                    }
                }
                else{
                    if (weakself.completeBlock) {
                        weakself.completeBlock(NO);
                        weakself.completeBlock = nil;
                    }
                }
            }];
        }
        else if (author == PHAuthorizationStatusAuthorized) {
            block(YES);
        }
        else if (author == PHAuthorizationStatusLimited) {
            block(YES);
        }
        else {
            block(NO);
        }
    }
    else {
        PHAuthorizationStatus author = [PHPhotoLibrary authorizationStatus];
        if (author == PHAuthorizationStatusNotDetermined) {
            __block BOOL accessGranted = NO;
            dispatch_semaphore_t sema = dispatch_semaphore_create(0);
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status){
                if (status==PHAuthorizationStatusAuthorized) {
                    accessGranted = YES;
                }
                else{
                    accessGranted = NO;
                }
                dispatch_semaphore_signal(sema);
            }];
            dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
            block(YES);
        }
        else if (author == PHAuthorizationStatusAuthorized) {
            block(YES);
        }
        else {
            block(NO);
        }
    }
}

/// 判断用户相册权限是否部分限制
+ (BOOL)isAlbumAuthorizedLimited{
    if (@available(iOS 14, *)) {
        PHAuthorizationStatus author = [PHPhotoLibrary authorizationStatusForAccessLevel:PHAccessLevelReadWrite];
        if (author == PHAuthorizationStatusNotDetermined) {
            return NO;
        }
        else if (author == PHAuthorizationStatusAuthorized) {
            return NO;
        }
        else if (author == PHAuthorizationStatusLimited) {
            return YES;
        }
        else {
            return NO;
        }
    }
    else {
        return NO;
    }
}


+ (BOOL)isCameraAuthorized{
    AVAuthorizationStatus author = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (author == AVAuthorizationStatusNotDetermined) {
        __block BOOL accessGranted = NO;
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            accessGranted = granted;
            dispatch_semaphore_signal(sema);
        }];
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        return accessGranted;
    }
    else if (author == AVAuthorizationStatusAuthorized) {
        return YES;
    }
    else {
        return NO;
    }
}

@end
