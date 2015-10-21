//
//  PPCollectViewController.m
//  PPBuy
//
//  Created by jiaguanglei on 15/10/16.
//  Copyright (c) 2015年 roseonly. All rights reserved.
//

#import "PPCollectViewController.h"
#import "UIBarButtonItem+Extension.h"

#import "PPHomeDealCell.h"
#import "PPDealTool.h"
#import "PPDeal.h"

#import "Masonry.h"
#import "PPDetailViewController.h"

#import "MJRefresh.h"

NSString *const PPDone = @"完成";
NSString *const PPEdit = @"编辑";
#define PPString(str) [NSString stringWithFormat:@"    %@   ",str]

@interface PPCollectViewController ()<PPHomeDealCellDelegate>
/**  没有数据, 提醒ImageView ***/
@property (nonatomic, weak) UIImageView *noDealsImageView;

/**  所有团购数据 ***/
@property (nonatomic, strong) NSMutableArray *deals;

 /**  当前页 ***/
@property (nonatomic, assign) int currentpage;

 /**  返回item ***/
@property (nonatomic, strong) UIBarButtonItem *backItem;
@property (nonatomic, strong) UIBarButtonItem *selectAllItem;
@property (nonatomic, strong) UIBarButtonItem *unSelectAllItem;
@property (nonatomic, strong) UIBarButtonItem *removeItem;

@end

@implementation PPCollectViewController

static NSString * const reuseIdentifier = @"deal";

/**
 *  将初始化, 封装在内部. (collectionViewController 需要制定layout布局
 */
- (instancetype)init
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(305, 305);
    
    // 设置主题
    UIBarButtonItem *item = [UIBarButtonItem appearance];
    [item setTitleTextAttributes:@{NSForegroundColorAttributeName : PPCOLOR_RGB(21, 188, 173)} forState:UIControlStateNormal];
    [item setTitleTextAttributes:@{NSForegroundColorAttributeName : PPCOLOR_BG} forState:UIControlStateDisabled];
    
    return [self initWithCollectionViewLayout:layout];
}

/**
 *  懒加载  -  没有数据提示
 */
- (UIImageView *)noDealsImageView{
    if (!_noDealsImageView) {
        // 添加一个imageView 提示没有符合条件
        UIImageView *noDealImageView = [[UIImageView alloc] init];
        noDealImageView.image = [UIImage imageNamed:@"icon_collects_empty"];
        [self.collectionView addSubview:noDealImageView];
        
        WS(weakSelf);
        [noDealImageView mas_makeConstraints:^(MASConstraintMaker *make){
            make.center.equalTo(weakSelf.collectionView);
        }];
        
        self.noDealsImageView = noDealImageView;
    }
    return _noDealsImageView;
}

/**
 *  懒加载
 */
- (NSMutableArray *)deals{
    if (!_deals) {
        _deals = [NSMutableArray array];
    }
    return _deals;
}

- (UIBarButtonItem *)backItem{
    if (!_backItem) {
        _backItem = [UIBarButtonItem itemWithTarget:self action:@selector(back) image:@"icon_back" highImage:@"icon_back_highlighted"];
    }
    return _backItem;
}

- (UIBarButtonItem *)selectAllItem{
    if (!_selectAllItem) {
        
        _selectAllItem = [[UIBarButtonItem alloc] initWithTitle:PPString(@"全选")  style:UIBarButtonItemStyleDone target:self action:@selector(selectAll:)];
    }
    return _selectAllItem;
}

- (UIBarButtonItem *)unSelectAllItem{
    if (!_unSelectAllItem) {
        _unSelectAllItem = [[UIBarButtonItem alloc] initWithTitle:PPString(@"全不选") style:UIBarButtonItemStyleDone target:self action:@selector(unSelectAll:)];
    }
    return _unSelectAllItem;
}

- (UIBarButtonItem *)removeItem{
    if (!_removeItem) {
        _removeItem = [[UIBarButtonItem alloc] initWithTitle:PPString(@"删除") style:UIBarButtonItemStyleDone target:self action:@selector(removeItem:)];

        _removeItem.enabled = NO;
    }
    return _removeItem;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 1. 基础设置
    [self setupNav];
    
    // 3. 加载数据
    [self loadMoreCollectedDeals];
    
    // 注册通知
    [PPNOTICEFICATION addObserver:self selector:@selector(collectStateChanged:) name:PPCollectionStateDidChangeNoticefication object:nil];
    
    
    // 4. 添加上拉加载
    self.collectionView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreCollectedDeals)];
}

#pragma mark - 设置导航栏
- (void)setupNav
{
    // 1. 基础设置
    //    self.currentpage = 0;
    self.title = @"收藏的团购";
    self.collectionView.backgroundColor = PPCOLOR_BG;
    // 1.2. 当collectionView不能拖动的时候, 需要设置此数此属性
    self.collectionView.alwaysBounceVertical = YES;
    // 注册cell
    [self.collectionView registerNib:[UINib nibWithNibName:@"PPHomeDealCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    
//    2.1 左边的返回按钮
    self.navigationItem.leftBarButtonItems = @[self.backItem];
    
    // 2.2 右边的item
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:PPEdit style:UIBarButtonItemStyleDone target:self action:@selector(edit:)];
    
}

/**
 *  监听编辑按钮点击
 */
- (void)edit:(UIBarButtonItem *)item
{
    if ([item.title isEqualToString:PPEdit]) { // 编辑状态
        item.title = PPDone;
//        UIBarButtonItem *gapItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
//        gapItem.width = 100;
        
        self.navigationItem.leftBarButtonItems = @[self.backItem, self.selectAllItem, self.unSelectAllItem, self.removeItem];
        // 进入编辑状态
        for(PPDeal *deal in self.deals){

            deal.editing = YES;
        }
        
    }else{
        item.title = PPEdit;
        self.navigationItem.leftBarButtonItems = @[self.backItem];
        
        // 结束编辑状态
        for(PPDeal *deal in self.deals){
            deal.editing = NO;
            deal.checking = NO;
        }
    }
    
    // 刷表
    [self.collectionView reloadData];
}

/**
 *  监听返回按钮点击
 */
- (void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

/**
 *  全选
 */
- (void)selectAll:(id)sender
{
    for(PPDeal *deal in self.deals){
        deal.checking = YES;
    }
    
    [self.collectionView reloadData];
    
    self.removeItem.enabled = YES;
}

/**
 *  全不选
 */
- (void)unSelectAll:(UIBarButtonItem *)item
{
    for (PPDeal *deal in self.deals) {
        deal.checking = NO;
    }
    
    [self.collectionView reloadData];
    
    self.removeItem.enabled = NO;
}

/**
 *  删除
 */
- (void)removeItem:(UIBarButtonItem *)item
{
    NSMutableArray *tempArray = [NSMutableArray array];
    
    for (PPDeal *deal in self.deals) {
        if (deal.isChecking) {
            [PPDealTool deleteCollectDeals:deal];
            
            [tempArray addObject:deal];
        }
    }
    
    // 删除所有打钩的模型
    [self.deals removeObjectsInArray:tempArray];
    
    [self.collectionView reloadData];
    
    self.removeItem.enabled = NO;
}


#pragma mark - 监听上拉
- (void)loadMoreCollectedDeals
{
    // 1. 增加页码
    self.currentpage++;
    
    // 2. 增加deal
    [self.deals addObjectsFromArray:[PPDealTool collectDeals:self.currentpage]];
    // 3. 结束刷新
    [self.collectionView.footer endRefreshing];

    // 4. 刷新表格
    [self.collectionView reloadData];

}


#pragma mark - 监听通知
- (void)collectStateChanged:(NSNotification *)noticefication
{
    if ([noticefication.userInfo[PPIsCollectedkey] boolValue]) { // 收藏成功
        
        [self.deals insertObject:noticefication.userInfo[PPCollectDealkey] atIndex:0];
        // 刷表
        [self.collectionView reloadData];
        
    }else{ // 每次, 取消收藏, 需要清楚原来的数据, 重新加载
        
//        [self.deals removeObject:noticefication.userInfo[PPCollectDealkey]];
        
        [self.deals removeAllObjects];
        self.currentpage =0;
        
        [self loadMoreCollectedDeals];
    }
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



#pragma mark <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    // 1. 计算 内边距
    [self viewWillTransitionToSize:self.collectionView.size withTransitionCoordinator:nil];
    
    // 2. 控制显示  没有数据提示
    self.noDealsImageView.hidden = self.deals.count;
    
    // 3. 控制尾部刷新控件的显示与隐藏
    if (self.deals.count == [PPDealTool collectDealsCount]) {
        self.collectionView.footer.hidden = YES;
        
        [self.collectionView.footer endRefreshingWithNoMoreData];
    }
    
  
    return self.deals.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PPHomeDealCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // 设置代理
    cell.delegate = self;
    
    // 赋值
    PPDeal *deal = self.deals[indexPath.row];
    cell.deal = deal;
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    PPDetailViewController *detailVc = [[PPDetailViewController alloc] init];
    detailVc.deal = self.deals[indexPath.row];
    detailVc.selectedCity = @"北京";
    
    [self presentViewController:detailVc animated:YES completion:nil];
}

#pragma mark - PPHomeCellDelegate
- (void)cellCheckingStateDidChanged:(PPHomeDealCell *)cell
{
    BOOL hasChecked = NO;
    for (PPDeal *deal in self.deals) {
        if (deal.isChecking) {
            hasChecked = YES;
            break;
        }
    }
    
    // 根据 check状态, 决定删除按钮是否可用
    self.removeItem.enabled = hasChecked;
}

- (void)dealloc
{
    [PPNOTICEFICATION removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
