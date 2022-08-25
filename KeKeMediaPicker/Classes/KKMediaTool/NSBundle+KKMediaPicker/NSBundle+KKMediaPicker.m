//
//  NSBundle+KKMediaPicker.m
//  KeKeMediaPicker
//
//  Created by edward lannister on 2022/08/21.
//  Copyright © 2022 KKLibrary. All rights reserved.
//

#import "NSBundle+KKMediaPicker.h"

@implementation NSBundle (KKMediaPicker)

+ (nullable UIImage*)kkmp_imageInBundle:(NSString*_Nullable)aBundleName
                            imageName:(NSString*_Nullable)aImageName{
    
    NSString *bundleName = aBundleName;
    if ([bundleName hasSuffix:@".bundle"]==NO) {
        bundleName = [bundleName stringByAppendingString:@".bundle"];
    }
    
    NSString *bundleFilePath = [[NSBundle mainBundle] pathForResource:bundleName ofType:nil];
    if (bundleFilePath==nil) {
        return nil;
    }
    
    NSString *imageName = [aImageName stringByReplacingOccurrencesOfString:@".png" withString:@""];
    imageName = [imageName stringByReplacingOccurrencesOfString:@"@3x" withString:@""];
    imageName = [imageName stringByReplacingOccurrencesOfString:@"@2x" withString:@""];
    imageName = [imageName stringByReplacingOccurrencesOfString:@"@1x" withString:@""];

    NSString *imageName1 = [NSString stringWithFormat:@"%@.png",imageName];
    NSString *imageName11 = [NSString stringWithFormat:@"%@@1x.png",imageName];
    NSString *imageName2 = [NSString stringWithFormat:@"%@@2x.png",imageName];
    NSString *imageName3 = [NSString stringWithFormat:@"%@@3x.png",imageName];

    NSString *filepath1 = [NSString stringWithFormat:@"%@/%@",bundleFilePath,imageName1];
    NSString *filepath11 = [NSString stringWithFormat:@"%@/%@",bundleFilePath,imageName11];
    NSString *filepath2 = [NSString stringWithFormat:@"%@/%@",bundleFilePath,imageName2];
    NSString *filepath3 = [NSString stringWithFormat:@"%@/%@",bundleFilePath,imageName3];
    
    CGFloat scale = [[UIScreen mainScreen] scale];
    if (scale==1) {
        UIImage *image = [UIImage imageWithContentsOfFile:filepath1];
        if (image==nil) {
            image = [UIImage imageWithContentsOfFile:filepath11];
        }
        if (image==nil) {
            image = [UIImage imageWithContentsOfFile:filepath2];
        }
        if (image==nil) {
            image = [UIImage imageWithContentsOfFile:filepath3];
        }
        return image;
    } else if (scale==2){
        UIImage *image = [UIImage imageWithContentsOfFile:filepath2];
        if (image==nil) {
            image = [UIImage imageWithContentsOfFile:filepath3];
        }
        if (image==nil) {
            image = [UIImage imageWithContentsOfFile:filepath1];
        }
        if (image==nil) {
            image = [UIImage imageWithContentsOfFile:filepath11];
        }
        return image;
    }
    else {
        UIImage *image = [UIImage imageWithContentsOfFile:filepath3];
        if (image==nil) {
            image = [UIImage imageWithContentsOfFile:filepath2];
        }
        if (image==nil) {
            image = [UIImage imageWithContentsOfFile:filepath1];
        }
        if (image==nil) {
            image = [UIImage imageWithContentsOfFile:filepath11];
        }
        return image;
    }
}

@end
