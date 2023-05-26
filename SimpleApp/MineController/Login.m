//
//  Login.m
//  SimpleApp
//
//  Created by 崔雪瑶 on 2023/2/25.
//

#import "Login.h"
#import <TencentOpenAPI/TencentOpenApiUmbrellaHeader.h>
//#import <TencentOpenAPI/QQApiInterface.h>
//#import <TencentOpenAPI/TencentOAuth.h>

@interface Login () <TencentSessionDelegate>
@property (nonatomic, strong, readwrite) TencentOAuth *oauth;
@property (nonatomic, copy, readwrite) LoginFinishBlock finishBlock;
@property (nonatomic, assign, readwrite) BOOL isLogin;
@end

@implementation Login
//生成一个单例
+ (instancetype)sharedLogin {
    static Login *login;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        login = [[Login alloc] init];
    });
    return login;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _isLogin = NO;
        //创建oauth并初始化其appid
        //appid应该是本APP申请到的ID
        _oauth = [[TencentOAuth alloc] initWithAppId:@"SimpleApp" andDelegate:(id<TencentSessionDelegate>)self];
    }
    return self;
}

- (BOOL)isLogin {
    //需要添加登陆态失效的逻辑
    return _isLogin;
}

- (void)loginWithFinishBlock:(LoginFinishBlock)finishBlock {
    
    _finishBlock = [finishBlock copy];
    
    _oauth.authMode = kAuthModeClientSideToken;
    //登录授权,oauth申请的权限
    [_oauth authorize:@[kOPEN_PERMISSION_GET_USER_INFO,
                        kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,
                        kOPEN_PERMISSION_ADD_ALBUM,
                        kOPEN_PERMISSION_ADD_ALBUM,
//                        kOPEN_PERMISSION_ADD_SHARE,
                        kOPEN_PERMISSION_ADD_TOPIC,
                        kOPEN_PERMISSION_CHECK_PAGE_FANS,
                        kOPEN_PERMISSION_GET_INFO,
                        kOPEN_PERMISSION_GET_OTHER_INFO,
                        kOPEN_PERMISSION_LIST_ALBUM,
                        kOPEN_PERMISSION_UPLOAD_PIC,
                        kOPEN_PERMISSION_GET_VIP_INFO,
                        kOPEN_PERMISSION_GET_VIP_RICH_INFO]];
}

- (void)logOut {
    [_oauth logout:self];
    _isLogin = NO;
}

#pragma mark - delegate
//登录成功后回调
- (void)tencentDidLogin {
    //登录功能是使用oauth认证，返回给客户端一个openID，没有用户信息，如需用户信息，调用getUserInfo方法获取
    _isLogin = YES;
    //保存openid
    [_oauth getUserInfo];
}
//非网络错误导致登录失败
- (void)tencentDidNotLogin:(BOOL)cancelled {
    if (_finishBlock) {
        _finishBlock(NO);
    }
}
//网络错误导致登录失败
- (void)tencentDidNotNetWork {

}

- (void)tencentDidLogout {
   //退出登录，需要清理下存储在本地的登录数据
}

- (void)getUserInfoResponse:(APIResponse *)response {
    NSDictionary *userInfo = response.jsonResponse;
    _nick = userInfo[@"nickname"];
    _address = userInfo[@"city"];
    _avatarUrl = userInfo[@"figureurl_qq_2"];
    if (_finishBlock) {
        _finishBlock(YES);
    }
}

#pragma mark -

- (void)shareToQQWithArticleUrl:(NSURL *)articleUrl {

    //登陆校验
    //loginWithFinishBlock

    QQApiNewsObject *newsObj = [QQApiNewsObject objectWithURL:articleUrl title:@"iOS" description:@"从0开始iOS开发" previewImageURL:nil];
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newsObj];
    __unused QQApiSendResultCode sent = [QQApiInterface SendReqToQZone:req];
}

@end

