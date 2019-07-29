//
//  UIAlertView+Fast.h
//  ShengLoveParadise
//
//  Created by xjkj on 14-4-10.
//  Copyright (c) 2014年 xjkj. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^CompleteBlock) (NSInteger buttonIndex);

@interface UIAlertView (Fast)<UIAlertViewDelegate>
- (void)showAlertViewWithCompleteBlock:(CompleteBlock) block;
@end
