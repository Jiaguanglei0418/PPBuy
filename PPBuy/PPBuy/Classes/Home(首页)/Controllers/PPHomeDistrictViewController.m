//
//  PPHomeDistrictViewController.m
//  PPBuy
//
//  Created by jiaguanglei on 15/10/10.
//  Copyright (c) 2015年 roseonly. All rights reserved.
//

#import "PPHomeDistrictViewController.h"
#import "PPHomeDropDown.h"
#import "PPHomeCityViewController.h"
#import "PPNavgationController.h"

@interface PPHomeDistrictViewController ()

@property (weak, nonatomic) IBOutlet UIView *topTittle;

- (IBAction)changeCity;
@end

@implementation PPHomeDistrictViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // 创建下拉菜单
    PPHomeDropDown *dropdown = [PPHomeDropDown dropdown];
    [self.view addSubview:dropdown];

    dropdown.y = self.topTittle.height;
    
    // 设置控制器在POPover中
    self.preferredContentSize = CGSizeMake(dropdown.width, CGRectGetMaxY(dropdown.frame));
    
    
    
    
}

/**
 *  监听切换城市按钮点击
 */
- (IBAction)changeCity {
    
    PPNavgationController *navVc = [[PPNavgationController alloc] initWithRootViewController:[[PPHomeCityViewController alloc] init]];
    navVc.modalPresentationStyle = UIModalPresentationFormSheet;
    
    // 填出控制器
    [self presentViewController:navVc animated:YES completion:^{
        
    }];
    
}
@end
