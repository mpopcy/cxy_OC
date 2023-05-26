//
//  ListLoader.h
//  SimpleApp
//
//  Created by 崔雪瑶 on 2023/2/18.
//

#import <Foundation/Foundation.h>

@class ListItem;
NS_ASSUME_NONNULL_BEGIN

typedef void(^ListLoaderFinishBlock)(BOOL success, NSArray<ListItem *> *dataArray);


/// 列表请求
@interface ListLoader : NSObject

-(void)loadListDataWithFinishBlock:(ListLoaderFinishBlock)finishBlock;

@end

NS_ASSUME_NONNULL_END
