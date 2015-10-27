//
//  PPBusiness.h
//  PPBuy
//
//  Created by jiaguanglei on 15/10/26.
//  Copyright (c) 2015年 roseonly. All rights reserved.
//

/**
 *  归档实现
 */

#import <Foundation/Foundation.h>

@interface PPBusiness : NSObject
/** 店名 */
@property (nonatomic, copy) NSString *name;
/** 纬度 */
@property (nonatomic, assign) float latitude;
/** 经度 */
@property (nonatomic, assign) float longitude;
@end
