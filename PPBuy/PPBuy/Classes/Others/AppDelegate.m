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
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"
//#import "UMSocialSinaSSOHandler.h"
#import "UMSocialSinaHandler.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    // 1. 设置UM_Appkey
    [UMSocialData setAppKey:UM_APPKEY];
    
    // 2. 设置微信key
    [UMSocialWechatHandler setWXAppId:WX_AppID appSecret:WX_AppSecret url:nil];
    
    // 3. 设置QQkey
    [UMSocialQQHandler setQQWithAppId:QQ_AppID appKey:QQ_Appkey url:@"http://www.umeng.com/social"];
    
    // 4. 设置sina
    //打开新浪微博的SSO开关，设置新浪微博回调地址，这里必须要和你在新浪微博后台设置的回调地址一致。若在新浪后台设置我们的回调地址，“http://sns.whalecloud.com/sina2/callback”，这里可以传nil
    //    [UMSocialSinaSSOHandler openNewSinaSSOWithRedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    // 非原生
    [UMSocialSinaHandler openSSOWithRedirectURL:@"http://sns.whalecloud.com/sina2/callback"];

    
    
    // 由于苹果审核政策需求，建议大家对未安装客户端平台进行隐藏，在设置QQ、微信AppID之后调用下面的方法
//    [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToQQ, UMShareToQzone, UMShareToWechatSession, UMShareToWechatTimeline]];
    
    // UUID
//    [UIDevice currentDevice].identifierForVendor
    
    self.window = [[UIWindow alloc] init];
    self.window.frame = [UIScreen mainScreen].bounds;

    // 根控制器
    self.window.rootViewController = [[PPNavgationController alloc] initWithRootViewController:[[PPHomeViewController alloc] init]];
    
    [self.window makeKeyAndVisible];
    
    return YES;
}


#pragma mark - 支付宝回调 微信回调
/**
 *  当应用程序从其他应用 跳转到当前应用时, 会调用此方法
 *
 *  @param application       支付宝
 */
#ifdef IOS7
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [UMSocialSnsService handleOpenURL:url];
}

#else
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [UMSocialSnsService handleOpenURL:url];
}
#endif


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
