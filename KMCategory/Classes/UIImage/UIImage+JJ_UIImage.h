//
//  UIImage+JJ_UIImage.h
//  WOEWO
//
//  Created by BPMAC on 2017/3/15.
//  Copyright © 2017年 BPMAC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (JJ_UIImage)
#pragma -mark 快速图片拉伸
+(UIImage*)jj_imageName:(NSString*)name
          WithCapInsets:(UIEdgeInsets)capInsets
           resizingMode:(UIImageResizingMode)resizingMode;
#pragma -mark 颜色图片
+ (UIImage *)jj_imageWithColor:(UIColor *)color;
#pragma -mark 生成二维码
+(UIImage *)jj_createQrCode:(NSString *)text
                   withSize:(CGFloat) size;
@end
