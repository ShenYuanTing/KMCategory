//
//  UITextField+JJ_UITextField.m
//  DEHONG
//
//  Created by BPMAC1 on 2017/9/5.
//  Copyright © 2017年 BPMAC. All rights reserved.
//

#import "UITextField+JJ_UITextField.h"

@implementation UITextField (JJ_UITextField)

- (void)jj_changetext:(NSString *)text {
    UITextPosition *beginning = self.beginningOfDocument;
    UITextPosition *start = self.selectedTextRange.start;
    UITextPosition *end = self.selectedTextRange.end;
    NSInteger startIndex = [self offsetFromPosition:beginning toPosition:start];
    NSInteger endIndex = [self offsetFromPosition:beginning toPosition:end];
    
    // 将输入框中的文字分成两部分，生成新字符串，判断新字符串是否满足要求
    NSString *originText = self.text;
    NSString *part1 = [originText substringToIndex:startIndex];
    NSString *part2 = [originText substringFromIndex:endIndex];
    
    NSInteger offset;
   
    if (![text isEqualToString:@""]) {
        offset = text.length;
        if ([originText containsString:@"."]) {
            //只能有一个小数点
            if ([text isEqualToString:@"."]) {
                return;
            }
            //小数点后2位
            NSArray *strArr = [originText componentsSeparatedByString:@"."];
            NSString *ss = strArr.lastObject;
            if (ss.length == 2) {
                return;
            }
        } else {
            //插入小数点，判断小数点后2位才可插入
            if ([text isEqualToString:@"."] && part2.length > 2) {
                return;
            }
        }
        if ([text isEqualToString:@"."]) {
//            return;
            
        }else{
            if ([originText containsString:@"."]) {
                NSInteger dotLocation = [originText rangeOfString:@"."].location;
                if (dotLocation >= 9) {
                    
                    NSLog(@"单笔金额不能超过亿位");
                    return;
                    
                }
            }
            else{
                if ([text isEqualToString:@"00"] && originText.length >= 7) {
                    return;
                }
                if (originText.length >= 8) {
                    
                    return;
                    
                }
                
            }
            
        }
    } else {
        if (startIndex == endIndex) { // 只删除一个字符
            if (startIndex == 0) {
                return;
            }
            offset = -1;
            part1 = [part1 substringToIndex:(part1.length - 1)];
        } else {
            offset = 0;
        }
    }
    
    
    
    
    NSString *newText = [NSString stringWithFormat:@"%@%@%@", part1, text, part2];
    self.text = newText;
    
    // 重置光标位置
    UITextPosition *now = [self positionFromPosition:start offset:offset];
    UITextRange *range = [self textRangeFromPosition:now toPosition:now];
    self.selectedTextRange = range;
}

@end
