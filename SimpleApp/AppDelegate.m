//
//  AppDelegate.m
//  SimpleApp
//
//  Created by 崔雪瑶 on 2023/2/14.
//

#import "AppDelegate.h"
#import "NewsViewController.h"
#import "VideoViewController.h"
#import "RecommendViewController.h"
#import "SplashView.h"
#import "MineViewController.h"
#import "Location.h"
#import "Notification.h"
#import <TencentOpenAPI/TencentOpenApiUmbrellaHeader.h>

@interface AppDelegate ()<UITabBarControllerDelegate>

@end

@implementation AppDelegate

@synthesize  window=_window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window=[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    UITabBarController *tabBarController=[[UITabBarController alloc] init];
    
    //rootView是当navigation栈中所有页面都pop出去后，展示的默认页面。
    NewsViewController *viewController=[[NewsViewController alloc] init];
    
    
//    UIViewController *controller1=[[UIViewController alloc] init];
//    navigationController.view.backgroundColor=[UIColor redColor];
    viewController.tabBarItem.title=@"news";
    viewController.tabBarItem.image=[UIImage imageNamed:@"icon.bundle/page@2x.png"];
    viewController.tabBarItem.selectedImage=[UIImage imageNamed:@"icon.bundle/page_selected@2x.png"];
    
    VideoViewController *videoController=[[VideoViewController alloc] init];
    
    RecommendViewController *recommendController=[[RecommendViewController alloc] init];
    
    MineViewController *mineController=[[MineViewController alloc] init];
    
    [tabBarController setViewControllers:@[viewController,videoController,recommendController,mineController]];
    
    UINavigationController *navigationController=[[UINavigationController alloc] initWithRootViewController:tabBarController];
    
    tabBarController.delegate=self;
    
    self.window.rootViewController=navigationController;
    [self.window makeKeyAndVisible];
    
    //当系统准备好所有需要展示的页面后，storyboard的闪屏页面会自动消失
    //消失前将广告位闪屏加入window，让其接替显示
    [self.window addSubview:({
        SplashView *splashView=[[SplashView alloc] initWithFrame:self.window.bounds];
        splashView;
    })];
    
    //在APP启动时获取位置权限，推送权限
    [[Location locationManager] checkLocationAuthorization];
    [[Notification notificationManager] checkNotificationAuthorization];
    
    //设置APP图标右上角角标为0
//    [UIApplication sharedApplication].applicationIconBadgeNumber=0;
    
    return YES;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    //点击tabBarItem切换TabBarController后，需要执行的逻辑
    NSLog(@"did select");
    //点击时切换APP图标
//    [self _changeIcon];
}

#pragma mark - PUSH
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    //尽量收敛到GTNotification中实现
    //注册成功
    NSLog(@"注册成功");
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //注册失败
    NSLog(@"注册失败");
}

#pragma mark - URL scheme
//实现接收scheme的delegate中的一个方法
-(BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options{
    if (YES == [TencentOAuth CanHandleOpenURL:url]) {
        return [TencentOAuth HandleOpenURL:url];
    }
    return NO;
    //处理通过SCHEME拉起的url 自定义业务逻辑
    return YES;
}

#pragma mark - change icon
//-(void)_changeIcon{
//    //判断当前系统版本是否支持替换图标
//    if([UIApplication sharedApplication].supportsAlternateIcons){
//        [[UIApplication sharedApplication] setAlternateIconName:@"newIcon" completionHandler:^(NSError * _Nullable error){
//            NSLog(@"替换成功");
//        }];
//    }
//}

@end
