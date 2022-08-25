//
//  KKAlbumAssetModelVideoPlayBar.m
//  BM
//
//  Created by sjyt on 2020/4/7.
//  Copyright © 2020 bm. All rights reserved.
//

#import "KKAlbumAssetModelVideoPlayBar.h"
#import "NSString+KKMediaPicker.h"
#import "NSBundle+KKMediaPicker.h"
#import "KKMediaPickerDefine.h"

@implementation KKAlbumAssetModelVideoPlaySlider

- (CGRect)trackRectForBounds:(CGRect)bounds{
    CGRect rect = bounds;
    rect.origin.y = (self.frame.size.height-2.5)/2.0;
    rect.size.height = 2.5;
    return rect;
}

@end

@implementation KKAlbumAssetModelVideoPlayBar

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;

        self.backgroundImageView = [[UIImageView alloc] initWithFrame:self.bounds];
//        self.backgroundImageView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
        [self addSubview:self.backgroundImageView];
        
        //×按钮
        self.backButton = [[UIButton alloc] initWithFrame:CGRectMake(30, 0, 44, 44)];
        [self.backButton setImage:[self VideoPlay_Cha_ButtonImage]
                         forState:UIControlStateNormal];
        [self.backButton addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.backButton];
        
        //更多
        self.moreButton = [[UIButton alloc] initWithFrame:CGRectMake(30, 0, 44, 44)];
        [self.moreButton setImage:[self VideoPlay_More_ButtonImage]
                         forState:UIControlStateNormal];
        [self.moreButton addTarget:self action:@selector(moreButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.moreButton];

        
        //滑动条
        self.mySlider = [[KKAlbumAssetModelVideoPlaySlider alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 5)];
//        self.mySlider.minimumTrackTintColor = [UIColor colorWithHexString:@"#1296DB"];
//        self.mySlider.maximumTrackTintColor = [UIColor colorWithRed:0.82f green:0.82f blue:0.82f alpha:1.00f];
        self.mySlider.minimumTrackTintColor = KKMediaPicker_Clolor_BEBFBE;
        self.mySlider.maximumTrackTintColor = KKMediaPicker_Clolor_606160;
        [self.mySlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
        [self.mySlider addTarget:self action:@selector(sliderClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.mySlider addTarget:self action:@selector(sliderTouchedDown:) forControlEvents:UIControlEventTouchDown];
        [self.mySlider addTarget:self action:@selector(sliderTouchedOutSide:) forControlEvents:UIControlEventTouchUpOutside];
        [self.mySlider addTarget:self action:@selector(sliderTouchedOutSide:) forControlEvents:UIControlEventTouchDragOutside];
        [self.mySlider addTarget:self action:@selector(sliderTouchedOutSide:) forControlEvents:UIControlEventTouchCancel];

        [self.mySlider setThumbImage:[self VideoPlay_SliderPoint_ButtonImage]
                            forState:UIControlStateNormal];
        [self.mySlider setThumbImage:[self VideoPlay_SliderPoint_ButtonImage]
                            forState:UIControlStateHighlighted];
        [self addSubview:self.mySlider];
        self.mySlider.minimumValue = 0;
        self.mySlider.maximumValue = 1.0;
        
        //当前时间
        self.currentTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, self.frame.size.width-20, 20)];
        self.currentTimeLabel.backgroundColor = [UIColor clearColor];
        self.currentTimeLabel.text = @"00:00:00";
        self.currentTimeLabel.textColor = [UIColor whiteColor];
        self.currentTimeLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:self.currentTimeLabel];

        //总时长
        self.durationtimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, self.frame.size.width-20, 20)];
        self.durationtimeLabel.backgroundColor = [UIColor clearColor];
        self.durationtimeLabel.text = @"--:--:--";
        self.durationtimeLabel.textAlignment = NSTextAlignmentRight;
        self.durationtimeLabel.textColor = [UIColor whiteColor];
        self.durationtimeLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:self.durationtimeLabel];

        //播放与暂停
        CGFloat height = 44;
        self.stopPlayButton = [[UIButton alloc] initWithFrame:CGRectMake((self.frame.size.width-height)/2.0, 15, height, height)];
        self.stopPlayButton.exclusiveTouch = YES;
        
        [self.stopPlayButton setImage:[self VideoPlay_Play_ButtonImage]
                             forState:UIControlStateNormal];
        self.stopPlayButton.tag = 1110;
        self.stopPlayButton.backgroundColor = [UIColor clearColor];
        [self.stopPlayButton addTarget:self action:@selector(playButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.stopPlayButton];
        
        [self layoutSubviews];
    }
    return self;
}

#pragma mark ==================================================
#pragma mark == 刷新界面
#pragma mark ==================================================
- (void)layoutSubviews{
    [super layoutSubviews];
    UIInterfaceOrientation currentInterfaceOrientation = [UIApplication sharedApplication].statusBarOrientation;
    [self reloadSubviewsForUIInterfaceOrientation:currentInterfaceOrientation];
}

- (void)reloadSubviewsForUIInterfaceOrientation:(UIInterfaceOrientation)currentInterfaceOrientation{
    switch (currentInterfaceOrientation) {
        case UIInterfaceOrientationUnknown:
        case UIInterfaceOrientationPortrait:
        case UIInterfaceOrientationPortraitUpsideDown:{
            self.backgroundImageView.frame = self.bounds;
            CGFloat offsetX = 0;
            
            //时间
            NSString *time1 = self.currentTimeLabel.text;
            if (time1==nil || time1.length==0) {
                time1 = @"--:--:--";
            }
            CGSize size1 = [time1 kkmp_sizeWithFont:self.currentTimeLabel.font maxWidth:CGFLOAT_MAX];
            NSString *time2 = self.durationtimeLabel.text;
            if (time2==nil || time2.length==0) {
                time2 = @"--:--:--";
            }
            CGSize size2 = [time2 kkmp_sizeWithFont:self.durationtimeLabel.font maxWidth:CGFLOAT_MAX];

            //播放按钮
            self.stopPlayButton.frame = CGRectMake(offsetX, 0, 60, 60);
            offsetX = offsetX + self.stopPlayButton.frame.size.width;

            //当前时间
            self.currentTimeLabel.frame = CGRectMake(offsetX, 20, size1.width, 20);
            offsetX = offsetX + size1.width;

            //进度条
            offsetX = offsetX + 10;
            self.mySlider.frame = CGRectMake(offsetX, 20, (self.frame.size.width-offsetX-10-size2.width-15), 20);
            offsetX = offsetX + self.mySlider.frame.size.width;

            //总进度
            offsetX = offsetX + 10;
            self.durationtimeLabel.frame = CGRectMake(offsetX, 20, size2.width, 20);
            
            //cha
            self.backButton.frame = CGRectMake(0, 60, 60, 60);
            
            //更多
            self.moreButton.frame = CGRectMake(self.frame.size.width-60, 60, 60, 60);

            break;
        }
        case UIInterfaceOrientationLandscapeLeft:
        case UIInterfaceOrientationLandscapeRight:{
            self.backgroundImageView.frame = self.bounds;
            CGFloat offsetX = 0;
            
            //时间
            NSString *time1 = self.currentTimeLabel.text;
            if (time1==nil || time1.length==0) {
                time1 = @"--:--:--";
            }
            CGSize size1 = [time1 kkmp_sizeWithFont:self.currentTimeLabel.font maxWidth:CGFLOAT_MAX];
            NSString *time2 = self.durationtimeLabel.text;
            if (time2==nil || time2.length==0) {
                time2 = @"--:--:--";
            }
            CGSize size2 = [time2 kkmp_sizeWithFont:self.durationtimeLabel.font maxWidth:CGFLOAT_MAX];

            //cha
            self.backButton.frame = CGRectMake(offsetX, 0, 60, 60);
            offsetX = offsetX + self.backButton.frame.size.width;

            //播放按钮
            self.stopPlayButton.frame = CGRectMake(offsetX, 0, 60, 60);
            offsetX = offsetX + self.stopPlayButton.frame.size.width;

            //当前时间
            self.currentTimeLabel.frame = CGRectMake(offsetX, 20, size1.width, 20);
            offsetX = offsetX + size1.width;

            //进度条
            offsetX = offsetX + 10;
            self.mySlider.frame = CGRectMake(offsetX, 20, (self.frame.size.width-offsetX-10-size2.width-60-15), 20);
            offsetX = offsetX + self.mySlider.frame.size.width;

            //总进度
            offsetX = offsetX + 10;
            self.durationtimeLabel.frame = CGRectMake(offsetX, 20, size2.width, 20);
                        
            //更多
            self.moreButton.frame = CGRectMake(self.frame.size.width-60, 0, 60, 60);
            break;
        }
        default:
            break;
    }
    
    //渐进蒙层
    [self addShadow];
//    UIColor *startColor = [UIColor colorWithWhite:0 alpha:0.75];
//    UIColor *endColor = [UIColor clearColor];
//    [self.backgroundImageView setBackgroundColorFromColor:startColor toColor:endColor direction:UIViewGradientColorDirection_BottomTop];
}

- (void)addShadow{
    self.backgroundImageView.layer.shadowColor = [UIColor colorWithWhite:0 alpha:0.75].CGColor;
    self.backgroundImageView.layer.shadowOffset = CGSizeZero; // 设置偏移量为 0 ，四周都有阴影
    self.backgroundImageView.layer.shadowRadius = 50.0; //阴影半径,默认 3
    self.backgroundImageView.layer.shadowOpacity = 1.0; //阴影透明度 ，默认 0
    self.backgroundImageView.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:self.backgroundImageView.bounds cornerRadius:self.backgroundImageView.layer.cornerRadius].CGPath;
}

#pragma mark ==================================================
#pragma mark == 按钮事件
#pragma mark ==================================================
- (void)playButtonClicked{
    if (self.stopPlayButton.tag==1110) {
        //开始播放
        self.stopPlayButton.tag=1111;
        [self.stopPlayButton setImage:[self VideoPlay_Pause_ButtonImage]
                             forState:UIControlStateNormal];
        if (self.delegate && [self.delegate respondsToSelector:@selector(KKAlbumAssetModelVideoPlayBar_PlayButtonClicked:)]) {
            [self.delegate KKAlbumAssetModelVideoPlayBar_PlayButtonClicked:self];
        }
    }
    else{
        //暂停播放
        self.stopPlayButton.tag=1110;
        [self.stopPlayButton setImage:[self VideoPlay_Play_ButtonImage]
                             forState:UIControlStateNormal];
        if (self.delegate && [self.delegate respondsToSelector:@selector(KKAlbumAssetModelVideoPlayBar_PauseButtonClicked:)]) {
            [self.delegate KKAlbumAssetModelVideoPlayBar_PauseButtonClicked:self];
        }
    }
}

- (void)moreButtonClicked{
    if (self.delegate && [self.delegate respondsToSelector:@selector(KKAlbumAssetModelVideoPlayBar_MoreButtonClicked:)]) {
        [self.delegate KKAlbumAssetModelVideoPlayBar_MoreButtonClicked:self];
    }
}

- (void)backButtonClicked{
    if (self.delegate && [self.delegate respondsToSelector:@selector(KKAlbumAssetModelVideoPlayBar_BackButtonClicked:)]) {
        [self.delegate KKAlbumAssetModelVideoPlayBar_BackButtonClicked:self];
    }
}

- (void)sliderValueChanged:(UISlider*)slider{
    self.currentTime = slider.value;
}

- (void)sliderClicked:(UISlider*)slider{
    self.currentTime = slider.value;
    self.isSliderTouched = NO;
    if (self.delegate && [self.delegate respondsToSelector:@selector(KKAlbumAssetModelVideoPlayBar:currentTimeChanged:)]) {
        [self.delegate KKAlbumAssetModelVideoPlayBar:self currentTimeChanged:_currentTime];
    }
}

- (void)sliderTouchedDown:(UISlider*)slider{
    self.isSliderTouched = YES;
}

- (void)sliderTouchedOutSide:(UISlider*)slider{
    self.isSliderTouched = NO;
}

#pragma mark ==================================================
#pragma mark == 外部调用
#pragma mark ==================================================
- (void)setButtonStatusStop{
    //暂停播放
    self.stopPlayButton.tag=1110;
    [self.stopPlayButton setImage:[self VideoPlay_Play_ButtonImage]
                         forState:UIControlStateNormal];
}

- (void)setButtonStatusPlaying{
    //开始播放
    self.stopPlayButton.tag=1111;
    [self.stopPlayButton setImage:[self VideoPlay_Pause_ButtonImage]
                         forState:UIControlStateNormal];
}

#pragma mark ==================================================
#pragma mark == 私有方法
#pragma mark ==================================================
- (void)setCurrentTime:(NSTimeInterval)currentTime{
    if (currentTime!=_currentTime) {
       _currentTime = currentTime;
        self.mySlider.value = _currentTime;
        
        int HH = _currentTime/(60*60);
        int MM = (_currentTime - HH*(60*60))/60;
        int SS = _currentTime - HH*(60*60) - MM*60;
        self.currentTimeLabel.text = [NSString stringWithFormat:@"%02d:%02d:%02d",HH,MM,SS];

        [self layoutSubviews];
    }
}

- (void)setDurationtime:(NSTimeInterval)durationtime{
    if (durationtime!=_durationtime) {
        _durationtime = durationtime;
        self.mySlider.minimumValue = 0;
        self.mySlider.maximumValue = MAX(_durationtime, 1.0);
        
        int HH = _durationtime/(60*60);
        int MM = (_durationtime - HH*(60*60))/60;
        int SS = _durationtime - HH*(60*60) - MM*60;
        self.durationtimeLabel.text = [NSString stringWithFormat:@"%02d:%02d:%02d",HH,MM,SS];

        if (durationtime<=1) {
            self.durationtimeLabel.text = @"--:--:--";
        }
        [self layoutSubviews];
    }
}

- (UIImage*)VideoPlay_Play_ButtonImage{
    UIImage *image = [NSBundle kkmp_imageInBundle:@"KKVideoPlay_Resource.bundle" imageName:@"GUPlayer_Play2"];
    return image;
}

- (UIImage*)VideoPlay_Pause_ButtonImage{
    UIImage *image = [NSBundle kkmp_imageInBundle:@"KKVideoPlay_Resource.bundle" imageName:@"GUPlayer_Pause2"];
    return image;
}

- (UIImage*)VideoPlay_SliderPoint_ButtonImage{
    UIImage *image = [NSBundle kkmp_imageInBundle:@"KKVideoPlay_Resource.bundle" imageName:@"VideoPlay_SliderPoint"];
    return image;
}

- (UIImage*)VideoPlay_Cha_ButtonImage{
    UIImage *image = [NSBundle kkmp_imageInBundle:@"KKVideoPlay_Resource.bundle" imageName:@"GUPlayer_Cha"];
    return image;
}

- (UIImage*)VideoPlay_More_ButtonImage{
    UIImage *image = [NSBundle kkmp_imageInBundle:@"KKVideoPlay_Resource.bundle" imageName:@"GUPlayer_More"];
    return image;
}

@end

