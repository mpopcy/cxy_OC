//
//  VideoPlayer.h
//  SimpleApp
//
//  Created by 崔雪瑶 on 2023/2/21.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VideoPlayer : NSObject

//播放器是一个单例
+(VideoPlayer *)Player;

//播放视频的页面需要粘在调用该方法的页面上
-(void)playWithVideoUrl:(NSString *)videoUrl attachView:(UIView *)attachView;

@end

NS_ASSUME_NONNULL_END
