//
//  PPRegion.h
//  PPBuy
//
//  Created by jiaguanglei on 15/10/10.
//  Copyright (c) 2015年 roseonly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PPRegion : NSObject

 /**  区域 名称 ***/
@property (nonatomic, copy) NSString *name;


 /**  子区域 ***/
@property (nonatomic, strong) NSArray *subregions;
@end
