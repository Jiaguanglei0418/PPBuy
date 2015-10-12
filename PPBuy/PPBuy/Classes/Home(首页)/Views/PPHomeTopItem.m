//
//  PPHomeTopItem.m
//  PPBuy
//
//  Created by jiaguanglei on 15/10/10.
//  Copyright (c) 2015年 roseonly. All rights reserved.
//

#import "PPHomeTopItem.h"

@interface PPHomeTopItem ()
@property (weak, nonatomic) IBOutlet UIButton *IconBtn;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;

@end

@implementation PPHomeTopItem

+ (instancetype)item
{
    return [[[NSBundle mainBundle] loadNibNamed:@"PPHomeTopItem" owner:nil options:nil] lastObject];
}

/**
 *  设置此属性, 旋转屏幕, 子控件的尺寸就不会再缩增了
 */
- (void)awakeFromNib
{
    self.autoresizingMask = UIViewAutoresizingNone;
}


- (void)addTarget:(id)target action:(SEL)action
{
    [self.IconBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}


- (void)setTitle:(NSString *)title
{
    self.titleLabel.text = title;
}


- (void)setSubTitle:(NSString *)subTitle
{
    self.subTitleLabel.text = subTitle;
}

// 设置图片
- (void)setIcon:(NSString *)icon highIcon:(NSString *)highIcon
{
    [self.IconBtn setImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
    [self.IconBtn setImage:[UIImage imageNamed:highIcon] forState:UIControlStateHighlighted];
}

@end
