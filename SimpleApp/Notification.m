//
//  Notification.m
//  SimpleApp
//
//  Created by 崔雪瑶 on 2023/2/27.
//

#import<UIKit/UIKit.h>
#import "Notification.h"
#import <UserNotifications/UserNotifications.h>

@interface Notification()<UNUserNotificationCenterDelegate>

@end

@implementation Notification

//单例
+(Notification *)notificationManager{
    static Notification *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager=[[Notification alloc] init];
    });
    return manager;
}

//校验权限
-(void)checkNotificationAuthorization{
    
    UNUserNotificationCenter *center=[UNUserNotificationCenter currentNotificationCenter];
    center.delegate=self;
    
    //获取到系统级的单例，验证权限
    [center requestAuthorizationWithOptions:UNAuthorizationOptionBadge | UNAuthorizationOptionSound completionHandler:^(BOOL granted, NSError * _Nullable error){
        //用户选择完权限后的回调
        //请求权限成功后触发推送
        if(granted){
            //有权限之后发起一条本地的push
            [self _pushLocalNotification];
            
            //远程推送首先需要设备和苹果系统的APNs之间发起一次网络请求,获取到自己的token，该请求要在主线程执行
//            dispatch_async(dispatch_get_main_queue(), ^{
//                //系统将注册的结果（成功or失败）通过delegate返回回来，在AppDelegate中接收回调
//                [[UIApplication sharedApplication] registerForRemoteNotifications];
//            });
            
        }
    }];
}

-(void)_pushLocalNotification{
    //生成一个content
    UNMutableNotificationContent *content=[[UNMutableNotificationContent alloc] init];
    content.badge=@(1);//APP图标右上角的角标
    content.title=@"SimpleApp";
    content.body=@"这是一条推送消息";
    
    //生成一个时间间隔类型的trigger
    UNTimeIntervalNotificationTrigger *trigger=[UNTimeIntervalNotificationTrigger triggerWithTimeInterval:10.f repeats:NO];
    
    //生成request封装content和trigger
    UNNotificationRequest *request=[UNNotificationRequest requestWithIdentifier:@"simpleApp" content:content trigger:trigger];
    
    //把request交给center
    [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error){
        NSLog(@"notification_center");
    }];
}

#pragma mark - delegate
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler{
    //采用alert弹出推送，可选的有声音、弹层、图标右上角的数字变化等
    completionHandler(UNNotificationPresentationOptionAlert);
}


- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)(void))completionHandler{
    //处理完该推送后，角标-1
    [UIApplication sharedApplication].applicationIconBadgeNumber-=1;
    //用户点击时进行回调
    completionHandler();
    //对于新闻类APP，点击后可以跳转到具体的底层页
}

@end
