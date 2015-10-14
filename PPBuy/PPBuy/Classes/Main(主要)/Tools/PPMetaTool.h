//
//  PPMetaTool.h
//  PPBuy
//
//  Created by jiaguanglei on 15/10/12.
//  Copyright (c) 2015年 roseonly. All rights reserved.
//
// 元数据 -- 管理所有的元数据(固定描述的数据)

#import <Foundation/Foundation.h>

@interface PPMetaTool : NSObject

/**
 *  返回所有城市 344个城市
 *
 */
+ (NSArray *)cities;


/**
 *  返回所有分类数据 
 *
 */
+ (NSArray *)categories;


/**
 *  返回所有排序数据
 *
 */
+ (NSArray *)sorts;
@end
