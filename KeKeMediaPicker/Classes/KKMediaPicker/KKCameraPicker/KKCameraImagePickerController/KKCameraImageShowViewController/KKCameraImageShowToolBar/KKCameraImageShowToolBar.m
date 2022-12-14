//
//  KKCameraImageShowToolBar.m
//  HeiPa
//
//  Created by liubo on 2019/3/16.
//  Copyright © 2019 gouuse. All rights reserved.
//

#import "KKCameraImageShowToolBar.h"
#import "KKAlbumManager.h"
#import "NSString+KKMediaPicker.h"
#import "KKMediaPickerDefine.h"
#import "UIWindow+KKMediaPicker.h"
#import "KKMediaPickerLocalization.h"

@implementation KKCameraImageShowToolBar

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
    backgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.25];
    backgroundView.userInteractionEnabled = YES;
    [self addSubview:backgroundView];
    
    self.okButton = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width-60, 5, 60, 30)];
    [self.okButton setImage:[KKAlbumManager themeImageForName:@"Done"] forState:UIControlStateNormal];
    self.okButton.backgroundColor = [UIColor clearColor];
    [self.okButton addTarget:self action:@selector(okButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.okButton];
    
    self.infoBoxView = [[UIImageView alloc]initWithFrame:CGRectMake(1 , 1, 1, 1)];
    self.infoBoxView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.infoBoxView];
    
    self.infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(1 , 1, 1, 1)];
    self.infoLabel.backgroundColor = [UIColor clearColor];
    self.infoLabel.textColor = [UIColor lightGrayColor];
    self.infoLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:self.infoLabel];
    
    [self setNumberOfPic:0 maxNumberOfPic:1];
}

/*图片*/
- (void)okButtonClicked{
    if (self.delegate && [self.delegate respondsToSelector:@selector(KKCameraImageShowToolBar_OKButtonClicked:)]) {
        [self.delegate KKCameraImageShowToolBar_OKButtonClicked:self];
    }
}

- (void)setNumberOfPic:(NSInteger)numberOfPic maxNumberOfPic:(NSInteger)maxNumberOfPic{
    
    if (numberOfPic>0) {
        self.okButton.userInteractionEnabled = YES;
    }
    else{
        self.okButton.userInteractionEnabled = NO;
    }
    
    NSString *infoString = [NSString stringWithFormat:@"%ld/%ld ",(long)numberOfPic,(long)maxNumberOfPic];
    
    CGSize size = [infoString kkmp_sizeWithFont:[UIFont systemFontOfSize:12] maxWidth:1000];
    
    self.infoBoxView.frame = CGRectMake(15, 10, size.width+35, 30);
    
    UIImage *image01 = [KKAlbumManager themeImageForName:@"RoundRectBox"];
    self.infoBoxView.image = [image01 stretchableImageWithLeftCapWidth:20 topCapHeight:20];
    
    self.infoLabel.frame = CGRectMake(CGRectGetMinX(self.infoBoxView.frame)+25, (self.infoBoxView.frame.origin.y + (self.infoBoxView.frame.size.height-30)/2.0), size.width, 30);
    self.infoLabel.text = infoString;
    
}

@end
