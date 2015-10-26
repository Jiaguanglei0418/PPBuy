//
//  PPNavgationController.m
//  PPBuy
//
//  Created by jiaguanglei on 15/10/9.
//  Copyright (c) 2015年 roseonly. All rights reserved.
//

#import "PPNavgationController.h"
#import "UIImage+JGL.h"

@interface PPNavgationController ()

@end

@implementation PPNavgationController

/**
 *  初始化操作, 一个类只调用一次
 */
+ (void)initialize
{
    UINavigationBar *bar = [UINavigationBar appearance];
    
    
    [bar setBackgroundImage:[UIImage resizedImageWithName:@"bg_navigationBar_normal"] forBarMetrics:UIBarMetricsDefault];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
