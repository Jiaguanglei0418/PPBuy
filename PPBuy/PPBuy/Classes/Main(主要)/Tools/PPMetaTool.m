//
//  PPMetaTool.m
//  PPBuy
//
//  Created by jiaguanglei on 15/10/12.
//  Copyright (c) 2015年 roseonly. All rights reserved.
//

#import "PPMetaTool.h"
#import "MJExtension.h"

#import "PPCity.h"
#import "PPCategory.h"
#import "PPSort.h"
#import "PPDeal.h"
@implementation PPMetaTool
static NSArray *_cities;

+ (NSArray *)cities
{
    if (!_cities) {
        _cities = [PPCity objectArrayWithFilename:@"cities.plist"];
    }
    return _cities;
}


static NSArray *_categoryDatas;
+ (NSArray *)categories
{
    if (!_categoryDatas) {
        _categoryDatas = [PPCategory objectArrayWithFilename:@"categories.plist" error:nil];
    }
    return _categoryDatas;
}

static NSArray *_sorts;
+ (NSArray *)sorts
{
    if (!_sorts) {
        _sorts = [PPSort objectArrayWithFilename:@"sorts.plist" error:nil];
    }
    return _sorts;
}

+ (PPCategory *)categoryWithDeal:(PPDeal *)deal
{
    NSArray *cs = [self categories];
    NSString *cname = [deal.categories firstObject];
    for (PPCategory *c in cs) {
        if ([cname isEqualToString:c.name]) return c;
        if ([c.subcategories containsObject:cname]) return c;
    }
    return nil;
}
@end
