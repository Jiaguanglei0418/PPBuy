#import <Foundation/Foundation.h>

/**
 *  1. RGB背景色
 */
#define PPCOLOR_RGB(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]

#define PPCOLOR_BG [UIColor colorWithRed:231/255.0 green:231/255.0 blue:231/255.0 alpha:1]


// 监听选中城市 通知
extern NSString *const PPHomeCitySearchVcCitySelectedNoticefication;
extern NSString *const PPHomeCitySearchVcSelectedCityName;


// 监听选中排序 通知
extern NSString *const PPHomeSortVcNoticefication;
extern NSString *const PPHomeSortSelectedSort;


// 监听修改分类 通知 -- dropdown cell
extern NSString *const PPHomeCategoryVcCategorySelectedNoticefication;
extern NSString *const PPHomeCategorySelectedCategory;
extern NSString *const PPHomeCategorySelectedSubCategoryName;


// 监听修改区域 通知
extern NSString *const PPHomeRegionVcRegionSelectedNoticefication;
extern NSString *const PPHomeRegionSelectedRegion;
extern NSString *const PPHomeRegionSelectedSubRegionName;

// 监听收藏, 取消收藏 通知
extern NSString *const PPCollectionStateDidChangeNoticefication;
extern NSString *const PPIsCollectedkey;
extern NSString *const PPCollectDealkey;


// 监听支付宝 完成支付, 跳转
extern NSString *const PPAlipayResultNoticefication;
extern NSString *const PPAlipayResultURLKey;



/**
 *  2.通知
 */
#define PPNOTICEFICATION [NSNotificationCenter defaultCenter]





// ---------------------------- 打印日志  ----------------------------------
// 自定义log
#ifdef DEBUG
#define PPLog(FORMAT, ...) fprintf(stderr,"\n%s %d\n %s\n", __FUNCTION__, __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String])
//#define PPLog(...) NSLog(@"%s %@",__func__, [NSString stringWithFormat:__VA_ARGS__])

#else
#define PPLog(FORMAT, ...)

#endif



// 打印返回responsedata
#define PPLogData(obj,content) \
if(SADEBUG) \
{ \
NSData *data = [NSJSONSerialization dataWithJSONObject:obj options:0 error:nil]; \
NSString *string = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]; \
NSLog(@"%@----->%@",content,string); \
}


// 设置输出颜色
#define XCODE_COLORS_ESCAPE @"\033["
#define XCODE_COLORS_RESET_FG  XCODE_COLORS_ESCAPE @"fg;" // Clear any foreground color
#define XCODE_COLORS_RESET_BG  XCODE_COLORS_ESCAPE @"bg;" // Clear any background color
#define XCODE_COLORS_RESET     XCODE_COLORS_ESCAPE @";"   // Clear any foreground or background color
#define LogBlue(frmt, ...) PPLog((XCODE_COLORS_ESCAPE @"fg0,0,255;" frmt XCODE_COLORS_RESET), ##__VA_ARGS__)
#define LogRed(frmt, ...) PPLog((XCODE_COLORS_ESCAPE @"fg255,0,0;" frmt XCODE_COLORS_RESET), ##__VA_ARGS__)
#define LogBlack(frmt, ...) PPLog((XCODE_COLORS_ESCAPE @"fg0,0,0;" frmt XCODE_COLORS_RESET), ##__VA_ARGS__)
#define LogBrown(frmt, ...) PPLog((XCODE_COLORS_ESCAPE @"fg153,102,51;" frmt XCODE_COLORS_RESET), ##__VA_ARGS__)
#define LogCyan(frmt, ...) PPLog((XCODE_COLORS_ESCAPE @"fg0,255,255;" frmt XCODE_COLORS_RESET), ##__VA_ARGS__)
#define LogGreen(frmt, ...) PPLog((XCODE_COLORS_ESCAPE @"fg0,255,0;" frmt XCODE_COLORS_RESET), ##__VA_ARGS__)
#define LogMagenta(frmt, ...) PPLog((XCODE_COLORS_ESCAPE @"fg255,0,255;" frmt XCODE_COLORS_RESET), ##__VA_ARGS__)
#define LogOrange(frmt, ...) PPLog((XCODE_COLORS_ESCAPE @"fg255,127,0;" frmt XCODE_COLORS_RESET), ##__VA_ARGS__)
#define LogPurple(frmt, ...) PPLog((XCODE_COLORS_ESCAPE @"fg127,0,127;" frmt XCODE_COLORS_RESET), ##__VA_ARGS__)
#define LogYellow(frmt, ...) PPLog((XCODE_COLORS_ESCAPE @"fg255,255,0;" frmt XCODE_COLORS_RESET), ##__VA_ARGS__)
#define LogWhite(frmt, ...) PPLog((XCODE_COLORS_ESCAPE @"fg255,255,255;" frmt XCODE_COLORS_RESET), ##__VA_ARGS__)


