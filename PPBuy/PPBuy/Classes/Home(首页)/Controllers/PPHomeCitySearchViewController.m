//
//  PPHomeCitySearchViewController.m
//  PPBuy
//
//  Created by jiaguanglei on 15/10/12.
//  Copyright (c) 2015年 roseonly. All rights reserved.
//

#import "PPHomeCitySearchViewController.h"
#import "PPCity.h"
//#import "MJExtension.h"
#import "PPMetaTool.h"


@interface PPHomeCitySearchViewController ()


 /**  所有城市 ***/
//@property (nonatomic, strong) NSArray *cities;

 /**  搜索结果的城市 ***/
@property (nonatomic, strong) NSMutableArray *resultCities;
@end

@implementation PPHomeCitySearchViewController

//- (NSArray *)cities{
//    if (!_cities) {
//        self.cities = [PPCity objectArrayWithFilename:@"cities.plist"];
//    }
//    return _cities;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //
    
}

- (void)setSearchText:(NSString *)searchText
{
    _searchText = [searchText copy];
    
    // 将搜索内容变成大写
    searchText = searchText.lowercaseString;
    LogRed(@"%@",searchText);
    
    self.resultCities = [NSMutableArray array];
//    // 根据关键字搜索城市数据
//    for (PPCity *city in self.cities) {
//        // 城市的name中包含了 searchText
//        // 城市的pinYin中包含了 searchText
//        // 城市的pinYin Head 中包含了 searchText
//        if([city.name containsString:searchText] || [city.pinYin.uppercaseString containsString:searchText] || [city.pinYinHead containsString:searchText]){
//
//            // 添加内容
//            [self.resultCities addObject:city];
//        }
//    }
    
    // 谓词: 能根据一定的条件, 从一个数组中过滤出想要的数据
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name contains %@ or pinYin contains %@ or pinYinHead contains %@",searchText, searchText,searchText];
    
    self.resultCities = [[PPMetaTool cities] filteredArrayUsingPredicate:predicate];
    

    // 刷表
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.resultCities.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"result";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    
    // 显示消息
    PPCity *city = self.resultCities[indexPath.row];
    cell.textLabel.text = city.name;
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [NSString stringWithFormat:@"共有%ld个搜索结果",self.resultCities.count];
}


#pragma mark - delegate - 监听选中城市 -- 通知
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PPCity *city = self.resultCities[indexPath.row];
    
    [PPNOTICEFICATION postNotificationName:PPHomeCitySearchVcCitySelectedNoticefication object:nil userInfo:@{PPHomeCitySearchVcSelectedCityName : city.name}];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
