//
//  NSString+KKMediaPicker.h
//  KKLibray
//
//  Created by liubo on 2018/5/5.
//  Copyright © 2018年 KKLibray. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (KKMediaPicker)


#pragma mark ==================================================
#pragma mark == 日常判断
#pragma mark ==================================================
/**
 判断字符串是否为空（nil、不是字符串、去掉空格之后，长度为0 都视为空）
 
 @param string 需要判断的字符串
 @return 结果
 */
+ (BOOL)kkmp_isStringNotEmpty:(nullable id)string;

/**
 判断字符串是否为空（nil、不是字符串、去掉空格之后，长度为0 都视为空）
 
 @param string 需要判断的字符串
 @return 结果
 */
+ (BOOL)kkmp_isStringEmpty:(nullable id)string;

/** 判断字符串是不是一个本地文件路径格式
 @param string 需要判断的字符串
 @return 结果
 */
+ (BOOL)kkmp_isLocalFilePath:(nullable id)string;

/**
 字符串的真实长度（汉字2 英文1）
 
 @return 长度
 */
- (int)kkmp_realLenth;

/**
 隐藏手机号中间4位

 @return 。。。
 */
- (NSString *_Nonnull)kkmp_hiddenPhoneNum;

/**
 判断字符串是否是邮箱地址
 
 @return 结果
 */
- (BOOL)kkmp_isEmail;

/**
 判断字符串是否是手机号码
 
 @return 结果
 */
- (BOOL)kkmp_isMobilePhoneNumber;

/**
 判断字符串是否是座机号码
 
 @return 结果
 */
- (BOOL)kkmp_isTelePhoneNumber;

/**
 判断字符串是否含有中文字符
 
 @return 结果
 */
- (BOOL)kkmp_isHaveChineseCharacter;

/**
 判断字符串是否是邮政编码
 
 @return 结果
 */
- (BOOL)kkmp_isPostCode;

/**
 计算字符串显示需要的尺寸大小
 
 @param font 字体大小
 @param width 宽度
 @param lineBreakMode 换行方式
 @return 大小
 */
- (CGSize)kkmp_sizeWithFont:(nullable UIFont *)font
                 maxWidth:(CGFloat)width
            lineBreakMode:(NSLineBreakMode)lineBreakMode;


/**
 计算字符串显示需要的尺寸大小
 
 @param font 字体大小
 @param width 宽度
 @return 大小
 */
- (CGSize)kkmp_sizeWithFont:(nullable UIFont *)font
                 maxWidth:(CGFloat)width;


/**
 计算字符串显示需要的尺寸大小
 
 @param font 字体大小
 @param size 展示区域大小
 @return 大小
 */
- (CGSize)kkmp_sizeWithFont:(nullable UIFont *)font
                  maxSize:(CGSize)size;

/**
 计算字符串显示需要的尺寸大小
 
 @param font 字体大小
 @param size 展示区域大小
 @param lineBreakMode 换行方式
 @return 大小
 */
- (CGSize)kkmp_sizeWithFont:(nullable UIFont *)font
                  maxSize:(CGSize)size
            lineBreakMode:(NSLineBreakMode)lineBreakMode;


/**
 计算字符串显示需要的尺寸大小
 
 @param font 字体大小
 @param width 展示区域宽度
 @param inset 缩进
 @return 大小
 */
- (CGSize)kkmp_sizeWithFont:(nullable UIFont *)font
                 maxWidth:(CGFloat)width
                    inset:(UIEdgeInsets)inset;


/**
 计算字符串显示需要的尺寸大小
 
 @param font 字体大小
 @param width 展示区域宽度
 @param inset 缩进
 @param lineBreakMode 换行方式
 @return 大小
 */
- (CGSize)kkmp_sizeWithFont:(nullable UIFont *)font
                 maxWidth:(CGFloat)width inset:(UIEdgeInsets)inset
            lineBreakMode:(NSLineBreakMode)lineBreakMode;


/**
 计算字符串显示需要的尺寸大小
 
 @param font 字体大小
 @param size 展示区域
 @param inset 缩进
 @param lineBreakMode 换行方式
 @return 大小
 */
- (CGSize)kkmp_sizeWithFont:(nullable UIFont *)font
                  maxSize:(CGSize)size
                    inset:(UIEdgeInsets)inset
            lineBreakMode:(NSLineBreakMode)lineBreakMode;

/**
 去掉字符串首尾的空格
 
 @return 结果
 */
-(nullable NSString*)kkmp_trimLeftAndRightSpace;

/**
 去掉字符串里面的所有空白（换行、制表符、中英文空格）
 
 @return 结果
 */
-(nullable NSString*)kkmp_trimAllSpace;

/**
 去掉字符串里面的所有数字
 
 @return 结果
 */
- (nullable NSString*)kkmp_trimNumber;


/**
 从NSData里面转为字符串
 
 @param data data
 @return 字符串
 */
+ (nullable NSString*)kkmp_stringWithData:(nullable NSData *)data;

/**
 判定字符串 是否是整数
 
 @return 结果
 */
- (BOOL)kkmp_isInteger;

/**
 判定字符串 是否是浮点数
 
 @return 结果
 */
- (BOOL)kkmp_isFloat;

/**
 判定字符串 是否是几位小数的浮点数
 
 @param aDigits 小数位数
 @return 结果
 */
- (BOOL)kkmp_isMathematicalNumbers_withDecimal:(NSInteger)aDigits;

/**
 将一个数字转换成中文的大写 (例如：123456 转换成： 拾贰万叁仟肆佰伍拾陆)
 
 @param aDigitalString 数字字符串
 @return 结果
 */
+ (nullable NSString*)kkmp_chineseUperTextFromDigitalString:(nullable NSString*)aDigitalString;

/**
 计算字符串所占用的字节数大小 编码方式：NSUTF8StringEncoding （一个汉字占3字节，一个英文占1字节）
 
 @param aString aString
 @return 结果
 */
+ (NSInteger)kkmp_sizeOfStringForNSUTF8StringEncoding:(nullable NSString*)aString;

/**
 截取字符串到制定字节大小    编码方式：NSUTF8StringEncoding
 
 @param size 需要截取的字节数
 @param string string
 @return 结果
 */
+ (nullable NSString*)kkmp_subStringForNSUTF8StringEncodingWithSize:(NSInteger)size string:(nullable NSString*)string;

/**
 计算字符串所占用的字节数大小 编码方式：NSUnicodeStringEncoding （一个汉字占2字节，一个英文占1字节）
 
 @param aString aString
 @return 结果
 */
+ (NSInteger)kkmp_sizeOfStringForNSUnicodeStringEncoding:(nullable NSString*)aString;

/**
 截取字符串到制定字节大小    编码方式：NSUnicodeStringEncoding
 
 @param size 需要截取的字节数
 @param string string
 @return 结果
 */
+ (nullable NSString*)kkmp_subStringForNSUnicodeStringEncodingWithSize:(NSInteger)size
                                                           string:(nullable NSString*)string;

+ (nonnull NSString*)kkmp_stringWithInteger:(NSInteger)intValue;

+ (nonnull NSString*)kkmp_stringWithFloat:(CGFloat)floatValue;

+ (nonnull NSString*)kkmp_stringWithDouble:(double)doubleValue;

+ (nonnull NSString*)kkmp_stringWithBool:(BOOL)boolValue;

#pragma mark ==================================================
#pragma mark == 随机字符串
#pragma mark ==================================================
/* 随机生成字符串(由大小写字母、数字组成) */
+ (NSString *_Nonnull)kkmp_randomString:(NSInteger)length;

/* 随机生成字符串(由大小写字母组成) */
+ (NSString *_Nonnull)kkmp_randomStringWithoutNumber:(NSInteger)length;

#pragma mark ==================================================
#pragma mark == KKSafe
#pragma mark ==================================================
/****************************************  substringFromIndex:  ***********************************/
/**
 从from位置截取字符串 对应 __NSCFConstantString
 
 @param from 截取起始位置
 @return 截取的子字符串
 */
- (NSString *_Nullable)kkmp_substringFromIndex_Safe:(NSUInteger)from;

/****************************************  substringFromIndex:  ***********************************/
/**
 从开始截取到to位置的字符串  对应  __NSCFConstantString
 
 @param to 截取终点位置
 @return 返回截取的字符串
 */
- (NSString *_Nullable)kkmp_substringToIndex_Safe:(NSUInteger)to;

/*********************************** rangeOfString:options:range:locale:  ***************************/
/**
 搜索指定 字符串  对应  __NSCFConstantString
 
 @param searchString 指定 字符串
 @param mask 比较模式
 @param rangeOfReceiverToSearch 搜索 范围
 @param locale 本地化
 @return 返回搜索到的字符串 范围
 */
- (NSRange)kkmp_rangeOfString_Safe:(NSString *_Nullable)searchString
                         options:(NSStringCompareOptions)mask
                           range:(NSRange)rangeOfReceiverToSearch
                          locale:(nullable NSLocale *)locale;

/*********************************** substringWithRange:  ***************************/
/**
 截取指定范围的字符串  对应  __NSCFConstantString
 
 @param range 指定的范围
 @return 返回截取的字符串
 */
- (NSString *_Nullable)kkmp_substringWithRange_Safe:(NSRange)range;

@end
