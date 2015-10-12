//
//  PPCity.m
//  PPBuy
//
//  Created by jiaguanglei on 15/10/10.
//  Copyright (c) 2015年 roseonly. All rights reserved.
//

#import "PPCity.h"
#import "MJExtension.h"
#import "PPRegion.h"

@implementation PPCity


+ (NSDictionary *)objectClassInArray
{
    return @{@"regions" : [PPRegion class]};
}


@end
