//
//  PPMapViewController.m
//  PPBuy
//
//  Created by jiaguanglei on 15/10/22.
//  Copyright (c) 2015年 roseonly. All rights reserved.
//

#import "PPMapViewController.h"
#import "UIBarButtonItem+Extension.h"

#import <MapKit/MapKit.h>

#import "DPAPI.h"
#import "MBProgressHUD+MJ.h"

#import "PPHomeTopItem.h"
#import "PPHomeCategoryController.h"
#import "PPCategory.h"

#import "PPDealAnnotation.h"
#import "PPDeal.h"
#import "MJExtension.h"
#import "PPMetaTool.h"

#import "PPBusiness.h"
@interface PPMapViewController ()<MKMapViewDelegate, DPRequestDelegate>
 /**  地图 ***/
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
 /**  编码 ***/
@property (nonatomic, strong) CLGeocoder *geocoder;
 /**  城市 ***/
@property (nonatomic, copy) NSString *city;

@property (nonatomic, strong) CLLocationManager *mgr;

 /**  分类item ***/
@property (nonatomic, weak) UIBarButtonItem *categoryItem;
 /**  分类菜单 ***/
@property (nonatomic, weak) UIPopoverController *categoryPopover;
 /**  选中分类名称 ***/
@property (nonatomic, copy) NSString *selectedCategoryName;

// 最近一次请求
@property (nonatomic, strong) DPRequest *lastRequest;
@end

@implementation PPMapViewController

- (CLLocationManager *)mgr{
    if (!_mgr) {
        _mgr = [[CLLocationManager alloc] init];
    }
    return _mgr;
}

- (CLGeocoder *)geocoder{
    if (!_geocoder) {
        _geocoder = [[CLGeocoder alloc] init];
    }
    return _geocoder;
}


- (void)viewDidLoad {
    [super viewDidLoad];

    /**
     *  ios8 需要在plist文件中设置, 
     NSLocationWhenInUseUsageDescription
     NSLocationAlwaysUsageDescription
     */
    if (IOS8) {
        [self.mgr requestAlwaysAuthorization];
    }
    
    
    // 设置导航栏返回按钮
    UIBarButtonItem *backItem = [UIBarButtonItem itemWithTarget:self action:@selector(back) image:@"icon_back" highImage:@"icon_back_highlighted"];
    // 标题
    self.title = @"地图";
    
    // 设置地图跟踪用户位置
    self.mapView.userTrackingMode = MKUserTrackingModeFollow;
    
    // 设置分类菜单
    PPHomeTopItem *categoryTopItem = [PPHomeTopItem item];
    [categoryTopItem addTarget:self action:@selector(categoryClick)];
    UIBarButtonItem *categoryItem = [[UIBarButtonItem alloc] initWithCustomView:categoryTopItem];
    self.categoryItem = categoryItem;
    
    self.navigationItem.leftBarButtonItems = @[backItem, categoryItem];
    
    // 监听分类改变
    [PPNOTICEFICATION addObserver:self selector:@selector(categoryItemDidSelected:) name:PPHomeCategoryVcCategorySelectedNoticefication object:nil];
}


/**
 *  监听分类item点击
 */
- (void)categoryClick
{
    // 显示分类菜单
    UIPopoverController *popoverVc = [[UIPopoverController alloc] initWithContentViewController:[[PPHomeCategoryController alloc] init]];
    self.categoryPopover = popoverVc;
    
    [self.categoryPopover presentPopoverFromBarButtonItem:self.categoryItem permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

/**
 *  监听通知
 */
- (void)categoryItemDidSelected:(NSNotification *)noticefication
{
    // 1. 关闭popover
    [self.categoryPopover dismissPopoverAnimated:YES];
    
    // 2. 获得要发送到服务器的类型名称
    PPCategory *category = noticefication.userInfo[PPHomeCategorySelectedCategory];
    NSString *subCategory = noticefication.userInfo[PPHomeCategorySelectedSubCategoryName];
    if (subCategory == nil || [subCategory isEqualToString:@"全部"]) {// 点击数据没有子类
        self.selectedCategoryName = category.name;
    }else{
        self.selectedCategoryName = subCategory;
    }
    if ([self.selectedCategoryName isEqualToString:@"全部分类"]) {
        self.selectedCategoryName = nil;
    }
    
    // 3. 删除之前的所有大头针
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    // 4.重新发送请求给服务器
    [self mapView:self.mapView regionDidChangeAnimated:YES];
    
    // 5.更换顶部item的文字
    PPHomeTopItem *topItem = (PPHomeTopItem *)self.categoryItem.customView;
    [topItem setIcon:category.icon highIcon:category.highlighted_icon];
    [topItem setTitle:category.name];
    [topItem setSubTitle:subCategory];
}


#pragma mark - MKMapViewDelegate
// -- 定位
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    // 设置中心位置
//    [self.mapView setCenterCoordinate:userLocation.location.coordinate animated:YES];
//    LogYellow(@"%@,--- %@, ---%@",userLocation.title, userLocation.subtitle,userLocation.location);
    
    
    // 1. 让地图显示到用户所在位置
    MKCoordinateRegion region = MKCoordinateRegionMake(userLocation.location.coordinate, MKCoordinateSpanMake(0.25, 0.25));
    [mapView setRegion:region animated:YES];
    
    
    // 2. 经纬度 --> 城市名称: 反地理编码
    // 名称  --> 经纬度: 地理编码
    [self.geocoder reverseGeocodeLocation:userLocation.location completionHandler:^(NSArray *placemarks, NSError *error) {
        // 如果有错, 直接返回
        if (error || placemarks.count == 0) return ;
        
        CLPlacemark *placeMark = [placemarks firstObject];
        LogCyan(@"%@ --- %@", placeMark.addressDictionary, placeMark.locality);
        
        // 城市
        NSString *cityString = placeMark.locality ? placeMark.locality : placeMark.addressDictionary[@"State"];
        // 截取 - 不能带有 "市"
        self.city = [cityString substringToIndex:cityString.length - 1];
        
        // 第一次发送请求给服务器
        [self mapView:mapView regionDidChangeAnimated:YES];
        
    }];
    
    /**
     *  latitude	float	纬度坐标，须与经度坐标同时传入
     longitude	float	经度坐标，须与纬度坐标同时传入
     radius	int	搜索半径，单位为米，最小值1，最大值5000，如不传入默认为1000
     region	string	包含团购信息的城市区域名，可选范围见相关API返回结果（不含返回结果中包括的城市名称信息）
     category	string	包含团购信息的分类名，支持多个category合并查询，多个category用逗号分割。可选范围见相关API返回结果
     */
    
    
}

/**
 *  监听区域改变
 */
- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    if(self.city == nil) return;
    
    // 发送请求给服务器
    DPAPI *api = [[DPAPI alloc] init];
    // 设置代理
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    // 城市
    params[@"city"] = self.city;
    
    if (self.selectedCategoryName) {
        params[@"category"] = self.selectedCategoryName;
    }
    
    // 纬度
    params[@"latitude"] = @(mapView.region.center.latitude);
    // 经度
    params[@"longitude"] = @(mapView.region.center.longitude);
    // 半径
    params[@"radius"] = @(5000);
    
    self.lastRequest = [api requestWithURL:@"v1/deal/find_deals" params:params delegate:self];
    LogRed(@"%@", params);

}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(PPDealAnnotation *)annotation{
    // 返回nil, 意味着交给系统处理
    if(![annotation isKindOfClass:[PPDealAnnotation class]]) return nil;
    // 创建大头针控件
    static NSString *ID = @"deal";
    MKAnnotationView *annoView = [mapView dequeueReusableAnnotationViewWithIdentifier:ID];
    
    if (annoView == nil) {
        annoView = [[MKAnnotationView alloc] initWithAnnotation:nil reuseIdentifier:ID];
        annoView.canShowCallout = YES;
    }
    
    // 设置模型
    annoView.annotation = annotation;
    
    // 设置图片
    annoView.image = [UIImage imageNamed:annotation.icon];
    
    return annoView;
}


#pragma mark - DPRequestDelegate
- (void)request:(DPRequest *)request didFinishLoadingWithResult:(id)result
{
//    LogYellow(@"请求成功 %@", result);
    if(request != self.lastRequest) return;

    // 解析数据
    NSArray *deals = [PPDeal objectArrayWithKeyValuesArray:result[@"deals"]];
    for (PPDeal *deal in deals) {
        // 获得搞团购所属类型
        PPCategory *category = [PPMetaTool categoryWithDeal:deal];
        
        for (PPBusiness *business in deal.businesses) {
            //
            PPDealAnnotation *anno = [[PPDealAnnotation alloc] init];
            anno.coordinate = CLLocationCoordinate2DMake(business.latitude, business.longitude);
            anno.title = business.name;
            anno.subtitle = deal.title;
            anno.icon = category.map_icon;
            
            if ([self.mapView.annotations containsObject:anno]) break;
            
            // 添加大头针
            [self.mapView addAnnotation:anno];
        }
    }
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
    [MBProgressHUD showError:@"网络繁忙, 请稍等" toView:self.view];
    

}



#pragma mark - 监听按钮点击
- (void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)dealloc{
    [PPNOTICEFICATION removeObserver:self];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
