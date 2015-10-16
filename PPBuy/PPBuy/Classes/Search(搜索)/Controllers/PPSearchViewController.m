//
//  PPSearchViewController.m
//  PPBuy
//
//  Created by jiaguanglei on 15/10/15.
//  Copyright (c) 2015年 roseonly. All rights reserved.
//

#import "PPSearchViewController.h"
#import "UIBarButtonItem+Extension.h"

#import "MJRefresh.h"

@interface PPSearchViewController ()<UISearchBarDelegate>

@end

@implementation PPSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置导航栏
    [self setupNav];
    
    
}


/**
 *  设置右边导航栏内容
 */
- (void)setupNav
{
    // 1. 左边的返回按钮
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(back) image:@"icon_back" highImage:@"icon_back_highlighted"];
    
    // 2. 中间搜索框
    // [注意]: 当把searchBar直接 成为titleView的时候, 默认填充整个title宽度, 设置无效
    // 中间层
//    UIView *titleView = [[UIView alloc] init];
//    titleView.size = CGSizeMake(400, 40);
//    self.navigationItem.titleView = titleView;

    UISearchBar *searchBar = [[UISearchBar alloc] init];
    searchBar.backgroundImage = [UIImage imageNamed:@"bg_login_textfield"];
    searchBar.placeholder = @"请输入关键词";
    searchBar.delegate = self;
//    searchBar.frame = titleView.bounds;
//    [titleView addSubview:searchBar];
    self.navigationItem.titleView = searchBar;
}


/**
 *  监听返回按钮点击
 */
- (void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    // 向服务器, 发送请求
    [self.collectionView.header beginRefreshing];
    
    // 键盘弹回
//    [searchBar endEditing:YES];
    [searchBar resignFirstResponder];
    
    //
}


#pragma mark - 实现父类方法
- (void)setupParams:(NSMutableDictionary *)params
{
    params[@"city"] = @"北京";
    UISearchBar *searchBar = (UISearchBar *)self.navigationItem.titleView;
    params[@"keyword"] = searchBar.text;
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
