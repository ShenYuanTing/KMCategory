//
//  UINavigationController+JJ_UINavigationController.m
//  WOEWO
//
//  Created by BPMAC on 2017/3/16.
//  Copyright © 2017年 BPMAC. All rights reserved.
//

#import "UINavigationController+JJ_UINavigationController.h"

//绿色
#define KM_GreenColor KM_RGB_X(0xd4d7d8)

//颜色  RGB_X(0x067AB5)
#define KM_RGB_X(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@implementation UINavigationController (JJ_UINavigationController)
+(void)jj_navBaseDefault{
    //导航栏
    [UIApplication sharedApplication].statusBarHidden = NO;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    // [[UINavigationBar appearance] setBarTintColor:BaseColor];//导航背景颜色
    
    //导航图片背景
    //UIImage *bgImage=[[UIImage imageNamed:@"tabbar_background_os7.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    //[[UINavigationBar appearance] setBackgroundImage:bgImage forBarMetrics:UIBarMetricsDefault];
    
    
    //全局 设置 tintColor
    [[UITextField appearance] setTintColor:KM_GreenColor];
    [[UITextView appearance] setTintColor:KM_GreenColor];
    [[UIAlertView appearance]setTintColor:KM_GreenColor];
    [[UIActionSheet appearance]setTintColor:KM_GreenColor];
    
}
@end
