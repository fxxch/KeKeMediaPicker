//
//  KKAlbumDirectoryModel.h
//  HeiPa
//
//  Created by liubo on 2019/3/13.
//  Copyright © 2019 gouuse. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
#import "KKAlbumAssetModel.h"

@interface KKAlbumDirectoryModel : NSObject

@property (nonatomic , strong) PHAssetCollection *assetCollection;
@property (nonatomic , copy)   NSString          *title;
@property (nonatomic , assign) NSInteger         count;
@property (nonatomic , strong) UIImage           *coverImage;
@property (nonatomic , strong) NSArray<KKAlbumAssetModel*>           *assetsArray;

@end
