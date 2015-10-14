//
//  PPHomeDropDown.h
//  PPBuy
//
//  Created by jiaguanglei on 15/10/10.
//  Copyright (c) 2015年 roseonly. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PPHomeDropDown;


//@protocol PPHomeDropDownData <NSObject>
//
//- (NSString *)title;
//- (NSString *)icon;
//- (NSString *)selectedIcon;
//- (NSArray *)subDatas;
//
//@end


// 下拉菜单数据源方法
@protocol PPHomeDropDownDataSource <NSObject>

/**
 *  左边表格一共有多少行
 */
- (NSInteger)numberOfRowsInMainTableView:(PPHomeDropDown *)homeDropdown;

/**
 *  左边表格每一行, 对应的数据模型
 */
//- (id<PPHomeDropDownData>)homeDropdown:(PPHomeDropDown *)homeDropdown dataForRowInMainTableView:(NSInteger)row;
// 标题
- (NSString *)homeDropdown:(PPHomeDropDown *)homeDropdown titleForRowInMainTableView:(NSInteger)row;

  // *  主表中某行, 对应附表中数据 **
- (NSArray *)homeDropdown:(PPHomeDropDown *)homeDropdown subDataForRowInMainTableView:(NSInteger)row;

@optional
// 图标
- (NSString *)homeDropdown:(PPHomeDropDown *)homeDropdown iconForRowInMainTableView:(NSInteger)row;
// 选中图标
- (NSString *)homeDropdown:(PPHomeDropDown *)homeDropdown selectedIconForRowInMainTableView:(NSInteger)row;

@end


/**
 *  监听cell -- 点击
 */
@protocol PPHomeDropDownDelegate <NSObject>

@optional
- (void)homeDropdown:(PPHomeDropDown *)homeDropdown didSelectedRowInMainTableView:(NSInteger)row;
- (void)homeDropdown:(PPHomeDropDown *)homeDropdown didSelectedRowInSubTableView:(NSInteger)subrow inMainTable:(NSInteger)mainrow;

@end


@interface PPHomeDropDown : UIView

 /**  分类数据 ***/
//@property (nonatomic, strong) NSArray *categories;

 /**  属性遵守协议 --  ***/
@property (nonatomic, weak) id<PPHomeDropDownDataSource> dataSource;

@property (nonatomic, weak) id<PPHomeDropDownDelegate> delegate;

+ (instancetype)dropdown;
@end
