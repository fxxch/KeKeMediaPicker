//
//  KKMediaPickerCountBoxView.h
//  KeKeMediaPicker
//
//  Created by edward lannister on 2022/09/05.
//  Copyright © 2022 KKLibrary. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KKMediaPickerCountBoxView : UIButton

@property(nonatomic,strong)UIImageView *infoBoxView;
@property(nonatomic,strong)UILabel *infoLabel;

- (void)setNumberOfPic:(NSInteger)numberOfPic maxNumberOfPic:(NSInteger)maxNumberOfPic;

@end
