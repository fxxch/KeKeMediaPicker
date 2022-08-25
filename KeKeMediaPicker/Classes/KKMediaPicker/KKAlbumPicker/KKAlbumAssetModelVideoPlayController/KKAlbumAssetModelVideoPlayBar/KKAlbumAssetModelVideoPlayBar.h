//
//  KKAlbumAssetModelVideoPlayBar.h
//  BM
//
//  Created by sjyt on 2020/4/7.
//  Copyright © 2020 bm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KKAlbumAssetModelVideoPlaySlider : UISlider

@end

@protocol KKAlbumAssetModelVideoPlayBarDelegate;

@interface KKAlbumAssetModelVideoPlayBar : UIView{
    NSTimeInterval _currentTime;//当前时间
    NSTimeInterval _durationtime;//当前时间
}

@property (nonatomic,strong)UIImageView *backgroundImageView;
@property (nonatomic,strong)KKAlbumAssetModelVideoPlaySlider *mySlider;
@property (nonatomic,strong)UILabel *currentTimeLabel;
@property (nonatomic,strong)UILabel *durationtimeLabel;
@property (nonatomic,assign)NSTimeInterval currentTime;//当前时间
@property (nonatomic,assign)NSTimeInterval durationtime;//当前时间
@property (nonatomic,strong)UIButton *stopPlayButton;
@property (nonatomic,strong)UIButton *backButton;//返回（×）
@property (nonatomic,strong)UIButton *moreButton;//更多（…）
@property (nonatomic,assign)BOOL isSliderTouched;

@property (nonatomic,assign)id<KKAlbumAssetModelVideoPlayBarDelegate> delegate;

- (void)setButtonStatusStop;

- (void)setButtonStatusPlaying;

@end


@protocol KKAlbumAssetModelVideoPlayBarDelegate <NSObject>

- (void)KKAlbumAssetModelVideoPlayBar_BackButtonClicked:(KKAlbumAssetModelVideoPlayBar*)aView;

- (void)KKAlbumAssetModelVideoPlayBar_MoreButtonClicked:(KKAlbumAssetModelVideoPlayBar*)aView;

- (void)KKAlbumAssetModelVideoPlayBar_PlayButtonClicked:(KKAlbumAssetModelVideoPlayBar*)aView;

- (void)KKAlbumAssetModelVideoPlayBar_PauseButtonClicked:(KKAlbumAssetModelVideoPlayBar*)aView;

- (void)KKAlbumAssetModelVideoPlayBar:(KKAlbumAssetModelVideoPlayBar*)aView currentTimeChanged:(NSTimeInterval)aCurrentTime;

@end
