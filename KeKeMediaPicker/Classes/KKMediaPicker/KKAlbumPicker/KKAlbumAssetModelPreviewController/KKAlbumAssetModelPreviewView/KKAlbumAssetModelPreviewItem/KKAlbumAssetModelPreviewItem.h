//
//  KKAlbumAssetModelPreviewItem.h
//  BM
//
//  Created by sjyt on 2020/4/7.
//  Copyright © 2020 bm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KKAlbumManager.h"
#import <AVFoundation/AVFoundation.h>

@class KKAlbumAssetModelPreviewItem;
#pragma mark ==================================================
#pragma mark == KKAlbumAssetModelPreviewItemDelegate
#pragma mark ==================================================
@protocol KKAlbumAssetModelPreviewItemDelegate <NSObject>
@optional

- (void)KKAlbumAssetModelPreviewItemSingleTap:(KKAlbumAssetModelPreviewItem*)aItemView;

- (void)KKAlbumAssetModelPreviewItem:(KKAlbumAssetModelPreviewItem*)aItemView
                                  playVideo:(BOOL)aPlay;

@end


static NSString *KKAlbumAssetModelPreviewItem_ID = @"KKAlbumAssetModelPreviewItem_ID";

@interface KKAlbumAssetModelPreviewItem : UICollectionViewCell
<UIGestureRecognizerDelegate,UIScrollViewDelegate>

@property (nonatomic,strong)UIScrollView *myScrollView;
@property (nonatomic,strong) UIImageView *myImageView;
@property (nonatomic,strong) UIButton *videoPlayButton;
@property (nonatomic,strong) AVPlayer *player;
@property (nonatomic,strong) AVPlayerLayer *playerLayer;

@property (nonatomic , weak) id<KKAlbumAssetModelPreviewItemDelegate> delegate;
@property (nonatomic , assign) NSInteger row;
@property (nonatomic , strong) KKAlbumAssetModel *assetModel;
@property (nonatomic , strong) UIView *waitingView;

- (void)reloadWithInformation:(KKAlbumAssetModel*)aModel
                          row:(NSInteger)aRow;


@end
