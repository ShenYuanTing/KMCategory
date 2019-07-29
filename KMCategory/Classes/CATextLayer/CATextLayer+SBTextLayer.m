//
//  CATextLayer+SBTextLayer.m
//  ShengLoveParadise
//
//  Created by xjkj on 14-4-16.
//  Copyright (c) 2014年 xjkj. All rights reserved.
//

#import "CATextLayer+SBTextLayer.h"

@implementation CATextLayer (SBTextLayer)
+(CATextLayer*)bulidWtih:(NSString *)text
               andNSarry:(NSArray *)dataArry
                andFrame:(CGRect)frame
{
  
    NSMutableAttributedString *lab = [[NSMutableAttributedString alloc]initWithString:text];
    
    int indexLength=0;
    int strLength=0;
    
    for (int i=0; i<dataArry.count; i++)
    {
        NSDictionary*dic=  [dataArry objectAtIndex:i];
        NSString *str=[dic objectForKey:@"text"];
        UIFont *font=[dic objectForKey:@"font"];
        UIColor *color=[dic objectForKey:@"color"];
        
        strLength= (int)str.length;
        
        [lab addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)color.CGColor range:NSMakeRange(indexLength, strLength)];
        //字体
        CTFontRef helveticaBold = CTFontCreateWithName((CFStringRef)font.fontName,
                                                       font.pointSize,
                                                       NULL);
        [lab addAttribute:(id)kCTFontAttributeName value:(__bridge id)helveticaBold range:NSMakeRange(indexLength,strLength)];
        
        indexLength=indexLength+strLength;
    }
    
    CATextLayer *textlay = [CATextLayer layer];
    textlay.string = lab;
    textlay.contentsScale = 2;//防止模糊！！重要
    [textlay setWrapped:YES];
    textlay.frame = frame;
    [textlay setAlignmentMode:@"left"];
    
    
    return textlay;

}

@end
