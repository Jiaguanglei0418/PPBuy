//
//  PPDealAnnotation.m
//  PPBuy
//
//  Created by jiaguanglei on 15/10/26.
//  Copyright (c) 2015年 roseonly. All rights reserved.
//

#import "PPDealAnnotation.h"

@implementation PPDealAnnotation
- (BOOL)isEqual:(PPDealAnnotation *)other
{
    return [self.title isEqual:other.title];
}
@end
