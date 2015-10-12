//
//  PPCityGroup.h
//  PPBuy
//
//  Created by jiaguanglei on 15/10/10.
//  Copyright (c) 2015年 roseonly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PPCityGroup : NSObject

/**  这组的 标题 ***/
@property (nonatomic, copy) NSString *title;


/**  这组的 城市数组 (内部装有 PPCity模型) ***/
@property (nonatomic, strong) NSArray *cities;

@end
