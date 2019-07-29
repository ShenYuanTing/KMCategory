//
//  FDAlertView.h
//  FDAlertViewDemo
//
//  Created by fergusding on 15/5/26.
//  Copyright (c) 2015年 fergusding. All rights reserved.
//

#import <UIKit/UIKit.h>

#define BaseColor  HEXCOLOR(0x6293f9)


@protocol FDAlertViewDelegate;

@interface FDAlertView : UIView

@property (strong, nonatomic) UIView *contentView;
@property (assign, nonatomic) BOOL isCanUserInterface;
@property (strong, nonatomic) UIImage *icon;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *message;
@property (copy, nonatomic)void(^touchAlterButton)(NSInteger index);
@property (weak, nonatomic) id<FDAlertViewDelegate> delegate;

- (instancetype)initWithTitle:(NSString *)title icon:(UIImage *)icon message:(NSString *)message textAlignment:(NSTextAlignment)textAlignment delegate:(id<FDAlertViewDelegate>)delegate buttonTitles:(NSString *)buttonTitles, ... NS_REQUIRES_NIL_TERMINATION;

// Show the alert view in current window
- (void)show;
- (void)showInCurrentVC:(UIViewController *)vc;
- (void)showInCurrentView:(UIView *)view;

// Hide the alert view
- (void)hide;

// Set the color and font size of title, if color is nil, default is black. if fontsize is 0, default is 14
- (void)setTitleColor:(UIColor *)color fontSize:(CGFloat)size;

// Set the color and font size of message, if color is nil, default is black. if fontsize is 0, default is 12
- (void)setMessageColor:(UIColor *)color fontSize:(CGFloat)size;

// Set the color and font size of button at the index, if color is nil, default is black. if fontsize is 0, default is 16
- (void)setButtonTitleColor:(UIColor *)color fontSize:(CGFloat)size atIndex:(NSInteger)index;

@end

@protocol FDAlertViewDelegate <NSObject>

- (void)alertView:(FDAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

@end
