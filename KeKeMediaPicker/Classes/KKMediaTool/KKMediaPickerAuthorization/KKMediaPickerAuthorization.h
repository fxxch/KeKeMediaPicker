//
//  CVNAuthorization.h
//  ChervonIot
//
//  Created by edward lannister on 2022/05/19.
//  Copyright © 2022 ts. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KKMediaPickerAuthorization : NSObject

/// 判断用户是否授权了相册权限
+ (BOOL)isAlbumAuthorized;

/// 判断用户相册权限是否部分限制
+ (BOOL)isAlbumAuthorizedLimited;

/// 判断用户是否授权了相机权限
+ (BOOL)isCameraAuthorized;

@end
