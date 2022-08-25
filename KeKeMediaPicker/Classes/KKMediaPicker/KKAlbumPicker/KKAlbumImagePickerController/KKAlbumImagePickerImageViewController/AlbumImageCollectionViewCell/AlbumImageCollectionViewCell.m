//
//  AlbumImageCollectionViewCell.m
//  HeiPa
//
//  Created by liubo on 2019/3/13.
//  Copyright © 2019 gouuse. All rights reserved.
//

#import "AlbumImageCollectionViewCell.h"
#import "NSString+KKMediaPicker.h"
#import "KKMediaPickerDefine.h"

#pragma mark ==================================================
#pragma mark == AlbumImageCollectionViewCell
#pragma mark ==================================================
@implementation AlbumImageCollectionViewCell

- (void)dealloc{
    [NSNotificationCenter.defaultCenter removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.mainImageView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        self.mainImageView.imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.mainImageView addTarget:self action:@selector(mainViewClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.mainImageView];
        self.mainImageView.clipsToBounds = YES;

        self.videoLogoView = [[UIImageView alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(self.mainImageView.frame)-5-14, 21, 14)];
        self.videoLogoView.image = [KKAlbumManager themeImageForName:@"VideoLogo"];
        [self addSubview:self.videoLogoView];

        NSString *text = @"99:99:99";
        CGSize size = [text kkmp_sizeWithFont:[UIFont systemFontOfSize:10] maxWidth:1000];
        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.videoLogoView.frame)+5, 0, self.mainImageView.frame.size.width-(CGRectGetMaxX(self.videoLogoView.frame)+5)-5, size.height)];
        self.timeLabel.textColor = [UIColor whiteColor];
        self.timeLabel.font = [UIFont systemFontOfSize:10];
        [self addSubview:self.timeLabel];

        self.selectedImageView = [[UIButton alloc] initWithFrame:CGRectMake(frame.size.width-2-25, 2, 25, 25)];
        [self.selectedImageView addTarget:self action:@selector(selectViewClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.selectedImageView];

        self.selectedButton = [[UIButton alloc] initWithFrame:CGRectMake(frame.size.width-2-25, 2, 25, 25)];
        [self.selectedButton addTarget:self action:@selector(selectViewClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.selectedButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.selectedButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:self.selectedButton];
        self.selectedButton.layer.cornerRadius = self.selectedButton.frame.size.width/2.0;
        self.selectedButton.layer.masksToBounds = YES;

        if ([KKAlbumImagePickerManager defaultManager].numberOfPhotosNeedSelected>1) {
            self.selectedImageView.hidden = YES;
            self.selectedButton.hidden = NO;
        }
        else{
            self.selectedImageView.hidden = YES;
            self.selectedButton.hidden = YES;
        }

        [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(Notification_KKAlbumManagerDataSourceChanged:) name:NotificationName_KKAlbumManagerDataSourceChanged object:nil];
        [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(Notification_KKAlbumAssetModelEditImageFinished:) name:NotificationName_KKAlbumAssetModelEditImageFinished object:nil];
    }
    return self;
}

- (void)reloadWithInformation:(KKAlbumAssetModel*)aInformation
                       select:(BOOL)select{

    self.assetModel = aInformation;
    
    if (select) {
        UIImage *image = [KKAlbumManager themeImageForName:@"SelectedH"];
        [self.selectedImageView setBackgroundImage:image forState:UIControlStateNormal];
    }
    else{
        UIImage *image = [KKAlbumManager themeImageForName:@"UnSelected"];
        [self.selectedImageView setBackgroundImage:image forState:UIControlStateNormal];
    }

    if (select) {
        NSInteger index = [KKAlbumImagePickerManager.defaultManager.allSource indexOfObject:aInformation];
        NSString *title = [NSString stringWithFormat:@"%ld",index+1];

        [self.selectedButton setBackgroundColor:KKMediaPicker_Clolor_1E95FF];
        [self.selectedButton setTitle:title forState:UIControlStateNormal];
    }
    else{
        UIImage *image = [KKAlbumManager themeImageForName:@"UnSelected"];
        [self.selectedButton setBackgroundColor:[UIColor clearColor]];
        [self.selectedButton setBackgroundImage:image forState:UIControlStateNormal];
        [self.selectedButton setTitle:@"" forState:UIControlStateNormal];
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
        self.timeLabel.hidden = NO;

        __weak   typeof(self) weakself = self;
        [self.assetModel videoPlayDuration:^(double dur) {
            int HH = dur/(60*60);
            int MM = (dur - HH*(60*60))/60;
            int SS = dur - HH*(60*60) - MM*60;
            if (HH>0) {
                weakself.timeLabel.text = [NSString stringWithFormat:@"%02d:%02d:%02d",HH,MM,SS];
            }
            else{
                weakself.timeLabel.text = [NSString stringWithFormat:@"%02d:%02d",MM,SS];
            }
            weakself.timeLabel.adjustsFontSizeToFitWidth = YES;
            
            CGPoint center = weakself.timeLabel.center;
            center.y = weakself.videoLogoView.center.y;
            weakself.timeLabel.center = center;
        }];
    }
    else{
        self.videoLogoView.hidden = YES;
        self.timeLabel.hidden = YES;
    }
    
}

- (void)mainViewClicked:(UIButton*)aButton{
    if (self.delegate && [self.delegate respondsToSelector:@selector(AlbumImageCollectionViewCell_MainButtonClicked:)]) {
        [self.delegate AlbumImageCollectionViewCell_MainButtonClicked:self];
    }
}

- (void)selectViewClicked:(UIButton*)aButton{
    if (self.delegate && [self.delegate respondsToSelector:@selector(AlbumImageCollectionViewCell_SelectButtonClicked:)]) {
        [self.delegate AlbumImageCollectionViewCell_SelectButtonClicked:self];
    }
}

- (void)Notification_KKAlbumManagerDataSourceChanged:(NSNotification*)notice{
    if ([KKAlbumImagePickerManager.defaultManager.allSource containsObject:self.assetModel]) {
        NSInteger index = [KKAlbumImagePickerManager.defaultManager.allSource indexOfObject:self.assetModel];
        NSString *title = [NSString stringWithFormat:@"%ld",index+1];

        [self.selectedButton setBackgroundColor:KKMediaPicker_Clolor_1E95FF];
        [self.selectedButton setTitle:title forState:UIControlStateNormal];
    }
    else{
        UIImage *image = [KKAlbumManager themeImageForName:@"UnSelected"];
        [self.selectedButton setBackgroundImage:image forState:UIControlStateNormal];
        [self.selectedButton setTitle:@"" forState:UIControlStateNormal];
    }
}

- (void)Notification_KKAlbumAssetModelEditImageFinished:(NSNotification*)notice{
    [self.mainImageView setImage:self.assetModel.smallImageForShowing forState:UIControlStateNormal];
}


@end
