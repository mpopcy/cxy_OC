//
//  DelCellView.h
//  SimpleApp
//
//  Created by 崔雪瑶 on 2023/2/18.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DelCellView : UIView

-(void)showDelViewFromPoint:(CGPoint)point clickBlock:(dispatch_block_t) clickBlock;

@end

NS_ASSUME_NONNULL_END
