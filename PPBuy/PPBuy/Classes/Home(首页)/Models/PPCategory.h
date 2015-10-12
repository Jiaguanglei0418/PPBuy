//
//  PPCategory.h
//  PPBuy
//
//  Created by jiaguanglei on 15/10/10.
//  Copyright (c) 2015年 roseonly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PPCategory : NSObject

 /**  类别的名称 ***/
@property (nonatomic, copy) NSString *name;

 /**  显示在导航栏上的大图标 ***/
@property (nonatomic, copy) NSString *highlighted_icon; // 选中图标
@property (nonatomic, copy) NSString *icon;

 /**  显示在下拉菜单中的小图标 ***/
@property (nonatomic, copy) NSString *small_icon;
@property (nonatomic, copy) NSString *small_highlighted_icon;

 /**  显示在地图上的图标 ***/
@property (nonatomic, copy) NSString *map_icon; // 地图图标

 /**  子菜单, 都是字符串 ***/
@property (nonatomic, strong) NSArray *subcategories;
@end
