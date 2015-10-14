//
//  PPHomeDropDown.m
//  PPBuy
//
//  Created by jiaguanglei on 15/10/10.
//  Copyright (c) 2015年 roseonly. All rights reserved.
//

#import "PPHomeDropDown.h"
#import "PPCategory.h"
#import "PPMetaTool.h"

#import "PPHomeDropdownMainCell.h"
#import "PPHomeDropdownPreCell.h"

@interface PPHomeDropDown ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *mainTableview;
@property (weak, nonatomic) IBOutlet UITableView *preTableView;

 /**  当前选中的cell的category ***/
//@property (nonatomic, strong) PPCategory *selectedCategory;
//@property (nonatomic, strong) id<PPHomeDropDownData> selectedData;
@property (nonatomic, assign) NSInteger selectedMainRow;

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
        return [self.dataSource numberOfRowsInMainTableView:self];
    }else{ // 从表
        return [self.dataSource homeDropdown:self subDataForRowInMainTableView:self.selectedMainRow].count;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
#warning 其实此处可以共用一个cell -- mainCell
    UITableViewCell *cell = nil;
    
    if (tableView == self.mainTableview) { // 主表
        cell = [PPHomeDropdownMainCell cellWithTableView:tableView];
        
        // 取出模型数据
//        id<PPHomeDropDownData> data = [self.dataSource homeDropdown:self dataForRowInMainTableView:indexPath.row];

        cell.textLabel.text = [self.dataSource homeDropdown:self titleForRowInMainTableView:indexPath.row];
        // icon
        if ([self.dataSource respondsToSelector:@selector(homeDropdown:iconForRowInMainTableView:)]) {
            cell.imageView.image = [UIImage imageNamed:[self.dataSource homeDropdown:self iconForRowInMainTableView:indexPath.row]];
        }
        // highIcon
        if ([self.dataSource respondsToSelector:@selector(homeDropdown:selectedIconForRowInMainTableView:)]) {
            cell.imageView.highlightedImage = [UIImage imageNamed:[self.dataSource homeDropdown:self selectedIconForRowInMainTableView:indexPath.row]];
        }
        
        NSArray *subDatas = [self.dataSource homeDropdown:self subDataForRowInMainTableView:indexPath.row];
        if (subDatas.count) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }else{
            cell.accessoryType = UITableViewCellAccessoryNone;
        }

    }else{ // 从表
        cell = [PPHomeDropdownPreCell cellWithTableView:tableView];
        NSArray *subData = [self.dataSource homeDropdown:self subDataForRowInMainTableView:self.selectedMainRow];
        cell.textLabel.text = subData[indexPath.row];
    }
    
    return cell;
}


#pragma mark - 代理方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.mainTableview) { // 主表
        // 被点击的分类
//        self.selectedData = [self.dataSource homeDropdown:self dataForRowInMainTableView:indexPath.row];
        
        self.selectedMainRow = indexPath.row;
        // 刷新右边的tableView
        [self.preTableView reloadData];
        
        // 代理
        if([self.delegate respondsToSelector:@selector(homeDropdown:didSelectedRowInMainTableView:)]){
            [self.delegate homeDropdown:self didSelectedRowInMainTableView:indexPath.row];
        }
        
    }else{ // 从表
//        LogYellow(@"点击了%ld", indexPath.row);
        // 代理
        if([self.delegate respondsToSelector:@selector(homeDropdown:didSelectedRowInSubTableView:inMainTable:)]){
            [self.delegate homeDropdown:self didSelectedRowInSubTableView:indexPath.row inMainTable:self.selectedMainRow];
        }
    }
    
}
@end
