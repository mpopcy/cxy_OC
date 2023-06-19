//
//  VideoPlayerAssetControl.h
//  SimpleApp
//
//  Created by 崔雪瑶 on 2023/6/19.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol VideoPlayerAssetControlDelegate

- (void)videoReadyToPlay:(AVPlayer *)player;

@optional
- (void)currentVideoDidChange:(AVPlayer *)player;

@end


@interface VideoPlayerAssetControl : NSObject

@property (weak, nonatomic) id <VideoPlayerAssetControlDelegate> delegate;

- (void)setVideoAsset:(AVAsset *)asset;

/// Set the current playback time
- (void)setCurrentTime:(float)currentTime;

/// set current playback rate
- (void)setRate:(float)rate;

/// get current playback rate
- (float)getRate;

/// get duration of the item's media
- (float)getDuration;

/// reset playback control
- (void)reset;

@end

NS_ASSUME_NONNULL_END
