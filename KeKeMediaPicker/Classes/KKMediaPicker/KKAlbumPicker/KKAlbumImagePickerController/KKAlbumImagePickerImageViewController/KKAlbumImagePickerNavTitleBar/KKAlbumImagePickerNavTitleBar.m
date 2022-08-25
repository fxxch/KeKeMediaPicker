//
//  KKAlbumImagePickerNavTitleBar.m
//  BM
//
//  Created by sjyt on 2020/3/23.
//  Copyright © 2020 bm. All rights reserved.
//

#import "KKAlbumImagePickerNavTitleBar.h"
#import "KKAlbumImagePickerManager.h"
#import "NSString+KKMediaPicker.h"
#import "KKMediaPickerDefine.h"
#import "KKMediaPickerAuthorization.h"
#import "UIWindow+KKMediaPicker.h"

@implementation KKAlbumImagePickerNavTitleBar

- (void)dealloc{
    [NSNotificationCenter.defaultCenter removeObserver:self name:NotificationName_KKAlbumManagerLoadSourceFinished object:nil];
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
        [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(Notification_KKAlbumManagerLoadSourceFinished:) name:NotificationName_KKAlbumManagerLoadSourceFinished object:nil];
    }
    return self;
}

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    
    CGFloat width = self.backgroundView.frame.size.width;
    self.backgroundView.frame = CGRectMake((self.frame.size.width-width)/2.0, (self.frame.size.height-44)+(44-30)/2.0, width, 30);
}

- (void)initUI{
    NSString *title = KKMediaPicker_Album_Photo;
    CGSize size = [title kkmp_sizeWithFont:[UIFont systemFontOfSize:17] maxWidth:1000];
    CGFloat width = 10 + size.width + 10 + 20 + 5;
    
    self.backgroundView = [[UIButton alloc] initWithFrame:CGRectMake((self.frame.size.width-width)/2.0, (self.frame.size.height-44)+(44-30)/2.0, width, 30)];
    self.backgroundView.backgroundColor = KKMediaPicker_Clolor_707070;
    [self.backgroundView addTarget:self action:@selector(backgroundViewClicked) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.backgroundView];
    self.backgroundView.layer.cornerRadius = 15.0;
    self.backgroundView.layer.masksToBounds = YES;
    self.backgroundView.userInteractionEnabled = NO;

    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 10 + size.width + 10, self.backgroundView.frame.size.height)];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.font = [UIFont systemFontOfSize:17];
    self.titleLabel.text = title;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.backgroundView addSubview:self.titleLabel];
    self.titleLabel.userInteractionEnabled = NO;

    self.arrowButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.titleLabel.frame), (self.backgroundView.frame.size.height-20)/2.0, 20, 20)];
    [self.arrowButton setBackgroundColor:[UIColor lightGrayColor]];
    UIImage *image01 = [KKAlbumManager themeImageForName:@"NavArrowDown"];
    [self.arrowButton setImage:image01 forState:UIControlStateNormal];
    self.arrowButton.layer.cornerRadius = self.arrowButton.frame.size.width/2.0;
    self.arrowButton.layer.masksToBounds = YES;
    [self.backgroundView addSubview:self.arrowButton];
    self.arrowButton.userInteractionEnabled = NO;
    self.hidden = YES;
        
    [self checkAlbumLimited];
}

- (void)backgroundViewClicked{
    if ([KKMediaPickerAuthorization isAlbumAuthorizedLimited]) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:KKMediaPicker_AuthorizedLimited_Album_AlertMessage message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:KKMediaPicker_Common_Cancel style:UIAlertActionStyleDefault handler:nil]];
        [alertController addAction:[UIAlertAction actionWithTitle:KKMediaPicker_Authorized_Go style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            [[UIApplication sharedApplication] openURL:url options:[NSDictionary dictionary] completionHandler:nil];
        }]];
        [[UIWindow kkmp_viewControllerOfView:self] presentViewController:alertController animated:true completion:nil];
    }
    else{
        if (self.isOpen) {
            [self close];
            if (self.delegate && [self.delegate respondsToSelector:@selector(KKAlbumImagePickerNavTitleBar_Open:)]) {
                [self.delegate KKAlbumImagePickerNavTitleBar_Open:NO];
            }
        } else {
            [self open];
            if (self.delegate && [self.delegate respondsToSelector:@selector(KKAlbumImagePickerNavTitleBar_Open:)]) {
                [self.delegate KKAlbumImagePickerNavTitleBar_Open:YES];
            }
        }
    }
}

- (void)close{
    if (self.isOpen==NO) return;
    self.isOpen = NO;
    CGAffineTransform endAngle = CGAffineTransformMakeRotation(0*(M_PI/180.0f));
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.arrowButton.transform = endAngle;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)open{
    if (self.isOpen==YES) return;
    self.isOpen = YES;
    CGAffineTransform endAngle = CGAffineTransformMakeRotation(180*(M_PI/180.0f));
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.arrowButton.transform = endAngle;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)Notification_KKAlbumManagerLoadSourceFinished:(NSNotification*)notice{
    NSArray *aArray = notice.object;
    if (aArray && [aArray isKindOfClass:[NSArray class]] && aArray.count>0) {
        self.backgroundView.userInteractionEnabled = YES;
        self.hidden = NO;
        NSArray *array = notice.object;
        for (NSInteger i=0; i<[array count]; i++) {
            KKAlbumDirectoryModel *data = (KKAlbumDirectoryModel*)[array objectAtIndex:i];
            if ([data.title isEqualToString:KKMediaPicker_Album_UserLibrary]) {
                [self reloadWithDirectoryModel:data];
                break;
            }
        }
    } else {
        self.backgroundView.userInteractionEnabled = NO;
        self.hidden = YES;
    }
    
    [self checkAlbumLimited];
}

- (void)reloadWithDirectoryModel:(KKAlbumDirectoryModel*)aModel{
    NSString *title = aModel.title;
    CGSize size = [title kkmp_sizeWithFont:[UIFont systemFontOfSize:17] maxWidth:1000];
    CGFloat width = 10 + size.width + 10 + 20 + 5;
    
    self.backgroundView.frame = CGRectMake((self.frame.size.width-width)/2.0, (self.frame.size.height-44)+(44-30)/2.0, width, 30);
    self.titleLabel.frame = CGRectMake(0, 0, 10 + size.width + 10, self.backgroundView.frame.size.height);
    self.titleLabel.text = title;
    self.arrowButton.frame = CGRectMake(CGRectGetMaxX(self.titleLabel.frame), (self.backgroundView.frame.size.height-20)/2.0, 20, 20);
}

- (void)checkAlbumLimited{
    
    if ([KKMediaPickerAuthorization isAlbumAuthorizedLimited]) {
        self.hidden = NO;

        NSString *title = KKMediaPicker_AuthorizedLimited_Album;
        CGSize size = [title kkmp_sizeWithFont:[UIFont systemFontOfSize:17] maxWidth:1000];
        CGFloat width = 10 + size.width + 10 + 20 + 5;
        
        self.backgroundView.frame = CGRectMake((self.frame.size.width-width)/2.0, (self.frame.size.height-44)+(44-30)/2.0, width, 30);
        self.titleLabel.frame = CGRectMake(0, 0, 10 + size.width + 10, self.backgroundView.frame.size.height);
        self.titleLabel.text = title;
        self.arrowButton.frame = CGRectMake(CGRectGetMaxX(self.titleLabel.frame), (self.backgroundView.frame.size.height-20)/2.0, 20, 20);
    }
}


@end
