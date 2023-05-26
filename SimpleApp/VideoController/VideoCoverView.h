//
//  VideoCoverView.h
//  SimpleApp
//
//  Created by 崔雪瑶 on 2023/2/20.
//

#import <UIKit/UIKit.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VideoCoverView : UICollectionViewCell

-(void)layoutWithVideoCoverUrl:(NSString *)videoCoverUrl videoUrl:(NSString *)videoUrl;

@end

NS_ASSUME_NONNULL_END
