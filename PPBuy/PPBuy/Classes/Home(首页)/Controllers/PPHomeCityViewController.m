//
//  PPHomeCityViewController.m
//  PPBuy
//
//  Created by jiaguanglei on 15/10/10.
//  Copyright (c) 2015年 roseonly. All rights reserved.
//

#import "PPHomeCityViewController.h"
#import "UIBarButtonItem+Extension.h"
#import "MJExtension.h"
#import "PPCityGroup.h"

@interface PPHomeCityViewController ()<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

 /**  存放 数据 ***/
@property (nonatomic, strong) NSArray *cityDatas;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

 /**  遮盖View ***/
@property (nonatomic, weak) UIView *cover;

@end

@implementation PPHomeCityViewController

/**
 *  懒加载
 */
- (NSArray *)cityDatas{
    if (!_cityDatas) {
        _cityDatas = [PPCityGroup objectArrayWithFilename:@"cityGroups.plist"];
    }
    return _cityDatas;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // 基本设置
    self.title = @"切换城市";
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(close) image:@"btn_navigation_close" highImage:@"btn_navigation_close_hl"];
    
    self.tableView.sectionIndexColor = [UIColor blackColor];
    
    // 加载城市数据
    
}


/**
 *  监听leftItem 点击
 */
- (void)close
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - 数据源方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.cityDatas.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    PPCityGroup *cityGroup = self.cityDatas[section];
    return cityGroup.cities.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"city";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    
    // 显示消息
    PPCityGroup *cityGroup = self.cityDatas[indexPath.section];
    
    cell.textLabel.text = cityGroup.cities[indexPath.row];
    
    return cell;
}


#pragma mark - 代理方法
/**
 *  返回组头
 */
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self.cityDatas[section] title];
}


- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
//    NSMutableArray *array = [NSMutableArray array];
//    
//    [self.cityDatas enumerateObjectsUsingBlock:^(PPCityGroup *cityGroup, NSUInteger idx, BOOL *stop) {
//        [array addObject:cityGroup.title];
//    }];
    
    // KVC  -- 将数组的每一个 "title" 属性, 放到数组中返回
    return [self.cityDatas valueForKeyPath:@"title"];
}


#pragma mark - searchBar 代理
/**
 * 键盘弹出: 搜索框开始编辑文字
 */
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    // 1. 隐藏导航栏
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    // 2. 添加遮盖
    UIView *cover = [[UIView alloc] init];
    cover.backgroundColor = [UIColor blackColor];
    cover.alpha = 0.5;
    cover.frame = self.tableView.bounds;
    [self.tableView addSubview:cover];

    self.cover = cover;
}

/**
 * 键盘返回: 搜索框结束编辑文字
 */
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    // 1. 显示导航栏
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    // 2. 移除遮盖
    [self.cover removeFromSuperview];
}
@end
