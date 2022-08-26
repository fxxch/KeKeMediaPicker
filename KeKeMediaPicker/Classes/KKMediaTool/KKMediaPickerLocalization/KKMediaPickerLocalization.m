//
//  KKMediaPickerLocalization.m
//  KeKeMediaPicker
//
//  Created by edward lannister on 2022/08/26.
//  Copyright © 2022 KKLibrary. All rights reserved.
//

#import "KKMediaPickerLocalization.h"
#import "KKMediaPickerDefine.h"

@implementation KKMediaPickerLocalization

+ (NSString*)localizationStringForKey:(NSString*)aKey{
    
    BOOL isChinese = NO;
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSArray * allLanguages = [defaults objectForKey:@"AppleLanguages"];
    NSString * preferredLang = [allLanguages objectAtIndex:0];
    if ([preferredLang rangeOfString:@"Hans"].length>0) {
        isChinese = YES;
    }

    if ([aKey isEqualToString:KKMediaPickerLocalKey_Common_Done]) {
        return isChinese?aKey:@"Done";
    }
    else if ([aKey isEqualToString:KKMediaPickerLocalKey_Common_Cancel]){
        return isChinese?aKey:@"Cancel";
    }
    else if ([aKey isEqualToString:KKMediaPickerLocalKey_Common_OK]){
        return isChinese?aKey:@"OK";
    }
    else if ([aKey isEqualToString:KKMediaPickerLocalKey_Album_Preview]){
        return isChinese?aKey:@"Preview";
    }
    else if ([aKey isEqualToString:KKMediaPickerLocalKey_Album_Origin]){
        return isChinese?aKey:@"Full Image";
    }
    else if ([aKey isEqualToString:KKMediaPickerLocalKey_Album_Edit]){
        return isChinese?aKey:@"Edit";
    }
    else if ([aKey isEqualToString:KKMediaPickerLocalKey_Album_MaxLimited]){
        return isChinese?aKey:@"Maximum quantity limit reached";
    }
    else if ([aKey isEqualToString:KKMediaPickerLocalKey_Authorized_Go]){
        return isChinese?aKey:@"Setting";
    }
    else if ([aKey isEqualToString:KKMediaPickerLocalKey_AuthorizedLimited_Album]){
        return isChinese?aKey:@"Selected Photos";
    }
    else if ([aKey isEqualToString:KKMediaPickerLocalKey_AuthorizedLimited_Album_AlertMessage]){
        return isChinese?aKey:@"You have only enabled access to some photos, to access more photos, go to settings and turn on \"Allow access to all photos\"";
    }
    else{
        return aKey;
    }
}

@end
