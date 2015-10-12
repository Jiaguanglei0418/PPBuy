//
//  PPMetaTool.m
//  PPBuy
//
//  Created by jiaguanglei on 15/10/12.
//  Copyright (c) 2015年 roseonly. All rights reserved.
//

#import "PPMetaTool.h"
#import "PPCity.h"
#import "MJExtension.h"

@implementation PPMetaTool
static NSArray *_cities;

+ (NSArray *)cities
{
    if (!_cities) {
        _cities = [PPCity objectArrayWithFilename:@"cities.plist"];
    }
    return _cities;
}


@end
