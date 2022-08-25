//
//  KKAlbumAssetModelVideoPlayView.h
//  BM
//
//  Created by sjyt on 2020/4/7.
//  Copyright © 2020 bm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>
#import "KKAlbumAssetModel.h"

@protocol KKAlbumAssetModelVideoPlayViewDelegate;


@interface KKAlbumAssetModelVideoPlayView : UIView

@property (nonatomic,strong) AVPlayer *player;
@property (nonatomic,strong) AVPlayerLayer *playerLayer;
@property (nonatomic , strong) KKAlbumAssetModel *assetModel;
@property (nonatomic , weak) id<KKAlbumAssetModelVideoPlayViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame albumAssetModel:(KKAlbumAssetModel*)aKKAlbumAssetModel;

- (void)startPlay;

- (void)stopPlay;

- (void)pausePlay;

- (void)seekToBackTime:(NSTimeInterval)aTime;

- (BOOL)isPlaying;

@end


#pragma mark ==================================================
#pragma mark == KKAlbumAssetModelVideoPlayViewDelegate
#pragma mark ==================================================
@protocol KKAlbumAssetModelVideoPlayViewDelegate <NSObject>
@optional

- (void)KKAlbumAssetModelVideoPlayView:(KKAlbumAssetModelVideoPlayView*)aView
                             playVideo:(BOOL)playVideo;

@required
//播放开始
- (void)KKAlbumAssetModelVideoPlayView_PlayDidStart:(KKAlbumAssetModelVideoPlayView*)player;

//继续开始
- (void)KKAlbumAssetModelVideoPlayView_PlayDidContinuePlay:(KKAlbumAssetModelVideoPlayView*)player;

//播放结束
- (void)KKAlbumAssetModelVideoPlayView_PlayDidFinished:(KKAlbumAssetModelVideoPlayView*)player;

//播放暂停
- (void)KKAlbumAssetModelVideoPlayView_PlayDidPause:(KKAlbumAssetModelVideoPlayView*)player;

//播放时间改变
- (void)KKAlbumAssetModelVideoPlayView:(KKAlbumAssetModelVideoPlayView*)player
                   playBackTimeChanged:(NSTimeInterval)currentTime
                          durationtime:(NSTimeInterval)durationtime;

@end

