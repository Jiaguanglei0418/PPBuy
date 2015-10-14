//
//  PPCity.h
//  PPBuy
//
//  Created by jiaguanglei on 15/10/10.
//  Copyright (c) 2015年 roseonly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PPCity : NSObject

 /**  城市名称 ***/
@property (nonatomic, copy) NSString *name;
 /**  城市的拼音 ***/
@property (nonatomic, copy) NSString *pinYin;
 /**  城市的声母 ***/
@property (nonatomic, copy) NSString *pinYinHead;

 /**  城市 包含的区 (数组里面存放的都是 PPRegion模型 )***/
@property (nonatomic, strong) NSArray *regions;



@end
