//
//  PPDetailViewController.m
//  PPBuy
//
//  Created by jiaguanglei on 15/10/16.
//  Copyright (c) 2015年 roseonly. All rights reserved.
//

#import "PPDetailViewController.h"
#import "PPDeal.h"
#import "UIImageView+WebCache.h"
#import "PPCenteLineLabel.h"
#import "DPAPI.h"
#import "MBProgressHUD+MJ.h"
#import "MJExtension.h"
#import "PPDetail.h"

#import "PPDealTool.h"// 数据库

@interface PPDetailViewController ()<UIWebViewDelegate,DPRequestDelegate>

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

 /**  标题 ***/
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
 /**  详情 ***/
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
 /**  图片 ***/
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
 /**  现价 ***/
@property (weak, nonatomic) IBOutlet UILabel *currentPriceLabel;
 /**  原价 ***/
@property (weak, nonatomic) IBOutlet PPCenteLineLabel *listPriceLabel;

 /**  监听返回按钮 ***/
- (IBAction)backbtn;
 /**  监听收藏按钮 ***/
- (IBAction)collectBtnDidSelected;
 /**  监听分享按钮 ***/
- (IBAction)shareBtnDidSelected;
 /**  监听立即购买按钮 ***/
- (IBAction)buyNowBtnDidSelected;

 /**  收藏按钮 ***/
@property (weak, nonatomic) IBOutlet UIButton *collectBtn;


 /**  是否支持随时退 ***/
@property (weak, nonatomic) IBOutlet UIButton *refundableAnytime;
 /**  是否支持过期退 ***/
@property (weak, nonatomic) IBOutlet UIButton *refundableExpired;
 /**  过期时间 ***/
@property (weak, nonatomic) IBOutlet UIButton *purchaseDeadline;
 /**  已售数量 ***/
@property (weak, nonatomic) IBOutlet UIButton *saledCounts;

 /**  详情url ***/

@end

@implementation PPDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 加载 webView
    self.webView.hidden = YES;
    self.webView.backgroundColor = PPCOLOR_BG;
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.deal.deal_h5_url]]];
    
    // 1. 设置基本信息
    [self setupBaseUI];

    // 过期时间
    [self setupDeadline];
    
    self.refundableAnytime.selected = YES;
    
    // 2. 发送请求
    DPAPI *api = [[DPAPI alloc] init];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    // deal_id
    params[@"deal_id"] = self.deal.deal_id;
    params[@"city"] = self.selectedCity;
    
    [api requestWithURL:@"v1/deal/find_deals" params:params delegate:self];
}


// 基本设置
- (void)setupBaseUI
{
    self.titleLabel.text = self.deal.title;
    self.descLabel.text = self.deal.desc;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:self.deal.image_url] placeholderImage:[UIImage imageNamed:@"placeholder_deal"]];
    
    self.currentPriceLabel.text = [NSString stringWithFormat:@"￥%@", self.deal.current_price];
    // 获取小数点位数
    NSUInteger dotLoc = [self.currentPriceLabel.text rangeOfString:@"."].location;
    if (dotLoc != NSNotFound) { // 小数超过2位
        // 89.9999 -- 89.99
        if (self.currentPriceLabel.text.length - dotLoc > 3) {
            self.currentPriceLabel.text = [self.currentPriceLabel.text substringToIndex:dotLoc + 3];
        }
    }
    
    self.listPriceLabel.text = [NSString stringWithFormat:@"门店价￥%@", self.deal.current_price];
    // 获取小数点位数
    NSUInteger dotLoc1 = [self.listPriceLabel.text rangeOfString:@"."].location;
    if (dotLoc1 != NSNotFound) { // 小数超过2位
        // 89.9999 -- 89.99
        if (self.listPriceLabel.text.length - dotLoc1 > 3) {
            self.listPriceLabel.text = [self.listPriceLabel.text substringToIndex:dotLoc1 + 3];
        }
    }

    [self.saledCounts setTitle:[NSString stringWithFormat:@"已售: %d", self.deal.purchase_count] forState:UIControlStateNormal];
    
    // 设置收藏状态
    self.collectBtn.selected = [PPDealTool isCollected:self.deal];
}


/**
 *  设置过期时间
 */
- (void)setupDeadline
{
    NSDate *now = [NSDate date];
    
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    NSDate *deadline = [fmt dateFromString:self.deal.purchase_deadline];
    // 追加1天
    deadline = [deadline dateByAddingTimeInterval:24 * 60 * 60];
    
    NSCalendarUnit unit = NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute;
    NSDateComponents *components = [[NSCalendar currentCalendar] components:unit fromDate:now toDate:deadline options:0];
    
    if (components.day > 31) {
        [self.purchaseDeadline setTitle:@"一个月内不过期" forState:UIControlStateNormal];
    }else{
        [self.purchaseDeadline setTitle:[NSString stringWithFormat:@"%ld天%ld小时%ld分钟", components.day, components.hour, components.minute] forState:UIControlStateNormal];
    }
}


#pragma mark - DPRequestDelegate
- (void)request:(DPRequest *)request didFinishLoadingWithResult:(id)result
{
    LogYellow(@"团购收据 %@", result);
    self.deal = [PPDeal objectWithKeyValues:[result[@"deals"] firstObject]];
    
    // 是否支持退款
    [self.refundableAnytime setEnabled:self.deal.restrictions.is_refundable];
    [self.refundableExpired setSelected:self.deal.restrictions.is_refundable];
}

/**
 *  请求错误
 */
- (void)request:(DPRequest *)request didFailWithError:(NSError *)error
{
    if (error) {
        LogGreen(@"失败 %@", error);
    }
    // [注意] 在支持横竖屏时, 提醒框最好不要添加到window上.
    // 1. 提醒失败 --- 如果不设置View, 默认显示在window上
    [MBProgressHUD showError:@"网络繁忙, 请稍等" toView:self.view];
}



#pragma mark - 监听按钮点击
/**
 *  监听返回按钮点击
 */
- (IBAction)backbtn {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

/**
 *  监听收藏按钮
 */
- (IBAction)collectBtnDidSelected {
    // 设置通知参数
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    info[PPCollectDealkey] = self.deal;
    
    if(self.collectBtn.isSelected){ // 取消收藏
        
        [PPDealTool deleteCollectDeals:self.deal];
        [MBProgressHUD showSuccess:@"取消收藏成功" toView:self.view];
        
        info[PPIsCollectedkey] = @(NO);
    }else{ // 添加
        
        [PPDealTool addCollectDeals:self.deal];
        [MBProgressHUD showSuccess:@"收藏成功" toView:self.view];
        
        info[PPIsCollectedkey] = @(YES);
    }

    self.collectBtn.selected = !self.collectBtn.isSelected;
    
    
    // 发送, 通知, collectionVc 刷新
    [PPNOTICEFICATION postNotificationName:PPCollectionStateDidChangeNoticefication object:nil userInfo:info];
    
}

/**
 *  监听分享按钮
 */
- (IBAction)shareBtnDidSelected {
    
}

/**
 *  监听购买按钮
 */
- (IBAction)buyNowBtnDidSelected {
    
}


#pragma mark - 设置屏幕方向
/**
 *
 UIInterfaceOrientationMaskPortrait = (1 << UIInterfaceOrientationPortrait),
 UIInterfaceOrientationMaskLandscapeLeft = (1 << UIInterfaceOrientationLandscapeLeft),
 UIInterfaceOrientationMaskLandscapeRight = (1 << UIInterfaceOrientationLandscapeRight),
 UIInterfaceOrientationMaskPortraitUpsideDown = (1 << UIInterfaceOrientationPortraitUpsideDown),
 UIInterfaceOrientationMaskLandscape = (UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight),
 UIInterfaceOrientationMaskAll = (UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight | UIInterfaceOrientationMaskPortraitUpsideDown),
 UIInterfaceOrientationMaskAllButUpsideDown = (UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight),
 */
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}

//- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
//{
//    return UIInterfaceOrientationLandscapeLeft;
//}

#pragma mark - UIWebViewDelegate
// 完成load, 会调用此方法
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    if ([webView.request.URL.absoluteString isEqualToString:self.deal.deal_h5_url]) {
        // 开始 显示正在加载
        [self.activityIndicator startAnimating];
        
        // 加载 webView
        NSString *idString = [self.deal.deal_id substringFromIndex:([self.deal.deal_id rangeOfString:@"-"].location + 1)];
        NSString *urlString = [NSString stringWithFormat:@"%@/%@", self.deal.deal_h5_url, idString];
        
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
    }else{ // 详情页面加载完毕
        
        // 1. 显示webView
        self.webView.hidden = NO;
        
        // 2. 隐藏正在下载
        [self.activityIndicator stopAnimating];
        
        // 3. 获取网页
//        NSString *html = [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('html')[0].outerHTML;"];
//        LogCyan(@"%@", html);
       
        // 用来拼接所有JS
        NSMutableString *js = [NSMutableString string];
        // js 删除header
        [js appendString:@"var header = document.getElementsByTagName('header')[0];"];
        [js appendString:@"header.parentNode.removeChild(header);"];
        
        // JS 删除顶部的购买
        [js appendString:@"var box = document.getElementsByClassName('cost-box')[0];"];
        [js appendString:@"box.parentNode.removeChild(box);"];
        
        // JS 删除底部的购买
        [js appendString:@"var buyNow = document.getElementsByClassName('buy-now')[0];"];
        [js appendString:@"buyNow.parentNode.removeChild(buyNow);"];
        
        // 拼
//        [js appendString:@"var html = document.body.getElementsByTagName('link')[0].outerHTML;"];
//        [js appendString:@"var infos = document.getElementsByClassName('detail-info');"];
//        [js appendString:@"for(var i = 0; i < infos.length; i++) {"];
//        [js appendString:@"html += info[i].outerHTML;"];
//        [js appendString:@"}"];
//        [js appendString:@"document.body.innerHTML = html;"];
        
        // 4. 利用webView执行 JS
        [webView stringByEvaluatingJavaScriptFromString:js];
    }
    
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
//    LogRed(@"%@",request.URL);
    
    return YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
