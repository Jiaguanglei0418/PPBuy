//
//  PPDealTool.h
//  PPBuy
//
//  Created by jiaguanglei on 15/10/19.
//  Copyright (c) 2015年 roseonly. All rights reserved.
//
//   -----   数据库存储

#import <Foundation/Foundation.h>
//@class singleton;
@class PPDeal;


@interface PPDealTool : NSObject
//SingletonH(PPDealTool)

// --------------     收藏     -------- ------
/**
 *  获取收藏团购数据 -  read读取
 *
 *  @param page 第 i 页(从1开始)
 *
 */
+ (NSArray *)collectDeals:(int)page;

/**
 *  收藏团购数据 -  save 存
 *
 *  @param deal PPDeal 对象
 *
 */
+ (void)addCollectDeals:(PPDeal *)deal;


/**
 *  取消收藏团购数据 -  删除
 *
 *  @param deal PPDeal 对象
 *
 */
+ (void)deleteCollectDeals:(PPDeal *)deal;

/**
 *  判断是否收藏  -- 判断
 *
 *  @param deal PPDeal 对象
 *
 */
+ (BOOL)isCollected:(PPDeal *)deal;

/**
 *  收藏团购的数量  -- 数量
 */
+ (int)collectDealsCount;



// ------------------   浏览记录  --------------
/**
 *  获取最近浏览团购数据 -  read读取
 *
 *  @param page 第 i 页(从1开始)
 *
 */
+ (NSArray *)recentDeals:(int)page;


/**
 *  添加浏览记录 -  存
 *
 *  @param deal PPDeal 对象
 *
 */
+ (void)addRecentDeals:(PPDeal *)deal;

/**
 *  删除浏览记录 -  删除
 *
 *  @param deal PPDeal 对象
 *
 */
+ (void)deleteRecentDeals:(PPDeal *)deal;



@end
