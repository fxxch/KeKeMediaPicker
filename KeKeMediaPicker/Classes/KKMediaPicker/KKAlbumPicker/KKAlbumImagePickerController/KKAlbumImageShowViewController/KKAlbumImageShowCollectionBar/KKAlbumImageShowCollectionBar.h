//
//  KKAlbumImageShowCollectionBar.h
//  HeiPa
//
//  Created by liubo on 2019/3/16.
//  Copyright © 2019 gouuse. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KKAlbumImageShowCollectionBarItem.h"

@protocol KKAlbumImageShowCollectionBarDelegate <NSObject>

- (void)KKAlbumImageShowCollectionBar_SelectModel:(KKAlbumAssetModel*)aModel;

@end

@interface KKAlbumImageShowCollectionBar : UIView

@property (nonatomic , weak) id<KKAlbumImageShowCollectionBarDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame;

- (void)selectModel:(KKAlbumAssetModel*)aSelectModel;

@end
