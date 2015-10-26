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

@interface PPMapViewController ()<MKMapViewDelegate, DPRequestDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (nonatomic, strong) CLLocationManager *mgr;

// 编码
@property (nonatomic, strong) CLGeocoder *geocoder;

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
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(back) image:@"icon_back" highImage:@"icon_back_highlighted"];
    // 标题
    self.title = @"地图";
    
    // 设置地图跟踪用户位置
    self.mapView.userTrackingMode = MKUserTrackingModeFollow;
}


#pragma mark - MKMapViewDelegate
// -- 定位
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    [self.mapView setCenterCoordinate:userLocation.location.coordinate animated:YES];
    
    LogYellow(@"%@,--- %@, ---%@",userLocation.title, userLocation.subtitle,userLocation.location);
    
    // 经纬度 --> 城市名称: 反地理编码
    // 名称  --> 经纬度: 地理编码
    [self.geocoder reverseGeocodeLocation:userLocation.location completionHandler:^(NSArray *placemarks, NSError *error) {
        // 如果有错, 直接返回
        if (error || placemarks.count == 0) return ;
        
        CLPlacemark *placeMark = [placemarks firstObject];
        LogCyan(@"%@ --- %@", placeMark.addressDictionary, placeMark.locality);
        
        // 服务器请求
        DPAPI *api = [[DPAPI alloc] init];
        // 设置代理
        
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        
        // 城市
        NSString *cityString = placeMark.locality ? placeMark.locality : placeMark.addressDictionary[@"State"];
        // 截取 - 不能带有 "市"
        params[@"city"] = [cityString substringToIndex:cityString.length - 1];
        // 纬度
        params[@"latitude"] = @(userLocation.location.coordinate.latitude);
        // 经度
        params[@"longitude"] = @(userLocation.location.coordinate.longitude);
        // 半径
        params[@"radius"] = @(500);
        
        self.lastRequest = [api requestWithURL:@"v1/deal/find_deals" params:params delegate:self];
        LogRed(@"%@", params);

        
        
    }];
    
    /**
     *  latitude	float	纬度坐标，须与经度坐标同时传入
     longitude	float	经度坐标，须与纬度坐标同时传入
     radius	int	搜索半径，单位为米，最小值1，最大值5000，如不传入默认为1000
     region	string	包含团购信息的城市区域名，可选范围见相关API返回结果（不含返回结果中包括的城市名称信息）
     category	string	包含团购信息的分类名，支持多个category合并查询，多个category用逗号分割。可选范围见相关API返回结果
     */
    
    
}


#pragma mark - DPRequestDelegate
- (void)request:(DPRequest *)request didFinishLoadingWithResult:(id)result
{
//    LogYellow(@"请求成功 %@", result);
    if(request != self.lastRequest) return;
    //
    
    
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
