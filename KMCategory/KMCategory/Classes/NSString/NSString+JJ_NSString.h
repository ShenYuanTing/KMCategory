//
//  NSString+JJ.h
//  WOEWO
//
//  Created by BPMAC on 2017/3/15.
//  Copyright © 2017年 BPMAC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (JJ_NSString)
#pragma -mark md5加密
+(NSString *)jj_md5Digest:(NSString *)digestStr;
#pragma -mark 判断邮箱
+(BOOL)jj_isValidateEmail:(NSString *)email;
#pragma -mark 判断手机号码
+(BOOL)jj_isValidatePhone:(NSString *)phone;
#pragma -mark 判断实名
+(BOOL)jj_isValidateName:(NSString *)name;
#pragma -mark 判断身份证号码
+ (BOOL)jj_isValidateCard:(NSString *)identityString ;
#pragma -mark 判断是否为整数
+ (BOOL)jj_isPureInt:(NSString*)string;
#pragma -mark 判断是否为浮点形
+(BOOL)jj_isPureFloat:(NSString*)string;
#pragma -mark 自由获取字符串
+(NSString *)jj_getRandomNumber:(int)number;
#pragma -mark 获得设备型号
+(NSString *)jj_getCurrentDevice;
#pragma -mark 打印设备信息
+(void)jj_nslogCurrentDevice;
#pragma -mark 普通字符串转换为十六进制的
+ (NSString *)jj_hexaDecimal:(NSString *)string;
#pragma -mark 设定时间
+(NSString*)jj_getDate:(NSDate*)date withFormatter:(NSString*)formatter;
#pragma -mark   获得NSString==>NSDate
+(NSDate*)jj_stringToDate:(NSString*)string withFormatter:(NSString*)formatter;
#pragma -mark  获得星期几
+ (NSString * )jj_weekdayStringFromDate:(NSDate*)inputDate;
#pragma -mark 获得程序信息
+(NSString *)jj_information:(NSString*)str;
#pragma -mark HTML
+(NSString *)jj_filterHTML:(NSString *)html;
#pragma mark obj转NSString
+(NSString*)jj_objToJson:(id)obj;
#pragma mark 计算字符串高
+(float)jj_getStringHeight:(NSString *)text maxW:(int)maxw AndFont:(int)fontSize;
#pragma mark 计算字符串宽
+(float)jj_getStringW:(NSString *)text maxH:(int)maxw AndFont:(int)fontSize;
#pragma mark obj转NSString
+(NSString*)jj_getJson:(id)obj;
#pragma mark NSDictionary转NSData
+ (NSData *)jj_dicToData:(id)theData;
#pragma -mark 获得万元字符串
+ (NSString *)jj_changeAsset:(NSString *)amountStr;
#pragma -mark 获得千位分隔符字符串
+(NSString *)jj_partStringWithSeparator:(NSString *)num;
#pragma -mark 获得千位分隔符字符串,返回不带‘.’
+(NSString *)jj_partStringWithSeparatorToInt:(NSString *)num;
#pragma mark-字符串处理
+ (NSString *)jj_stringReplaceWith:(NSString *)str;
#pragma -mark  测试图片
+(NSString *)jj_getImageUrl;
#pragma -mark 加密
+(NSString *)jj_signatureWithMd5New:(NSDictionary *)dic andHost:(NSString *)host;
#pragma -mark 获取webURL
+(NSString *)extractionOfdigitalFromString:(NSString *)str;
#pragma mark 计算字体高度
+ (CGFloat)getHeight:(NSString *)str;
#pragma -mark 设置字符串不同颜色
+ (NSMutableAttributedString *)jj_getAttributedString:(NSString *)allString
                                           andChangeS:(NSString *)string
                                             andColor:(UIColor *)color
                                              andFont:(UIFont *)font;

#pragma -mark  获取xxx xxxx xxxx格式手机号
+(NSString *)jj_showPhoneText:(NSString *)phone;
@end
