//
//  Screen.h
//  SimpleApp
//
//  Created by 崔雪瑶 on 2023/2/23.
//  根据获取的屏幕尺寸进行适配

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

//判断是否为横屏
#define IS_LANDSCAPE (UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]))
//屏幕宽度，从uiscreen的bounds获取。如果是横屏，取当前高度作为宽度，竖屏取宽度即可
#define SCREEN_WIDTH (IS_LANDSCAPE ? [[UIScreen mainScreen] bounds].size.height : [[UIScreen mainScreen] bounds].size.width)
//屏幕高度
#define SCREEN_HEIGHT (IS_LANDSCAPE ? [[UIScreen mainScreen] bounds].size.width : [[UIScreen mainScreen] bounds].size.height)

//判断是否是iphone x xr max
#define IS_IPHONE_X (SCREEN_WIDTH==[Screen sizeFor58Inch].width && SCREEN_HEIGHT==[Screen sizeFor58Inch].height)
//xr和xs max屏幕大小相同，像素密度不同
#define IS_IPHONE_XR (SCREEN_WIDTH==[Screen sizeFor61Inch].width && SCREEN_HEIGHT==[Screen sizeFor61Inch].height && [UIScreen mainScreen].scale==2)
#define IS_IPHONE_MAX (SCREEN_WIDTH==[Screen sizeFor65Inch].width && SCREEN_HEIGHT==[Screen sizeFor65Inch].height && [UIScreen mainScreen].scale==3)

//判断是否是刘海屏
#define IS_IPHONE_X_XR_MAX (IS_IPHONE_X || IS_IPHONE_XR || IS_IPHONE_MAX)
//如果是刘海屏，上侧留出宽度44，否则留出20
#define STATUSBARHEIGHT (IS_IPHONE_X_XR_MAX ? 44:20)

//将下面两个适配函数定义成宏
#define UI(x) UIAdapter(x)
#define UIRect(x,y,width,height) UIRectAdapter(x,y,width,height)

//屏幕适配选择按比例扩大or缩小的方式进行
static inline NSInteger UIAdapter (float x){
    //分机型，特定比例
    
    
    //根据屏幕宽度，按比例适配，（以初始的XR机型的尺寸宽度为基准进行适配，也可以传入基准值参数）
    CGFloat scale=414/SCREEN_WIDTH;
    return (NSInteger)x/scale;
}
//适配整个model（四个参数）
static inline CGRect UIRectAdapter (x,y,width,height){
    return CGRectMake(UIAdapter(x), UIAdapter(y), UIAdapter(width), UIAdapter(height));
}

@interface Screen : NSObject

//iphone xs max
+(CGSize)sizeFor65Inch;
//iphone xr
+(CGSize)sizeFor61Inch;
//iphonex
+(CGSize)sizeFor58Inch;

@end

NS_ASSUME_NONNULL_END
