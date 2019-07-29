//
//  UIActionSheet+Fast.h
//  ShengLoveParadise
//
//  Created by xjkj on 14-4-17.
//  Copyright (c) 2014年 xjkj. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^CompleteSheetBlock) (NSInteger buttonIndex);

@interface UIActionSheet (Fast)<UIActionSheetDelegate>

- (void)showActionSheetWithCompleteBlock:(CompleteSheetBlock) block;
@end
