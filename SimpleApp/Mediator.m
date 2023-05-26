//
//  Mediator.m
//  SimpleApp
//
//  Created by 崔雪瑶 on 2023/2/24.
//  中转类，原本是点击news页面的cell，跳转至detailView，现在使用target-action方式，利用中转类将该功能组件化、解耦

#import "Mediator.h"
#import <Foundation/Foundation.h>
#import "DetailViewController.h"

@implementation Mediator

#pragma mark - target action
+(__kindof UIViewController *)detailViewControllerWithUrl:(NSString *)detailUrl{
    
    //这种写法多了之后会导致mediator依赖于很多类
//    DetailViewController *controller=[[DetailViewController alloc] initWithUrlString:detailUrl];
    
    //将一个字符串类型反射到一个class
    Class detailCls=NSClassFromString(@"DetailViewController");
    UIViewController *controller=[[detailCls alloc] performSelector:NSSelectorFromString(@"initWithUrlString:") withObject:detailUrl];
    
    return controller;
}

#pragma mark - url scheme
//url scheme
//维护一张scheme表
+(NSMutableDictionary *)mediatorCache{
    static NSMutableDictionary *cache;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cache=@{}.mutableCopy;
    });
    return cache;
}
//将scheme和block都注册到表中
+(void)registerScheme:(NSString *)scheme processBlock:(MediatorProcessBlock)processBlock{
    if(scheme && processBlock){
        [[[self class] mediatorCache] setObject:processBlock forKey:scheme];
    }
}
//在使用时对应URL确定scheme，然后取出scheme的block对参数params进行处理，同时执行block
+(void)openUrl:(NSString *)url params:(NSDictionary *)params{
    MediatorProcessBlock block=[[[self class] mediatorCache] objectForKey:url];
    if(block){
        block(params);
    }
}

@end
