//
//  KKAlbumAssetModelPreviewController.h
//  BM
//
//  Created by sjyt on 2020/4/7.
//  Copyright © 2020 bm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KKMediaPickerDefine.h"
#import "KKAlbumAssetModel.h"
#import "KKMediaPickerBaseViewController.h"

@interface KKAlbumAssetModelPreviewController : KKMediaPickerBaseViewController

+ (void)showFromNavigationController:(UINavigationController*_Nullable)aNavController
                               items:(NSArray<KKAlbumAssetModel*>*_Nullable)aItemsArray
                       selectedIndex:(NSInteger)aSelectedIndex
                            fromRect:(CGRect)aFromRect;

@end
