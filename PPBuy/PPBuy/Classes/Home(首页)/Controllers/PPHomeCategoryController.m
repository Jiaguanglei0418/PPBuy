//
//  PPHomeCategoryController.m
//  PPBuy
//
//  Created by jiaguanglei on 15/10/10.
//  Copyright (c) 2015年 roseonly. All rights reserved.
//

#import "PPHomeCategoryController.h"
#import "PPHomeDropDown.h"
#import "UIView+Extension.h"

#import "PPCategory.h"
#import "MJExtension.h"
#import "Masonry.h"

@interface PPHomeCategoryController ()

@property (nonatomic, strong) NSArray *categoryDatas;

@property (nonatomic, weak) PPHomeDropDown *dropdown;

@end

@implementation PPHomeCategoryController


- (NSArray *)categoryDatas{
    if (!_categoryDatas) {
        self.categoryDatas = [PPCategory objectArrayWithFilename:@"categories.plist" error:nil];
    }
    return _categoryDatas;
}


- (void)loadView
{
    // 添加视图
    PPHomeDropDown *dropdown = [PPHomeDropDown dropdown];
    
    //#warning 当子控件消失, 不显示时注意, 去掉自动布局看看能不能显示
    //    // 设置不要跟着父控件的尺寸, 而伸缩
    //    dropdown.autoresizingMask = UIViewAutoresizingNone;
    
    // 加载数据
    dropdown.categories = self.categoryDatas;
    
    self.view = dropdown;
    
    // [注意]: 在iPad中, 控制器的View的尺寸默认为1024 * 768, PPHomeDropDownView的尺寸默认为 300 * 350
    // PPHomeCategoryController显示在popover中, 尺寸变为320 * 480, 子控件也跟着缩小0 * 0
    
    // 设置控制器View在popover中尺寸
    self.preferredContentSize = dropdown.size;

}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 添加视图
//    PPHomeDropDown *dropdown = [PPHomeDropDown dropdown];
//
////#warning 当子控件消失, 不显示时注意, 去掉自动布局看看能不能显示
////    // 设置不要跟着父控件的尺寸, 而伸缩
////    dropdown.autoresizingMask = UIViewAutoresizingNone;
//   
//    // 加载数据
//    dropdown.categories = self.categoryDatas;
//    
//    [self.view addSubview:dropdown];
//    
//// [注意]: 在iPad中, 控制器的View的尺寸默认为1024 * 768, PPHomeDropDownView的尺寸默认为 300 * 350
//// PPHomeCategoryController显示在popover中, 尺寸变为320 * 480, 子控件也跟着缩小0 * 0
//    
//    // 设置控制器View在popover中尺寸
//    self.preferredContentSize = dropdown.size;
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
