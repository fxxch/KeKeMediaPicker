//
//  KKMediaPickerWatingView.m
//  KeKeMediaPicker
//
//  Created by edward lannister on 2022/08/15.
//  Copyright © 2022 KKLibrary. All rights reserved.
//

#import "KKMediaPickerWatingView.h"
#import "UIWindow+KKMediaPicker.h"

#define KKMediaPickerWatingView_TagWindow 2022081501
#define KKMediaPickerWatingView_TagView 2022081502

@interface KKMediaPickerWatingView ()


@end

@implementation KKMediaPickerWatingView

+ (KKMediaPickerWatingView*)showInView:(UIView*)aView
                       blackBackground:(BOOL)aBlackBackground{

    [KKMediaPickerWatingView hideForView:aView animation:NO];
    
    KKMediaPickerWatingView *subView = [[KKMediaPickerWatingView alloc] initWithFrame:aView.bounds
                                                                      blackBackground:aBlackBackground];
    if ([aView isKindOfClass:[UIWindow class]]) {
        subView.tag = KKMediaPickerWatingView_TagWindow;
    }
    else{
        subView.tag = KKMediaPickerWatingView_TagView;
    }
    [aView addSubview:subView];
    [aView bringSubviewToFront:subView];
    subView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

    return subView;
}

+ (void)hideForView:(UIView*)aView{
    [KKMediaPickerWatingView hideForView:aView animation:YES];
}

+ (void)hideForView:(UIView*)aView animation:(BOOL)animation{
    
    KKMediaPickerWatingView *subView = nil;
    if ([aView isKindOfClass:[UIWindow class]]) {
        subView = (KKMediaPickerWatingView*)[aView viewWithTag:KKMediaPickerWatingView_TagWindow];
    }
    else{
        subView = (KKMediaPickerWatingView*)[aView viewWithTag:KKMediaPickerWatingView_TagView];
    }

    if (subView) {
        [subView.superview bringSubviewToFront:subView];
        
        if (animation) {
            [UIView animateWithDuration:0.25 animations:^{
                subView.alpha = 0;
            } completion:^(BOOL finished) {
                [subView removeFromSuperview];
            }];
        }
        else{
            [subView removeFromSuperview];
        }
    }
}

- (instancetype)initWithFrame:(CGRect)frame
              blackBackground:(BOOL)aBlackBackground{
    self = [super initWithFrame:frame];
    if (self) {
        self.blackBackground = aBlackBackground;
        self.backgroundColor = [UIColor clearColor];
        
        [[UIWindow kkmp_currentKeyWindow] endEditing:YES];
        
        [self initUI];
    }
    return self;
}

- (void)initUI{
    
    if (self.blackBackground) {
        
        //黑色背景
        UIButton *button = [[UIButton alloc] initWithFrame:self.bounds];
        button.backgroundColor = [UIColor blackColor];
        button.alpha = 0.5;
        [self addSubview:button];
        
        //
        CGFloat img_width = 40;
        CGFloat img_height = 40;
        CGFloat spaceBetween = 0;

        CGFloat Y = (self.frame.size.height-img_height-spaceBetween)/2.0;
        
        //黑色框
        UIView *boxView = [[UIView alloc] initWithFrame:CGRectMake((self.frame.size.width-img_width)/2.0, Y, img_width, img_height)];
        boxView.backgroundColor = [UIColor clearColor];
        boxView.alpha = 0.6;
        [self addSubview:boxView];

        UIActivityIndicatorView *iconImageView = [[UIActivityIndicatorView alloc] initWithFrame:boxView.frame];
        [self addSubview:iconImageView];
        iconImageView.tag = 20171024;
        iconImageView.userInteractionEnabled = NO;
        Y = Y + img_height;
        //开始旋转动画
        [iconImageView startAnimating];
    }
    else{
        //黑色背景
        UIButton *button = [[UIButton alloc] initWithFrame:self.bounds];
        button.backgroundColor = [UIColor clearColor];
        button.alpha = 0.6;
        [self addSubview:button];
        
        //
        CGFloat img_width = 40;
        CGFloat img_height = 40;
        CGFloat bigBox_width = self.frame.size.width-160;
        CGFloat bigBox_height = (25+img_height+25);
        if (bigBox_height<bigBox_width) {
            bigBox_width = bigBox_height;
        }
        
        CGFloat Y = (button.frame.size.height-bigBox_height)/2.0;
        
        //大黑色框
        UIView *bigBoxView = [[UIView alloc] initWithFrame:CGRectMake((button.frame.size.width-bigBox_width)/2.0, Y, bigBox_width, bigBox_height)];
        bigBoxView.backgroundColor = [UIColor blackColor];
        bigBoxView.alpha = 0.5;
        bigBoxView.layer.cornerRadius = 5;
        bigBoxView.layer.masksToBounds = YES;
        [self addSubview:bigBoxView];
        Y = Y+25;

        //黑色框
        UIView *boxView = [[UIView alloc] initWithFrame:CGRectMake((button.frame.size.width-img_width)/2.0, Y, img_width, img_height)];
        boxView.backgroundColor = [UIColor clearColor];
        boxView.alpha = 0.6;
        [self addSubview:boxView];

        UIActivityIndicatorView *iconImageView = [[UIActivityIndicatorView alloc] initWithFrame:boxView.frame];
        iconImageView.tag = 20171024;
        [self addSubview:iconImageView];
        iconImageView.userInteractionEnabled = NO;
        Y = Y + img_height;
        //开始旋转动画
        [iconImageView startAnimating];
    }
}

- (void)startAnimating{
    
    UIImageView *imageView = [self viewWithTag:20171024];
    if (imageView && [imageView isKindOfClass:[UIImageView class]]) {
        [imageView startAnimating];
    }
}

- (void)stopAnimating{
    
    UIImageView *imageView = [self viewWithTag:20171024];
    if (imageView && [imageView isKindOfClass:[UIImageView class]]) {
        [imageView stopAnimating];
    }
}


@end
