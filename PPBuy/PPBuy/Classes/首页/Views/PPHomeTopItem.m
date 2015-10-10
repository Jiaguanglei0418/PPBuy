//
//  PPHomeTopItem.m
//  PPBuy
//
//  Created by jiaguanglei on 15/10/10.
//  Copyright (c) 2015年 roseonly. All rights reserved.
//

#import "PPHomeTopItem.h"

@implementation PPHomeTopItem

+ (instancetype)item
{
    return [[[NSBundle mainBundle] loadNibNamed:@"PPHomeTopItem" owner:nil options:nil] lastObject];
}

@end
