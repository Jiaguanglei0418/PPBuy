//
//  PPDeal.h
//  PPBuy
//
//  Created by jiaguanglei on 15/10/14.
//  Copyright (c) 2015年 roseonly. All rights reserved.
//

// ---   一个团购模型

/**
 *  
 deal_id	string	团购单ID
 title	string	团购标题
 description	string	团购描述
 city	string	城市名称，city为＂全国＂表示全国单，其他为本地单，城市范围见相关API返回结果
 list_price	float	团购包含商品原价值
 current_price	float	团购价格
 regions	list	团购适用商户所在行政区
 categories	list	团购所属分类
 purchase_count	int	团购当前已购买数
 publish_date	string	团购发布上线日期
 purchase_deadline	string	团购单的截止购买日期
 distance	int	团购单所适用商户中距离参数坐标点最近的一家与坐标点的距离，单位为米；如不传入经纬度坐标，结果为-1；如团购单无关联商户，结果为MAXINT
 image_url	string	团购图片链接，最大图片尺寸450×280
 s_image_url	string	小尺寸团购图片链接，最大图片尺寸160×100
 deal_url	string	团购Web页面链接，适用于网页应用
 deal_h5_url	string	团购HTML5页面链接，适用于移动应用和联网车载应用
publish_date	string	团购发布上线日期
 */
#import <Foundation/Foundation.h>

@interface PPDeal : NSObject
/** 团购单ID */
@property (copy, nonatomic) NSString *deal_id;
/** 团购标题 */
@property (copy, nonatomic) NSString *title;
/** 团购描述 */
@property (copy, nonatomic) NSString *desc;

/** 如果想完整地保留服务器返回数字的小数位数(没有小数\1位小数\2位小数等),那么就应该用NSNumber , NSString */
/** 团购包含商品原价值 */
@property (strong, nonatomic) NSNumber *list_price;
/** 团购价格 */
@property (strong, nonatomic) NSNumber *current_price;
/** 团购当前已购买数 */
@property (assign, nonatomic) int purchase_count;

/** 团购图片链接，最大图片尺寸450×280 */
@property (copy, nonatomic) NSString *image_url;
/** 小尺寸团购图片链接，最大图片尺寸160×100 */
@property (copy, nonatomic) NSString *s_image_url;

 /**  发布日期 ***/
@property (nonatomic, copy) NSString *publish_date;

@end
