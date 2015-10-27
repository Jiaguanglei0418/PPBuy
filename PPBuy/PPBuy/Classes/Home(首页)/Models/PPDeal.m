//
//  PPDeal.m
//  PPBuy
//
//  Created by jiaguanglei on 15/10/14.
//  Copyright (c) 2015年 roseonly. All rights reserved.
//

#import "PPDeal.h"
#import "MJExtension.h"

#import "PPBusiness.h"
@implementation PPDeal
/**
 *  数组中包含模型
 */
+ (NSDictionary *)objectClassInArray
{
    return @{@"businesses" : [PPBusiness class]};
}

/**
 *  写出 模型中的属性名 和 字典中的key不相同
 */
+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"desc" : @"description"};
}

#warning 跨类删除模型
/**
 *  通过详情中 取消收藏 来删除数组中的模型, 需要设置此步骤
 */
- (BOOL)isEqual:(PPDeal *)deal
{
    return [self.deal_id isEqual:deal.deal_id];
}



MJCodingImplementation
@end
