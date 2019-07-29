//
//  NSString+JJ.m
//  WOEWO
//
//  Created by BPMAC on 2017/3/15.
//  Copyright © 2017年 BPMAC. All rights reserved.
//

#import "NSString+JJ_NSString.h"
#import <CommonCrypto/CommonDigest.h>//md5加密
#include <sys/types.h>//设备型号
#include <sys/sysctl.h>//设备型号
#import <LocalAuthentication/LocalAuthentication.h>
#import <sys/utsname.h>

#define KM_ScreenWidth     [[UIScreen mainScreen] bounds].size.width

@implementation NSString (JJ_NSString)
#pragma -mark- =================== 登陆判断 =======================
#pragma -mark md5加密
+(NSString *)jj_md5Digest:(NSString *)digestStr{
    
    const char *cStr = [digestStr UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (int)strlen(cStr), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++)
    {
        [hash appendFormat:@"%02X", result[i]];
    }
    return [hash lowercaseString];
}
#pragma -mark 判断邮箱
+(BOOL)jj_isValidateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",emailRegex];
    return [emailTest evaluateWithObject:email];
}
#pragma -mark 判断实名
+(BOOL)jj_isValidateName:(NSString *)name{
    if ([name length] == 0) {
        return NO;
    }
    NSString *nameRegex = @"^[\u4E00-\u9FA5]*$";
    NSPredicate *nameTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",nameRegex];
    return [nameTest evaluateWithObject:name];
    
}
#pragma -mark 判断手机号码
+(BOOL)jj_isValidatePhone:(NSString *)phone
{
    NSString *Regex =@"(13[0-9]|14[0-9]|15[0-9]|16[0-9]|17[0-9]|18[0-9]|19[0-9])\\d{8}";//@"(13[0-9]|14[0-9]|15[0-9]|18[0-9])\\d{8}";
    NSPredicate *mobileTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", Regex];
    return [mobileTest evaluateWithObject:phone];
}
#pragma -mark 判断身份证号码
+ (BOOL)jj_isValidateCard:(NSString *)identityString {
    
    if (identityString.length != 18) return NO;
    // 正则表达式判断基本 身份证号是否满足格式
    NSString *regex = @"^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}([0-9]|X)$";
    //  NSString *regex = @"^(^[1-9]\\d{7}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}$)|(^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])((\\d{4})|\\d{3}[Xx])$)$";
    NSPredicate *identityStringPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    //如果通过该验证，说明身份证格式正确，但准确性还需计算
    if(![identityStringPredicate evaluateWithObject:identityString]) return NO;
    
    //** 开始进行校验 *//
    
    //将前17位加权因子保存在数组里
    NSArray *idCardWiArray = @[@"7", @"9", @"10", @"5", @"8", @"4", @"2", @"1", @"6", @"3", @"7", @"9", @"10", @"5", @"8", @"4", @"2"];
    
    //这是除以11后，可能产生的11位余数、验证码，也保存成数组
    NSArray *idCardYArray = @[@"1", @"0", @"10", @"9", @"8", @"7", @"6", @"5", @"4", @"3", @"2"];
    
    //用来保存前17位各自乖以加权因子后的总和
    NSInteger idCardWiSum = 0;
    for(int i = 0;i < 17;i++) {
        NSInteger subStrIndex = [[identityString substringWithRange:NSMakeRange(i, 1)] integerValue];
        NSInteger idCardWiIndex = [[idCardWiArray objectAtIndex:i] integerValue];
        idCardWiSum+= subStrIndex * idCardWiIndex;
    }
    
    //计算出校验码所在数组的位置
    NSInteger idCardMod=idCardWiSum%11;
    //得到最后一位身份证号码
    NSString *idCardLast= [identityString substringWithRange:NSMakeRange(17, 1)];
    //如果等于2，则说明校验码是10，身份证号码最后一位应该是X
    if(idCardMod==2) {
        if(![idCardLast isEqualToString:@"X"]||[idCardLast isEqualToString:@"x"]) {
            return NO;
        }
    }
    else{
        //用计算出的验证码与最后一位身份证号码匹配，如果一致，说明通过，否则是无效的身份证号码
        if(![idCardLast isEqualToString: [idCardYArray objectAtIndex:idCardMod]]) {
            return NO;
        }
    }
    return YES;
}
#pragma -mark 判断是否为整数
+ (BOOL)jj_isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}
#pragma -mark 判断是否为浮点形
+(BOOL)jj_isPureFloat:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    float val;
    return[scan scanFloat:&val] && [scan isAtEnd];
}
#pragma -mark 自由获取字符串
+(NSString *)jj_getRandomNumber:(int)number{
    NSArray *arry = [[NSArray alloc] initWithObjects:@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9", nil];//存放十个数，以备随机取
    NSMutableString * getStr = [[NSMutableString alloc] init];
    NSMutableString *changeString = [[NSMutableString alloc] initWithCapacity:number];//
    for (int i = 0; i<number; i++) {
        NSInteger index = arc4random()%([arry count]-1);//
        getStr = arry[index];
        changeString = (NSMutableString *)[changeString stringByAppendingString:getStr];
    }
    return changeString;
}
#pragma -mark 获得设备型号
+(NSString *)jj_getCurrentDevice{
    
    int mib[2];
    size_t len;
    char *machine;
    
    mib[0] = CTL_HW;
    mib[1] = HW_MACHINE;
    sysctl(mib, 2, NULL, &len, NULL, 0);
    machine = malloc(len);
    sysctl(mib, 2, machine, &len, NULL, 0);
    
    NSString *platform = [NSString stringWithCString:machine encoding:NSASCIIStringEncoding];
    free(machine);
    
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G (A1203)";
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G (A1241/A1324)";
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS (A1303/A1325)";
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4 (A1332)";
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4 (A1332)";
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4 (A1349)";
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S (A1387/A1431)";
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5 (A1428)";
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5 (A1429/A1442)";
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c (A1456/A1532)";
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c (A1507/A1516/A1526/A1529)";
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s (A1453/A1533)";
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s (A1457/A1518/A1528/A1530)";
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus (A1522/A1524)";
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6 (A1549/A1586)";
    if ([platform isEqualToString:@"iPhone8,2"]) return @"iPhone 6s Plus (A1522/A1524)";
    if ([platform isEqualToString:@"iPhone8,1"]) return @"iPhone 6s (A1549/A1586)";
    if ([platform isEqualToString:@"iPhone9,1"]) return @"iPhone 7";
    if ([platform isEqualToString:@"iPhone9,2"]) return @"iPhone 7 Plus";
    
    if ([platform isEqualToString:@"iPhone10,1"])    return @"iPhone 8";
    if ([platform isEqualToString:@"iPhone10,4"])    return @"iPhone 8";
    if ([platform isEqualToString:@"iPhone10,2"])    return @"iPhone 8 Plus";
    if ([platform isEqualToString:@"iPhone10,5"])    return @"iPhone 8 Plus";
    
    
    if ([platform isEqualToString:@"iPhone10,3"])    return @"iPhone X";
    if ([platform isEqualToString:@"iPhone10,6"])    return @"iPhone X";
    
    if ([platform isEqualToString:@"iPod1,1"])   return @"iPod Touch 1G (A1213)";
    if ([platform isEqualToString:@"iPod2,1"])   return @"iPod Touch 2G (A1288)";
    if ([platform isEqualToString:@"iPod3,1"])   return @"iPod Touch 3G (A1318)";
    if ([platform isEqualToString:@"iPod4,1"])   return @"iPod Touch 4G (A1367)";
    if ([platform isEqualToString:@"iPod5,1"])   return @"iPod Touch 5G (A1421/A1509)";
    
    if ([platform isEqualToString:@"iPad1,1"])   return @"iPad 1G (A1219/A1337)";
    
    if ([platform isEqualToString:@"iPad2,1"])   return @"iPad 2 (A1395)";
    if ([platform isEqualToString:@"iPad2,2"])   return @"iPad 2 (A1396)";
    if ([platform isEqualToString:@"iPad2,3"])   return @"iPad 2 (A1397)";
    if ([platform isEqualToString:@"iPad2,4"])   return @"iPad 2 (A1395+New Chip)";
    if ([platform isEqualToString:@"iPad2,5"])   return @"iPad Mini 1G (A1432)";
    if ([platform isEqualToString:@"iPad2,6"])   return @"iPad Mini 1G (A1454)";
    if ([platform isEqualToString:@"iPad2,7"])   return @"iPad Mini 1G (A1455)";
    
    if ([platform isEqualToString:@"iPad3,1"])   return @"iPad 3 (A1416)";
    if ([platform isEqualToString:@"iPad3,2"])   return @"iPad 3 (A1403)";
    if ([platform isEqualToString:@"iPad3,3"])   return @"iPad 3 (A1430)";
    if ([platform isEqualToString:@"iPad3,4"])   return @"iPad 4 (A1458)";
    if ([platform isEqualToString:@"iPad3,5"])   return @"iPad 4 (A1459)";
    if ([platform isEqualToString:@"iPad3,6"])   return @"iPad 4 (A1460)";
    
    if ([platform isEqualToString:@"iPad4,1"])   return @"iPad Air (A1474)";
    if ([platform isEqualToString:@"iPad4,2"])   return @"iPad Air (A1475)";
    if ([platform isEqualToString:@"iPad4,3"])   return @"iPad Air (A1476)";
    if ([platform isEqualToString:@"iPad4,4"])   return @"iPad Mini 2G (A1489)";
    if ([platform isEqualToString:@"iPad4,5"])   return @"iPad Mini 2G (A1490)";
    if ([platform isEqualToString:@"iPad4,6"])   return @"iPad Mini 2G (A1491)";
    
    if ([platform isEqualToString:@"i386"])      return @"iPhone Simulator";
    if ([platform isEqualToString:@"x86_64"])    return @"iPhone Simulator";
    
    return platform;
}
#pragma -mark 打印设备信息
+(void)jj_nslogCurrentDevice{
    
    NSString *platform=[NSString jj_getCurrentDevice];
    UIDevice *device=[UIDevice currentDevice];
    NSLog(@"  ");
    NSLog(@"======================设备信息======================");
    NSLog(@"  ");
    NSLog(@"设备所有者的名称----   %@",device.name);
    NSLog(@"设备的类别---------   %@",device.model);
    NSLog(@"设备的的本地版本----  %@",device.localizedModel);
    NSLog(@"设备运行的系统-----    %@",device.systemName);
    NSLog(@"当前系统的版本-----    %@",device.systemVersion);
    NSLog(@"设备识别码--------    %@",device.identifierForVendor.UUIDString);
    NSLog(@"当前设备型号:%@",platform);
    NSLog(@"沙盒路径：%@",NSHomeDirectory());
    NSLog(@"  ");
    NSLog(@"=================================================");
    NSLog(@"  ");
}
#pragma mark 计算字体高度
+ (CGFloat)getHeight:(NSString *)str{
    if (str.length>0) {
        CGFloat labelWidth = KM_ScreenWidth-20;
        
        NSAttributedString * test = [[NSAttributedString alloc] initWithData:[str dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
        NSStringDrawingOptions options= NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading;
        
        CGRect rect = [test boundingRectWithSize:CGSizeMake(labelWidth, 0) options:options context:nil];
        
        return (CGFloat)(ceil(rect.size.height) + 30);
        
    }
    return 44;
}
#pragma -mark 普通字符串转换为十六进制的
+ (NSString *)jj_hexaDecimal:(NSString *)string{
    NSData *myD = [string dataUsingEncoding:NSUTF8StringEncoding];
    Byte *bytes = (Byte *)[myD bytes];
    //下面是Byte 转换为16进制。
    NSString *hexStr=@"";
    for(int i=0;i<[myD length];i++)
        
    {
        NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i]&0xff];///16进制数
        
        if([newHexStr length]==1)
            
            hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
        
        else
            
            hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr];
    }
    return hexStr;
}



#pragma -mark 设定时间
+(NSString*)jj_getDate:(NSDate*)date withFormatter:(NSString*)formatter{
    //YYYY-MM-dd HH:mm:ss
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:formatter];
    //用[NSDate date]可以获取系统当前时间
    NSString *currentDateStr = [dateFormatter stringFromDate:date];
    //输出格式为：2010-10-27 10:22:13
    
    return currentDateStr;
}

#pragma -mark   获得NSString==>NSDate
+(NSDate*)jj_stringToDate:(NSString*)string withFormatter:(NSString*)formatter{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init] ;
    [dateFormatter setDateFormat:formatter];
    NSDate *date=[dateFormatter dateFromString:string];
    
    return date;
}
#pragma -mark  获得星期几
+ (NSString * )jj_weekdayStringFromDate:(NSDate*)inputDate {
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"Sunday", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六", nil];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    
    [calendar setTimeZone: timeZone];
    
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:inputDate];
    
    return [weekdays objectAtIndex:theComponents.weekday];
}
#pragma -mark 获得程序信息
+(NSString *)jj_information:(NSString*)str{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    //NSLog(@"%@",(infoDictionary));
    //  app名称CFBundleDisplayName
    //  app CFBundleIdentifier
    //  app版本CFBundleShortVersionString
    //  app build版本 CFBundleVersion
    NSString *appStr = [infoDictionary objectForKey:str];
    return appStr;
}
#pragma -mark HTML
+(NSString *)jj_filterHTML:(NSString *)html{
    NSScanner * scanner = [NSScanner scannerWithString:html];
    NSString * text = nil;
    while([scanner isAtEnd]==NO)
    {
        //找到标签的起始位置
        [scanner scanUpToString:@"<" intoString:nil];
        //找到标签的结束位置
        [scanner scanUpToString:@">" intoString:&text];
        //替换字符
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
    }
    
    NSString * regEx = @"&nbsp";
    html = [html stringByReplacingOccurrencesOfString:regEx withString:@""];
    return html;
}
#pragma mark obj转NSString
+(NSString*)jj_objToJson:(id)obj{
    
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:obj
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    if ([jsonData length] > 0 && error == nil){
        
        NSString *jsonString = [[NSString alloc] initWithData:jsonData
                                
                                                     encoding:NSUTF8StringEncoding];
        
        return jsonString;
        
    }else{
        
        return @"";
        
    }

    

}
#pragma mark 计算字符串高
+(float)jj_getStringHeight:(NSString *)text maxW:(int)maxw AndFont:(int)fontSize{
    //返回计算出的size
    NSDictionary *dic=@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]};
    NSStringDrawingOptions option=NSStringDrawingTruncatesLastVisibleLine| NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    CGSize size= [text boundingRectWithSize:CGSizeMake(maxw, 10000)
                                   options: option
                                attributes:dic
                                   context:nil].size;
    return size.height;
}
#pragma mark 计算字符串宽
+(float)jj_getStringW:(NSString *)text maxH:(int)maxw AndFont:(int)fontSize{
    //返回计算出的size
    NSDictionary *dic=@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize] };
    NSStringDrawingOptions option=NSStringDrawingTruncatesLastVisibleLine| NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    CGSize size= [text boundingRectWithSize:CGSizeMake(10000, maxw)
                                    options:option
                                 attributes:dic
                                    context:nil].size;
    return size.width;
}
#pragma mark obj转NSString
+(NSString*)jj_getJson:(id)obj{
    
    NSData *data=[NSString jj_dicToData:obj];
    NSString *jsonString = [[NSString alloc] initWithData:data
                            
                                                 encoding:NSUTF8StringEncoding];
    
    return jsonString;
}
#pragma mark NSDictionary转NSData
+ (NSData *)jj_dicToData:(id)theData{
    
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:theData
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    
    
    if ([jsonData length] > 0 && error == nil){
        return jsonData;
        
    }else{
        
        return nil;
        
    }
    
}
#pragma -mark 获得万元字符串
+ (NSString *)jj_changeAsset:(NSString *)amountStr
{
    if (amountStr && ![amountStr isEqualToString:@""] && ![amountStr isEqual:[NSNull null]])
    {
        NSNumber *num = [NSNumber numberWithDouble:amountStr.doubleValue];
        NSNumberFormatter *numberFormatter = [NSNumberFormatter new];
        numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
        numberFormatter.multiplier     = @0.0001;
        numberFormatter.positiveSuffix = @"万";
        return [numberFormatter stringFromNumber:num];
    }
    return @"0万元";
}
#pragma -mark 获得千位分隔符字符串
+(NSString *)jj_partStringWithSeparator:(NSString *)num{
    if (num && num.length && ![num isEqual:[NSNull null]]) {
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setPositiveFormat:@"###,##0.00;"];
        NSNumber *number = [numberFormatter numberFromString:num];
        numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
        return [numberFormatter stringFromNumber:number];
    }
    return @"0";
}
#pragma -mark 获得千位分隔符字符串,返回不带‘.’
+(NSString *)jj_partStringWithSeparatorToInt:(NSString *)num{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setPositiveFormat:@"###,##0;"];
    NSNumber *four = [numberFormatter numberFromString:num];
    NSString *formattedNumberString = [numberFormatter stringFromNumber:four];
    return ([formattedNumberString isEqual:[NSNull null]]||formattedNumberString==nil)?@"0":formattedNumberString;
}
#pragma mark-字符串处理
+ (NSString *)jj_stringReplaceWith:(NSString *)str{
    if (str.length>12) {
        NSString *str1 = [str substringFromIndex:str.length-4];
        NSString *str2 = [str substringToIndex:4];
        NSString *newStr = [NSString stringWithFormat:@"%@***%@",str2,str1];
        return newStr;
    }else{
        return str;
    }
    
}
#pragma -mark 加密
+(NSString *)jj_signatureWithMd5New:(NSDictionary *)dic andHost:(NSString *)host{
    NSMutableDictionary *dd=[[NSMutableDictionary alloc]initWithDictionary:dic];
    NSArray    *aa = [host componentsSeparatedByString:@"/"];
    [dd setObject:[aa objectAtIndex:0] forKey:@"m"];
    [dd setObject:[aa objectAtIndex:1] forKey:@"a"];
    
    NSString *urlString=[[NSString alloc]init];
    NSMutableDictionary *mutableParameters=[NSMutableDictionary dictionary];
    NSArray *arr=[dd allKeys];
    NSMutableArray *mutableArray=[[NSMutableArray alloc]initWithArray:arr];
    
    [mutableArray sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
    for ( int i=0;i<mutableArray.count; i++ ) {
        NSString *string=[mutableArray objectAtIndex:i];
        [mutableParameters setObject:[dd objectForKey:string] forKey:string];
        NSString *aa=[NSString stringWithFormat:@"%@=%@",string,[dd objectForKey:string]];
        if ([urlString isEqualToString:@""]){
            urlString=aa;
        }else{
            urlString =[NSString stringWithFormat:@"%@&%@",urlString,aa];
        }
        
    }
    return  urlString;
}



#pragma -mark  测试图片
+(NSString *)jj_getImageUrl{
    
    
    NSString *imageUrl;
    switch (arc4random()%5) {
        case 0:{
            imageUrl=  @"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=4123029992,2153970001&fm=11&gp=0.jpg";
        }
            break;
        case 1:{
            imageUrl= @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1490705974654&di=6cd34329dba29bffe671e0c2603d97aa&imgtype=0&src=http%3A%2F%2Fp2.cri.cn%2FM00%2FBD%2F6D%2FCqgNOljR0pWAOyppAAAAAAAAAAA825.500x624.jpg";
        }
            break;
        case 2:{
            imageUrl= @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1490705987693&di=b0cc7ddbf3de9743f777bdf796f40aba&imgtype=0&src=http%3A%2F%2Fent.chinadaily.com.cn%2Fimg%2Fattachement%2Fjpg%2Fsite1%2F20170324%2Fbc305bcee6d91a3f1b9439.jpg";
        }
            break;
        case 3:{
            imageUrl= @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1490706007993&di=c0aa2da096614705b06c572eb3005784&imgtype=0&src=http%3A%2F%2Fwww.sxdaily.com.cn%2FNMediaFile%2F2017%2F0301%2FSXRB201703010801000423413978025.jpg";
        }
            break;
        case 4:{
            
            imageUrl= @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1490706054129&di=12bb32d7bc134cc7d5c7c2dd2bc74562&imgtype=0&src=http%3A%2F%2Fwww.sznews.com%2Fent%2Fimages%2Fattachement%2Fjpg%2Fsite3%2F20160617%2FIMG7427ea1e3ca641613024497.jpg";
        }
            break;
        default:{
            
            imageUrl= @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1490706054129&di=12bb32d7bc134cc7d5c7c2dd2bc74562&imgtype=0&src=http%3A%2F%2Fwww.sznews.com%2Fent%2Fimages%2Fattachement%2Fjpg%2Fsite3%2F20160617%2FIMG7427ea1e3ca641613024497.jpg";
            break;
        }
            
    }
    
    
    return imageUrl;
}

//取出字符串中的数字
+(NSString *)extractionOfdigitalFromString:(NSString *)str{
    NSMutableString *strippedString = [NSMutableString stringWithCapacity:str.length];
    NSScanner *scanner = [NSScanner scannerWithString:str];
    NSCharacterSet *numbers = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    while ([scanner isAtEnd] == NO) {
        NSString *buffer;
        if ([scanner scanCharactersFromSet:numbers intoString:&buffer]) {
            [strippedString appendString:buffer];
        } else {
            [scanner setScanLocation:([scanner scanLocation] + 1)];
        }
    }
    return str;
}
#pragma -mark 设置字符串不同颜色
+ (NSMutableAttributedString *)jj_getAttributedString:(NSString *)allString
                                           andChangeS:(NSString *)string
                                             andColor:(UIColor *)color
                                             andFont:(UIFont *)font
{
    
    NSMutableAttributedString *one = [[NSMutableAttributedString alloc] initWithString:allString];
    NSRange ss=[allString rangeOfString:string];
    // 添加文字颜色 大小
    [one addAttribute:NSForegroundColorAttributeName value:color range:ss];
    [one addAttribute:NSFontAttributeName value:font range:ss];
    return one;
}


#pragma -mark  获取xxx xxxx xxxx格式手机号
+(NSString *)jj_showPhoneText:(NSString *)phone {
    if (phone.length == 11) {
        NSMutableString *temString = [NSMutableString stringWithString:phone];
        [temString insertString:@" " atIndex:7];
        [temString insertString:@" " atIndex:3];
        return temString;
    }
    return phone;
}
@end
