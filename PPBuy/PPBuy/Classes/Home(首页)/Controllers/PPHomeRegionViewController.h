//
//  PPHomeDistrictViewController.h
//  PPBuy
//
//  Created by jiaguanglei on 15/10/10.
//  Copyright (c) 2015年 roseonly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PPHomeRegionViewController : UIViewController

 /**  城市 对应的区域 ***/
@property (nonatomic, strong) NSArray *regions;

 /**  必须用弱指针 ***/
@property (nonatomic, weak) UIPopoverController *popoverVc;
@end

// elispse
