//
//  PPHomeCategoryController.h
//  PPBuy
//
//  Created by jiaguanglei on 15/10/10.
//  Copyright (c) 2015年 roseonly. All rights reserved.
//
//  ---  分类控制器, 显示分类列表

#import <UIKit/UIKit.h>
@class PPCategory;

typedef void (^PPCategoryBlock) (PPCategory * category);

@interface PPHomeCategoryController : UIViewController

 /**  block 给HomeVc 传值 ***/
@property (nonatomic, copy) PPCategoryBlock block;

@end
