//
//  VideoPlayer.m
//  SimpleApp
//
//  Created by 崔雪瑶 on 2023/6/18.
//

#import "SingleVideoPlayer.h"
#import "VideoPlayerAssetControl.h"

@interface SingleVideoPlayer () <VideoPlayerAssetControlDelegate, VideoPlayerViewDelegate>

@property (strong, nonatomic) VideoPlayerView *playerView;

@end


@implementation SingleVideoPlayer {
    VideoPlayerAssetControl *_assetControl;
    AVPlayerLayer *_playerLayer;
    BOOL _isAutoPlay;//是否自动播放
    
    id _timeObserverToken;//timer观察者的token
    BOOL _isNewAsset;
    BOOL _isReset;
}

- (void)dealloc {
    [self reset];
}

#pragma mark - Initialization

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupVideoPlayer];
    }
    
    return self;
}

- (void)setupVideoPlayer {//启动播放器
    // Set AssetControl delegate for ready to play video
    _assetControl = [[VideoPlayerAssetControl alloc] init];
    _assetControl.delegate = self;
    
    // Add notification of finished playing
    [self addVideoDidPlayToEndNotification];
    
    // Add notification of application will resign active
    //APP即将从前台进入后台时，触发播放器进入后台的函数
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(playerWillResignActive)
                                                 name: UIApplicationWillResignActiveNotification
                                               object: nil];
    
    // Init video player view
    _playerLayer = [[AVPlayerLayer alloc] init];
    self.playerView = [[VideoPlayerView alloc] initPlayerViewWithLayer:_playerLayer];
    self.playerView.delegate = self;
}

#pragma mark - Player Notification

//监听”视频播放完成“
- (void)addVideoDidPlayToEndNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self.playerView
                                             selector:@selector(videoItemDidPlayToEnd)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:nil];
    
}

//同上
- (void)removeVideoDidPlayToEndNotification {
    [[NSNotificationCenter defaultCenter] removeObserver:self.playerView
                                                    name:AVPlayerItemDidPlayToEndTimeNotification
                                                  object:nil];
}

#pragma mark - Public function

//加载播放资源
- (void)setVideoUrlString:(NSString *)videoUrlString autoPlay:(BOOL)isAutoPlay {
    [self.playerView displayLoadingVideoSource];//将播放器状态设置为loading，并开始加载视频
    _isNewAsset = YES;
    _isAutoPlay = isAutoPlay;
    NSURL *urlAsset = [NSURL URLWithString:videoUrlString];
    AVAsset *asset = [AVAsset assetWithURL:urlAsset];
    [_assetControl setVideoAsset:asset];
}

//调整播放器size
- (void)scalePlayerToFillScreenSize:(CGSize)screenSize {
    UIDeviceOrientation deviceOrientation = [[UIDevice currentDevice] orientation];
    CGFloat width = screenSize.width;
    CGFloat height = screenSize.width * 0.5625;
    if (deviceOrientation == UIDeviceOrientationLandscapeLeft || deviceOrientation == UIDeviceOrientationLandscapeRight) {
        CGFloat playerOffsetY = screenSize.height/2 - height/2;
        [self.playerView setFrame:CGRectMake(0, playerOffsetY, width, height)];
    } else {
        CGFloat playerOffsetY = screenSize.height/2 - height/2;
        [self.playerView setFrame:CGRectMake(0, playerOffsetY, width, height)];
    }
}

- (void)reset {
    _isReset = YES;
    
    // Remove notifications
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    // Remove timer
    [self.playerView clearHideControlsTimer];
    
    // Remove periodic time observer token
    [self removePlayerTimeObserver];
    
    // Pause media
    [_playerLayer.player pause];
}

#pragma mark - Private function

- (void)removePlayerTimeObserver {
    //如果token非空，移除timer的观察者
    if (_timeObserverToken != nil) {
        [_playerLayer.player removeTimeObserver:_timeObserverToken];
        _timeObserverToken = nil;
    }
}

#pragma mark - VideoPlayerAssetControl Delegate

- (void)videoReadyToPlay:(AVPlayer *)player {
    //判断播放状态，如果是正在加载或已完成拖动进度条，直接返回（已经是准备好播放的状态）
    if (self.playerView.playerState != VideoPlayerStateLoading && self.playerView.playerState != VideoPlayerStateCompleteSeekingProgress) return;
    [self updatePlayerProgressPerSecByDuration:[_assetControl getDuration]];//如果不是以上两种状态，更新进度条
    [self.playerView displayVideoIsReadyToPlay:_isAutoPlay];//将player状态设置为readyToPlay，根据_isAutoPlay判断是否要自动播放
}

//更新进度条
- (void)updatePlayerProgressPerSecByDuration:(float)newDuration {
    if (!_isNewAsset) return;//如果不是新的asset，直接返回
    _isNewAsset = NO;
    // Remove periodic time observer token
    [self removePlayerTimeObserver];
    // 每秒调用一次回调，interval是回调时间间隔
    CMTime interval = CMTimeMakeWithSeconds(1, NSEC_PER_SEC);
    // Queue on which to invoke the callback调用回调的队列
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    // Add time observer
    __weak SingleVideoPlayer *weakSelf = self;
    __block BOOL blockIsReset = _isReset;
    _timeObserverToken = [_playerLayer.player addPeriodicTimeObserverForInterval:interval queue:mainQueue usingBlock:^(CMTime time) {//每次进度条变化都会调用该block
        float timeElapsed = (float)CMTimeGetSeconds(time);//当前进度条到第几秒
        if (blockIsReset) {
            [weakSelf reset];
        }
        [weakSelf.playerView updateProgressWithCurrentTimeInSec:timeElapsed durationInSec:newDuration];//newDuration指更新后的视频总时长？？
        if (weakSelf.delegate != nil) {
            //控制台输出当前播放到第几秒
            [weakSelf.delegate updatePlayerProgressPerSec:timeElapsed];
        }

    }];
}

//完成“拖动进度条”动作后调用该方法
- (void)checkPlayer {
    if (_timeObserverToken != nil) {
        return;
    }
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    // Add time observer
    CMTime interval = CMTimeMakeWithSeconds(1, NSEC_PER_SEC);
    __weak SingleVideoPlayer *weakSelf = self;
    float newDuration = [_assetControl getDuration];//返回player当前item的总时长（秒数）
    _timeObserverToken = [_playerLayer.player addPeriodicTimeObserverForInterval:interval queue:mainQueue usingBlock:^(CMTime time) {
        float timeElapsed = (float)CMTimeGetSeconds(time);//当前进度条到第几秒
        [weakSelf.playerView updateProgressWithCurrentTimeInSec:timeElapsed durationInSec:newDuration];//更新进度条的左右数值
        if (weakSelf.delegate != nil) {
            //控制台输出当前播放到第几秒
            [weakSelf.delegate updatePlayerProgressPerSec:timeElapsed];
        }
        
    }];
}

//什么时候调用？
- (void)currentVideoDidChange:(AVPlayer *)player {
    if (player.currentItem == nil) return;
    [_playerLayer setPlayer:player];//将当前playerLayer的player设置为传进来的参数player
}

#pragma mark - VideoPlayerAssetControl Delegate

- (float)playbackRate {
    return [_assetControl getRate];//player中的属性rate播放速率，0表示暂停播放，1表示正常速度播放
}

- (void)setPlaybackRate:(float)rate {
    [_assetControl setRate:rate];
}

- (void)setCurrentTime:(float)currentTime {
    [_assetControl setCurrentTime:currentTime];//将播放光标移动到指定时间的位置
}

//更新播放器状态，如果是loading不执行任何操作
- (void)updatePlayerState:(VideoPlayerState)state {
    NSLog(@"MTVideoPlayerState: %lu", (unsigned long)state);
    switch (state) {
        case VideoPlayerStateItemPlaying:
            [_playerLayer.player play];
            break;
        case VideoPlayerStateItemPaused:
            [_playerLayer.player pause];
            break;
        case VideoPlayerStateSeekingProgress://正在拖动进度条
            _isAutoPlay = NO;
            [self removeVideoDidPlayToEndNotification];//移除一个回调为空的监听（监听播放到末尾的事件）
            break;
        case VideoPlayerStateCompleteSeekingProgress://已完成拖动进度条的动作
            [self addVideoDidPlayToEndNotification];//重新添加监听事件（监听播放到末尾的事件）的观察者
            [self checkPlayer];//更新进度条的左右数值
            break;
        default:
            break;
    }
}


@end
