//
//  PPHomeDealCell.h
//  PPBuy
//
//  Created by jiaguanglei on 15/10/14.
//  Copyright (c) 2015年 roseonly. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PPDeal, PPHomeDealCell;

@protocol PPHomeDealCellDelegate <NSObject>

- (void)cellCheckingStateDidChanged:(PPHomeDealCell *)cell;

@end
@interface PPHomeDealCell : UICollectionViewCell

 /**  deal模型 ***/
@property (nonatomic, strong) PPDeal *deal;

@property (nonatomic, weak) id<PPHomeDealCellDelegate> delegate;
@end
