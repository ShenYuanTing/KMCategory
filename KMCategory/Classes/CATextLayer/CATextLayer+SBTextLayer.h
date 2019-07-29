//
//  CATextLayer+SBTextLayer.h
//  ShengLoveParadise
//
//  Created by xjkj on 14-4-16.
//  Copyright (c) 2014年 xjkj. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import<CoreText/CoreText.h>
@interface CATextLayer (SBTextLayer)
+(CATextLayer*)bulidWtih:(NSString *)text
               andNSarry:(NSArray *)dataArry
                andFrame:(CGRect)frame;
@end
