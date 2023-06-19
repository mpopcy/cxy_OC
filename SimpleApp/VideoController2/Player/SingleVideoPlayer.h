//
//  VideoPlayer.h
//  SimpleApp
//
//  Created by 崔雪瑶 on 2023/6/18.
//

#import <Foundation/Foundation.h>
#import "VideoPlayerView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol VideoPlayerDelegate

@optional
- (void)updatePlayerProgressPerSec:(float)ts;

@end

@interface SingleVideoPlayer : NSObject

@property (strong, nonatomic, readonly) VideoPlayerView *playerView;
@property (weak, nonatomic) id <VideoPlayerDelegate> delegate;

/**
 Set a URL string that references a media resource and initializes to play.
 
 @param videoUrlString URL string that references a media resource by using HLS.
 @param isAutoPlay Let VideoPlayer play media automatically
 */
- (void)setVideoUrlString:(NSString *)videoUrlString autoPlay:(BOOL)isAutoPlay;

- (void)scalePlayerToFillScreenSize:(CGSize)screenSize;

@end

NS_ASSUME_NONNULL_END
