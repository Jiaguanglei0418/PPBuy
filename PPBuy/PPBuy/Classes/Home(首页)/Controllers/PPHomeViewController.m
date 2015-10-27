//
//  PPHomeViewController.m
//  PPBuy
//
//  Created by jiaguanglei on 15/10/9.
//  Copyright (c) 2015年 roseonly. All rights reserved.
//

#import "PPHomeViewController.h"
#import "UIBarButtonItem+Extension.h"
#import "PPHomeTopItem.h"

#import "PPHomeCategoryController.h"
#import "PPHomeRegionViewController.h"
#import "PPHomeSortViewController.h"

#import "PPMetaTool.h"
#import "PPCity.h"
#import "PPSort.h"
#import "PPCategory.h"
#import "PPRegion.h"
#import "MBProgressHUD+MJ.h"

#import "MJRefresh.h"
#import "AwesomeMenu.h"
#import "Masonry.h"

#import "PPSearchViewController.h"// 搜索
#import "PPNavgationController.h"

#import "PPCollectViewController.h"// 收藏
#import "PPRecentViewController.h" // 记录

#import "PPMapViewController.h"// map

@interface PPHomeViewController ()<AwesomeMenuDelegate>
// 分类item
@property (nonatomic, weak) UIBarButtonItem *categoryItem;
// 区域item
@property (nonatomic, weak) UIBarButtonItem *regionItem;
// 排序item
@property (nonatomic, weak) UIBarButtonItem *sortItem;

// 当前选中城市名称
//@property (nonatomic, copy) NSString *selectedCityName;
// 当前选中区域名称
@property (nonatomic, copy) NSString *selectedRegionName;
// 当前选中分类名称
@property (nonatomic, copy) NSString *selectedCategoryName;
// 当前选中分类名称
@property (nonatomic, assign) int selectedSortName;

 /**  popoverVc ***/
@property (nonatomic, strong) UIPopoverController *sortPopVc;
@property (nonatomic, strong) UIPopoverController *categoryPopVc;
@property (nonatomic, strong) UIPopoverController *regionPopVc;

 /**  PPTopItem ***/
//@property (nonatomic, strong) PPHomeTopItem *sort;
//@property (nonatomic, strong) PPHomeTopItem *category;
//@property (nonatomic, strong) PPHomeTopItem *region;


@end

@implementation PPHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置背景及导航菜单
    [self setupNoticefication];
    
    // 设置导航栏内容
    [self setupLeftNav];
    
    [self setupRightNav];
    
    // 创建awesomemenu
    [self setupAwesomeMenu];
}


/**
 *  设置 AwesomeMenu
 */
- (void)setupAwesomeMenu
{
    // 创建
    AwesomeMenuItem *starItem = [[AwesomeMenuItem alloc] initWithImage:[UIImage imageNamed:@"icon_pathMenu_background_highlighted"] highlightedImage:nil ContentImage:[UIImage imageNamed:@"icon_pathMenu_mainMine_normal"] highlightedContentImage:[UIImage imageNamed:@"icon_pathMenu_mainMine_highlighted"]];
    
    AwesomeMenuItem *item0 = [[AwesomeMenuItem alloc] initWithImage:[UIImage imageNamed:@"bg_pathMenu_black_normal"] highlightedImage:nil ContentImage:[UIImage imageNamed:@"icon_pathMenu_collect_normal"] highlightedContentImage:[UIImage imageNamed:@"icon_pathMenu_collect_highlighted"]];
    
    AwesomeMenuItem *item1 = [[AwesomeMenuItem alloc] initWithImage:[UIImage imageNamed:@"bg_pathMenu_black_normal"] highlightedImage:nil ContentImage:[UIImage imageNamed:@"icon_pathMenu_mine_normal"] highlightedContentImage:[UIImage imageNamed:@"icon_pathMenu_mine_highlighted"]];

    AwesomeMenuItem *item2 = [[AwesomeMenuItem alloc] initWithImage:[UIImage imageNamed:@"bg_pathMenu_black_normal"] highlightedImage:nil ContentImage:[UIImage imageNamed:@"icon_pathMenu_more_normal"] highlightedContentImage:[UIImage imageNamed:@"icon_pathMenu_more_highlighted"]];
    
    AwesomeMenuItem *item3 = [[AwesomeMenuItem alloc] initWithImage:[UIImage imageNamed:@"bg_pathMenu_black_normal"] highlightedImage:nil ContentImage:[UIImage imageNamed:@"icon_pathMenu_scan_normal"] highlightedContentImage:[UIImage imageNamed:@"icon_pathMenu_scan_highlighted"]];
    
    AwesomeMenu *menu = [[AwesomeMenu alloc] initWithFrame:CGRectZero startItem:starItem menuItems:@[item1, item0, item3, item2]];
    
    [self.view addSubview:menu];
    WS(weakSelf);
    [menu mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view).with.offset(50);
        make.bottom.equalTo(weakSelf.view).with.offset(-50);
        make.size.mas_equalTo(CGSizeMake(200, 200));
    }];
    
    // 半透明
    menu.alpha = 0.5;
    
    // 不要旋转按钮
    menu.rotateAddButton = NO;
    
    // 设置菜单的活动范围
    menu.menuWholeAngle = M_PI_2;
    
    // 设置起始点
    menu.startPoint = CGPointMake(0, 200);
    
    // 设置代理
    menu.delegate = self;
}

#pragma mark - AwesomeMenuDelegate
// 监听菜单展开
- (void)awesomeMenuDidFinishAnimationOpen:(AwesomeMenu *)menu
{

    [UIView animateWithDuration:0.1 animations:^{
        menu.alpha = 1.0;
    }];
    
    // 替换菜单内容
    menu.contentImage = [UIImage imageNamed:@"icon_pathMenu_cross_normal"];
    
}

// 监听菜单关闭
- (void)awesomeMenuDidFinishAnimationClose:(AwesomeMenu *)menu
{
    // 替换菜单内容
    menu.contentImage = [UIImage imageNamed:@"icon_pathMenu_mainMine_normal"];
    [UIView animateWithDuration:1.0 animations:^{
        menu.alpha = 0.5;
    }];
    
}

// 监听item点击
- (void)awesomeMenu:(AwesomeMenu *)menu didSelectIndex:(NSInteger)idx
{
    // 替换菜单内容
    menu.contentImage = [UIImage imageNamed:@"icon_pathMenu_mainMine_normal"];
    
    // 选中item
    AwesomeMenuItem *item = menu.menuItems[idx];
    
    // 监听idx
    switch (idx) {
        case 0: // 我的
            LogGreen(@"我的---------");
            break;
        case 1: // 收藏
            
            [self collectItemDidSelected:item];
            break;
        case 2: // 浏览记录
            
            [self recordItemDidSelected:item];
            break;
        case 3: // 更多
            
            [self moreItemDidSelected:item];
            break;

        default:
            break;
    }
    
    // 设置透明
    [UIView animateWithDuration:1.0 animations:^{
        menu.alpha = 0.5;
    }];
}

#pragma mark - MenuItem点击方法
// 收藏
- (void)collectItemDidSelected:(AwesomeMenuItem *)item
{
    PPCollectViewController *collectVc = [[PPCollectViewController alloc] init];
    
    [self presentViewController:[[PPNavgationController alloc] initWithRootViewController:collectVc] animated:YES completion:nil];
}

// 访问记录
- (void)recordItemDidSelected:(AwesomeMenuItem *)item
{
    PPRecentViewController *recordVc = [[PPRecentViewController alloc] init];
    
    [self presentViewController:[[PPNavgationController alloc] initWithRootViewController:recordVc] animated:YES completion:nil];
}

// 更多
- (void)moreItemDidSelected:(AwesomeMenuItem *)item
{
    LogRed(@" 更多 -- ");
}

/**
 *  设置导航下拉菜单
 */
- (void)setupNoticefication
{
    // 注册通知, 监听切换城市
    [PPNOTICEFICATION addObserver:self selector:@selector(changeCity:) name:PPHomeCitySearchVcCitySelectedNoticefication object:nil];
    // 监听排序
    [PPNOTICEFICATION addObserver:self selector:@selector(changeSort:) name:PPHomeSortVcNoticefication object:nil];
    // 监听分类改变
    [PPNOTICEFICATION addObserver:self selector:@selector(changeCategory:) name:PPHomeCategoryVcCategorySelectedNoticefication object:nil];
    // 监听地区改变
    [PPNOTICEFICATION addObserver:self selector:@selector(changeRegion:) name:PPHomeRegionVcRegionSelectedNoticefication object:nil];
}


#pragma mark - 监听通知
/**
 *  监听通知 - 改变区域
 */
- (void)changeRegion:(NSNotification *)noticefication
{
    PPRegion *region = noticefication.userInfo[PPHomeRegionSelectedRegion];
    NSString *subRegionname = noticefication.userInfo[PPHomeRegionSelectedSubRegionName];
    
    // 设置选中区域
    if (subRegionname == nil || [subRegionname isEqualToString:@"全部"]) {
        self.selectedRegionName = region.name;
    }else{
        self.selectedRegionName = subRegionname;
    }
    
    if ([self.selectedRegionName isEqualToString:@"全部"]) {
        self.selectedRegionName = nil;
    }
    
    // 1. 显示标题名称
    PPHomeTopItem *topItem = (PPHomeTopItem *)self.regionItem.customView;
    
    [topItem setTitle:region.name];
    [topItem setSubTitle:subRegionname ? subRegionname : @"全部"];
    
    // 2. 关闭popover
    [self.regionPopVc dismissPopoverAnimated:YES];
    
    // 3. 刷新表格
    [self.collectionView.header beginRefreshing];
}


/**
 *  监听通知 - 改变分类
 */
- (void)changeCategory:(NSNotification *)noticefication
{
    PPCategory *category = noticefication.userInfo[PPHomeCategorySelectedCategory];
    NSString *subCategoryname = noticefication.userInfo[PPHomeCategorySelectedSubCategoryName];
    
    // 设置选中分类 -- 发送到服务器
    if(subCategoryname == nil || [subCategoryname isEqualToString:@"全部"]){ // 点击数据没有子类
        self.selectedCategoryName = category.name;
    }else{
        self.selectedCategoryName = subCategoryname;
    }
    
    // 分类为 - 全部分类
    if ([self.selectedCategoryName isEqualToString:@"全部分类"]) {
        self.selectedCategoryName = nil;
    }
    
    // 1. 显示标题名称
    PPHomeTopItem *topItem = (PPHomeTopItem *)self.categoryItem.customView;
    [topItem setIcon:category.icon highIcon:category.highlighted_icon];
    [topItem setTitle:category.name];
    [topItem setSubTitle:subCategoryname ? subCategoryname : @"全部"];
    
    // 2. 关闭popover
    [self.categoryPopVc dismissPopoverAnimated:YES];
    
    // 3. 刷新表格
//    [self loadNewDeals];
    [self.collectionView.header beginRefreshing];
}

/**
 *  监听通知 - 改变城市
 */
- (void)changeCity:(NSNotification *)noticefication
{
    self.selectedCityName = noticefication.userInfo[PPHomeCitySearchVcSelectedCityName];
    
    // 1. 该表标题名称
    PPHomeTopItem *topItem = (PPHomeTopItem *)self.regionItem.customView;
    [topItem setTitle:[NSString stringWithFormat:@"%@ - 全部", self.selectedCityName]];
    [topItem setSubTitle:nil];
    
    // 2. 刷新表格数据
//    [self loadNewDeals];
    [self.collectionView.header beginRefreshing];
}

/**
 *  监听排序
 */
- (void)changeSort:(NSNotification *)noticefication
{
//    LogRed(@"%s",__func__);
    // 1. 显示排序菜单
    PPSort *sort = noticefication.userInfo[PPHomeSortSelectedSort];
    PPHomeTopItem *topItem = (PPHomeTopItem *)self.sortItem.customView;
    topItem.subTitle = sort.label;
    
    self.selectedSortName = sort.value;
    
    // 2. 移除popVc
    [self.sortPopVc dismissPopoverAnimated:YES];
    
    // 3. 刷新数据
//    [self loadNewDeals];
    [self.collectionView.header beginRefreshing];
    
}


#pragma mark - 顶部item点击方法
// 分类
- (void)categoryItemClicked
{
    // 显示分类菜单
    self.categoryPopVc = [[UIPopoverController alloc] initWithContentViewController:[[PPHomeCategoryController alloc] init]];
    
    [self.categoryPopVc presentPopoverFromBarButtonItem:self.categoryItem permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];

}


// 地区
- (void)districtItemClicked
{
    // 设置显示区域
    PPHomeRegionViewController *regionVc = [[PPHomeRegionViewController alloc] init];

    if (self.selectedCityName) {
        // 获取当前选中城市
        PPCity *city = [[[PPMetaTool cities] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"name = %@",self.selectedCityName]] firstObject];
        
        regionVc.regions = city.regions;
        
    }
    
    // 显示地区菜单
    self.regionPopVc = [[UIPopoverController alloc] initWithContentViewController:regionVc];
    
    [self.regionPopVc presentPopoverFromBarButtonItem:self.regionItem permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    
    // 传值
    regionVc.popoverVc = self.regionPopVc;
}

// 排序
- (void)sortItemClicked
{
    PPHomeSortViewController *sortVc = [[PPHomeSortViewController alloc] init];
    self.sortPopVc = [[UIPopoverController alloc] initWithContentViewController:sortVc];
    
    [self.sortPopVc presentPopoverFromBarButtonItem:self.sortItem permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}


/**
 *  设置导航栏内容
 */
- (void)setupLeftNav
{
    // 1. logo
    UIBarButtonItem *logoItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_meituan_logo"] style:UIBarButtonItemStyleDone target:nil action:nil];
    logoItem.enabled = NO;
    
    // 2. 类别
    PPHomeTopItem *category = [PPHomeTopItem item];
    [category setIcon:@"icon_category_0" highIcon:@"icon_category_highlighted_0"];
    [category setTitle:@"分类"];
    [category setSubTitle:@""];
    
    // 添加监听点击
    [category addTarget:self action:@selector(categoryItemClicked)];
    
    UIBarButtonItem *categoryItem = [[UIBarButtonItem alloc] initWithCustomView:category];
    self.categoryItem = categoryItem;
    
    // 3. 地区
    PPHomeTopItem *region = [PPHomeTopItem item];
    [region setIcon:@"icon_district" highIcon:@"icon_district_highlighted"];
    [region setTitle:@"地区"];
    [region setSubTitle:@""];
    // 添加监听点击
    [region addTarget:self action:@selector(districtItemClicked)];
    
    UIBarButtonItem *regionItem = [[UIBarButtonItem alloc] initWithCustomView:region];
    
    self.regionItem = regionItem;
    
    // 4. 排序
    PPHomeTopItem *sort = [PPHomeTopItem item];
    [sort setIcon:@"icon_sort" highIcon:@"icon_sort_highlighted"];
    [sort setTitle:@"排序"];
    [sort setSubTitle:@""];
    // 添加监听点击
    [sort addTarget:self action:@selector(sortItemClicked)];
    
    UIBarButtonItem *sortItem = [[UIBarButtonItem alloc] initWithCustomView:sort];
    self.sortItem = sortItem;
    
    
    self.navigationItem.leftBarButtonItems = @[logoItem, categoryItem, regionItem, sortItem];
}


/**
 *  设置右边导航栏内容
 */
- (void)setupRightNav
{
    UIBarButtonItem *mapItem = [UIBarButtonItem itemWithTarget:self action:@selector(mapMethod:) image:@"icon_map" highImage:@"icon_map_highlighted"];
    UIBarButtonItem *searchItem = [UIBarButtonItem itemWithTarget:self action:@selector(searchMethod:) image:@"icon_search" highImage:@"icon_search_highlighted"];
    UIBarButtonItem *gapItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    gapItem.width = 50;
    
    self.navigationItem.rightBarButtonItems = @[mapItem, gapItem, searchItem];
}

/**
 *  监听地图item点击
 */
- (void)mapMethod:(UIBarButtonItem *)item
{
    // 跳转到地图
    PPMapViewController *mapVc = [[PPMapViewController alloc] init];
    
    [self presentViewController:[[PPNavgationController alloc] initWithRootViewController:mapVc] animated:YES completion:nil];
}


/**
 *  监听搜索item -  点击
 */
- (void)searchMethod:(UIBarButtonItem *)item
{
    //
    if(self.selectedCityName){
        PPSearchViewController *searchVc = [[PPSearchViewController alloc] init];
        
        searchVc.title = self.selectedCityName;
        
        [self presentViewController:[[PPNavgationController alloc] initWithRootViewController:searchVc] animated:YES completion:^{
        }];
    }else{
        [MBProgressHUD showError:@"请选择城市" toView:self.collectionView];
    }
}



#pragma mark - 实现父类方法
- (void)setupParams:(NSMutableDictionary *)params
{
    // 城市
    params[@"city"] = self.selectedCityName;
    // 区域
    if (self.selectedRegionName) {
        params[@"region"] = self.selectedRegionName;
    }
    // 分类
    if(self.selectedCategoryName){
        params[@"category"] = self.selectedCategoryName;
    }
    // 排序
    if (self.selectedSortName) {
        params[@"sort"] = @(self.selectedSortName);
    }
}


- (void)dealloc{
    [PPNOTICEFICATION removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
