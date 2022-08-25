//
//  KKAlbumImageShowToolBar.m
//  HeiPa
//
//  Created by liubo on 2019/3/16.
//  Copyright © 2019 gouuse. All rights reserved.
//

#import "KKAlbumImageShowToolBar.h"
#import "KKAlbumManager.h"
#import "KKAlbumImagePickerManager.h"
#import "NSString+KKMediaPicker.h"
#import "KKMediaPickerDefine.h"
#import "UIWindow+KKMediaPicker.h"

#define KKAlbumImageShowToolBar_ButtonFont [UIFont boldSystemFontOfSize:14]
#define KKAlbumImageShowToolBar_InfoFont [UIFont systemFontOfSize:12]

@implementation KKAlbumImageShowToolBar

- (void)dealloc
{
    [NSNotificationCenter.defaultCenter removeObserver:self];
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        [self initUI];
        [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(Notification_KKAlbumManagerIsSelectOriginChanged:) name:NotificationName_KKAlbumManagerIsSelectOriginChanged object:nil];
    }
    return self;
}


- (void)initUI{
    
    UIImageView *backgroundView = [[UIImageView alloc] initWithFrame:self.bounds];
    backgroundView.backgroundColor = [UIColor blackColor];
    backgroundView.userInteractionEnabled = YES;
    [self addSubview:backgroundView];

    self.editButton = [[UIButton alloc] initWithFrame:CGRectMake(UIWindow.kkmp_screenWidth-15-60-15-60, 10, 60, 30)];
    [self.editButton setBackgroundColor:KKMediaPicker_Clolor_1E95FF];
    self.editButton.titleLabel.font = KKAlbumImageShowToolBar_ButtonFont;
    [self.editButton setTitle:KKMediaPicker_Album_Edit forState:UIControlStateNormal];
    self.editButton.backgroundColor = [UIColor clearColor];
    self.editButton.layer.cornerRadius = 15.0;
    self.editButton.layer.masksToBounds = YES;
    [self.editButton addTarget:self action:@selector(editButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.editButton];
    self.editButton.hidden = YES;

    self.originButton = [[UIButton alloc] initWithFrame:CGRectMake((UIWindow.kkmp_screenWidth-90)/2.0, 10, 90, 30)];
    [self.originButton setImage:[KKAlbumManager themeImageForName:@"UnSelected"] forState:UIControlStateNormal];
    [self.originButton setImage:[KKAlbumManager themeImageForName:@"SelectedH"] forState:UIControlStateSelected];
    self.originButton.titleLabel.font = KKAlbumImageShowToolBar_ButtonFont;
    [self.originButton setTitle:KKMediaPicker_Album_Origin forState:UIControlStateNormal];
    self.originButton.backgroundColor = [UIColor clearColor];
    [self.originButton addTarget:self action:@selector(originButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.originButton];
    self.originButton.hidden = NO;
    [self kkmp_setButtonLayout:self.originButton];
    if (KKAlbumImagePickerManager.defaultManager.isSelectOrigin) {
        self.originButton.selected = YES;
    } else {
        self.originButton.selected = NO;
    }

    self.okButton = [[UIButton alloc] initWithFrame:CGRectMake(UIWindow.kkmp_screenWidth-15-60, 10, 60, 30)];
    [self.okButton setBackgroundColor:KKMediaPicker_Clolor_1E95FF];
    self.okButton.titleLabel.font = KKAlbumImageShowToolBar_ButtonFont;
    [self.okButton setTitle:KKMediaPicker_Common_Done forState:UIControlStateNormal];
    self.okButton.backgroundColor = [UIColor clearColor];
    self.okButton.layer.cornerRadius = 15.0;
    self.okButton.layer.masksToBounds = YES;
    [self.okButton addTarget:self action:@selector(okButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.okButton];
    
    self.infoBoxView = [[UIImageView alloc]initWithFrame:CGRectMake(1 , 1, 1, 1)];
    self.infoBoxView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.infoBoxView];
    self.infoBoxView.hidden = YES;

    self.infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(1 , 1, 1, 1)];
    self.infoLabel.backgroundColor = [UIColor clearColor];
    self.infoLabel.textColor = [UIColor lightGrayColor];
    self.infoLabel.font = KKAlbumImageShowToolBar_InfoFont;
    [self addSubview:self.infoLabel];
    self.infoLabel.hidden = YES;
    
    NSInteger maxNumber = [KKAlbumImagePickerManager defaultManager].numberOfPhotosNeedSelected;
    NSInteger selectNumber = [[KKAlbumImagePickerManager defaultManager].allSource count];
    [self setNumberOfPic:selectNumber maxNumberOfPic:maxNumber];

    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(Notification_KKAlbumManagerDataSourceChanged:) name:NotificationName_KKAlbumManagerDataSourceChanged object:nil];

    self.editButton.frame = CGRectMake(15, 10, 60, 30);
}

/*编辑*/
- (void)editButtonClicked{
    if (self.delegate && [self.delegate respondsToSelector:@selector(KKAlbumImageShowToolBar_EditButtonClicked:)]) {
        [self.delegate KKAlbumImageShowToolBar_EditButtonClicked:self];
    }
}

/*原图*/
- (void)originButtonClicked{
    BOOL oldValue = KKAlbumImagePickerManager.defaultManager.isSelectOrigin;
    KKAlbumImagePickerManager.defaultManager.isSelectOrigin = !oldValue;
    [NSNotificationCenter.defaultCenter postNotificationName:NotificationName_KKAlbumManagerIsSelectOriginChanged object:nil];
}

/*确定*/
- (void)okButtonClicked{
    if (self.delegate && [self.delegate respondsToSelector:@selector(KKAlbumImageShowToolBar_OKButtonClicked:)]) {
        [self.delegate KKAlbumImageShowToolBar_OKButtonClicked:self];
    }
}

- (void)setNumberOfPic:(NSInteger)numberOfPic maxNumberOfPic:(NSInteger)maxNumberOfPic{

    if (numberOfPic>0) {
        self.okButton.userInteractionEnabled = YES;
        self.okButton.alpha = 1.0;
        NSString *okTitle = [NSString stringWithFormat:@"%@(%ld)",KKMediaPicker_Common_Done,(long)numberOfPic];
        CGSize size = [okTitle kkmp_sizeWithFont:KKAlbumImageShowToolBar_ButtonFont maxWidth:1000];
        self.okButton.frame = CGRectMake(UIWindow.kkmp_screenWidth-15-(size.width)-30, 10, size.width+30, 30);
        [self.okButton setTitle:okTitle forState:UIControlStateNormal];
    }
    else{
        self.okButton.userInteractionEnabled = NO;
        self.okButton.alpha = 0.3;
        [self.okButton setTitle:KKMediaPicker_Common_Done forState:UIControlStateNormal];
        self.okButton.frame = CGRectMake(UIWindow.kkmp_screenWidth-15-60, 10, 60, 30);
    }

    NSString *infoString = [NSString stringWithFormat:@"%ld/%ld ",(long)numberOfPic,(long)maxNumberOfPic];
    
    CGSize size = [infoString kkmp_sizeWithFont:KKAlbumImageShowToolBar_InfoFont maxWidth:1000];
    
    self.infoBoxView.frame = CGRectMake(15, (self.frame.size.height-30)/2.0, size.width+35, 30);
    
    UIImage *image01 = [KKAlbumManager themeImageForName:@"RoundRectBox"];
    self.infoBoxView.image = [image01 stretchableImageWithLeftCapWidth:20 topCapHeight:20];
    
    self.infoLabel.frame = CGRectMake(CGRectGetMinX(self.infoBoxView.frame)+25, (self.frame.size.height-30)/2.0, size.width, 30);
    self.infoLabel.text = infoString;
    
}

- (void)kkmp_setButtonLayout:(UIButton*)aButton{
    aButton.titleEdgeInsets = UIEdgeInsetsZero;
    aButton.imageEdgeInsets = UIEdgeInsetsZero;
    
    CGFloat aSpace = 5;
    
    NSString *aTitle = aButton.titleLabel.text;
    
    CGSize titleSize = [aTitle kkmp_sizeWithFont:aButton.titleLabel.font maxSize:CGSizeMake(aButton.frame.size.width, 1000)];
    
    CGSize aImageSize = aButton.imageView.frame.size;
    if (!aButton.imageView.image) {
        aImageSize = CGSizeZero;
    }
    
    // 取得imageView最初的center
    CGPoint startImageViewCenter = aButton.imageView.center;
    // 取得titleLabel最初的center
    CGPoint startTitleLabelCenter = aButton.titleLabel.center;
    
    // 找出titleLabel最终的center
    CGPoint endTitleLabelCenter = CGPointZero;
    // 找出imageView最终的center
    CGPoint endImageViewCenter = CGPointZero;
    
    // 找出imageView最终的center
    endImageViewCenter = CGPointMake((aButton.frame.size.width-titleSize.width-aImageSize.width-aSpace)/2.0+aImageSize.width/2.0, aButton.frame.size.height/2.0);
    // 找出titleLabel最终的center
    endTitleLabelCenter = CGPointMake(endImageViewCenter.x+(aImageSize.width)/2.0+aSpace+titleSize.width/2.0, aButton.frame.size.height/2.0);
    
    // 设置titleEdgeInsets
    CGFloat titleEdgeInsetsTop = endTitleLabelCenter.y-startTitleLabelCenter.y+aButton.titleEdgeInsets.top;
    CGFloat titleEdgeInsetsLeft = endTitleLabelCenter.x - startTitleLabelCenter.x+aButton.titleEdgeInsets.left;
    CGFloat titleEdgeInsetsBottom = -titleEdgeInsetsTop;
    CGFloat titleEdgeInsetsRight = -titleEdgeInsetsLeft;
    aButton.titleEdgeInsets = UIEdgeInsetsMake(titleEdgeInsetsTop, titleEdgeInsetsLeft, titleEdgeInsetsBottom, titleEdgeInsetsRight);
    
    
    // 设置imageEdgeInsets
    CGFloat imageEdgeInsetsTop = endImageViewCenter.y - startImageViewCenter.y+aButton.imageEdgeInsets.top;
    CGFloat imageEdgeInsetsLeft = endImageViewCenter.x - startImageViewCenter.x+aButton.imageEdgeInsets.left;
    CGFloat imageEdgeInsetsBottom = -imageEdgeInsetsTop;
    CGFloat imageEdgeInsetsRight = -imageEdgeInsetsLeft;
    aButton.imageEdgeInsets = UIEdgeInsetsMake(imageEdgeInsetsTop, imageEdgeInsetsLeft, imageEdgeInsetsBottom, imageEdgeInsetsRight);
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
    } else {
        self.originButton.selected = NO;
    }
}

@end
