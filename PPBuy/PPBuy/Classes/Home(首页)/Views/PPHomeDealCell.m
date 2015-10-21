//
//  PPHomeDealCell.m
//  PPBuy
//
//  Created by jiaguanglei on 15/10/14.
//  Copyright (c) 2015年 roseonly. All rights reserved.
//

#import "PPHomeDealCell.h"
#import "UIImageView+WebCache.h"
#import "PPDeal.h"
#import "PPCenteLineLabel.h"
@interface PPHomeDealCell ()
 /**  图片 ***/
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
 /**  标题 ***/
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
 /**  描述 ***/
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
 /**  现价 ***/
@property (weak, nonatomic) IBOutlet UILabel *current_priceLabel;
 /**  原价 ***/
@property (weak, nonatomic) IBOutlet PPCenteLineLabel *list_priceLabel;
 /**  销售量 ***/
@property (weak, nonatomic) IBOutlet UILabel *purchase_countLabel;
 /**  是否新单图标 ***/
@property (weak, nonatomic) IBOutlet UIImageView *isNewDealImageView;

 /**  遮盖按钮 ***/
@property (weak, nonatomic) IBOutlet UIButton *coverBtn;
- (IBAction)coverBtnDidSelected:(id)sender;
 /**  勾选标识 ***/
@property (weak, nonatomic) IBOutlet UIImageView *checkView;


@end


@implementation PPHomeDealCell


- (void)awakeFromNib {
    // 设置cell背景
    // 1. 拉伸
//    self.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_dealcell"]];
    // 2. 平铺
//    self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_dealcell"]];
}

/**
 *  3. 背景图片 --- 绘图 -- 不用创建空间        ***** 
 */
- (void)drawRect:(CGRect)rect
{
    // 拉伸
    [[UIImage imageNamed:@"bg_dealcell"] drawInRect:rect];
    // 平铺
//    [[UIImage imageNamed:@"bg_dealcell"] drawAsPatternInRect:rect];
}


- (void)setDeal:(PPDeal *)deal
{
    _deal = deal;
    
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:deal.image_url] placeholderImage:[UIImage imageNamed:@"placeholder_deal"]];
    // 标题
    self.titleLabel.text = deal.title;
    // 描述
    self.descLabel.text = deal.desc;
    
    // 当前价格
    // 筛选小数 -- NSNumber
    self.current_priceLabel.text = [NSString stringWithFormat:@"￥%@", deal.current_price];
    // 获取小数点位数
    NSUInteger dotLoc = [self.current_priceLabel.text rangeOfString:@"."].location;
    if (dotLoc != NSNotFound) { // 小数超过2位
        // 89.9999 -- 89.99
        if (self.current_priceLabel.text.length - dotLoc > 3) {
           
            self.current_priceLabel.text = [self.current_priceLabel.text substringToIndex:dotLoc + 3];
        }
    }
    
    /**
     *  1. UIView 
        2. 画线, 矩形
        3. 背景图片
     */
    self.list_priceLabel.text = [NSString stringWithFormat:@"￥%@", deal.list_price];
    
    
    self.purchase_countLabel.text = [NSString stringWithFormat:@"已售%d", deal.purchase_count];
    // 是否显示 新单
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSString *nowStr = [formatter stringFromDate:[NSDate date]];
    
    // 今天发布的团购, 显示新单
    // 发布日期 < 今天  -- 隐藏
    self.isNewDealImageView.hidden = [deal.publish_date compare:nowStr] == NSOrderedAscending;
//    self.isNewDealImageView.hidden = ![deal.publish_date isEqualToString:nowStr];
    
    // 设置cover的显示与隐藏
    self.coverBtn.hidden = !self.deal.isEditing;
    
    // 设置勾选显示
    self.checkView.hidden = !self.deal.isChecking;
    
}

/**
 *  监听遮盖按钮点击
 */
- (IBAction)coverBtnDidSelected:(id)sender {
    // 设置模型
    self.deal.checking = !self.deal.isChecking;
    
    // 修改状态
    self.checkView.hidden = !self.deal.isChecking;
    
    // 代理方法
    if ([self.delegate respondsToSelector:@selector(cellCheckingStateDidChanged:)]) {
        [self.delegate performSelector:@selector(cellCheckingStateDidChanged:) withObject:self];
    }
}
@end
