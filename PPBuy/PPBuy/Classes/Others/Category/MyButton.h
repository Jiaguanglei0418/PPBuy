//
//  MyButton.h
//  bolock
//
//  Created by zhaokai on 15/5/28.
//  Copyright (c) 2015年 zhaokai. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MyButton;


//注意:这里最好传一个参数,而且这个参数最好是当前按钮自身,这样可以将按钮的所有属性都传出去
typedef void (^myBlock)(MyButton *button);

@interface MyButton : UIButton


@property (nonatomic,copy) myBlock tempBlock;

+(MyButton *)buttonWithFrame:(CGRect)frame type:(UIButtonType)type title:(NSString *)title target:(id)target andAction:(SEL)sel;

+(MyButton *)buttonWithFrame:(CGRect)frame type:(UIButtonType )type title:(NSString *)title andBlock:(myBlock)block;


+ (MyButton *)buttonWithFrame:(CGRect)frame type:(UIButtonType)type title:(NSString *)title titleColor:(UIColor *)color image:(UIImage *)image selectedImage:(UIImage *)seleImage backgroundImage:(UIImage *)backImage andBlock:(myBlock)block;

@end
