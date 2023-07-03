//
//  VideoCollectionViewCell.h
//  SimpleApp
//
//  Created by 崔雪瑶 on 2023/6/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VideoCollectionViewCell : UICollectionViewCell

-(void)layoutWithVideoCoverUrl:(NSString *)videoCoverUrl videoUrl:(NSString *)videoUrl;

@end

NS_ASSUME_NONNULL_END
