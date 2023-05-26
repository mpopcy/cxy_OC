//
//  Login.h
//  SimpleApp
//
//  Created by 崔雪瑶 on 2023/2/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^LoginFinishBlock)(BOOL isLogin);

/**
 QQ登录和分享相关逻辑
 */
@interface Login : NSObject
//登录完成后保存用户的三个属性信息
//正常开发应有一个user类型的model保存用户信息
@property(nonatomic, strong, readonly)NSString *nick;
@property(nonatomic, strong, readonly)NSString *address;
@property(nonatomic, strong, readonly)NSString *avatarUrl;

+ (instancetype)sharedLogin;

#pragma - mark - 登录

- (BOOL)isLogin;//判断当前是否登录
- (void)loginWithFinishBlock:(LoginFinishBlock)finishBlock;//登录
- (void)logOut;//登出

#pragma mark - 分享
- (void)shareToQQWithArticleUrl:(NSURL *)articleUrl;

@end

NS_ASSUME_NONNULL_END
