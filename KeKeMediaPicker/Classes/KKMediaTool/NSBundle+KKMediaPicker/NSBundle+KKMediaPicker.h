//
//  NSBundle+KKMediaPicker.h
//  KeKeMediaPicker
//
//  Created by edward lannister on 2022/08/21.
//  Copyright © 2022 KKLibrary. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSBundle (KKMediaPicker)

+ (nullable UIImage*)kkmp_imageInBundle:(NSString*_Nullable)aBundleName
                              imageName:(NSString*_Nullable)aImageName;
@end
