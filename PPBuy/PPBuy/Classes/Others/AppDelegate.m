//
//  AppDelegate.m
//  PPBuy
//
//  Created by jiaguanglei on 15/10/9.
//  Copyright (c) 2015年 roseonly. All rights reserved.
//

#import "AppDelegate.h"
#import "PPNavgationController.h"
#import "PPHomeViewController.h"

#import <AlipaySDK/AlipaySDK.h>

#import "UMSocial.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    // 设置AppKey -- UM
    [UMSocialData setAppKey:UM_APPKEY];

    // 由于苹果审核政策需求，建议大家对未安装客户端平台进行隐藏，在设置QQ、微信AppID之后调用下面的方法
    [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToQQ, UMShareToQzone, UMShareToWechatSession, UMShareToWechatTimeline]];
    
    // UUID
//    [UIDevice currentDevice].identifierForVendor
    
    self.window = [[UIWindow alloc] init];
    self.window.frame = [UIScreen mainScreen].bounds;

    // 根控制器
    self.window.rootViewController = [[PPNavgationController alloc] initWithRootViewController:[[PPHomeViewController alloc] init]];
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

/**
 *  当应用程序从其他应用 跳转到当前应用时, 会调用此方法
 *
 *  @param application       支付宝
 */
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    // scheme: - PPBuy
    
    
    return YES;
}

- (void)parse:(NSURL *)url application:(UIApplication *)application
{
//    // 结果处理
//    AlixPayResult *result = nil;
//    
//    if (url != nil && [[url host] compare:@"safepay"] == 0) {
//        NSString *query = [[url query] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//
//        result = [[AlixPayResult alloc] initWithString:query];
//    }
//    
//    
//    if (result.statusCode == 9000) { // 成功
//        /**
//          *  用公钥验证签名  严格验证请使用 result.resultString与result.signString验签
//          */
//        // 交易成功
////        NSString *key = @"签约账户后获取到的支付宝公钥";
//        id<DataVerifier> verifier = CreateRSADataVerifier(AlipayPubKey);
//        if ([verifier verifyString:result.resultString withSign:result.signString]) {
//            // 验证签名成功, 交易结果无篡改
//            
//        }else{// 交易被篡改, 失败
//            
//            
//        }
//    }else{ // 失败
//    
//    }
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
