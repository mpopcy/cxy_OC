//
//  Mediator.h
//  SimpleApp
//
//  Created by 崔雪瑶 on 2023/2/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface Mediator : NSObject

//target action
+(__kindof UIViewController *)detailViewControllerWithUrl:(NSString *)detailUrl;

//url scheme，被解耦的组件（detailViewController）需要注册一个scheme用于标记指向谁，一个block，如何处理参数等
//使用时用openURL传入参数
typedef void(^MediatorProcessBlock)(NSDictionary *params);
+(void)registerScheme:(NSString *)scheme processBlock:(MediatorProcessBlock)processBlock;
+(void)openUrl:(NSString *)url params:(NSDictionary *)params;

@end

NS_ASSUME_NONNULL_END
