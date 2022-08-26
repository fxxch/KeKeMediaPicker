//
//  KKMediaPickerLocalization.h
//  KeKeMediaPicker
//
//  Created by edward lannister on 2022/08/26.
//  Copyright © 2022 KKLibrary. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define KKMediaPickerLocalKey_Common_Done         @"完成"
#define KKMediaPickerLocalKey_Common_Cancel       @"取消"
#define KKMediaPickerLocalKey_Album_Preview       @"预览"
#define KKMediaPickerLocalKey_Album_Origin        @"原图"
#define KKMediaPickerLocalKey_Album_Edit          @"编辑"
#define KKMediaPickerLocalKey_Album_MaxLimited    @"已达到最大数量限制" //暂时没用
#define KKMediaPickerLocalKey_Common_OK           @"确定" //暂时没用

#define KKMediaPickerLocalKey_Authorized_Go                        @"去设置"
#define KKMediaPickerLocalKey_AuthorizedLimited_Album              @"部分照片"
#define KKMediaPickerLocalKey_AuthorizedLimited_Album_AlertMessage @"您只开启了部分照片访问权限，要访问更多照片，请前往设置，开启“允许访问所有照片”"


@interface KKMediaPickerLocalization : NSObject

+ (NSString*)localizationStringForKey:(NSString*)aKey;

@end
