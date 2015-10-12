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
#import "PPHomeDistrictViewController.h"

@interface PPHomeViewController ()
// 分类item
@property (nonatomic, weak) UIBarButtonItem *categoryItem;

// 区域item
@property (nonatomic, weak) UIBarButtonItem *districtItem;

// 排序item
@property (nonatomic, weak) UIBarButtonItem *sortItem;


@end

@implementation PPHomeViewController

static NSString * const reuseIdentifier = @"Cell";

/**
 *  将初始化, 封装在内部. (collectionViewController 需要制定layout布局)
 *
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
    
    // 设置导航栏内容
    [self setupLeftNav];
    
    [self setupRightNav];
    
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
    // 添加监听点击
    [category addTarget:self action:@selector(categoryItemClicked)];

    UIBarButtonItem *categoryItem = [[UIBarButtonItem alloc] initWithCustomView:category];
    self.categoryItem = categoryItem;
    
    // 3. 地区
    PPHomeTopItem *district = [PPHomeTopItem item];
    // 添加监听点击
    [district addTarget:self action:@selector(districtItemClicked)];
    
    UIBarButtonItem *districtItem = [[UIBarButtonItem alloc] initWithCustomView:district];
    self.districtItem = districtItem;
    
    // 4. 排序
    PPHomeTopItem *sort = [PPHomeTopItem item];
    // 添加监听点击
    [sort addTarget:self action:@selector(sortItemClicked)];
    
    UIBarButtonItem *sortItem = [[UIBarButtonItem alloc] initWithCustomView:sort];
    self.sortItem = sortItem;
    
    
    self.navigationItem.leftBarButtonItems = @[logoItem, categoryItem, districtItem, sortItem];
}


#pragma mark - 顶部item点击方法
// 分类
- (void)categoryItemClicked
{
    // 显示分类菜单
    UIPopoverController *popoverVc = [[UIPopoverController alloc] initWithContentViewController:[[PPHomeCategoryController alloc] init]];
    
    [popoverVc presentPopoverFromBarButtonItem:self.categoryItem permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}


// 地区
- (void)districtItemClicked
{
    LogPurple(@"%s",__func__);
    // 显示地区菜单
    UIPopoverController *popoverVc = [[UIPopoverController alloc] initWithContentViewController:[[PPHomeDistrictViewController alloc] init]];
    
    [popoverVc presentPopoverFromBarButtonItem:self.districtItem permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

// 排序
- (void)sortItemClicked
{
    LogPurple(@"%s",__func__);
    PPHomeCategoryController *sortVc = [[PPHomeCategoryController alloc] init];
    UIPopoverController *popoverVc = [[UIPopoverController alloc] initWithContentViewController:sortVc];
    
    [popoverVc presentPopoverFromBarButtonItem:self.sortItem permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
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
