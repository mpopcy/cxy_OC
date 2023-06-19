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
    VideoPlayerOverlayView *_mOverlayView;
    VideoPlayerBottomBar *_mBottomBar;
    VideoPlayerTopBar *_mTopBar;
    
    BOOL _controlsHidden;
    NSTimer *_hideControlsTimer;
    float _currentRate;
}

#pragma mark - Initialization

- (instancetype)initPlayerViewWithLayer:(AVPlayerLayer *)playerLayer;{
    self = [super init];
    if (self) {
        [self setClipsToBounds:YES];
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

- (void)addPlayerPlaybackView:(VideoPlayerPlaybackView *)playerPlaybackView {
    playerPlaybackView.delegate = self;
    [self addSubview:playerPlaybackView];
}

#pragma mark - Setup layout size

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

- (void)displayLoadingVideoSource {
    self.playerState = VideoPlayerStateLoading;
    [self startLoadingView];
    [self.delegate updatePlayerState:VideoPlayerStateLoading];
}

- (void)displayVideoIsReadyToPlay:(BOOL)isAutoPlay {
    [self stopLoadingView];
    self.playerState = VideoPlayerStateItemReadyToPlay;
    if (isAutoPlay) {
        [self playMedia];
    }
    [self.delegate updatePlayerState:VideoPlayerStateItemReadyToPlay];
}

- (void)updateProgressWithCurrentTimeInSec:(float)currentTime durationInSec:(float)duration {
    [_mOverlayView updateProgressWithCurrentTimeInSec:currentTime durationInSec:duration];
    [_mTopBar updateProgressWithCurrentTimeInSec:currentTime durationInSec:duration];
    [_mBottomBar updateProgressWithCurrentTimeInSec:currentTime durationInSec:duration];
}

- (void)clearHideControlsTimer {
    if (_hideControlsTimer != nil) {
        [_hideControlsTimer invalidate];
    }
}

#pragma mark - Private function

- (void)displayMediaIsPlaying {
    [_mOverlayView displayMediaIsPlaying];
    [_mTopBar displayMediaIsPlaying];
    [_mBottomBar displayMediaIsPlaying];
}

- (void)displayMediaIsPaused {
    [_mOverlayView displayMediaIsPaused];
    [_mTopBar displayMediaIsPaused];
    [_mBottomBar displayMediaIsPaused];
}

- (void)displayMediaPlayToEnd {
    [_mOverlayView displayMediaPlayToEnd];
    [_mTopBar displayMediaPlayToEnd];
    [_mBottomBar displayMediaPlayToEnd];
}

- (void)startLoadingView {
    [self stopLoadingView];
    CABasicAnimation *rotate;
    rotate = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rotate.fromValue = [NSNumber numberWithFloat:0];
    rotate.toValue = [NSNumber numberWithFloat: M_PI * 2.0];
    rotate.duration = 1;
    rotate.repeatCount = INFINITY;
    [_loadingImage.layer addAnimation:rotate forKey:@"rotationAnimation"];
    [_loadingImage setHidden:NO];
}

- (void)stopLoadingView {
    [_loadingImage.layer removeAnimationForKey:@"rotationAnimation"];
    [_loadingImage setHidden:YES];
}

- (void)playMedia {
    [self displayMediaIsPlaying];
    if (self.playerState == VideoPlayerStateItemPlayToEnd) {
        [self.delegate setCurrentTime:0];
    }
    self.playerState = VideoPlayerStateItemPlaying;
    [self.delegate updatePlayerState:VideoPlayerStateItemPlaying];
    _currentRate = [self.delegate playbackRate];
    [self resetHideControlsTimer];
}

- (void)pauseMedia {
    [self displayMediaIsPaused];
    self.playerState = VideoPlayerStateItemPaused;
    [self.delegate updatePlayerState:VideoPlayerStateItemPaused];
    _currentRate = [self.delegate playbackRate];
    [self clearHideControlsTimer];
}

- (void)resetHideControlsTimer {
    [self clearHideControlsTimer];
    _hideControlsTimer = [NSTimer cht_scheduledTimerWithTimeInterval:3 repeats:NO block:^(NSTimer *timer) {
        BOOL isHidden = [self.delegate playbackRate] > 0;
        [self setControlsHidden:isHidden];
    }];
}

- (void)setControlsHidden:(BOOL)isHidden {
    if (_controlsHidden == isHidden) return;
    _controlsHidden = isHidden;
    [UIView animateWithDuration:0.2 animations:^{
        [self layoutSubviews];
    }];
}

#pragma mark - Player Notification Selector

- (void)playerWillResignActive {
    [self pauseMedia];
    [self setControlsHidden:NO];
}

- (void)videoItemDidPlayToEnd {
    self.playerState = VideoPlayerStateItemPlayToEnd;
    [self displayMediaPlayToEnd];
    [self setControlsHidden:NO];
    [self.delegate setPlaybackRate:0];
    [self.delegate updatePlayerState:VideoPlayerStateItemPlayToEnd];
}

#pragma mark - MTVideoPlayerPlaybackDelegate

- (void)playOrPauseMedia {
    if ([self.delegate playbackRate] > 0) {
        [self pauseMedia];
    } else {
        [self playMedia];
    }
}

- (void)seekProgressToCurrentTimeInSec:(float)currentTime {
    [self.delegate setCurrentTime:currentTime];
    [self resetHideControlsTimer];
}

- (void)startSeekingMediaProgress {
    [self startLoadingView];
    [self.delegate setPlaybackRate:0];
    self.playerState = VideoPlayerStateSeekingProgress;
    [self.delegate updatePlayerState:VideoPlayerStateSeekingProgress];
}

- (void)completeSeekingMediaProgress {
    [self.delegate setPlaybackRate:_currentRate];
    if (_currentRate > 0) {
        [self resetHideControlsTimer];
    }
    self.playerState = VideoPlayerStateCompleteSeekingProgress;
    [self.delegate updatePlayerState:VideoPlayerStateCompleteSeekingProgress];
}

- (void)showOrHideMediaControl {
    if (_controlsHidden == YES) {
        // Control invisible, so show control
        [self resetHideControlsTimer];
        [self setControlsHidden:NO];
    } else {
        // Control visible, so hide control
        [self clearHideControlsTimer];
        [self setControlsHidden:YES];
    }
}


@end
