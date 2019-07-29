//
//  NSObject+JJ.h
//  WOEWO
//
//  Created by ; on 2017/3/15.
//  Copyright © 2017年 BPMAC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (JJ_NSObject)
#pragma -mark  延迟几秒执行的方法
+ (void)performBlock:(void(^)(void))block
          afterDelay:(NSTimeInterval)delay;
#pragma -mark  线程
+ (void)performOneBlock:(void(^)(void))oneBlock TwoBlock:(void(^)(void))twoBlock;
+ (void)createGCDformBlock:(void(^)(void))block withMainBlock:(void(^)(void))mainBlock;
#pragma -mark 是否真机
+ (BOOL)isSimulator;
#pragma -mark 单个文件的大小
+(long long)fileSizeAtPath:(NSString*) filePath;
#pragma -mark 遍历文件夹获得文件夹大小 返回多少M
+ (float )folderSizeAtPath:(NSString*) folderPath;
#pragma -mark 清除大小
+(float)theCacheSize;
#pragma -mark 清除缓存
+(void)clearTheCache;

#pragma -mark 提示框1
+(void)alertViewWithTitle:(NSString*)title
              contentText:(NSString*)contStr
          leftButtonTitle:(NSString*)leftstr//nil--0
         rightButtonTitle:(NSString*)rightstr//@"sure"--1
                   finish:(void (^)(NSInteger index))block;
#pragma -mark 提示框2
+(void)sheetWithTitle:(NSString*)title
              oneText:(NSString*)oneText//0
              twoText:(NSString*)twoText//1
               finish:(void (^)(NSInteger index))block;

+(void)sheetWithTitle:(NSString*)title
              oneText:(NSString*)oneText//0
               finish:(void (^)(NSInteger index))block;



#pragma -mark- =================== 登陆判断 =======================
#pragma -mark 身份证号
+ (BOOL)validateIdentityCard: (NSString *)value;
#pragma -mark 判断邮箱
+(BOOL)isValidateEmail:(NSString *)email;
#pragma -mark 判断手机号码
+(BOOL)isValidatePhone:(NSString *)phone;
#pragma -mark 判断实名
+(BOOL)isValidateName:(NSString *)name;
#pragma -mark 判断密码(由数字/大写字母/小写字母组成
+(BOOL)isValidatePass:(NSString *)paw;
#pragma mask - 判断昵称
+(BOOL)isValidateNickName:(NSString *)nickName;
@end
