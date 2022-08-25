//
//  KKAlbumImageShowCollectionBarItem.m
//  HeiPa
//
//  Created by liubo on 2019/3/16.
//  Copyright © 2019 gouuse. All rights reserved.
//

#import "KKAlbumImageShowCollectionBarItem.h"
#import "KKMediaPickerDefine.h"

#pragma mark ==================================================
#pragma mark == KKAlbumImageShowCollectionBarItem
#pragma mark ==================================================
@implementation KKAlbumImageShowCollectionBarItem

- (void)dealloc{
    [NSNotificationCenter.defaultCenter removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.mainImageView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self.mainImageView addTarget:self action:@selector(mainViewClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.mainImageView];
        self.mainImageView.userInteractionEnabled = NO;
        self.mainImageView.imageView.contentMode = UIViewContentModeScaleAspectFill;
        self.mainImageView.clipsToBounds = YES;
        
        self.videoLogoView = [[UIImageView alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(self.mainImageView.frame)-5-14, 21, 14)];
        self.videoLogoView.image = [KKAlbumManager themeImageForName:@"VideoLogo"];
        [self addSubview:self.videoLogoView];

        [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(Notification_KKAlbumAssetModelEditImageFinished:) name:NotificationName_KKAlbumAssetModelEditImageFinished object:nil];
    }
    return self;
}

- (void)reloadWithInformation:(KKAlbumAssetModel*)aInformation
                       select:(BOOL)select{
    
    self.assetModel = aInformation;

    if (select) {
        [self.mainImageView.layer setBorderWidth:2.0];
        [self.mainImageView.layer setBorderColor:KKMediaPicker_Clolor_1E95FF.CGColor];
    }
    else{
        [self.mainImageView.layer setBorderWidth:0];
        [self.mainImageView.layer setBorderColor:[UIColor clearColor].CGColor];
    }
    
    [self.mainImageView setImage:nil forState:UIControlStateNormal];
    
    if ([aInformation isKindOfClass:[KKAlbumAssetModel class]]) {
        
        if (self.assetModel.smallImageForShowing) {
            [self.mainImageView setImage:self.assetModel.smallImageForShowing forState:UIControlStateNormal];
        }
        else{
            __weak   typeof(self) weakself = self;
            [KKAlbumManager loadThumbnailImage_withPHAsset:((KKAlbumAssetModel*)aInformation).asset targetSize:self.mainImageView.frame.size resultBlock:^(UIImage * _Nullable aImage, NSDictionary * _Nullable info) {
                weakself.assetModel.thumbImage = aImage;
                [weakself.mainImageView setImage:aImage forState:UIControlStateNormal];
            }];
        }
    }
    
    if (self.assetModel.asset.mediaType==PHAssetMediaTypeVideo) {
        self.videoLogoView.hidden = NO;
    }
    else{
        self.videoLogoView.hidden = YES;
    }
    
}

- (void)mainViewClicked:(UIButton*)aButton{

}

- (void)Notification_KKAlbumAssetModelEditImageFinished:(NSNotification*)notice{
    [self.mainImageView setImage:self.assetModel.smallImageForShowing forState:UIControlStateNormal];
}


@end
