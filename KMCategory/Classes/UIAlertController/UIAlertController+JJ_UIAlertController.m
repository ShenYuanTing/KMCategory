//
//  UIAlertController+JJ_UIAlertController.m
//  WOEWO
//
//  Created by BPMAC on 2017/3/16.
//  Copyright © 2017年 BPMAC. All rights reserved.
//

#import "UIAlertController+JJ_UIAlertController.h"
#import "FDAlertView.h"
//总色调
#define KM_BaseColor  KM_RGB_X(0x6293f9)


//颜色  RGB_X(0x067AB5)
#define KM_RGB_X(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@implementation UIAlertController (JJ_UIAlertController)
+ (void)showNormalAlertWithTitle:(NSString*)title
                     contentText:(NSString*)contStr
                 leftButtonTitle:(NSString*)leftstr
                rightButtonTitle:(NSString*)rightstr
                          finish:(void (^)(NSInteger index))block{
    FDAlertView *alert = [[FDAlertView alloc] initWithTitle:[title isEqualToString:@"内容左对齐"] ? nil : title icon:nil message:contStr textAlignment:[title isEqualToString:@"内容左对齐"] ? NSTextAlignmentLeft : NSTextAlignmentCenter delegate:nil buttonTitles:leftstr, rightstr, nil];
    alert.touchAlterButton = ^(NSInteger index){
        if (block){
            block(index);
        }
    };
    [alert show];
}

+ (void)showNormalAlertWithTitleAndCustomButtons:(NSString*)title
                     contentText:(NSString*)contStr
                leftButtonTitle:(NSString*)leftstr
                leftButtonTitleColor:(UIColor *)leftColor
                rightButtonTitle:(NSString*)rightstr
                rightButtonTitleColor:(UIColor *)rightColor
                          finish:(void (^)(NSInteger index))block{
    FDAlertView *alert = [[FDAlertView alloc] initWithTitle:[title isEqualToString:@"内容左对齐"] ? nil : title icon:nil message:contStr textAlignment:[title isEqualToString:@"内容左对齐"] ? NSTextAlignmentLeft : NSTextAlignmentCenter delegate:nil buttonTitles:leftstr, rightstr, nil];
    alert.touchAlterButton = ^(NSInteger index){
        if (block){
            block(index);
        }
    };
    [alert setButtonTitleColor:leftColor fontSize:16 atIndex:0];
    [alert setButtonTitleColor:rightColor fontSize:16 atIndex:1];
    [alert show];
}

+(void)jj_showTitle:(NSString*)title
            message:(NSString*)message
     preferredStyle:(UIAlertControllerStyle)preferredStyle
     viewController:(UIViewController*)vc
       action1Title:(NSString*)action1Title
       action2Title:(NSString*)action2Title
       action3Title:(NSString*)action3Title
     action1Handler:(void (^)(UIAlertAction *action1))action1Handler
     action2Handler:(void (^)(UIAlertAction *action2))action2Handler
     action3Handler:(void (^)(UIAlertAction *action3))action3Handler{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title.length?title:nil
                                                                             message:message.length?message:nil
                                                                      preferredStyle:preferredStyle];
    
    
    alertController.view.tintColor = KM_BaseColor;
    
    if (action1Title.length) {
        
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:action1Title
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction * _Nonnull action) {
                                                            
                                                            if (action1Handler) {
                                                                action1Handler(action);
                                                            }
                                                            
                                                        }];
        //[action setValue:BaseColor forKey:@"_titleTextColor"];
        [alertController addAction:action1];
    }
    if (action2Title.length) {
        
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:action2Title
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction * _Nonnull action) {
                                                            
                                                            if (action2Handler) {
                                                                action2Handler(action);
                                                            }
                                                            
                                                        }];
        //[action setValue:BaseColor forKey:@"_titleTextColor"];
        [alertController addAction:action2];
    }
    if (action3Title.length) {
        
        UIAlertAction *action3 = [UIAlertAction actionWithTitle:action3Title
                                                          style:[action3Title isEqualToString:@"取消"]?UIAlertActionStyleCancel:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction * _Nonnull action) {
                                                            
                                                            if (action3Handler) {
                                                                action3Handler(action);
                                                            }
                                                            
                                                        }];
        //[action setValue:BaseColor forKey:@"_titleTextColor"];
        [alertController addAction:action3];
    }
    if (vc) {
        [vc presentViewController:alertController animated:YES completion:nil];
        
    }else{
        [[UIAlertController topViewController] presentViewController:alertController animated:YES completion:nil];
        
        
    }
    
    
    
    
}

+ (UIViewController *)topViewController {
    UIViewController *resultVC;
    resultVC = [self _topViewController:[[UIApplication sharedApplication].keyWindow rootViewController]];
    while (resultVC.presentedViewController) {
        resultVC = [self _topViewController:resultVC.presentedViewController];
    }
    return resultVC;
}

+ (UIViewController *)_topViewController:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self _topViewController:[(UINavigationController *)vc topViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self _topViewController:[(UITabBarController *)vc selectedViewController]];
    } else {
        return vc;
    }
    return nil;
}


+(void)jj_showTitle:(NSString*)title
            message:(NSString*)message
     viewController:(UIViewController*)vc
         textField1:(NSString*)textField1Str
         textField2:(NSString*)textField2Str
       action1Title:(NSString*)action1Title
       action2Title:(NSString*)action2Title
     action1Handler:(void (^)(UIAlertAction *action1))action1Handler
     action2Handler:(void (^)(UIAlertAction *action2,NSString*textField1Text,NSString*textField2Text))action2Handler{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title.length?title:nil
                                                                             message:message.length?message:nil
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    
    alertController.view.tintColor = KM_BaseColor;
    
    if (textField1Str) {
        
        [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            
            textField.placeholder = textField1Str;
            textField.borderStyle=UITextBorderStyleNone;
        }];
    }
    
    if (textField2Str) {
        [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            
            textField.placeholder = textField2Str;
            textField.borderStyle=UITextBorderStyleNone;
        }];
        
    }
    
    
    
    
    if (action1Title.length) {
        
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:action1Title
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction * _Nonnull action) {
                                                            
                                                            if (action1Handler) {
                                                                action1Handler(action);
                                                            }
                                                            
                                                        }];
        //[action setValue:BaseColor forKey:@"_titleTextColor"];
        [alertController addAction:action1];
    }
    if (action2Title.length) {
        
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:action2Title
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction * _Nonnull action) {
                                                            
                                                            UITextField *textField1 = alertController.textFields.firstObject;
                                                            UITextField *textField2 = alertController.textFields.lastObject;
                                                            
                                                            if (action2Handler) {
                                                                action2Handler(action,textField1.text,textField2.text);
                                                            }
                                                            
                                                        }];
        //[action setValue:BaseColor forKey:@"_titleTextColor"];
        [alertController addAction:action2];
    }
    
    [[UIAlertController topViewController] presentViewController:alertController animated:YES completion:nil];
    
    
    
    
}


@end
