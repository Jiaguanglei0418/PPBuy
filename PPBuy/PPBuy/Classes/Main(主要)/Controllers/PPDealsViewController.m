//
//  PPDealsViewController.m
//  PPBuy
//
//  Created by jiaguanglei on 15/10/16.
//  Copyright (c) 2015年 roseonly. All rights reserved.
//

#import "PPDealsViewController.h"


#import "DPAPI.h" // 大众点评
#import "MJExtension.h"
#import "MJRefresh.h"
#import "PPDeal.h"
#import "PPHomeDealCell.h"

#import "MBProgressHUD+MJ.h"
#import "Masonry.h"

@interface PPDealsViewController ()<DPRequestDelegate>
 /**  所有团购数据 ***/
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

@implementation PPDealsViewController

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
    
    // 设置背景颜色
    self.collectionView.backgroundColor = PPCOLOR_BG;
    
    // 当collectionView不能拖动的时候, 需要设置此数此属性
    self.collectionView.alwaysBounceVertical = YES;
    
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
    
    // 调用子类的 setupParam方法
    [self setupParams:params];
    
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


#pragma mark <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    // 1. 计算 内边距
    [self viewWillTransitionToSize:self.collectionView.size withTransitionCoordinator:nil];
    
    // 2. 控制显示  没有数据提示
    self.noDealsImageView.hidden = self.deals.count;
    
    // 3. 控制尾部刷新控件的显示与隐藏
    //    self.collectionView.footer.hidden = self.totalCount == self.deals.count;

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

@end
