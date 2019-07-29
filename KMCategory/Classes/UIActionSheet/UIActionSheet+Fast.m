//
//  UIActionSheet+Fast.m
//  ShengLoveParadise
//
//  Created by xjkj on 14-4-17.
//  Copyright (c) 2014年 xjkj. All rights reserved.
//

#import "UIActionSheet+Fast.h"
#import <objc/runtime.h>

//总色调
#define KM_BaseColor  KM_RGB_X(0x6293f9)


//颜色  RGB_X(0x067AB5)
#define KM_RGB_X(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
static char key;

@implementation UIActionSheet (Fast)
// 用Block的方式回调，这时候会默认用self作为Delegate
- (void)showActionSheetWithCompleteBlock:(CompleteSheetBlock) block
{
    if (block) {
        ////移除所有关联
        objc_removeAssociatedObjects(self);
        /**
         1 创建关联（源对象，关键字，关联的对象和一个关联策略。)
         2 关键字是一个void类型的指针。每一个关联的关键字必须是唯一的。通常都是会采用静态变量来作为关键字。
         3 关联策略表明了相关的对象是通过赋值，保留引用还是复制的方式进行关联的；关联是原子的还是非原子的。这里的关联策略和声明属性时的很类似。
         */
        objc_setAssociatedObject(self, &key, block, OBJC_ASSOCIATION_COPY);
        ////设置delegate
        self.delegate = self;
    }

    ////show
    [self showInView:[UIApplication sharedApplication].keyWindow];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    ///获取关联的对象，通过关键字。
    CompleteSheetBlock block = objc_getAssociatedObject(self, &key);
    if (block) {
        ///block传值
        block(buttonIndex);
    }
}
-(void)willPresentActionSheet:(UIActionSheet *)actionSheet  {
    SEL selector = NSSelectorFromString(@"_alertController");
    if ([actionSheet respondsToSelector:selector]) {
        UIAlertController *alertController = [actionSheet valueForKey:@"_alertController"];
        if ([alertController isKindOfClass:[UIAlertController class]]) {
            alertController.view.tintColor = KM_BaseColor;
        }
    }
}
@end
