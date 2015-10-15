//
//  PPDeal.m
//  PPBuy
//
//  Created by jiaguanglei on 15/10/14.
//  Copyright (c) 2015年 roseonly. All rights reserved.
//

#import "PPDeal.h"
#import "MJExtension.h"
@implementation PPDeal

/**
 *  写出 模型中的属性名 和 字典中的key不相同
 */
+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"desc" : @"description"};
}


@end
