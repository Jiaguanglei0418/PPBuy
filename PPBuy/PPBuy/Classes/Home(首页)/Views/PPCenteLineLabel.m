//
//  PPCenteLineLabel.m
//  PPBuy
//
//  Created by jiaguanglei on 15/10/15.
//  Copyright (c) 2015年 roseonly. All rights reserved.
//

#import "PPCenteLineLabel.h"

@implementation PPCenteLineLabel

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    // 画线
//    [self drawLineInRect:rect];
    
    // 画矩形框
    [self drawRectInRect:rect];
}

/**
 *  画矩形
 */
- (void)drawRectInRect:(CGRect)rect
{
    UIRectFill(CGRectMake(0, rect.size.height * 0.4, rect.size.width, 1));
}


/**
 *  画线
 */
- (void)drawLineInRect:(CGRect)rect
{
    // 画线
    CGContextRef ref = UIGraphicsGetCurrentContext();
    
    // 设置颜色
    [[UIColor grayColor] set];
    // 线宽
    CGContextSetLineWidth(ref, 1);
    
    // 设置起点
    CGContextMoveToPoint(ref, 0, rect.size.height * 0.3);
    // 连线到另一个点
    CGContextAddLineToPoint(ref, rect.size.width, rect.size.height * 0.3);
    // 渲染
    CGContextStrokePath(ref);
}
@end
