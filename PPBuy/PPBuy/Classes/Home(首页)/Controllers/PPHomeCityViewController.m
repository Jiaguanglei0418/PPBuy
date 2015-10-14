//
//  PPHomeCityViewController.m
//  PPBuy
//
//  Created by jiaguanglei on 15/10/10.
//  Copyright (c) 2015年 roseonly. All rights reserved.
//

#import "PPHomeCityViewController.h"
#import "UIBarButtonItem+Extension.h"
#import "PPCityGroup.h"
#import "PPCity.h"
#import "PPHomeCitySearchViewController.h"

#import "MJExtension.h"
#import "Masonry.h"

const int PPCoverTag = 999;

@interface PPHomeCityViewController ()<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

 /**  存放 数据 ***/
@property (nonatomic, strong) NSArray *cityDatas;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

 /**  遮盖View ***/
@property (nonatomic, weak) UIView *cover;

 /**  搜索框 ***/
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIButton *coverBtn;

- (IBAction)coverBtnClicked;

 /**  显示搜索结果 ***/
@property (nonatomic, weak) PPHomeCitySearchViewController *citySearchVc;
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

/**
 *  懒加载  -- weak
 */
- (PPHomeCitySearchViewController *)citySearchVc{
    if (!_citySearchVc) {
        PPHomeCitySearchViewController *citySearchVc = [[PPHomeCitySearchViewController alloc] init];
        // 很关键
        //[注意]: 如果View具有父子关系, 最好让其对应的控制器成为父子关系.
        [self addChildViewController:citySearchVc];
        
        self.citySearchVc = citySearchVc;

        [self.view addSubview:self.citySearchVc.view];
        // 添加约束
        [self.citySearchVc.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(self.searchBar.height, 0, 0, 0));
        }];
    }
    return _citySearchVc;
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
    PPCityGroup *group = self.cityDatas[section];
    return group.title;
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


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PPCityGroup *group = self.cityDatas[indexPath.section];
    
    // 发通知
    [PPNOTICEFICATION postNotificationName:PPHomeCitySearchVcCitySelectedNoticefication object:nil userInfo:@{PPHomeCitySearchVcSelectedCityName : group.cities[indexPath.row]}];
    
    // 移除 ---- 父子关系 nav -- cityVC
    [self dismissViewControllerAnimated:YES completion:nil];
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
//    UIView *cover = [[UIView alloc] init];
//    cover.backgroundColor = [UIColor blackColor];
//    cover.alpha = 0.5;
//    cover.tag = PPCoverTag;
//    [cover addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self.searchBar action:@selector(resignFirstResponder)]];
//    
//    [self.view addSubview:cover];
//    
//    [cover mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.tableView);
//    }];
    
    // 2.1 btn遮盖
    [UIView animateWithDuration:1.0 animations:^{
        self.coverBtn.alpha = 0.5;
        
    }];
    
    // 3. 添加取消
    searchBar.showsCancelButton = YES;
    
    // 3.1 设置光标和cancel的颜色
    searchBar.tintColor = PPCOLOR_RGB(32, 191, 179);
    
//    self.cover = cover;
    // 修改背景图片
    [searchBar setBackgroundImage:[UIImage imageNamed:@"bg_login_textfield_hl"] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
}

/**
 * 键盘返回: 搜索框结束编辑文字
 */
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    // 1. 显示导航栏
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    // 2. 移除遮盖
    [UIView animateWithDuration:1.0 animations:^{
        self.coverBtn.alpha = 0.0;
        
    }];
    
//    [[self.view viewWithTag:PPCoverTag] removeFromSuperview];
//    [self.cover removeFromSuperview];
    
    // 取消
    searchBar.showsCancelButton = NO;
    
    // 移除搜索结果
    self.citySearchVc.view.hidden = YES;
    searchBar.text = nil;
    
    // 3. 设置背景图片
    [searchBar setBackgroundImage:[UIImage imageNamed:@"bg_login_textfield"] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
}

/**
 *  监听遮盖点击
 */
- (IBAction)coverBtnClicked {
    // 2. 移除遮盖
    [self.searchBar resignFirstResponder];
    
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}


/**
 *  当搜索框文字发生改变的时候, 调用此方法
 *
 */
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchBar.text.length) {
        self.citySearchVc.view.hidden = NO;
        
        // 赋值
        self.citySearchVc.searchText = searchText;
        LogRed(@"%@",searchText);
    }else{
        self.citySearchVc.view.hidden = YES;
    }
}


@end
