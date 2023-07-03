//
//  VideoPlayerView.m
//  SimpleApp
//
//  Created by 崔雪瑶 on 2023/6/18.
//

#import "VideoPlayerView.h"
#import "VideoPlayerOverlayView.h"
#import "VideoPlayerBottomBar.h"
#import "VideoPlayerTopBar.h"
#import "NSTimer+Block.h"

@interface VideoPlayerView () <VideoPlayerPlaybackDelegate>

@property (nonatomic) VideoPlayerState playerState;

@end

@implementation VideoPlayerView {
    UIImageView *_loadingImage;
    CALayer *_playerLayer;
    VideoPlayerOverlayView *_mOverlayView;//屏幕中央的播放暂停按钮view
    VideoPlayerBottomBar *_mBottomBar;
    VideoPlayerTopBar *_mTopBar;
    
    BOOL _controlsHidden;//是否隐藏进度条和中央按钮
    NSTimer *_hideControlsTimer;//隐藏起进度条和中央播放暂停按钮的timer
    float _currentRate;
}

#pragma mark - Initialization

- (instancetype)initPlayerViewWithLayer:(AVPlayerLayer *)playerLayer;{
    self = [super init];
    if (self) {
        [self setClipsToBounds:YES];//设置为YES，内容和子视图将剪裁到视图的边界。
        [self setBackgroundColor:[UIColor blackColor]];
        _playerLayer = (CALayer *)playerLayer;
        [self.layer addSublayer:_playerLayer];
        
        _loadingImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_loading.png"]];
        [self addSubview:_loadingImage];
        
        _mOverlayView = [[VideoPlayerOverlayView alloc] init];
        [self addPlayerPlaybackView:_mOverlayView];
        _mBottomBar = [[VideoPlayerBottomBar alloc] init];
        [self addPlayerPlaybackView:_mBottomBar];
        _mTopBar = [[VideoPlayerTopBar alloc] init];
        [self addPlayerPlaybackView:_mTopBar];
    }
    
    return self;
}

//添加播放器的播放视图
- (void)addPlayerPlaybackView:(VideoPlayerPlaybackView *)playerPlaybackView {
    playerPlaybackView.delegate = self;
    [self addSubview:playerPlaybackView];
}

#pragma mark - Setup layout size

//展示布局
- (void)layoutSubviews {
    CGSize size = self.bounds.size;
    // Resize player layer
    [_playerLayer setFrame:self.bounds];
    
    // Resize loading image
    CGFloat loadingImageWidth = 30;
    CGFloat loadingImageHeight = 30;
    [_loadingImage setFrame:CGRectMake(size.width/2 - loadingImageWidth/2,
                                       size.height/2 - loadingImageHeight/2,
                                       loadingImageWidth,
                                       loadingImageHeight)];
    
    
    
    // Resize view of center overlay
    [_mOverlayView setFrame:self.bounds];
    [_mOverlayView setContentHidden:_controlsHidden];
    
    // Resize view of top bar
    [_mTopBar setFrame:CGRectMake(0,
                                  _controlsHidden ? - TopBarHeight : 0,
                                  size.width,
                                  TopBarHeight)];
    [_mTopBar setContentHidden:_controlsHidden];
    
    // Resize view of bottom bar
    [_mBottomBar setFrame:CGRectMake(0,
                            size.height - (_controlsHidden ? 0 : BottomBarHeight),
                            size.width,
                            BottomBarHeight)];
    [_mBottomBar setContentHidden:_controlsHidden];
}

#pragma mark - Public function

//显示加载视频源：更改视频状态，显示加载动画，加载视频
- (void)displayLoadingVideoSource {
    self.playerState = VideoPlayerStateLoading;
    [self startLoadingView];
    [self.delegate updatePlayerState:VideoPlayerStateLoading];
}

//展示视频准备好播放的画面
- (void)displayVideoIsReadyToPlay:(BOOL)isAutoPlay {
    [self stopLoadingView];//停止加载，隐藏加载动画
    self.playerState = VideoPlayerStateItemReadyToPlay;//更新播放器状态
    if (isAutoPlay) {
        [self playMedia];//是否自动播放
    }
    [self.delegate updatePlayerState:VideoPlayerStateItemReadyToPlay];
}

//将进度条从current time更新到+duration时间（？）
- (void)updateProgressWithCurrentTimeInSec:(float)currentTime durationInSec:(float)duration {
    [_mOverlayView updateProgressWithCurrentTimeInSec:currentTime durationInSec:duration];//方法实现没找到or就是执行一个空的方法？
    [_mTopBar updateProgressWithCurrentTimeInSec:currentTime durationInSec:duration];//同上
    [_mBottomBar updateProgressWithCurrentTimeInSec:currentTime durationInSec:duration];
}

//暂停播放视频后，调用该函数将timer置为invalid
- (void)clearHideControlsTimer {
    if (_hideControlsTimer != nil) {
        [_hideControlsTimer invalidate];
    }
}

#pragma mark - Private function

//展示播放正在播放的状态
- (void)displayMediaIsPlaying {
    [_mOverlayView displayMediaIsPlaying];
    [_mTopBar displayMediaIsPlaying];
    [_mBottomBar displayMediaIsPlaying];
}

//展示播放暂停状态，页面中的三个地方都换成暂停状态
- (void)displayMediaIsPaused {
    [_mOverlayView displayMediaIsPaused];
    [_mTopBar displayMediaIsPaused];
    [_mBottomBar displayMediaIsPaused];
}

//展示播放到视频最后的状态
- (void)displayMediaPlayToEnd {
    [_mOverlayView displayMediaPlayToEnd];
    [_mTopBar displayMediaPlayToEnd];
    [_mBottomBar displayMediaPlayToEnd];
}

//开始加载视频
- (void)startLoadingView {
    [self stopLoadingView];//先把之前的加载停掉（？）
    CABasicAnimation *rotate;//定义动画”旋转“，在加载视频时，视频中央有个小圈一直转动，表示在加载中
    rotate = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rotate.fromValue = [NSNumber numberWithFloat:0];
    rotate.toValue = [NSNumber numberWithFloat: M_PI * 2.0];//动画在fromValue和toValue之间插入（动画效果是从fromValue的值变化到toValue）转一圈
    rotate.duration = 1;
    rotate.repeatCount = INFINITY;
    [_loadingImage.layer addAnimation:rotate forKey:@"rotationAnimation"];
    [_loadingImage setHidden:NO];
}

//停止加载
- (void)stopLoadingView {
    [_loadingImage.layer removeAnimationForKey:@"rotationAnimation"];//移除掉key为rotationAnimation的layer上的所有动画（中央表示正在加载视频的小圈）
    [_loadingImage setHidden:YES];//将中央小圈隐藏起来
}

//播放视频
- (void)playMedia {
    [self displayMediaIsPlaying];//将页面展示的按钮都换成播放状态
    if (self.playerState == VideoPlayerStateItemPlayToEnd) {//如果播放到末尾了，设置回到0秒
        [self.delegate setCurrentTime:0];
    }
    self.playerState = VideoPlayerStateItemPlaying;//player状态改成播放
    [self.delegate updatePlayerState:VideoPlayerStateItemPlaying];//更新player状态
    _currentRate = [self.delegate playbackRate];//获取当前播放速率
    [self resetHideControlsTimer];//重置timer
}

//暂停视频
- (void)pauseMedia {
    [self displayMediaIsPaused];//将页面展示的按钮都换成暂停状态
    self.playerState = VideoPlayerStateItemPaused;//player状态改成暂停
    [self.delegate updatePlayerState:VideoPlayerStateItemPaused];//更新player状态
    _currentRate = [self.delegate playbackRate];//获取当前播放速率
    [self clearHideControlsTimer];//将timer置为invalid
}

//重置timer
- (void)resetHideControlsTimer {
    [self clearHideControlsTimer];//先清除timer
    _hideControlsTimer = [NSTimer cht_scheduledTimerWithTimeInterval:3 repeats:NO block:^(NSTimer *timer) {
        BOOL isHidden = [self.delegate playbackRate] > 0;//视频正在播放，就隐藏进度条；否则就展示进度条
        [self setControlsHidden:isHidden];
    }];
}

//隐藏进度条和中央播放按钮
- (void)setControlsHidden:(BOOL)isHidden {
    if (_controlsHidden == isHidden) return;
    _controlsHidden = isHidden;
    [UIView animateWithDuration:0.2 animations:^{
        [self layoutSubviews];//展示除了进度条和中央按钮以外的播放界面
    }];
}

#pragma mark - Player Notification Selector

//暂停播放视频？
- (void)playerWillResignActive {
    [self pauseMedia];
    [self setControlsHidden:NO];//进度条及中央按钮都展示出来
}

//视频播放到最后
- (void)videoItemDidPlayToEnd {
    self.playerState = VideoPlayerStateItemPlayToEnd;
    [self displayMediaPlayToEnd];
    [self setControlsHidden:NO];
    [self.delegate setPlaybackRate:0];
    [self.delegate updatePlayerState:VideoPlayerStateItemPlayToEnd];
}

#pragma mark - MTVideoPlayerPlaybackDelegate

//点击播放器的播放暂停按钮后调用
- (void)playOrPauseMedia {
    if ([self.delegate playbackRate] > 0) {//原来是播放状态，就暂停
        [self pauseMedia];
    } else {
        [self playMedia];//原来是暂停状态，开始播放视频
    }
}

//将进度条设置到指定时间（参数）
- (void)seekProgressToCurrentTimeInSec:(float)currentTime {
    [self.delegate setCurrentTime:currentTime];
    [self resetHideControlsTimer];//重置隐藏进度条的timer
}

//开始拖动进度条时调用
- (void)startSeekingMediaProgress {
    [self startLoadingView];//加载视频
    [self.delegate setPlaybackRate:0];//暂停播放
    self.playerState = VideoPlayerStateSeekingProgress;
    [self.delegate updatePlayerState:VideoPlayerStateSeekingProgress];//更新player状态
}

//拖动进度条的动作完成后调用
- (void)completeSeekingMediaProgress {
    [self.delegate setPlaybackRate:_currentRate];
    if (_currentRate > 0) {
        [self resetHideControlsTimer];
    }
    self.playerState = VideoPlayerStateCompleteSeekingProgress;
    [self.delegate updatePlayerState:VideoPlayerStateCompleteSeekingProgress];//添加监听播放到末尾的observer，更新进度条两侧的时间数值
}

//是否隐藏进度条及中央播放按钮
- (void)showOrHideMediaControl {
    if (_controlsHidden == YES) {//当前是隐藏状态
        // Control invisible, so show control
        [self resetHideControlsTimer];//重置定时器
        [self setControlsHidden:NO];//让其展示出来
    } else {//当前是展示状态
        // Control visible, so hide control
        [self clearHideControlsTimer];//invalid定时器
        [self setControlsHidden:YES];//让其隐藏起来
    }
}


@end
