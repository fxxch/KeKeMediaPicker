//
//  CVNAuthorization.h
//  ChervonIot
//
//  Created by edward lannister on 2022/05/19.
//  Copyright © 2022 ts. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^KKMediaPickerAuthorizationFinishedBlock)(BOOL isAuthorized);

@interface KKMediaPickerAuthorization : NSObject

+ (KKMediaPickerAuthorization*)defaultManager;

/// 判断用户是否授权了相册权限
- (void)isAlbumAuthorized:(KKMediaPickerAuthorizationFinishedBlock)block;

/// 判断用户相册权限是否部分限制
+ (BOOL)isAlbumAuthorizedLimited;

/// 判断用户是否授权了相机权限
+ (BOOL)isCameraAuthorized;

@end
