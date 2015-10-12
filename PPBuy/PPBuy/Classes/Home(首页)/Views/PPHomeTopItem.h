//
//  PPHomeTopItem.h
//  PPBuy
//
//  Created by jiaguanglei on 15/10/10.
//  Copyright (c) 2015年 roseonly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PPHomeTopItem : UIView

 /**  标题 ***/
@property (nonatomic, copy) NSString *title;
 /**  子标题 ***/
@property (nonatomic, copy) NSString *subTitle;

 /**  当需要只允许设置属性, 不允许访问属性时, 只声明set方法 ***/
- (void)setTitle:(NSString *)title;
- (void)setSubTitle:(NSString *)subTitle;

//@property (nonatomic, copy) NSString *icon;
//@property (nonatomic, copy) NSString *highIcon;
- (void)setIcon:(NSString *)icon highIcon:(NSString *)highIcon;



+ (instancetype)item;

/**
 *  设置监听器 ---- 监听事件少, 采用此方法 (多的话, 采用代理)
 *
 *  @param target 监听器
 *  @param action 监听方法
 */
- (void)addTarget:(id)target action:(SEL)action;
@end
