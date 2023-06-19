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
        self.tabBarItem.title=@"recommand";
        self.tabBarItem.image=[UIImage imageNamed:@"icon.bundle/like@2x.png"];
        self.tabBarItem.selectedImage=[UIImage imageNamed:@"icon.bundle/like_selected@2x.png"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.SingleVideoPlayer = [[SingleVideoPlayer alloc] init];
    self.SingleVideoPlayer.delegate = self;
    [self.SingleVideoPlayer scalePlayerToFillScreenSize:[[UIScreen mainScreen] bounds].size];
    [self.view addSubview:self.SingleVideoPlayer.playerView];
    
    [self.SingleVideoPlayer setVideoUrlString:kSampeVideoUrl autoPlay:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    [self.SingleVideoPlayer scalePlayerToFillScreenSize:size];
}

#pragma mark - UdnVideoPlayerDelegate methods

- (void)updatePlayerProgressPerSec:(float)currenTime {
    NSLog(@"Current time: %lu",(unsigned long)currenTime);
}

@end
