//
//  PPDetail.h
//  PPBuy
//
//  Created by jiaguanglei on 15/10/19.
//  Copyright (c) 2015年 roseonly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PPDetail : NSObject
 /**  是否需要预约 ***/
@property (nonatomic, assign) int is_reservation_required;

/**  是否支持随时退款  ***/
@property (nonatomic, assign) int is_refundable;

/**  附加信息 ***/
@property (nonatomic, copy) NSString *special_tips;


@end
