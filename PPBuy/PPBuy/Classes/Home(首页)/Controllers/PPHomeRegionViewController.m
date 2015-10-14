//
//  PPHomeDistrictViewController.m
//  PPBuy
//
//  Created by jiaguanglei on 15/10/10.
//  Copyright (c) 2015年 roseonly. All rights reserved.
//

#import "PPHomeRegionViewController.h"

#import "PPHomeDropDown.h"
#import "PPHomeCityViewController.h"
#import "PPNavgationController.h"
#import "PPRegion.h"
#import "PPMetaTool.h"
#import "PPCity.h"

@interface PPHomeRegionViewController ()<PPHomeDropDownDataSource,PPHomeDropDownDelegate>

@property (weak, nonatomic) IBOutlet UIView *topTittle;

- (IBAction)changeCity;
@end

@implementation PPHomeRegionViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // 创建下拉菜单
    PPHomeDropDown *dropdown = [PPHomeDropDown dropdown];
    [self.view addSubview:dropdown];

    dropdown.y = self.topTittle.height;
    dropdown.dataSource = self;
    dropdown.delegate = self;
    
    // 设置控制器在POPover中
    self.preferredContentSize = CGSizeMake(dropdown.width, CGRectGetMaxY(dropdown.frame));
    
    
    
}


/**
 *  监听切换城市按钮点击
 */
- (IBAction)changeCity {
    // pop dismiss
    [self.popoverVc dismissPopoverAnimated:YES];
    
    PPNavgationController *navVc = [[PPNavgationController alloc] initWithRootViewController:[[PPHomeCityViewController alloc] init]];
    navVc.modalPresentationStyle = UIModalPresentationFormSheet;
    
// 弹出控制器 --- 不能用self modal, self.presentedViewController 对nav引用
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:navVc animated:YES completion:^{
    }];
    
}


#pragma mark - PPHomeDropDownDataSource
- (NSInteger)numberOfRowsInMainTableView:(PPHomeDropDown *)homeDropdown
{
    return self.regions.count;
//    LogPurple(@"%ld",self.regions.count);
}

- (NSString *)homeDropdown:(PPHomeDropDown *)homeDropdown titleForRowInMainTableView:(NSInteger)row
{
    PPRegion *region = self.regions[row];
//    LogPurple(@"%@",region.name);
    return region.name;
}

- (NSArray *)homeDropdown:(PPHomeDropDown *)homeDropdown subDataForRowInMainTableView:(NSInteger)row
{
    PPRegion *region = self.regions[row];
//    LogPurple(@"%ld",region.subregions.count);
    return region.subregions;
}


#pragma mark - PPHomeDropDownDelegate
- (void)homeDropdown:(PPHomeDropDown *)homeDropdown didSelectedRowInMainTableView:(NSInteger)row
{
    PPRegion *region = self.regions[row];
    
//    LogYellow(@"%@",category.name);
    
    // 发通知
    if(!region.subregions.count){
        [PPNOTICEFICATION postNotificationName:PPHomeRegionVcRegionSelectedNoticefication object:nil userInfo:@{PPHomeRegionSelectedRegion : region}];
    }
}

- (void)homeDropdown:(PPHomeDropDown *)homeDropdown didSelectedRowInSubTableView:(NSInteger)subrow inMainTable:(NSInteger)mainrow
{
    // 取出主表模型
    PPRegion *region = self.regions[mainrow];
//    LogMagenta(@"%@",category.subcategories[subrow]);
    
    // 发通知
    [PPNOTICEFICATION postNotificationName:PPHomeRegionVcRegionSelectedNoticefication object:nil userInfo:@{PPHomeRegionSelectedRegion : region, PPHomeRegionSelectedSubRegionName : region.subregions[subrow]}];
    
}


- (void)dealloc
{
    [PPNOTICEFICATION removeObserver:self];
}

@end
