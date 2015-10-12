//
//  PPHomeDropDown.m
//  PPBuy
//
//  Created by jiaguanglei on 15/10/10.
//  Copyright (c) 2015年 roseonly. All rights reserved.
//

#import "PPHomeDropDown.h"
#import "PPCategory.h"

#import "PPHomeDropdownMainCell.h"
#import "PPHomeDropdownPreCell.h"

@interface PPHomeDropDown ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *mainTableview;
@property (weak, nonatomic) IBOutlet UITableView *preTableView;

 /**  当前选中的cell的category ***/
@property (nonatomic, strong) PPCategory *selectedCategory;
@end

@implementation PPHomeDropDown

- (void)awakeFromNib
{
#warning 当子控件消失, 不显示时注意, 去掉自动布局看看能不能显示
    // 设置不要跟着父控件的尺寸, 而伸缩
    self.autoresizingMask = UIViewAutoresizingNone;
}

+ (instancetype)dropdown
{
    return [[[NSBundle mainBundle] loadNibNamed:@"PPHomeDropDown" owner:nil options:nil]  firstObject];
}


#pragma mark - dataSource数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //[注意]: 当两个tableView公用一个 数据源方法, 通过tableView来区别
    if(tableView == self.mainTableview){ // 主表
        return self.categories.count;
    }else{ // 从表
        return self.selectedCategory.subcategories.count;
    }
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
#warning 其实此处可以共用一个cell -- mainCell
    UITableViewCell *cell = nil;
    
    if (tableView == self.mainTableview) { // 主表
        cell = [PPHomeDropdownMainCell cellWithTableView:tableView];
        
        // 显示消息
        PPCategory *category = self.categories[indexPath.row];

        cell.textLabel.text = category.name;
        cell.imageView.image = [UIImage imageNamed:category.small_icon];
        if (category.subcategories.count) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }else{
            cell.accessoryType = UITableViewCellAccessoryNone;
        }

    }else{ // 从表
        cell = [PPHomeDropdownPreCell cellWithTableView:tableView];
        
        cell.textLabel.text = self.selectedCategory.subcategories[indexPath.row];
    }
    
    return cell;
}


#pragma mark - 代理方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.mainTableview) {
        // 被点击的分类
        self.selectedCategory = self.categories[indexPath.row];
        
        // 刷新右边的tableView
        [self.preTableView reloadData];
        
    }
    
}
@end
