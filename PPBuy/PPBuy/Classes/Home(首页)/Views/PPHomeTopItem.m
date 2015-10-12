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


@end
