//
//  KKAlbumAssetModelPreviewView.h
//  BM
//
//  Created by sjyt on 2020/4/7.
//  Copyright © 2020 bm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KKAlbumAssetModel.h"
#import "KKAlbumAssetModelPreviewItem.h"

@interface KKAlbumAssetModelPreviewView : UIView

@property (nonatomic , strong) NSMutableArray<KKAlbumAssetModel*> * _Nonnull itemsArray;
@property (nonatomic,assign)NSInteger nowSelectedIndex;

- (id _Nullable)initWithFrame:(CGRect)frame
                        items:(NSArray<KKAlbumAssetModel*>*_Nullable)aItemsArray
                selectedIndex:(NSInteger)aSelectedIndex
                     fromRect:(CGRect)aFromRect;

- (void)show;

@end

