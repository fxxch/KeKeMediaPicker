//
//  KKCameraImageShowNavBar.m
//  HeiPa
//
//  Created by liubo on 2019/3/15.
//  Copyright © 2019 gouuse. All rights reserved.
//

#import "KKCameraImageShowNavBar.h"
#import "KKAlbumManager.h"

@implementation KKCameraImageShowNavBar

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

        UIImage *image02 = [KKAlbumManager themeImageForName:@"DeleteNav"];
        self.rightButton = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width-44,self.frame.size.height-44, 44, 44)];
        [self.rightButton addTarget:self action:@selector(navRightButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.rightButton setImage:image02
                          forState:UIControlStateNormal];
        [self addSubview:self.rightButton];
    }
    return self;
}

- (void)navBackButtonClicked{
    if (self.delegate && [self.delegate respondsToSelector:@selector(KKCameraImageShowNavBar_LeftButtonClicked)]) {
        [self.delegate KKCameraImageShowNavBar_LeftButtonClicked];
    }
}

- (void)navRightButtonClicked{
    if (self.delegate && [self.delegate respondsToSelector:@selector(KKCameraImageShowNavBar_RightButtonClicked)]) {
        [self.delegate KKCameraImageShowNavBar_RightButtonClicked];
    }
}

@end
