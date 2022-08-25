//
//  KKAlbumImageShowNavBar.m
//  HeiPa
//
//  Created by liubo on 2019/3/16.
//  Copyright © 2019 gouuse. All rights reserved.
//

#import "KKAlbumImageShowNavBar.h"
#import "KKAlbumManager.h"
#import "KKAlbumImagePickerManager.h"
#import "KKMediaPickerDefine.h"

@interface KKAlbumImageShowNavBar ()

@property (nonatomic , assign) BOOL isSelectItem;

@end

@implementation KKAlbumImageShowNavBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIImageView *backgroundView = [[UIImageView alloc] initWithFrame:self.bounds];
        backgroundView.backgroundColor = [UIColor blackColor];
        backgroundView.alpha = 0.75;
        backgroundView.userInteractionEnabled = YES;
        [self addSubview:backgroundView];
        
        CGFloat fontHeight = ceilf([UIFont boldSystemFontOfSize:17].lineHeight);
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height-44+(44-fontHeight)/2.0, self.frame.size.width, fontHeight)];
        self.titleLabel.textColor = [UIColor whiteColor];
        self.titleLabel.numberOfLines = 0;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont boldSystemFontOfSize:17];
        self.titleLabel.text = @"9/9";
        self.titleLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:self.titleLabel];
        
        UIImage *image01 = [KKAlbumManager themeImageForName:@"NavBack"];
        self.backButton = [[UIButton alloc] initWithFrame:CGRectMake(0,self.frame.size.height-44, 60, 44)];
        [self.backButton addTarget:self action:@selector(navBackButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.backButton setImage:image01
                           forState:UIControlStateNormal];
        [self addSubview:self.backButton];
        
        UIImage *image02 = [KKAlbumManager themeImageForName:@"NavSelectedH"];
        self.rightButton = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width-44,self.frame.size.height-44, 30, 30)];
        [self.rightButton addTarget:self action:@selector(navRightButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.rightButton setImage:image02
                          forState:UIControlStateNormal];
        [self addSubview:self.rightButton];
        self.rightButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        [self.rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.rightButton.layer.cornerRadius = self.rightButton.frame.size.width/2.0;
        self.rightButton.layer.masksToBounds = YES;
    }
    return self;
}

- (void)navBackButtonClicked{
    if (self.delegate && [self.delegate respondsToSelector:@selector(KKAlbumImageShowNavBar_LeftButtonClicked)]) {
        [self.delegate KKAlbumImageShowNavBar_LeftButtonClicked];
    }
}

- (void)navRightButtonClicked{
    if (self.delegate && [self.delegate respondsToSelector:@selector(KKAlbumImageShowNavBar_RightButtonClicked)]) {
        [self.delegate KKAlbumImageShowNavBar_RightButtonClicked];
    }
}

- (void)setSelect:(BOOL)select item:(KKAlbumAssetModel*)aModel{
    self.isSelectItem = select;
    
    if (select) {
        NSInteger index = [KKAlbumImagePickerManager.defaultManager.allSource indexOfObject:aModel];
        NSString *title = [NSString stringWithFormat:@"%ld",index+1];
        [self.rightButton setBackgroundColor:KKMediaPicker_Clolor_1E95FF];
        [self.rightButton setImage:nil
                          forState:UIControlStateNormal];
        [self.rightButton setTitle:title forState:UIControlStateNormal];
        [self showZoomAnimation];
    }
    else{
        UIImage *image02 = [KKAlbumManager themeImageForName:@"NavSelectedH"];
        [self.rightButton setBackgroundColor:[UIColor clearColor]];
        [self.rightButton setImage:image02
                          forState:UIControlStateNormal];
        [self.rightButton setTitle:@"" forState:UIControlStateNormal];
    }

}

- (BOOL)isSelect{
    return self.isSelectItem;
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
    
    [self.rightButton.layer addAnimation:animation forKey:nil];
}


@end
