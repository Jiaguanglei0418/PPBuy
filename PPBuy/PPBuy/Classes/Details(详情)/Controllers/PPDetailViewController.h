//
//  PPDetailViewController.h
//  PPBuy
//
//  Created by jiaguanglei on 15/10/16.
//  Copyright (c) 2015年 roseonly. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PPDeal;
@interface PPDetailViewController : UIViewController

@property (nonatomic, strong) PPDeal *deal;

 /**  选中参数 ***/
@property (nonatomic, strong) NSString *selectedCity;

@end
