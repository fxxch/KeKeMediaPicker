//
//  KKAlbumAssetModelVideoPlayView.m
//  BM
//
//  Created by sjyt on 2020/4/7.
//  Copyright © 2020 bm. All rights reserved.
//

#import "KKAlbumAssetModelVideoPlayView.h"

/**
 *  KKAlbumAssetModelVideoPlayStatus
 */
typedef NS_ENUM(NSInteger,KKAlbumAssetModelVideoPlayStatus) {
    
    KKAlbumAssetModelVideoPlayStatusNone = 0,/* 未知 */
    
    KKAlbumAssetModelVideoPlayStatusPlaying = 1,/* 播放 */
    
    KKAlbumAssetModelVideoPlayStatusStop = 2,/* 停止 */
    
    KKAlbumAssetModelVideoPlayStatusPause = 3,/* 暂停 */

};

@interface KKAlbumAssetModelVideoPlayView ()

@property (nonatomic , strong) UIView *waitingView;
@property (nonatomic , assign) float totalDuration;
@property (nonatomic , assign) KKAlbumAssetModelVideoPlayStatus status;
@property (nonatomic ,strong) id playbackTimeObserver;
@end

@implementation KKAlbumAssetModelVideoPlayView

- (void)dealloc
{
    [self removeKVOObserver];
}

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    self.playerLayer.frame = self.bounds;
}

- (instancetype)initWithFrame:(CGRect)frame albumAssetModel:(KKAlbumAssetModel*)aKKAlbumAssetModel{
    self = [super initWithFrame:frame];
    if (self) {
        self.assetModel = aKKAlbumAssetModel;
        [self initUI];
    }
    return self;
}

- (void)initUI{
    PHVideoRequestOptions *option = [[PHVideoRequestOptions alloc] init];
    option.networkAccessAllowed = YES;
    option.progressHandler = ^(double progress, NSError *error, BOOL *stop, NSDictionary *info) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                if (progressHandler) {
//                    progressHandler(progress, error, stop, info);
//                }
//            });
    };
    [self showWaitingView:YES];

    __weak   typeof(self) weakself = self;
    [[PHImageManager defaultManager] requestPlayerItemForVideo:self.assetModel.asset options:option resultHandler:^(AVPlayerItem *playerItem, NSDictionary *info) {

        dispatch_async(dispatch_get_main_queue(), ^{
            [weakself showWaitingView:NO];
            if (playerItem) {
                weakself.player = [[AVPlayer alloc]initWithPlayerItem:playerItem];
                AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:weakself.player];
                //设置模式
                playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
                playerLayer.contentsScale = [UIScreen mainScreen].scale;
                playerLayer.frame = weakself.bounds;
                [weakself.layer addSublayer:playerLayer];
                weakself.playerLayer = playerLayer;
                
                [self addKVO];
                
                [self addNotification];
                                                
                if (weakself.delegate && [weakself.delegate respondsToSelector:@selector(KKAlbumAssetModelVideoPlayView:playVideo:)]) {
                    [weakself.delegate KKAlbumAssetModelVideoPlayView:weakself playVideo:YES];
                }
            }
        });
    }];
}

- (void)showWaitingView:(BOOL)show{
    if (show) {
        if (self.waitingView==nil) {
            self.waitingView = [[UIView alloc] initWithFrame:self.bounds];
            self.waitingView.backgroundColor = [UIColor clearColor];
            self.waitingView.contentMode = UIViewContentModeScaleAspectFit;
            self.waitingView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
            [self addSubview:self.waitingView];
            self.waitingView.clipsToBounds = YES;
            self.waitingView.userInteractionEnabled = YES;
            
            UIActivityIndicatorView *activeView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
            [activeView startAnimating];
            activeView.tag = 2020040601;
            activeView.center = CGPointMake(self.waitingView.frame.size.width/2.0, self.waitingView.frame.size.height/2.0);
            activeView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
            [self.waitingView addSubview:activeView];
            self.waitingView.hidden = YES;
        }
        self.waitingView.hidden = NO;
        self.waitingView.frame = self.bounds;
        UIActivityIndicatorView *activeView = [self.waitingView viewWithTag:2020040601];
        activeView.center = CGPointMake(self.waitingView.frame.size.width/2.0, self.waitingView.frame.size.height/2.0);
    } else {
        self.waitingView.hidden = YES;
    }
}

#pragma mark ==================================================
#pragma mark == 播放控制
#pragma mark ==================================================
- (void)startPlay{
    [self.player play];
    self.status = KKAlbumAssetModelVideoPlayStatusPlaying;
    if (self.delegate && [self.delegate respondsToSelector:@selector(KKAlbumAssetModelVideoPlayView_PlayDidStart:)]) {
        [self.delegate KKAlbumAssetModelVideoPlayView_PlayDidStart:self];
    }
}

- (void)stopPlay{
    [self.player seekToTime:kCMTimeZero];
    [self.player pause];
    self.status = KKAlbumAssetModelVideoPlayStatusStop;
    if (self.delegate && [self.delegate respondsToSelector:@selector(KKAlbumAssetModelVideoPlayView_PlayDidFinished:)]) {
        [self.delegate KKAlbumAssetModelVideoPlayView_PlayDidFinished:self];
    }
}

- (void)pausePlay{
    [self.player pause];
    self.status = KKAlbumAssetModelVideoPlayStatusPause;
    if (self.delegate && [self.delegate respondsToSelector:@selector(KKAlbumAssetModelVideoPlayView_PlayDidPause:)]) {
        [self.delegate KKAlbumAssetModelVideoPlayView_PlayDidPause:self];
    }
}

- (void)seekToBackTime:(NSTimeInterval)aTime{
    [self.player seekToTime:CMTimeMakeWithSeconds(aTime, 1*NSEC_PER_SEC)];
}

- (BOOL)isPlaying{
    if (self.status == KKAlbumAssetModelVideoPlayStatusPlaying) {
        return YES;
    } else {
        return NO;
    }
}

#pragma mark ==================================================
#pragma mark == KVO
#pragma mark ==================================================
-(void)addKVO{
    //监听状态属性
    [[self.player currentItem] addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    //监听网络加载情况属性
    [[self.player currentItem] addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
    //监听播放的区域缓存是否为空
    [[self.player currentItem] addObserver:self forKeyPath:@"playbackBufferEmpty" options:NSKeyValueObservingOptionNew context:nil];
    //缓存可以播放的时候调用
    [[self.player currentItem] addObserver:self forKeyPath:@"playbackLikelyToKeepUp" options:NSKeyValueObservingOptionNew context:nil];
    //监听暂停或者播放中
    [self.player addObserver:self forKeyPath:@"rate" options:NSKeyValueObservingOptionNew context:nil];
    [self.player addObserver:self forKeyPath:@"timeControlStatus" options:NSKeyValueObservingOptionNew context:nil];
}

//移除监听
- (void)removeKVOObserver{
    [[self.player currentItem] removeObserver:self forKeyPath:@"status" context:nil];
    [[self.player currentItem] removeObserver:self forKeyPath:@"loadedTimeRanges" context:nil];
    [[self.player currentItem] removeObserver:self forKeyPath:@"playbackBufferEmpty" context:nil];
    [[self.player currentItem] removeObserver:self forKeyPath:@"playbackLikelyToKeepUp" context:nil];
    [self.player removeObserver:self forKeyPath:@"rate" context:nil];
    [self.player removeObserver:self forKeyPath:@"timeControlStatus" context:nil];
}

/**
 监听滚动距离
 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    NSLog(@"%@: %@",keyPath,object);

    if ([keyPath isEqualToString:@"rate"]) {

    }
    else if ([keyPath isEqualToString:@"timeControlStatus"]){
        
    }
    else if ([keyPath isEqualToString:@"status"]){
        AVPlayerStatus status = [[change objectForKey:@"new"] intValue];
        if (status == AVPlayerStatusReadyToPlay) {
            NSLog(@"准备好播放");
            CMTime duration = [self.player currentItem].duration;
            self.totalDuration = CMTimeGetSeconds(duration);//总时长
            NSLog(@"视频总时长:%.2f",self.totalDuration);
            // 播放
            [self.player play];
            self.status = KKAlbumAssetModelVideoPlayStatusPlaying;

            // 监听播放状态
            if (self.playbackTimeObserver==nil) {
                __weak   typeof(self) weakself = self;
                self.playbackTimeObserver = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 5) queue:NULL usingBlock:^(CMTime time) {
                    CGFloat currentSecond = weakself.player.currentItem.currentTime.value/weakself.player.currentItem.currentTime.timescale;// 计算当前在第几秒
                    //如果需要进度条的话，这里可以更新进度条
                    if (weakself.delegate && [weakself.delegate respondsToSelector:@selector(KKAlbumAssetModelVideoPlayView:playBackTimeChanged:durationtime:)]) {
                        [weakself.delegate KKAlbumAssetModelVideoPlayView:weakself playBackTimeChanged:currentSecond durationtime:weakself.totalDuration];
                    }

                }];
            }
            
        }else if (status == AVPlayerStatusFailed){
            NSLog(@"视频准备发生错误");
        }else{
            NSLog(@"位置错误");
        }
    }
    else if ([keyPath isEqualToString:@"loadedTimeRanges"]){
        
    }
    else if ([keyPath isEqualToString:@"playbackBufferEmpty"]){
        
    }
    else if ([keyPath isEqualToString:@"playbackLikelyToKeepUp"]){
        
    }
    else {
        
    }
}


#pragma mark ==================================================
#pragma mark == 通知
#pragma mark ==================================================
- (void)addNotification{
    [NSNotificationCenter.defaultCenter removeObserver:self];
    //监听当视频播放结束时
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(PlayerItemDidPlayToEndTimeNotification:) name:AVPlayerItemDidPlayToEndTimeNotification object:[self.player currentItem]];
    //监听当视频开始或快进或者慢进或者跳过某段播放
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(PlayerItemTimeJumpedNotification:) name:AVPlayerItemTimeJumpedNotification object:[self.player currentItem]];
    //监听播放失败时
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(PlayerItemFailedToPlayToEndTimeNotification:) name:AVPlayerItemFailedToPlayToEndTimeNotification object:[self.player currentItem]];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(PlayerItemPlaybackStalledNotification:) name:AVPlayerItemPlaybackStalledNotification object:[self.player currentItem]];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(PlayerItemNewAccessLogEntryNotification:) name:AVPlayerItemNewAccessLogEntryNotification object:[self.player currentItem]];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(PlayerItemNewErrorLogEntryNotification:) name:AVPlayerItemNewErrorLogEntryNotification object:[self.player currentItem]];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(PlayerItemFailedToPlayToEndTimeErrorKey:) name:AVPlayerItemFailedToPlayToEndTimeErrorKey object:[self.player currentItem]];
}

- (void)PlayerItemDidPlayToEndTimeNotification:(NSNotification*)notice{
    [self.player seekToTime:kCMTimeZero];
    [self.player pause];
    self.status = KKAlbumAssetModelVideoPlayStatusStop;
    if (self.delegate && [self.delegate respondsToSelector:@selector(KKAlbumAssetModelVideoPlayView_PlayDidFinished:)]) {
        [self.delegate KKAlbumAssetModelVideoPlayView_PlayDidFinished:self];
    }
}

- (void)PlayerItemTimeJumpedNotification:(NSNotification*)notice{
    NSLog(@"%s: %@",__FUNCTION__,notice.object);
}

- (void)PlayerItemFailedToPlayToEndTimeNotification:(NSNotification*)notice{
    NSLog(@"%s: %@",__FUNCTION__,notice.object);
}

- (void)PlayerItemNewAccessLogEntryNotification:(NSNotification*)notice{
    NSLog(@"%s: %@",__FUNCTION__,notice.object);
}

- (void)PlayerItemNewErrorLogEntryNotification:(NSNotification*)notice{
    NSLog(@"%s: %@",__FUNCTION__,notice.object);
}

- (void)PlayerItemPlaybackStalledNotification:(NSNotification*)notice{
    NSLog(@"%s: %@",__FUNCTION__,notice.object);
}

- (void)PlayerItemFailedToPlayToEndTimeErrorKey:(NSNotification*)notice{
    NSLog(@"%s: %@",__FUNCTION__,notice.object);
}

@end
