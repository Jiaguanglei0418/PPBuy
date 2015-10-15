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

#import "DPAPI.h" // 大众点评
#import "PPDeal.h"
#import "MJExtension.h"
#import "PPHomeDealCell.h"
#import "MJRefresh.h"
#import "MBProgressHUD+MJ.h"
#import "Masonry.h"

#import "PPSearchViewController.h"// 搜索
#import "PPNavgationController.h"

@interface PPHomeViewController ()<DPRequestDelegate>
// 分类item
@property (nonatomic, weak) UIBarButtonItem *categoryItem;

// 区域item
@property (nonatomic, weak) UIBarButtonItem *regionItem;

// 排序item
@property (nonatomic, weak) UIBarButtonItem *sortItem;

// 当前选中城市名称
@property (nonatomic, copy) NSString *selectedCityName;
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

@property (nonatomic, strong) NSMutableArray *deals;
 /**  记录当前页码 ***/
@property (nonatomic, assign) int currentPage;
 /**  团购总数  -- 用于判断是否隐藏上拉刷新 ***/
@property (nonatomic, assign) NSInteger totalCount;
 /**  保存最后一个请求 ***/
@property (nonatomic, weak) DPRequest *lastRequest;
 /**  没有数据, 提醒ImageView ***/
@property (nonatomic, weak) UIImageView *noDealsImageView;
@end

@implementation PPHomeViewController

static NSString * const reuseIdentifier = @"deal";

/**
 *  将初始化, 封装在内部. (collectionViewController 需要制定layout布局
 */
- (instancetype)init
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(305, 305);
   
    CGFloat margin = 20;
    layout.sectionInset = UIEdgeInsetsMake(margin, margin, margin, margin);
    
    return [self initWithCollectionViewLayout:layout];
}

/**
 *  懒加载
 */
- (NSMutableArray *)deals{
    if (!_deals) {
        _deals = [[NSMutableArray alloc] init];
    }
    return _deals;
}

/**
 *  懒加载  -  没有数据提示
 */
- (UIImageView *)noDealsImageView{
    if (!_noDealsImageView) {
        // 添加一个imageView 提示没有符合条件
        UIImageView *noDealImageView = [[UIImageView alloc] init];
        noDealImageView.image = [UIImage imageNamed:@"icon_deals_empty"];
        [self.collectionView addSubview:noDealImageView];
        
        WS(weakSelf);
        [noDealImageView mas_makeConstraints:^(MASConstraintMaker *make){
            make.center.equalTo(weakSelf.collectionView);
        }];
        
        self.noDealsImageView = noDealImageView;
    }
    return _noDealsImageView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置背景及导航菜单
    [self setupBG];

    // 注册cell
    [self.collectionView registerNib:[UINib nibWithNibName:@"PPHomeDealCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    // 上拉刷新
    self.collectionView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreDeals)];
    // 下拉刷新
    self.collectionView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadNewDeals];
    }];
}


/**
 *  当屏幕旋转, 控制器View发生改变, 调用
 *
 *  @param size        屏幕尺寸
 *  @param coordinator 协议
 */
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
//    LogYellow(@"%@", NSStringFromCGSize(size));
    
    // 横屏显示3列, 竖屏显示2列 - 根据屏幕宽度决定列数
    int colums = size.width == 1024 ? 3 : 2;

    // 根据列数 决定边距
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionViewLayout;
    CGFloat inset = (size.width - colums * layout.itemSize.width) / (colums + 1);
    layout.sectionInset = UIEdgeInsetsMake(inset, inset, inset, inset);
    layout.minimumLineSpacing = inset;

}


/**
 *  设置导航下拉菜单
 */
- (void)setupBG
{
    //    self.collectionView != self.view
    // 设置背景颜色
    self.collectionView.backgroundColor = PPCOLOR_BG;
    
    // 当collectionView不能拖动的时候, 需要设置此数此属性
    self.collectionView.alwaysBounceVertical = YES;
    
    // Register cell classes
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // 注册通知, 监听切换城市
    [PPNOTICEFICATION addObserver:self selector:@selector(changeCity:) name:PPHomeCitySearchVcCitySelectedNoticefication object:nil];
    // 监听排序
    [PPNOTICEFICATION addObserver:self selector:@selector(changeSort:) name:PPHomeSortVcNoticefication object:nil];
    // 监听分类改变
    [PPNOTICEFICATION addObserver:self selector:@selector(changeCategory:) name:PPHomeCategoryVcCategorySelectedNoticefication object:nil];
    // 监听地区改变
    [PPNOTICEFICATION addObserver:self selector:@selector(changeRegion:) name:PPHomeRegionVcRegionSelectedNoticefication object:nil];
    
    // 设置导航栏内容
    [self setupLeftNav];
    
    [self setupRightNav];
    
    
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
    [self loadNewDeals];
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

#pragma mark - 跟服务器交互
/**
 *  加载更多数据
 */
- (void)loadMoreDeals
{
    self.currentPage++;

    // 加载数据
    [self loadDeals];
}

/**
 *  加载新的数据
 */
- (void)loadNewDeals
{
    self.currentPage = 1;
    
    // 加载数据
    [self loadDeals];
}

- (void)loadDeals
{
    DPAPI *api = [[DPAPI alloc] init];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
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
    // 每页条数
    params[@"limit"] = @(6);
    // 页数
    params[@"page"] = @(self.currentPage);
    
    self.lastRequest = [api requestWithURL:@"v1/deal/find_deals" params:params delegate:self];
    LogRed(@"%@", params);
}


#pragma mark - DPRequestDelegate
- (void)request:(DPRequest *)request didFinishLoadingWithResult:(id)result
{
    LogYellow(@"请求成功 %@", result);
#warning 屏蔽同时有多个请求       *****
    /**
     (判断, 在本次请求数据中, 同时开始一个新的数据请求) - 网络数据请求, 不是lastRequest 直接返回!
     */
    if(request != self.lastRequest) return;
    //
    self.totalCount = [result[@"total_count"] integerValue];
    
    // 1. 取出团购数组
    NSArray *newDeals = [PPDeal objectArrayWithKeyValuesArray:result[@"deals"]];
    
    if (self.currentPage == 1) { // 如果page == 1, 加载最新数据, 需要清空旧的数据
       [self.deals removeAllObjects];
    }
    
    [self.deals addObjectsFromArray:newDeals];
    
    // 2. 刷新表格
//    LogGreen(@"%@",self.deals);
    [self.collectionView reloadData];
    
    // 3. 结束 上拉刷新
    [self.collectionView.footer endRefreshing];
    [self.collectionView.header endRefreshing];
    
    // 4. 控制尾部刷新控件的显示与隐藏
//    self.totalCount = [result[@"total_count"] integerValue];
    self.collectionView.footer.hidden = [result[@"total_count"] integerValue] == self.deals.count;

    // 5. 设置 没有数据提醒  --- 最好写在, 刷新表格的方法中
//    self.noDealsImageView.hidden = self.deals.count;
}

/**
 *  请求错误
 */
- (void)request:(DPRequest *)request didFailWithError:(NSError *)error
{
    if(request != self.lastRequest) return;
    
    if (error) {
        LogGreen(@"失败 %@", error);
    }
    // [注意] 在支持横竖屏时, 提醒框最好不要添加到window上.
    // 1. 提醒失败 --- 如果不设置View, 默认显示在window上
    [MBProgressHUD showError:@"网络繁忙, 请稍等" toView:self.collectionView];
    
    // 2. 停止刷新
    [self.collectionView.footer endRefreshing];
    [self.collectionView.header endRefreshing];
    
    // 3. 如果是上拉加载失败, 将当前的选中页码 减1
    if(self.currentPage > 1){
        self.currentPage--;
    }
}


/**
 *  设置导航栏内容
 */
- (void)setupLeftNav
{
    // 1. logo
    UIBarButtonItem *logoItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_meituan_logo"] style:UIBarButtonItemStylePlain target:nil action:nil];
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
 *  设置右边导航栏内容
 */
- (void)setupRightNav
{
    UIBarButtonItem *mapItem = [UIBarButtonItem itemWithTarget:self action:@selector(searchMethod:) image:@"icon_map" highImage:@"icon_map_highlighted"];
    UIBarButtonItem *searchItem = [UIBarButtonItem itemWithTarget:self action:@selector(itemMethod:) image:@"icon_search" highImage:@"icon_search_highlighted"];
    UIBarButtonItem *gapItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    gapItem.width = 50;
    
    self.navigationItem.rightBarButtonItems = @[mapItem, gapItem, searchItem];
}



/**
 *  监听搜索item -  点击
 */
- (void)searchMethod:(UIBarButtonItem *)item
{
    LogRed(@"%s",__func__);
    
    PPSearchViewController *searchVc = [[PPSearchViewController alloc] init];

    [self presentViewController:[[PPNavgationController alloc] initWithRootViewController:searchVc] animated:YES completion:^{
        
    }];
}



#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    // 1. 计算 内边距
    [self viewWillTransitionToSize:self.collectionView.size withTransitionCoordinator:nil];
    
    // 2. 控制显示  没有数据提示
    self.noDealsImageView.hidden = self.deals.count;
    
    // 3. 控制尾部刷新控件的显示与隐藏
//    self.collectionView.footer.hidden = self.totalCount == self.deals.count;
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.deals.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PPHomeDealCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // 赋值
    PPDeal *deal = self.deals[indexPath.row];
    cell.deal = deal;
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>



- (void)dealloc{
    [PPNOTICEFICATION removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
