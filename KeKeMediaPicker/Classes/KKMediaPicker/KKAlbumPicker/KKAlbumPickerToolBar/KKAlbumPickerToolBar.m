//
//  KKAlbumPickerToolBar.m
//  KeKeMediaPicker
//
//  Created by edward lannister on 2022/09/05.
//  Copyright © 2022 KKLibrary. All rights reserved.
//

#import "KKAlbumPickerToolBar.h"
#import "KKAlbumManager.h"
#import "KKMediaPickerLocalization.h"
#import "UIButton+KKMediaPicker.h"
#import "KKAlbumImagePickerManager.h"
#import "NSString+KKMediaPicker.h"

#define KKAlbumPickerToolBar_ButtonFont [UIFont boldSystemFontOfSize:14]

@implementation KKAlbumPickerToolBar

- (void)dealloc{
    [NSNotificationCenter.defaultCenter removeObserver:self];
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        [self initUI];
    }
    return self;
}

- (void)initUI{
    UIImageView *backgroundView = [[UIImageView alloc] initWithFrame:self.bounds];
    backgroundView.backgroundColor = [UIColor blackColor];
    backgroundView.userInteractionEnabled = YES;
    [self addSubview:backgroundView];

    //Edit
    self.editButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 10, 60, 30)];
    [self.editButton setImage:[KKAlbumManager themeImageForName:@"EditImage"] forState:UIControlStateNormal];
    self.editButton.backgroundColor = [UIColor clearColor];
    [self.editButton addTarget:self action:@selector(editButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.editButton];
    // TODO:暂时关闭编辑功能
    self.editButton.enabled = NO;
    self.editButton.alpha = 0;

    //countBoxButton
    self.countBoxButton = [[KKMediaPickerCountBoxView alloc] initWithFrame:CGRectMake(15, 10, 60, 30)];
    self.countBoxButton.backgroundColor = [UIColor clearColor];
    [self.countBoxButton addTarget:self action:@selector(countBoxButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.countBoxButton];
    self.countBoxButton.hidden = YES;
    
    //Origin
//    NSString *title = [KKMediaPickerLocalization localizationStringForKey:KKMediaPickerLocalKey_Album_Origin];
//    CGSize titleSize = [title kkmp_sizeWithFont:KKAlbumPickerToolBar_ButtonFont maxWidth:self.frame.size.width-120-35];
    self.originButton = [[UIButton alloc] initWithFrame:CGRectMake((self.frame.size.width-60)/2.0, 0, 60, 50)];
    [self.originButton setImage:[KKAlbumManager themeImageForName:@"OriginImageN"] forState:UIControlStateNormal];
    [self.originButton setImage:[KKAlbumManager themeImageForName:@"OriginImageH"] forState:UIControlStateSelected];
    self.originButton.titleLabel.font = KKAlbumPickerToolBar_ButtonFont;
//    [self.originButton setTitle:title forState:UIControlStateNormal];
    self.originButton.backgroundColor = [UIColor clearColor];
    [self.originButton addTarget:self action:@selector(originButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.originButton];
    self.originButton.hidden = NO;
    [self.originButton kkmp_setButtonImgLeftTitleRightCenter];
    if (KKAlbumImagePickerManager.defaultManager.isSelectOrigin) {
        self.originButton.selected = YES;
    } else {
        self.originButton.selected = NO;
    }

    //Done
    self.doneButton = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width-60, 10, 60, 30)];
    self.doneButton.backgroundColor = [UIColor clearColor];
    [self.doneButton setImage:[KKAlbumManager themeImageForName:@"Done"] forState:UIControlStateNormal];
    [self.doneButton addTarget:self action:@selector(doneButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.doneButton];
    
    NSInteger maxNumber = [KKAlbumImagePickerManager defaultManager].numberOfPhotosNeedSelected;
    NSInteger selectNumber = [[KKAlbumImagePickerManager defaultManager].allSource count];
    [self setNumberOfPic:selectNumber maxNumberOfPic:maxNumber];

    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(Notification_KKAlbumManagerIsSelectOriginChanged:) name:NotificationName_KKAlbumManagerIsSelectOriginChanged object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(Notification_KKAlbumManagerDataSourceChanged:) name:NotificationName_KKAlbumManagerDataSourceChanged object:nil];
}

#pragma mark ==================================================
#pragma mark == EVENT
#pragma mark ==================================================
- (void)editButtonClicked{
    if (self.delegate && [self.delegate respondsToSelector:@selector(KKAlbumPickerToolBar_EditButtonClicked:)]) {
        [self.delegate KKAlbumPickerToolBar_EditButtonClicked:self];
    }
}

- (void)countBoxButtonClicked{
    if (self.delegate && [self.delegate respondsToSelector:@selector(KKAlbumPickerToolBar_CountBoxButtonClicked:)]) {
        [self.delegate KKAlbumPickerToolBar_CountBoxButtonClicked:self];
    }
}

- (void)originButtonClicked{
    BOOL oldValue = KKAlbumImagePickerManager.defaultManager.isSelectOrigin;
    KKAlbumImagePickerManager.defaultManager.isSelectOrigin = !oldValue;
    [NSNotificationCenter.defaultCenter postNotificationName:NotificationName_KKAlbumManagerIsSelectOriginChanged object:nil];
}

- (void)doneButtonClicked{
    if (self.delegate && [self.delegate respondsToSelector:@selector(KKAlbumPickerToolBar_DoneButtonClicked:)]) {
        [self.delegate KKAlbumPickerToolBar_DoneButtonClicked:self];
    }
}

#pragma mark ==================================================
#pragma mark == 处理
#pragma mark ==================================================
- (void)setNumberOfPic:(NSInteger)numberOfPic maxNumberOfPic:(NSInteger)maxNumberOfPic{
    if (numberOfPic>0) {
        self.doneButton.userInteractionEnabled = YES;
        self.doneButton.alpha = 1.0;
    }
    else{
        self.doneButton.userInteractionEnabled = NO;
        self.doneButton.alpha = 0.3;
    }
    [self.countBoxButton setNumberOfPic:numberOfPic maxNumberOfPic:maxNumberOfPic];
}

#pragma mark ==================================================
#pragma mark == 通知
#pragma mark ==================================================
- (void)Notification_KKAlbumManagerDataSourceChanged:(NSNotification*)notice{
    NSInteger maxNumber = [KKAlbumImagePickerManager defaultManager].numberOfPhotosNeedSelected;
    NSInteger selectNumber = [[KKAlbumImagePickerManager defaultManager].allSource count];
    [self setNumberOfPic:selectNumber maxNumberOfPic:maxNumber];
}

- (void)Notification_KKAlbumManagerIsSelectOriginChanged:(NSNotification*)notice{
    if (KKAlbumImagePickerManager.defaultManager.isSelectOrigin) {
        self.originButton.selected = YES;
        [self showZoomAnimation];
    } else {
        self.originButton.selected = NO;
    }
}

#pragma mark ==================================================
#pragma mark == 缩放动画
#pragma mark ==================================================
- (void)showZoomAnimation{
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    
    animation.duration = 0.5;
    
    NSMutableArray *values = [NSMutableArray array];

    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.85, 0.85, 1.0)]];
    
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1, 1.1, 1.0)]];
    
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1.0)]];
    
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    
    animation.values = values;
    
    [self.originButton.layer addAnimation:animation forKey:nil];
}


@end
