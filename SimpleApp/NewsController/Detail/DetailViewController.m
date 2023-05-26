//
//  DetailViewController.m
//  SimpleApp
//
//  Created by 崔雪瑶 on 2023/2/17.
//  实现一个webView，加载一个URL并展示其内容

#import "DetailViewController.h"
#import <WebKit/WebKit.h>
#import "Screen.h"
#import "Mediator.h"

@interface DetailViewController ()<WKNavigationDelegate>

@property(nonatomic,strong,readwrite) WKWebView *webView;
//进度加载的展示条
@property(nonatomic,strong,readwrite) UIProgressView *progressView;
//使用一个变量保存将要加载的URL
@property(nonatomic,strong,readwrite) NSString *articleUrl;

@end

@implementation DetailViewController

//url scheme组件化
+(void)load{
    //将底层页push的逻辑注册到Mediator中
    [Mediator registerScheme:@"detail://" processBlock:^(NSDictionary * _Nonnull params){
        NSString *url=(NSString *)[params objectForKey:@"url"];
        UINavigationController *navigationController=(UINavigationController *)[params objectForKey:@"controller"];
        
        DetailViewController *controller=[[DetailViewController alloc] initWithUrlString:url];
        
//        controller.title=[NSString stringWithFormat:@"%@",@(indexPath.row)];
        [navigationController pushViewController:controller animated:YES];
    }];
    
    
}

//在监听者销毁时移除监听
-(void)dealloc{
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
}

//在页面初始化时带上item参数
-(instancetype)initWithUrlString:(NSString *)urlString{
    self=[super init];
    if(self){
        self.articleUrl=urlString;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:({
        //STATUSBARHEIGHT是为刘海屏留出的高度，44是navigationBar的高度
        self.webView=[[WKWebView alloc] initWithFrame:CGRectMake(0, STATUSBARHEIGHT+44, self.view.frame.size.width, self.view.frame.size.height-44-STATUSBARHEIGHT)];
        self.webView.navigationDelegate=self;
        self.webView;
    })];
    
    [self.view addSubview:({
        self.progressView=[[UIProgressView alloc] initWithFrame:CGRectMake(0, STATUSBARHEIGHT+44, self.view.frame.size.width, 20)];
        self.progressView;
    })];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.articleUrl]]];
    
    //监听webView的estimatedProgress属性
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
}

//WKNavigationDelegate的2个方法实现：
//
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(nonnull WKNavigationAction *)navigationAction decisionHandler:(nonnull void (^)(WKNavigationActionPolicy))decisionHandler{
    //loadRequest后是否加载该URL
    decisionHandler(WKNavigationActionPolicyAllow);
    NSLog(@"decidePolicyForNavigationResponse");
}
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation{
    //页面加载完毕后回调
    NSLog(@"WKNavigationDelegate didFinishNavigation");
}

//监听者self调用该函数以接收通知
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    //在每次加载进度发生变化时，设置进度条的值
    self.progressView.progress=self.webView.estimatedProgress;
    NSLog(@"observer receive change");
}

@end
