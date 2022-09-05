//
//  KKMediaPickerCountBoxView.m
//  KeKeMediaPicker
//
//  Created by edward lannister on 2022/09/05.
//  Copyright © 2022 KKLibrary. All rights reserved.
//

#import "KKMediaPickerCountBoxView.h"
#import "NSString+KKMediaPicker.h"
#import "KKAlbumManager.h"

@implementation KKMediaPickerCountBoxView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
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
    return self;
}

- (void)setNumberOfPic:(NSInteger)numberOfPic maxNumberOfPic:(NSInteger)maxNumberOfPic{
    
    if (numberOfPic>0) {
        self.hidden = NO;
    }
    else{
        self.hidden = YES;
    }
    
    NSString *infoString = [NSString stringWithFormat:@"%ld/%ld ",(long)numberOfPic,(long)maxNumberOfPic];
    CGSize size = [infoString kkmp_sizeWithFont:[UIFont systemFontOfSize:12] maxWidth:1000];
    
    self.infoBoxView.frame = CGRectMake(0, (self.frame.size.height-30)/2.0, size.width+35, 30);
    UIImage *image01 = [KKAlbumManager themeImageForName:@"RoundRectBox"];
    self.infoBoxView.image = [image01 stretchableImageWithLeftCapWidth:20 topCapHeight:20];
    
    self.infoLabel.frame = CGRectMake(25, (self.frame.size.height-30)/2.0, size.width, 30);
    self.infoLabel.text = infoString;
    
    CGRect rect = self.frame;
    rect.size.width = self.infoBoxView.frame.size.width;
    self.frame = rect;
}

@end
