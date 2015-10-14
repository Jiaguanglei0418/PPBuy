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

@interface PPHomeViewController ()
// 分类item
@property (nonatomic, weak) UIBarButtonItem *categoryItem;

// 区域item
@property (nonatomic, weak) UIBarButtonItem *regionItem;

// 排序item
@property (nonatomic, weak) UIBarButtonItem *sortItem;

// 当前选中城市名称
@property (nonatomic, copy) NSString *selectedCityName;

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

static NSString * const reuseIdentifier = @"Cell";

/**
 *  将初始化, 封装在内部. (collectionViewController 需要制定layout布局
 */
- (instancetype)init
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    return [self initWithCollectionViewLayout:layout];
}


- (void)viewDidLoad {
    [super viewDidLoad];

//    self.collectionView != self.view
    // 设置背景颜色
    self.collectionView.backgroundColor = PPCOLOR_BG;
    
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

- (void)dealloc
{
    [PPNOTICEFICATION removeObserver:self];
}

/**
 *  监听通知 - 改变区域
 */
- (void)changeRegion:(NSNotification *)noticefication
{
    PPRegion *region = noticefication.userInfo[PPHomeRegionSelectedRegion];
    NSString *subRegionname = noticefication.userInfo[PPHomeRegionSelectedSubRegionName];
    
    // 1. 显示标题名称
    PPHomeTopItem *topItem = (PPHomeTopItem *)self.regionItem.customView;
    
    [topItem setTitle:region.name];
    [topItem setSubTitle:subRegionname ? subRegionname : @"全部"];
    
    // 2. 关闭popover
    [self.regionPopVc dismissPopoverAnimated:YES];
    
    // 3. 刷新表格
#warning todo
    
    
}


/**
 *  监听通知 - 改变分类
 */
- (void)changeCategory:(NSNotification *)noticefication
{
    PPCategory *category = noticefication.userInfo[PPHomeCategorySelectedCategory];
    NSString *subCategoryname = noticefication.userInfo[PPHomeCategorySelectedSubCategoryName];
    
    // 1. 显示标题名称
    PPHomeTopItem *topItem = (PPHomeTopItem *)self.categoryItem.customView;
    [topItem setIcon:category.icon highIcon:category.highlighted_icon];
    [topItem setTitle:category.name];
    [topItem setSubTitle:subCategoryname ? subCategoryname : @"全部"];
    
    // 2. 关闭popover
    [self.categoryPopVc dismissPopoverAnimated:YES];
    
    // 3. 刷新表格
#warning todo
    
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
#warning todo
    
    
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
    
    // 2. 移除popVc
    [self.sortPopVc dismissPopoverAnimated:YES];
    
    // 3. 刷新数据
    
    
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
    UIBarButtonItem *mapItem = [UIBarButtonItem itemWithTarget:self action:@selector(itemMethod:) image:@"icon_map" highImage:@"icon_map_highlighted"];
    UIBarButtonItem *searchItem = [UIBarButtonItem itemWithTarget:self action:@selector(itemMethod:) image:@"icon_search" highImage:@"icon_search_highlighted"];
    UIBarButtonItem *gapItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    gapItem.width = 50;
    
    self.navigationItem.rightBarButtonItems = @[mapItem, gapItem, searchItem];
}


- (void)itemMethod:(UIBarButtonItem *)item
{
    LogRed(@"%s",__func__);
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
#warning Incomplete method implementation -- Return the number of sections
    return 0;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
#warning Incomplete method implementation -- Return the number of items in the section
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
