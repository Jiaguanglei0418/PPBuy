//
//  PPHomeTopItem.h
//  PPBuy
//
//  Created by jiaguanglei on 15/10/10.
//  Copyright (c) 2015年 roseonly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PPHomeTopItem : UIView

+ (instancetype)item;



/**
 *  设置监听器 ---- 监听事件少, 采用此方法 (多的话, 采用代理)
 *
 *  @param target 监听器
 *  @param action 监听方法
 */
- (void)addTarget:(id)target action:(SEL)action;
@end
