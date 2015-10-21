//
//  PPDealTool.m
//  PPBuy
//
//  Created by jiaguanglei on 15/10/19.
//  Copyright (c) 2015年 roseonly. All rights reserved.
//

#import "PPDealTool.h"
#import "FMDB.h"

#import "PPDeal.h"
//#import "Singleton.h"

@implementation PPDealTool
//SingletonM(PPDealTool);

static FMDatabase *_db;

+ (void)initialize
{
    // 1. 打开数据库
    NSString *filename = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"deal.sqlite"];
//    LogYellow(@"%@", filename);
    _db = [FMDatabase databaseWithPath:filename];
    
    // 打开失败, 直接返回
    if(![_db open]) return;
    
    // 2. 创建表
    [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_collect_deal(id interger PRIMARY KEY, deal blob NOT NULL, deal_id text NOT NULL);"];
    [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_recent_deal(id interger PRIMARY KEY, deal blob NOT NULL, deal_id text NOT NULL);"];
}

// --------------------------------    收藏   ----------------------------
+ (NSArray *)collectDeals:(int)page
{
    // 每次取20条
    int size = 6;
    // 位置, 从第 position 个数据开始取
    int position = (page - 1) * size;
    
    // 排序, 查询
    FMResultSet *set = [_db executeQueryWithFormat:@"SELECT * FROM t_collect_deal ORDER BY id DESC LIMIT %d,%d;", position, size];
    
    NSMutableArray *deals = [NSMutableArray array];
    while ([set next]) {
        // 解档
        PPDeal *deal = [NSKeyedUnarchiver unarchiveObjectWithData:[set objectForColumnName:@"deal"]];
        [deals addObject:deal];
    }
    return deals;
}

/**
 *  添加
 */
+ (void)addCollectDeals:(PPDeal *)deal
{
    // 转换成 -- NSData -- // 归档, 必须准售NSCoding协议
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:deal];
    
    // 执行存储
    [_db executeUpdateWithFormat:@"INSERT INTO t_collect_deal(deal, deal_id) VALUES(%@, %@);", data, deal.deal_id];
}

/**
 *  删除
 */
+ (void)deleteCollectDeals:(PPDeal *)deal
{
    [_db executeUpdateWithFormat:@"DELETE FROM t_collect_deal WHERE deal_id = %@;", deal.deal_id];
}

+ (BOOL)isCollected:(PPDeal *)deal
{
    // 查询 个数
    FMResultSet *set = [_db executeQueryWithFormat:@"SELECT count(*) AS deal_count FROM t_collect_deal WHERE deal_id = %@;", deal.deal_id];
    [set next];
    
    // 返回收藏
    return [set intForColumn:@"deal_count"] == 1;
}

+ (int)collectDealsCount
{
    FMResultSet *set = [_db executeQueryWithFormat:@"SELECT count(*) AS deal_count FROM t_collect_deal;"];
    [set next];
    
    return [set intForColumn:@"deal_count"];
}

// --------------------------------    浏览记录   ----------------------------
+ (NSArray *)recentDeals:(int)page
{
    return nil;
}

+ (void)addRecentDeals:(PPDeal *)deal
{

}

+ (void)deleteRecentDeals:(PPDeal *)deal
{

}
@end
