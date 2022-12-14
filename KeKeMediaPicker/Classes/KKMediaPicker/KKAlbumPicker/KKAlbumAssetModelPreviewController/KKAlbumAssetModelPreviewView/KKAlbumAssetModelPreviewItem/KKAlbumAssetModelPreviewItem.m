//
//  KKAlbumAssetModelPreviewItem.m
//  BM
//
//  Created by sjyt on 2020/4/7.
//  Copyright © 2020 bm. All rights reserved.
//

#import "KKAlbumAssetModelPreviewItem.h"
#import "KKAlbumImagePickerManager.h"

@interface KKAlbumAssetModelPreviewItem ()

@property (nonatomic , assign) CGRect myImageViewOriginFrame;

@end

@implementation KKAlbumAssetModelPreviewItem

- (void)dealloc
{
    [NSNotificationCenter.defaultCenter removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.myScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        self.myScrollView.backgroundColor = [UIColor clearColor];
        self.myScrollView.bounces = YES;
        self.myScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight ;
        self.myScrollView.minimumZoomScale = 1.0;
        self.myScrollView.maximumZoomScale = 5.0;
        self.myScrollView.delegate = self;
        [self addSubview:self.myScrollView];
        if (@available(iOS 11.0, *)) {
            self.myScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }

        self.myImageView = [[UIImageView alloc]initWithFrame:self.bounds];
        self.myImageView.contentMode = UIViewContentModeScaleAspectFit;
        self.myImageView.clipsToBounds = YES;
        self.myImageView.backgroundColor = [UIColor clearColor];
        self.myImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight ;
        [self.myScrollView addSubview:self.myImageView];
        
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
        tapGestureRecognizer.delegate = self;
        [self.myScrollView addGestureRecognizer:tapGestureRecognizer];
        
        self.videoPlayButton = [[UIButton alloc] initWithFrame:self.bounds];
        [self.videoPlayButton addTarget:self action:@selector(videoPlayButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        UIImage *playImage = [KKAlbumManager themeImageForName:@"VideoPreviewPlay"];
        [self.videoPlayButton setImage:playImage forState:UIControlStateNormal];
        [self addSubview:self.videoPlayButton];
        
        [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(Notification_KKAlbumAssetModelPreviewItemResetZoomScale:) name:@"NotificationName_KKAlbumAssetModelPreviewItemResetZoomScale" object:nil];
        [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(Notification_KKAlbumAssetModelEditImageFinished:) name:NotificationName_KKAlbumAssetModelEditImageFinished object:nil];
    }
    return self;
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

//单击
-(void) singleTap:(UITapGestureRecognizer*) tap {
    if (self.delegate && [self.delegate respondsToSelector:@selector(KKAlbumAssetModelPreviewItemSingleTap:)]) {
        [self.delegate KKAlbumAssetModelPreviewItemSingleTap:self];
    }
}

- (void)Notification_KKAlbumAssetModelPreviewItemResetZoomScale:(NSNotification*)notice{
    
    NSInteger index = [notice.object integerValue];
    if (index!=self.row) {
        [self.myScrollView setZoomScale:1.0 animated:YES];

        UIImage *playImage = [KKAlbumManager themeImageForName:@"VideoPreviewPlay"];
        [self.videoPlayButton setImage:playImage forState:UIControlStateNormal];

        [self.player pause];
        self.player = nil;
        [self.playerLayer removeFromSuperlayer];
        self.playerLayer = nil;
    }
}

- (void)Notification_KKAlbumAssetModelEditImageFinished:(NSNotification*)notice{
    self.myImageView.image = self.assetModel.img_EditeImage;
    [self initImageViewFrame];
}


- (void)reloadWithInformation:(KKAlbumAssetModel*)aModel
                          row:(NSInteger)aRow{
    self.row = aRow;
    self.assetModel = aModel;

    
    //本地没有，去下载
    if (self.assetModel.bigImageForShowing==nil) {
        [self showWaitingView:YES];
        __weak   typeof(self) weakself = self;
        [KKAlbumManager loadBigImage_withPHAsset:weakself.assetModel.asset targetSize:CGSizeMake(self.myImageView.frame.size.width, self.myImageView.frame.size.height) resultBlock:^(UIImage * _Nullable aImage, NSDictionary * _Nullable info) {
            
            [weakself showWaitingView:NO];

            if (aImage) {
                weakself.assetModel.bigImage = aImage;
                weakself.myImageView.image = aImage;
                if (weakself.assetModel.asset.mediaType==PHAssetMediaTypeImage) {
                    [weakself initImageViewFrame];
                }
            }
            
        }];
    }
    else{
        self.myImageView.image = self.assetModel.bigImageForShowing;
        if (self.assetModel.asset.mediaType==PHAssetMediaTypeImage) {
            [self initImageViewFrame];
        }
    }

    if (self.assetModel.asset.mediaType==PHAssetMediaTypeImage) {
        self.videoPlayButton.hidden = YES;
        self.myScrollView.minimumZoomScale = 1.0;
        self.myScrollView.maximumZoomScale = 5.0;
    }
    else if (self.assetModel.asset.mediaType==PHAssetMediaTypeVideo) {
        self.myImageViewOriginFrame = self.bounds;
        [self.myScrollView setZoomScale:1.0 animated:YES];
        self.videoPlayButton.hidden = NO;
        self.myScrollView.minimumZoomScale = 1.0;
        self.myScrollView.maximumZoomScale = 1.0;
        
        self.myImageView.frame = self.bounds;
        self.myImageView.contentMode = UIViewContentModeScaleAspectFit;
        self.myImageView.clipsToBounds = YES;
        self.myImageView.backgroundColor = [UIColor clearColor];
        self.myImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight ;
    }
    else{
        self.videoPlayButton.hidden = YES;
    }
    
    [self reloadPlayer];
}

- (void)reloadPlayer{
    [self.player pause];
    self.player = nil;
    [self.playerLayer removeFromSuperlayer];
    self.playerLayer = nil;

    PHVideoRequestOptions *option = [[PHVideoRequestOptions alloc] init];
    option.networkAccessAllowed = NO;
    option.progressHandler = ^(double progress, NSError *error, BOOL *stop, NSDictionary *info) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                if (progressHandler) {
//                    progressHandler(progress, error, stop, info);
//                }
//            });
    };
    __weak   typeof(self) weakself = self;
    [[PHImageManager defaultManager] requestPlayerItemForVideo:self.assetModel.asset options:option resultHandler:^(AVPlayerItem *playerItem, NSDictionary *info) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (playerItem) {
                weakself.player = [[AVPlayer alloc]initWithPlayerItem:playerItem];
                
                AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:weakself.player];
                //设置模式
                playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
                playerLayer.contentsScale = [UIScreen mainScreen].scale;
                playerLayer.frame = weakself.bounds;
                [weakself.myImageView.layer addSublayer:playerLayer];
                weakself.playerLayer = playerLayer;
                
                [[NSNotificationCenter defaultCenter] addObserver:weakself selector:@selector(playbackFinished) name:AVPlayerItemDidPlayToEndTimeNotification object:weakself.player.currentItem];

            }
        });
        
    }];

}

#pragma mark ==================================================
#pragma mark == 缩放
#pragma mark ==================================================
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self.myImageView;//返回ScrollView上添加的需要缩放的视图
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView{
    [self reloadImageViewFrame];
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale{
//    [self reloadImageViewFrame];
//    NSLog(@"%@: SCALE:%.1f",view,scale);
}

- (void)reloadImageViewFrame{
    float imageWidth = self.myImageViewOriginFrame.size.width * self.myScrollView.zoomScale;
    float imageHeight = self.myImageViewOriginFrame.size.height * self.myScrollView.zoomScale;
    float newScrollWidth = MAX(self.myScrollView.contentSize.width, self.myScrollView.frame.size.width);
    float newScrollHeight = MAX(self.myScrollView.contentSize.height, self.myScrollView.frame.size.height);
    self.myImageView.frame = CGRectMake((newScrollWidth-imageWidth)/2.0, (newScrollHeight-imageHeight)/2.0, imageWidth, imageHeight);
//    NSLog(@"AAA scale:%.1f frame:%@",self.myScrollView.zoomScale,NSStringFromCGRect(self.myImageView.frame));
}

- (void)initImageViewFrame{
    if (self.myImageView.image) {
        self.myScrollView.minimumZoomScale = 1.0;
        self.myScrollView.maximumZoomScale = 5.0;
        
        float widthRatio = self.myScrollView.bounds.size.width / self.myImageView.image.size.width;
        float heightRatio = self.myScrollView.bounds.size.height / self.myImageView.image.size.height;
        float scale = MIN(widthRatio,heightRatio);
        float imageWidth = scale * self.myImageView.image.size.width * self.myScrollView.zoomScale;
        float imageHeight = scale * self.myImageView.image.size.height * self.myScrollView.zoomScale;
        self.myImageView.frame = CGRectMake((self.myScrollView.frame.size.width-imageWidth)/2.0, (self.myScrollView.frame.size.height-imageHeight)/2.0, imageWidth, imageHeight);
        self.myImageViewOriginFrame = self.myImageView.frame;
    } else {
        [self.myScrollView setZoomScale:1.0 animated:YES];;
        self.myScrollView.minimumZoomScale = 1.0;
        self.myScrollView.maximumZoomScale = 1.0;
        
        if (self.myImageView.animationImages && [self.myImageView.animationImages count]>0) {
            float widthRatio = self.myScrollView.bounds.size.width;
            float heightRatio = self.myScrollView.bounds.size.height;
            float scale = MIN(widthRatio,heightRatio);
            float imageWidth = scale * self.myImageView.bounds.size.width * self.myScrollView.zoomScale;
            float imageHeight = scale * self.myImageView.bounds.size.height * self.myScrollView.zoomScale;
            self.myImageView.frame = CGRectMake((self.myScrollView.frame.size.width-imageWidth)/2.0, (self.myScrollView.frame.size.height-imageHeight)/2.0, imageWidth, imageHeight);
            self.myImageViewOriginFrame = self.myImageView.frame;
        }
    }
}


#pragma mark ==================================================
#pragma mark == 视频播放
#pragma mark ==================================================
- (void)videoPlayButtonClicked{
    
    UIImage *image = [self.videoPlayButton imageForState:UIControlStateNormal];
    if (image) {
        if (self.player) {

            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished) name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];

            [self.player play];
            
            [self.videoPlayButton setImage:nil forState:UIControlStateNormal];
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(KKAlbumAssetModelPreviewItem:playVideo:)]) {
                [self.delegate KKAlbumAssetModelPreviewItem:self playVideo:YES];
            }

        }
        else{
            [self startPlay];
        }
    }
    else{
        [self.player pause];

        [NSNotificationCenter.defaultCenter removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];

        UIImage *playImage = [KKAlbumManager themeImageForName:@"VideoPreviewPlay"];
        [self.videoPlayButton setImage:playImage forState:UIControlStateNormal];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(KKAlbumAssetModelPreviewItem:playVideo:)]) {
            [self.delegate KKAlbumAssetModelPreviewItem:self playVideo:NO];
        }
    }
}

- (void)startPlay{
    if (self.player==nil) {
        
        
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
                    [weakself.myImageView.layer addSublayer:playerLayer];
                    weakself.playerLayer = playerLayer;
                    
                    [[NSNotificationCenter defaultCenter] addObserver:weakself selector:@selector(playbackFinished) name:AVPlayerItemDidPlayToEndTimeNotification object:weakself.player.currentItem];
                    
                    [weakself.player play];

                    [weakself.videoPlayButton setImage:nil forState:UIControlStateNormal];
                    
                    if (weakself.delegate && [weakself.delegate respondsToSelector:@selector(KKAlbumAssetModelPreviewItem:playVideo:)]) {
                        [weakself.delegate KKAlbumAssetModelPreviewItem:weakself playVideo:YES];
                    }
                }
            });


        }];
    }
}

- (void)playbackFinished{
    [self.player seekToTime:kCMTimeZero];
    [self videoPlayButtonClicked];
}

@end
