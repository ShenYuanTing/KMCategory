//
//  NSObject+JJ.m
//  WOEWO
//
//  Created by BPMAC on 2017/3/15.
//  Copyright © 2017年 BPMAC. All rights reserved.
//

#import "NSObject+JJ_NSObject.h"
#import <CommonCrypto/CommonDigest.h>//md5加密
#import "UIAlertView+Fast.h"//系统弹出框快捷方式1
#import "UIActionSheet+Fast.h"//系统弹出框快捷方式2
//*****************************
#include <sys/types.h>//设备型号
#include <sys/sysctl.h>//设备型号
#import <LocalAuthentication/LocalAuthentication.h>
#import <sys/utsname.h>

@implementation NSObject (JJ_NSObject)
#pragma -mark- =================== 好用方法 =======================
#pragma -mark 延迟几秒执行
+ (void)performBlock:(void(^)(void))block afterDelay:(NSTimeInterval)delay {
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), block);
}
#pragma -mark  并列线程
+ (void)performOneBlock:(void(^)(void))oneBlock TwoBlock:(void(^)(void))twoBlock{
    // 1.自己创建一个串行队列
    dispatch_queue_t queue = dispatch_queue_create("com.dehong.queue", DISPATCH_QUEUE_SERIAL);
    //block中的是任务，将任务加到并行队列中，异步队列会开辟出来新的子线程，任务按添加顺序执行
    dispatch_sync(queue, ^{
        if (oneBlock) {
            oneBlock();
        }
    });
    dispatch_sync(queue, ^{
        if (twoBlock) {
            twoBlock();
        }
    });
    
}
#pragma -mark  新线程
+(void)createGCDformBlock:(void(^)(void))block withMainBlock:(void(^)(void))mainBlock{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //子线程异步执行下载任务，防止主线程卡顿
        if (block) {
            block();
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            //异步返回主线程，根据获取的数据，更新UI
            if (mainBlock) {
                mainBlock();
            }
        });
    });
}
#pragma -mark 是否真机
+ (BOOL)isSimulator{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceMachine = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    if ([deviceMachine isEqualToString:@"i386"] || [deviceMachine isEqualToString:@"x86_64"])       {
        return YES;
    }
    return NO;
}
#pragma -mark- =================== 清除缓存用到 =======================
#pragma -mark 单个文件的大小
+(long long)fileSizeAtPath:(NSString*) filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}
#pragma -mark 遍历文件夹获得文件夹大小 返回多少M
+ (float )folderSizeAtPath:(NSString*) folderPath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [NSObject fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize/(1024.0*1024.0);
}
#pragma -mark 清除大小
+(float)theCacheSize{
    NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES) objectAtIndex:0];
    
    return   [NSObject folderSizeAtPath:cachPath];
    
}
#pragma -mark 清除缓存
+(void)clearTheCache{
    //    NSString *homeDir = NSHomeDirectory();
    //    NSLog(@"获取Home目录路径%@",homeDir);
    //    // 获取Documents目录路径
    //    NSArray *documents = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //    NSString *docDir = [documents objectAtIndex:0];
    //    NSLog(@"获取Documents目录路径%@",docDir);
    //    // 获取Caches目录路径
    //    NSArray *caches = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    //
    //    NSString *cachesDir = [caches objectAtIndex:0];
    //    NSLog(@" 获取Caches目录路径%@",cachesDir);
    //    // 获取tmp目录路径
    //    NSString *tmpDir =  NSTemporaryDirectory();
    //    NSLog(@" 获取tmp目录路径%@",tmpDir);
    
    //清除缓存
    NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES) objectAtIndex:0];
    NSLog(@"缓存文件大小%f",[NSObject folderSizeAtPath:cachPath]);
    NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachPath];
    NSLog(@"缓存文件个数 :%lu",(unsigned long)[files count]);
    for (NSString *p in files) {
        NSError *error;
        NSString *path = [cachPath stringByAppendingPathComponent:p];
        if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
            [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
            
        }
    }
    
    
}
#pragma -mark 提示框1
+(void)alertViewWithTitle:(NSString*)title
              contentText:(NSString*)contStr
          leftButtonTitle:(NSString*)leftstr//nil--0
         rightButtonTitle:(NSString*)rightstr//@"sure"--1
                   finish:(void (^)(NSInteger index))block
{
    
    
    UIAlertView *alert;
    
    alert = [[UIAlertView alloc]initWithTitle:title
                                      message:contStr
                                     delegate:nil
                            cancelButtonTitle:leftstr
                            otherButtonTitles:rightstr, nil];
    
    [alert showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
        
        if (block) {
            block(buttonIndex);
        }
    }];
    
    
    
    
    
}
#pragma -mark 提示框2
+(void)sheetWithTitle:(NSString*)title
              oneText:(NSString*)oneText//0
              twoText:(NSString*)twoText//1
               finish:(void (^)(NSInteger index))block{
    UIActionSheet *sheet;
    sheet=[[UIActionSheet alloc]initWithTitle:title
                                     delegate:nil
                            cancelButtonTitle:@"取消"
                       destructiveButtonTitle:nil
                            otherButtonTitles:oneText,twoText, nil];
    [sheet showActionSheetWithCompleteBlock:^(NSInteger buttonIndex) {
        
        if (block) {
            block(buttonIndex);
        }
    }];
}
+(void)sheetWithTitle:(NSString*)title
              oneText:(NSString*)oneText//0
               finish:(void (^)(NSInteger index))block{
    UIActionSheet *sheet;
    sheet=[[UIActionSheet alloc]initWithTitle:title
                                     delegate:nil
                            cancelButtonTitle:@"取消"
                       destructiveButtonTitle:nil
                            otherButtonTitles:oneText, nil];
    [sheet showActionSheetWithCompleteBlock:^(NSInteger buttonIndex) {
        
        if (block) {
            block(buttonIndex);
        }
    }];
}


#pragma -mark- =================== 登陆判断 =======================
#pragma -mark 身份证号
+ (BOOL)validateIdentityCard: (NSString *)value
{
    value = [value uppercaseString];
    value = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    
    long int length =0;
    if (!value) {
        return NO;
    }else {
        length = value.length;
        
        if (length !=15 && length !=18) {
            return NO;
        }
    }
    // 省份代码
    NSArray *areasArray =@[@"11",@"12", @"13",@"14", @"15",@"21", @"22",@"23", @"31",@"32", @"33",@"34", @"35",@"36", @"37",@"41", @"42",@"43", @"44",@"45", @"46",@"50", @"51",@"52", @"53",@"54", @"61",@"62", @"63",@"64", @"65",@"71", @"81",@"82", @"91"];
    
    NSString *valueStart2 = [value substringToIndex:2];
    BOOL areaFlag =NO;
    for (NSString *areaCode in areasArray) {
        if ([areaCode isEqualToString:valueStart2]) {
            areaFlag =YES;
            break;
        }
    }
    
    if (!areaFlag) {
        return false;
    }
    
    
    NSRegularExpression *regularExpression;
    NSUInteger numberofMatch;
    
    long int year =0;
    switch (length) {
        case 15:
            year = [value substringWithRange:NSMakeRange(6,2)].intValue +1900;
            
            if (year %4 ==0 || (year %100 ==0 && year %4 ==0)) {
                
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}$"
                                                                        options:NSRegularExpressionCaseInsensitive
                                                                          error:nil];//测试出生日期的合法性
            }else {
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}$"
                                                                        options:NSRegularExpressionCaseInsensitive
                                                                          error:nil];//测试出生日期的合法性
            }
            numberofMatch = [regularExpression numberOfMatchesInString:value
                                                               options:NSMatchingReportProgress
                                                                 range:NSMakeRange(0, value.length)];
            
            
            if(numberofMatch >0) {
                return YES;
            }else {
                return NO;
            }
        case 18:
            
            year = [value substringWithRange:NSMakeRange(6,4)].intValue;
            
            if (year %4 ==0 || (year %100 ==0 && year %4 ==0)) {
                
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}[0-9Xx]$"
                                                                        options:NSRegularExpressionCaseInsensitive
                                                                          error:nil];//测试出生日期的合法性
            }else {
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}[0-9Xx]$"
                                                                        options:NSRegularExpressionCaseInsensitive
                                                                          error:nil];//测试出生日期的合法性
            }
            numberofMatch = [regularExpression numberOfMatchesInString:value
                                                               options:NSMatchingReportProgress
                                                                 range:NSMakeRange(0, value.length)];
            
            
            
            if(numberofMatch >0) {
                int S = ([value substringWithRange:NSMakeRange(0,1)].intValue + [value substringWithRange:NSMakeRange(10,1)].intValue) *7 + ([value substringWithRange:NSMakeRange(1,1)].intValue + [value substringWithRange:NSMakeRange(11,1)].intValue) *9 + ([value substringWithRange:NSMakeRange(2,1)].intValue + [value substringWithRange:NSMakeRange(12,1)].intValue) *10 + ([value substringWithRange:NSMakeRange(3,1)].intValue + [value substringWithRange:NSMakeRange(13,1)].intValue) *5 + ([value substringWithRange:NSMakeRange(4,1)].intValue + [value substringWithRange:NSMakeRange(14,1)].intValue) *8 + ([value substringWithRange:NSMakeRange(5,1)].intValue + [value substringWithRange:NSMakeRange(15,1)].intValue) *4 + ([value substringWithRange:NSMakeRange(6,1)].intValue + [value substringWithRange:NSMakeRange(16,1)].intValue) *2 + [value substringWithRange:NSMakeRange(7,1)].intValue *1 + [value substringWithRange:NSMakeRange(8,1)].intValue *6 + [value substringWithRange:NSMakeRange(9,1)].intValue *3;
                int Y = S %11;
                NSString *M =@"F";
                NSString *JYM =@"10X98765432";
                M = [JYM substringWithRange:NSMakeRange(Y,1)];// 判断校验位
                if ([M isEqualToString:[value substringWithRange:NSMakeRange(17,1)]]) {
                    return YES;// 检测ID的校验位
                }else {
                    return NO;
                }
                
            }else {
                return NO;
            }
        default:
            return NO;
    }
}
#pragma -mark 判断邮箱
+(BOOL)isValidateEmail:(NSString *)email
{
    if ([email length] == 0) {
        return NO;
    }
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",emailRegex];
    return [emailTest evaluateWithObject:email];
}
#pragma -mark 判断手机号码
+(BOOL)isValidatePhone:(NSString *)phone
{
    if ([phone length]<11) {
        return NO;
    }
    NSString *Regex =@"(13[0-9]|14[0-9]|15[0-9]|16[0-9]|17[0-9]|18[0-9]|19[0-9])\\d{8}";
    NSPredicate *mobileTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", Regex];
    return [mobileTest evaluateWithObject:phone];
}
#pragma -mark 判断实名
+(BOOL)isValidateName:(NSString *)name{
    if ([name length] == 0) {
        return NO;
    }
    NSString *nameRegex = @"^[\u4E00-\u9FA5]*$";
    NSPredicate *nameTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",nameRegex];
    return [nameTest evaluateWithObject:name];
    
}
#pragma -mark 判断密码(由数字/大写字母/小写字母组成
+(BOOL)isValidatePass:(NSString *)paw{
    if ([paw length] <8 ||[paw length]>18) {
        return NO;
    }
    
    NSString *regex = @"^(?![0-9]+$)(?![a-zA-Z]+$)[a-zA-Z0-9]{8,18}";
    regex = @"^(?![0-9]+$)(?![a-zA-Z]+$)(?![0-9A-Z]+$)(?![0-9a-z]+$)[0-9A-Za-z]{8,18}$";
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [pred evaluateWithObject:paw];
    
}
#pragma mask - 判断昵称
+(BOOL)isValidateNickName:(NSString *)nickName{
    if ([nickName length] == 0||[nickName length] == 21) {
        return NO;
    }
    NSString *regex = @"^[\u4E00-\u9FA5A-Za-z0-9_]+$";
    NSPredicate *nickNamepred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [nickNamepred evaluateWithObject:nickName];
    
}


@end
