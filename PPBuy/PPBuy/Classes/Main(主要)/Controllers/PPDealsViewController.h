//
//  PPDealsViewController.h
//  PPBuy
//
//  Created by jiaguanglei on 15/10/16.
//  Copyright (c) 2015年 roseonly. All rights reserved.
//
//  ---   团购列表控制器 (父类)

#import <UIKit/UIKit.h>

@interface PPDealsViewController : UICollectionViewController

/**
 *  设置请求参数  -- 思想: 父类提供方法, 交给子类来实现(父类统一调用)
 */
- (void)setupParams:(NSMutableDictionary *)params;


@end
