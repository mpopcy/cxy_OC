//
//  VideoViewController.m
//  SimpleApp
//
//  Created by 崔雪瑶 on 2023/6/18.
//

#import "SingleVideoViewController.h"

@interface SingleVideoViewController ()

@end

static NSString *const kSampeVideoUrl = @"http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4";

@implementation SingleVideoViewController

-(instancetype)init{
    self=[super init];
    if(self){
        self.tabBarItem.title=@"videoPlayer";
        self.tabBarItem.image=[UIImage imageNamed:@"icon.bundle/like@2x.png"];
        self.tabBarItem.selectedImage=[UIImage imageNamed:@"icon.bundle/like_selected@2x.png"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.SingleVideoPlayer = [[SingleVideoPlayer alloc] init];//初始化player，启动播放器
    self.SingleVideoPlayer.delegate = self;
    [self.SingleVideoPlayer scalePlayerToFillScreenSize:[[UIScreen mainScreen] bounds].size];//调整player的size
    [self.view addSubview:self.SingleVideoPlayer.playerView];//将player的view粘到当前view上
    
    //加载URL播放资源
    [self.SingleVideoPlayer setVideoUrlString:kSampeVideoUrl autoPlay:YES];
}

#pragma mark - UIViewController的方法

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    [self.SingleVideoPlayer scalePlayerToFillScreenSize:size];//调整player的size适应屏幕
}

#pragma mark - UdnVideoPlayerDelegate methods

- (void)updatePlayerProgressPerSec:(float)currenTime {//控制台输出当前播放到第几秒
    NSLog(@"Current time: %lu",(unsigned long)currenTime);
}

@end
