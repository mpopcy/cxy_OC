//
//  VideoPlayerView.h
//  SimpleApp
//
//  Created by 崔雪瑶 on 2023/6/18.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, VideoPlayerState) {
    VideoPlayerStateUnknown = 0,
    VideoPlayerStateLoading,
    VideoPlayerStateItemReadyToPlay,
    VideoPlayerStateItemPlaying,
    VideoPlayerStateItemPaused,
    VideoPlayerStateItemPlayToEnd,
    VideoPlayerStateSeekingProgress,
    VideoPlayerStateCompleteSeekingProgress
};

@protocol VideoPlayerViewDelegate
- (float)playbackRate;
- (void)setPlaybackRate:(float)rate;
- (void)setCurrentTime:(float)currentTime;
- (void)updatePlayerState:(VideoPlayerState)state;
@end

@class AVPlayerLayer;

@interface VideoPlayerView : UIView

@property (nonatomic, readonly) VideoPlayerState playerState;

@property (weak, nonatomic) id <VideoPlayerViewDelegate> delegate;

- (instancetype)initPlayerViewWithLayer:(AVPlayerLayer *)playerLayer;

- (void)updateProgressWithCurrentTimeInSec:(float)currentTime durationInSec:(float)duration;
- (void)displayLoadingVideoSource;
- (void)displayVideoIsReadyToPlay:(BOOL)isAutoPlay;
- (void)clearHideControlsTimer;

@end

NS_ASSUME_NONNULL_END
