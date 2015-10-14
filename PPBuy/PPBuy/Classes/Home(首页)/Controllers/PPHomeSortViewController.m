//
//  PPHomeSortViewController.m
//  PPBuy
//
//  Created by jiaguanglei on 15/10/13.
//  Copyright (c) 2015年 roseonly. All rights reserved.
//

#import "PPHomeSortViewController.h"
#import "PPSort.h"
#import "PPMetaTool.h"

@interface PPSortButton : MyButton
//@property (nonatomic, strong) PPSort *sort;
@end

@implementation PPSortButton

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [self setBackgroundImage:[UIImage imageNamed:@"btn_filter_normal"] forState:UIControlStateNormal];
        [self setBackgroundImage:[UIImage imageNamed:@"btn_filter_selected"] forState:UIControlStateHighlighted];
    }
    return self;
}
@end


@implementation PPHomeSortViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 创建UI
    NSArray *sorts = [PPMetaTool sorts];
    NSInteger count = sorts.count;
    
    CGFloat btnW = 100;
    CGFloat btnH = 30;
    CGFloat btnX = 15;
    CGFloat btnStartY = 15;
    CGFloat btnMargin = 15;
    CGFloat height = 0;
    for (NSUInteger i = 0 ; i < count; i++) {
        PPSort *sort = sorts[i];

        PPSortButton *btn = (PPSortButton *)[PPSortButton buttonWithFrame:CGRectMake(btnX, btnStartY + (btnH + btnMargin)* i, btnW, btnH) type:UIButtonTypeCustom title:sort.label target:self andAction:@selector(btnClicked:)];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [btn setBackgroundImage:[UIImage imageNamed:@"btn_filter_normal"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"btn_filter_selected"] forState:UIControlStateHighlighted];
        btn.tag = i;
        
//        btn.sort = sort;
        
        [self.view addSubview:btn];
        
        // 高度
        height = CGRectGetMaxY(btn.frame);
    }
    
    // 设置控制器在POPover中的尺寸
    CGFloat width = btnW + 2 * btnX;
    height += btnMargin;
    self.preferredContentSize = CGSizeMake(width, height);
    
}


- (void)btnClicked:(MyButton *)btn
{
    [PPNOTICEFICATION postNotificationName:PPHomeSortVcNoticefication object:nil userInfo:@{PPHomeSortSelectedSort : [PPMetaTool sorts][btn.tag]}];
    
    // dismiss POPVc
//    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
