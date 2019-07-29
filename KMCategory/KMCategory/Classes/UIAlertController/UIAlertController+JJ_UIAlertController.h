//
//  UIAlertController+JJ_UIAlertController.h
//  WOEWO
//
//  Created by BPMAC on 2017/3/16.
//  Copyright © 2017年 BPMAC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertController (JJ_UIAlertController)
+ (void)showNormalAlertWithTitle:(NSString*)title
                     contentText:(NSString*)contStr
                 leftButtonTitle:(NSString*)leftstr
                rightButtonTitle:(NSString*)rightstr
                          finish:(void (^)(NSInteger index))block;

+ (void)showNormalAlertWithTitleAndCustomButtons:(NSString*)title
                     contentText:(NSString*)contStr
                 leftButtonTitle:(NSString*)leftstr
            leftButtonTitleColor:(UIColor *)leftColor
                rightButtonTitle:(NSString*)rightstr
           rightButtonTitleColor:(UIColor *)rightColor
                          finish:(void (^)(NSInteger index))block;

+(void)jj_showTitle:(NSString*)title
            message:(NSString*)message
     preferredStyle:(UIAlertControllerStyle)preferredStyle
     viewController:(UIViewController*)vc
       action1Title:(NSString*)action1Title
       action2Title:(NSString*)action2Title
       action3Title:(NSString*)action3Title
     action1Handler:(void (^)(UIAlertAction *action1))action1Handler
     action2Handler:(void (^)(UIAlertAction *action2))action2Handler
     action3Handler:(void (^)(UIAlertAction *action3))action3Handler;

+(void)jj_showTitle:(NSString*)title
            message:(NSString*)message
     viewController:(UIViewController*)vc
         textField1:(NSString*)textField1Str
         textField2:(NSString*)textField2Str
       action1Title:(NSString*)action1Title
       action2Title:(NSString*)action2Title
     action1Handler:(void (^)(UIAlertAction *action1))action1Handler
     action2Handler:(void (^)(UIAlertAction *action2,NSString*textField1Text,NSString*textField2Text))action2Handler;

@end
