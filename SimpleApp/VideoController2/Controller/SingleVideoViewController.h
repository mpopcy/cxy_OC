//
//  VideoViewController.h
//  SimpleApp
//
//  Created by 崔雪瑶 on 2023/6/18.
//

#import <UIKit/UIKit.h>
#import "SingleVideoPlayer.h"

NS_ASSUME_NONNULL_BEGIN

@interface SingleVideoViewController : UIViewController<VideoPlayerDelegate>

@property (nonatomic,strong) SingleVideoPlayer *SingleVideoPlayer;

@end

NS_ASSUME_NONNULL_END
