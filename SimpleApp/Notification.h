//
//  Notification.h
//  SimpleApp
//
//  Created by 崔雪瑶 on 2023/2/27.
//  推送管理，首先验证权限

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Notification : NSObject

//单例
+(Notification *)notificationManager;

//校验权限
-(void)checkNotificationAuthorization;

@end

NS_ASSUME_NONNULL_END
