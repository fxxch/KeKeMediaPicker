//
//  UIButton+KKMediaPicker.m
//  KeKeMediaPicker
//
//  Created by edward lannister on 2022/09/05.
//  Copyright © 2022 KKLibrary. All rights reserved.
//

#import "UIButton+KKMediaPicker.h"
#import "NSString+KKMediaPicker.h"

@implementation UIButton (KKMediaPicker)

- (void)kkmp_setButtonImgLeftTitleRightLeft{
    
    self.titleEdgeInsets = UIEdgeInsetsZero;
    self.imageEdgeInsets = UIEdgeInsetsZero;
    
    UIEdgeInsets aEdgeInsets = UIEdgeInsetsZero;
    CGFloat aSpace = 5;
    NSString *aTitle = self.titleLabel.text;
    
    CGSize titleSize = [aTitle kkmp_sizeWithFont:self.titleLabel.font maxSize:CGSizeMake(self.frame.size.width, 1000)];
    
    CGSize aImageSize = self.imageView.frame.size;
    if (!self.imageView.image) {
        aImageSize = CGSizeZero;
    }
    
    
    // 取得imageView最初的center
    CGPoint startImageViewCenter = self.imageView.center;
    // 取得titleLabel最初的center
    CGPoint startTitleLabelCenter = self.titleLabel.center;
    
    // 找出titleLabel最终的center
    CGPoint endTitleLabelCenter = CGPointZero;
    // 找出imageView最终的center
    CGPoint endImageViewCenter = CGPointZero;

    /* 图片在左边，标题在右边, 整体居左边 */
    // 找出titleLabel最终的center
    endTitleLabelCenter = CGPointMake(aEdgeInsets.left+titleSize.width/2.0+aImageSize.width+aSpace, self.frame.size.height/2.0);
    // 找出imageView最终的center
    endImageViewCenter = CGPointMake(aEdgeInsets.left+aImageSize.width/2.0, self.frame.size.height/2.0);
    
    // 设置titleEdgeInsets
    CGFloat titleEdgeInsetsTop = endTitleLabelCenter.y-startTitleLabelCenter.y+self.titleEdgeInsets.top;
    CGFloat titleEdgeInsetsLeft = endTitleLabelCenter.x - startTitleLabelCenter.x+self.titleEdgeInsets.left;
    CGFloat titleEdgeInsetsBottom = -titleEdgeInsetsTop;
    CGFloat titleEdgeInsetsRight = -titleEdgeInsetsLeft;
    self.titleEdgeInsets = UIEdgeInsetsMake(titleEdgeInsetsTop, titleEdgeInsetsLeft, titleEdgeInsetsBottom, titleEdgeInsetsRight);
    
    // 设置imageEdgeInsets
    CGFloat imageEdgeInsetsTop = endImageViewCenter.y - startImageViewCenter.y+self.imageEdgeInsets.top;
    CGFloat imageEdgeInsetsLeft = endImageViewCenter.x - startImageViewCenter.x+self.imageEdgeInsets.left;
    CGFloat imageEdgeInsetsBottom = -imageEdgeInsetsTop;
    CGFloat imageEdgeInsetsRight = -imageEdgeInsetsLeft;
    self.imageEdgeInsets = UIEdgeInsetsMake(imageEdgeInsetsTop, imageEdgeInsetsLeft, imageEdgeInsetsBottom, imageEdgeInsetsRight);
}

- (void)kkmp_setButtonImgLeftTitleRightCenter{
    
    self.titleEdgeInsets = UIEdgeInsetsZero;
    self.imageEdgeInsets = UIEdgeInsetsZero;
    
    CGFloat aSpace = 5;
    NSString *aTitle = self.titleLabel.text;
    
    CGSize titleSize = [aTitle kkmp_sizeWithFont:self.titleLabel.font maxSize:CGSizeMake(self.frame.size.width, 1000)];
    
    CGSize aImageSize = self.imageView.frame.size;
    if (!self.imageView.image) {
        aImageSize = CGSizeZero;
    }
    
    
    // 取得imageView最初的center
    CGPoint startImageViewCenter = self.imageView.center;
    // 取得titleLabel最初的center
    CGPoint startTitleLabelCenter = self.titleLabel.center;
    
    // 找出titleLabel最终的center
    CGPoint endTitleLabelCenter = CGPointZero;
    // 找出imageView最终的center
    CGPoint endImageViewCenter = CGPointZero;

    /* 图片在左边，标题在右边, 整体居中 */
    // 找出imageView最终的center
    endImageViewCenter = CGPointMake((self.frame.size.width-titleSize.width-aImageSize.width-aSpace)/2.0+aImageSize.width/2.0, self.frame.size.height/2.0);
    // 找出titleLabel最终的center
    endTitleLabelCenter = CGPointMake(endImageViewCenter.x+(aImageSize.width)/2.0+aSpace+titleSize.width/2.0, self.frame.size.height/2.0);

    // 设置titleEdgeInsets
    CGFloat titleEdgeInsetsTop = endTitleLabelCenter.y-startTitleLabelCenter.y+self.titleEdgeInsets.top;
    CGFloat titleEdgeInsetsLeft = endTitleLabelCenter.x - startTitleLabelCenter.x+self.titleEdgeInsets.left;
    CGFloat titleEdgeInsetsBottom = -titleEdgeInsetsTop;
    CGFloat titleEdgeInsetsRight = -titleEdgeInsetsLeft;
    self.titleEdgeInsets = UIEdgeInsetsMake(titleEdgeInsetsTop, titleEdgeInsetsLeft, titleEdgeInsetsBottom, titleEdgeInsetsRight);
    
    // 设置imageEdgeInsets
    CGFloat imageEdgeInsetsTop = endImageViewCenter.y - startImageViewCenter.y+self.imageEdgeInsets.top;
    CGFloat imageEdgeInsetsLeft = endImageViewCenter.x - startImageViewCenter.x+self.imageEdgeInsets.left;
    CGFloat imageEdgeInsetsBottom = -imageEdgeInsetsTop;
    CGFloat imageEdgeInsetsRight = -imageEdgeInsetsLeft;
    self.imageEdgeInsets = UIEdgeInsetsMake(imageEdgeInsetsTop, imageEdgeInsetsLeft, imageEdgeInsetsBottom, imageEdgeInsetsRight);
}

//- (void)kk_setButtonContentAlignment:(KKButtonContentAlignment)contentAlignment
//            buttonContentLayoutModal:(KKButtonContentLayoutModal)contentLayoutModal
//          buttonContentTitlePosition:(KKButtonContentTitlePosition)contentTitlePosition
//           sapceBetweenImageAndTitle:(CGFloat)aSpace
//                          edgeInsets:(UIEdgeInsets)aEdgeInsets{
//    self.titleEdgeInsets = UIEdgeInsetsZero;
//    self.imageEdgeInsets = UIEdgeInsetsZero;
//
//    NSString *aTitle = self.titleLabel.text;
//
//    CGSize titleSize = [aTitle kk_sizeWithFont:self.titleLabel.font maxSize:CGSizeMake(self.frame.size.width, 1000)];
//
//    CGSize aImageSize = self.imageView.frame.size;
//    if (!self.imageView.image) {
//        aImageSize = CGSizeZero;
//    }
//
//
//    // 取得imageView最初的center
//    CGPoint startImageViewCenter = self.imageView.center;
//    // 取得titleLabel最初的center
//    CGPoint startTitleLabelCenter = self.titleLabel.center;
//
//    // 找出titleLabel最终的center
//    CGPoint endTitleLabelCenter = CGPointZero;
//    // 找出imageView最终的center
//    CGPoint endImageViewCenter = CGPointZero;
//
//
//    //垂直对齐
//    if (contentLayoutModal==KKButtonContentLayoutModalVertical) {
//        if (contentAlignment==KKButtonContentAlignmentLeft) {
//            if (contentTitlePosition==KKButtonContentTitlePositionBefore) {
//                // 找出titleLabel最终的center
//                endTitleLabelCenter = CGPointMake(aEdgeInsets.left+MAX(titleSize.width, aImageSize.width)/2.0, (self.frame.size.height-titleSize.height-aImageSize.height-aSpace)/2.0+titleSize.height/2.0);
//                // 找出imageView最终的center
//                endImageViewCenter = CGPointMake(aEdgeInsets.left+MAX(titleSize.width, aImageSize.width)/2.0,  (self.frame.size.height-titleSize.height-aImageSize.height-aSpace)/2.0+titleSize.height+aSpace+aImageSize.height);
//            }
//            else if (contentTitlePosition==KKButtonContentTitlePositionAfter){
//                // 找出imageView最终的center
//                endImageViewCenter = CGPointMake(aEdgeInsets.left+MAX(titleSize.width, aImageSize.width)/2.0,  (self.frame.size.height-titleSize.height-aImageSize.height-aSpace)/2.0+aImageSize.height/2.0);
//
//                // 找出titleLabel最终的center
//                endTitleLabelCenter = CGPointMake(aEdgeInsets.left+MAX(titleSize.width, aImageSize.width)/2.0, (self.frame.size.height-titleSize.height-aImageSize.height-aSpace)/2.0+aImageSize.height+aSpace+titleSize.height/2.0);
//            }
//            else{
//
//            }
//        }
//        else if (contentAlignment==KKButtonContentAlignmentCenter){
//            if (contentTitlePosition==KKButtonContentTitlePositionBefore) {
//                // 找出titleLabel最终的center
//                endTitleLabelCenter = CGPointMake((self.frame.size.width-MAX(titleSize.width, aImageSize.width))/2.0+MAX(titleSize.width, aImageSize.width)/2.0, (self.frame.size.height-titleSize.height-aImageSize.height-aSpace)/2.0+titleSize.height/2.0);
//                // 找出imageView最终的center
//                endImageViewCenter = CGPointMake((self.frame.size.width-MAX(titleSize.width, aImageSize.width))/2.0+MAX(titleSize.width, aImageSize.width)/2.0,  (self.frame.size.height-titleSize.height-aImageSize.height-aSpace)/2.0+titleSize.height+aSpace+aImageSize.height);
//            }
//            else if (contentTitlePosition==KKButtonContentTitlePositionAfter){
//                // 找出imageView最终的center
//                endImageViewCenter = CGPointMake((self.frame.size.width-MAX(titleSize.width, aImageSize.width))/2.0+MAX(titleSize.width, aImageSize.width)/2.0,  (self.frame.size.height-titleSize.height-aImageSize.height-aSpace)/2.0+aImageSize.height/2.0);
//
//                // 找出titleLabel最终的center
//                endTitleLabelCenter = CGPointMake((self.frame.size.width-MAX(titleSize.width, aImageSize.width))/2.0+MAX(titleSize.width, aImageSize.width)/2.0, (self.frame.size.height-titleSize.height-aImageSize.height-aSpace)/2.0+aImageSize.height+aSpace+titleSize.height/2.0);
//            }
//            else{
//
//            }
//        }
//        else if (contentAlignment==KKButtonContentAlignmentRight){
//
//            if (contentTitlePosition==KKButtonContentTitlePositionBefore) {
//                // 找出titleLabel最终的center
//                endTitleLabelCenter = CGPointMake(self.frame.size.width-aEdgeInsets.right-MAX(titleSize.width, aImageSize.width)/2.0, (self.frame.size.height-titleSize.height-aImageSize.height-aSpace)/2.0+titleSize.height/2.0);
//                // 找出imageView最终的center
//                endImageViewCenter = CGPointMake(self.frame.size.width-aEdgeInsets.right-MAX(titleSize.width, aImageSize.width)/2.0,  (self.frame.size.height-titleSize.height-aImageSize.height-aSpace)/2.0+titleSize.height+aSpace+aImageSize.height);
//            }
//            else if (contentTitlePosition==KKButtonContentTitlePositionAfter){
//                // 找出imageView最终的center
//                endImageViewCenter = CGPointMake(self.frame.size.width-aEdgeInsets.right-MAX(titleSize.width, aImageSize.width)/2.0,  (self.frame.size.height-titleSize.height-aImageSize.height-aSpace)/2.0+aImageSize.height/2.0);
//
//                // 找出titleLabel最终的center
//                endTitleLabelCenter = CGPointMake(self.frame.size.width-aEdgeInsets.right-MAX(titleSize.width, aImageSize.width)/2.0, (self.frame.size.height-titleSize.height-aImageSize.height-aSpace)/2.0+aImageSize.height+aSpace+titleSize.height/2.0);
//            }
//            else{
//
//            }
//        }
//        else{
//
//        }
//    }
//    //水平对齐
//    else if (contentLayoutModal==KKButtonContentLayoutModalHorizontal){
//        if (contentAlignment==KKButtonContentAlignmentLeft) {
//            if (contentTitlePosition==KKButtonContentTitlePositionBefore) {
//                // 找出titleLabel最终的center
//                endTitleLabelCenter = CGPointMake(aEdgeInsets.left+titleSize.width/2.0, self.frame.size.height/2.0);
//                // 找出imageView最终的center
//                endImageViewCenter = CGPointMake(aEdgeInsets.left+titleSize.width+aImageSize.width/2.0+aSpace, self.frame.size.height/2.0);
//            }
//            else if (contentTitlePosition==KKButtonContentTitlePositionAfter){
//                // 找出titleLabel最终的center
//                endTitleLabelCenter = CGPointMake(aEdgeInsets.left+titleSize.width/2.0+aImageSize.width+aSpace, self.frame.size.height/2.0);
//                // 找出imageView最终的center
//                endImageViewCenter = CGPointMake(aEdgeInsets.left+aImageSize.width/2.0, self.frame.size.height/2.0);
//            }
//            else{
//
//            }
//        }
//        else if (contentAlignment==KKButtonContentAlignmentCenter){
//            if (contentTitlePosition==KKButtonContentTitlePositionBefore) {
//                // 找出titleLabel最终的center
//                CGFloat endTitleLabelCenter_X = MAX((self.frame.size.width-titleSize.width-aImageSize.width-aSpace)/2.0+titleSize.width/2.0, titleSize.width/2.0+5);
//                endTitleLabelCenter = CGPointMake(endTitleLabelCenter_X, self.frame.size.height/2.0);
//                // 找出imageView最终的center
//                CGFloat endImageViewCenter_X = MIN((self.frame.size.width-titleSize.width-aImageSize.width-aSpace)/2.0+titleSize.width+aSpace+aImageSize.width/2.0, self.frame.size.width-aImageSize.width/2.0);
//                endImageViewCenter = CGPointMake(endImageViewCenter_X, self.frame.size.height/2.0);
//            }
//            else if (contentTitlePosition==KKButtonContentTitlePositionAfter){
//                // 找出imageView最终的center
//                endImageViewCenter = CGPointMake((self.frame.size.width-titleSize.width-aImageSize.width-aSpace)/2.0+aImageSize.width/2.0, self.frame.size.height/2.0);
//                // 找出titleLabel最终的center
//                endTitleLabelCenter = CGPointMake(endImageViewCenter.x+(aImageSize.width)/2.0+aSpace+titleSize.width/2.0, self.frame.size.height/2.0);
//            }
//            else{
//
//            }
//        }
//        else if (contentAlignment==KKButtonContentAlignmentRight){
//
//            if (contentTitlePosition==KKButtonContentTitlePositionBefore) {
//                // 找出titleLabel最终的center
//                endTitleLabelCenter = CGPointMake(self.frame.size.width-titleSize.width/2.0-aImageSize.width-aEdgeInsets.right-aSpace, self.frame.size.height/2.0);
//                // 找出imageView最终的center
//                endImageViewCenter = CGPointMake(self.frame.size.width-aEdgeInsets.right-aImageSize.width/2.0, self.frame.size.height/2.0);
//            }
//            else if (contentTitlePosition==KKButtonContentTitlePositionAfter){
//                // 找出imageView最终的center
//                endImageViewCenter = CGPointMake(self.frame.size.width-aImageSize.width/2.0-titleSize.width-aEdgeInsets.right-aSpace, self.frame.size.height/2.0);
//                // 找出titleLabel最终的center
//                endTitleLabelCenter = CGPointMake(self.frame.size.width-aEdgeInsets.right-titleSize.width/2.0, self.frame.size.height/2.0);
//            }
//            else{
//
//            }
//        }
//        else{
//
//        }
//    }
//    else{
//
//    }
//
//    // 设置titleEdgeInsets
//    CGFloat titleEdgeInsetsTop = endTitleLabelCenter.y-startTitleLabelCenter.y+self.titleEdgeInsets.top;
//    CGFloat titleEdgeInsetsLeft = endTitleLabelCenter.x - startTitleLabelCenter.x+self.titleEdgeInsets.left;
//    CGFloat titleEdgeInsetsBottom = -titleEdgeInsetsTop;
//    CGFloat titleEdgeInsetsRight = -titleEdgeInsetsLeft;
//    self.titleEdgeInsets = UIEdgeInsetsMake(titleEdgeInsetsTop, titleEdgeInsetsLeft, titleEdgeInsetsBottom, titleEdgeInsetsRight);
//
//
//    // 设置imageEdgeInsets
//    CGFloat imageEdgeInsetsTop = endImageViewCenter.y - startImageViewCenter.y+self.imageEdgeInsets.top;
//    CGFloat imageEdgeInsetsLeft = endImageViewCenter.x - startImageViewCenter.x+self.imageEdgeInsets.left;
//    CGFloat imageEdgeInsetsBottom = -imageEdgeInsetsTop;
//    CGFloat imageEdgeInsetsRight = -imageEdgeInsetsLeft;
//    self.imageEdgeInsets = UIEdgeInsetsMake(imageEdgeInsetsTop, imageEdgeInsetsLeft, imageEdgeInsetsBottom, imageEdgeInsetsRight);
//}
@end
