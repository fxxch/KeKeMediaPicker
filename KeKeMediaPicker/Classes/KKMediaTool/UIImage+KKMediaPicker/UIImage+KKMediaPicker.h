//
//  UIImage+KKMediaPicker.h
//  KeKeMediaPicker
//
//  Created by edward lannister on 2022/08/24.
//  Copyright © 2022 KKLibrary. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (KKMediaPicker)

- (nullable UIImage *)kkmp_fixOrientation;

- (nullable UIImage *)kkmp_cropImageWithX:(CGFloat)x
                                        y:(CGFloat)y
                                    width:(CGFloat)width
                                   height:(CGFloat)height;

- (nullable UIImage *)kkmp_resizeToWidth:(CGFloat)width
                                  height:(CGFloat)height;

@end
