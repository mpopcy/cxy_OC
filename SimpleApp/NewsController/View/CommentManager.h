//
//  CommentManager.h
//  SimpleApp
//
//  Created by 崔雪瑶 on 2023/2/28.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CommentManager : NSObject

+(CommentManager *)sharedManager;

-(void)showCommentView;

@end

NS_ASSUME_NONNULL_END
