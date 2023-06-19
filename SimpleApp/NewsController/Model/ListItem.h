//
//  ListItem.h
//  SimpleApp
//
//  Created by 崔雪瑶 on 2023/2/19.
//

#import <Foundation/Foundation.h>
#import "IGListKit.h"

NS_ASSUME_NONNULL_BEGIN


/// 列表结构化数据
@interface ListItem : NSObject <NSSecureCoding>

@property(nonatomic,strong,readwrite) NSString *category;
@property(nonatomic,strong,readwrite) NSString *picUrl;
@property(nonatomic,strong,readwrite) NSString *uniqueKey;
@property(nonatomic,strong,readwrite) NSString *title;
@property(nonatomic,strong,readwrite) NSString *date;
@property(nonatomic,strong,readwrite) NSString *authorName;
@property(nonatomic,strong,readwrite) NSString *articleUrl;

//将字典数组转换为ListItem，解析字典并赋值给上述属性
-(void)configWithDictionary:(NSDictionary *)dictionary;

@end

NS_ASSUME_NONNULL_END
