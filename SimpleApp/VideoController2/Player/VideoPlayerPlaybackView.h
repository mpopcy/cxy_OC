//
//  VideoPlayerPlaybackView.h
//  SimpleApp
//
//  Created by 崔雪瑶 on 2023/6/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, VideoPlayerPlaybackViewType) {
    VideoPlayerPlaybackTypeOverlay = 0,
    VideoPlayerPlaybackTypeBottomBar,
    VideoPlayerPlaybackTypeTopBar
};

@protocol VideoPlayerPlaybackDelegate
/// This is called when user press play or pause button.
- (void)playOrPauseMedia;

/// This is called when user change slider value.
- (void)seekProgressToCurrentTimeInSec:(float)currentTime;

/// This is called when user start dragging slider.
- (void)startSeekingMediaProgress;

/// This is called when user stop dragging slider.
- (void)completeSeekingMediaProgress;

/// This is called when user tap screen.
- (void)showOrHideMediaControl;

@optional
/// This is called when user change mute value.
- (void)muteAudio:(BOOL)isMuted;
@end

@interface VideoPlayerPlaybackView : UIView

@property (weak, nonatomic) id <VideoPlayerPlaybackDelegate> delegate;

@property (nonatomic) VideoPlayerPlaybackViewType playbackViewType;

/// Update UI when player is playing.
- (void)displayMediaIsPlaying;

/// Update UI when player is paused.
- (void)displayMediaIsPaused;

/// Update UI when player play to end.
- (void)displayMediaPlayToEnd;

/// Hide or show certain media control view.
- (void)setContentHidden:(BOOL)isHidden;

/// Call the method to update progress UI.
- (void)updateProgressWithCurrentTimeInSec:(float)currentTime durationInSec:(float)duration;
@end

NS_ASSUME_NONNULL_END
