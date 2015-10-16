//
//  PPDetailViewController.m
//  PPBuy
//
//  Created by jiaguanglei on 15/10/16.
//  Copyright (c) 2015年 roseonly. All rights reserved.
//

#import "PPDetailViewController.h"
#import "PPDeal.h"

@interface PPDetailViewController ()<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;

 /**  详情url ***/
//@property (nonatomic, copy) NSString *urlString;
@end

@implementation PPDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 加载 webView
    NSString *idString = [self.deal.deal_id substringFromIndex:([self.deal.deal_id rangeOfString:@"-"].location + 1)];
    LogRed(@"idString = %@", idString);
    
    NSString *urlString = [NSString stringWithFormat:@"%@/%@", self.deal.deal_h5_url, idString];
    LogGreen(@"urlstring - %@",urlString);
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
    
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
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    LogRed(@"%@",request.URL);
    
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
