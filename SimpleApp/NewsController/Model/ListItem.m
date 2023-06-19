//
//  ListItem.m
//  SimpleApp
//
//  Created by 崔雪瑶 on 2023/2/19.
//

#import "ListItem.h"

@implementation ListItem

#pragma mark - NSSecureCoding

-(nullable instancetype)initWithCoder:(NSCoder *)aDecoder{
    self=[super init];
    if(self){
        self.category=[aDecoder decodeObjectForKey:@"category"];
        self.picUrl=[aDecoder decodeObjectForKey:@"picUrl"];
        self.uniqueKey=[aDecoder decodeObjectForKey:@"uniquekey"];
        self.title=[aDecoder decodeObjectForKey:@"title"];
        self.date=[aDecoder decodeObjectForKey:@"date"];
        self.authorName=[aDecoder decodeObjectForKey:@"authorName"];
        self.articleUrl=[aDecoder decodeObjectForKey:@"url"];
    }
    return self;
}
-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.category forKey:@"category"];
    [aCoder encodeObject:self.picUrl forKey:@"picUrl"];
    [aCoder encodeObject:self.uniqueKey forKey:@"uniqueKey"];
    [aCoder encodeObject:self.title forKey:@"title"];
    [aCoder encodeObject:self.date forKey:@"date"];
    [aCoder encodeObject:self.authorName forKey:@"authorName"];
    [aCoder encodeObject:self.articleUrl forKey:@"articleUrl"];
}
//安全性协议
+(BOOL)supportsSecureCoding{
    return YES;
}


#pragma mark - public method
-(void)configWithDictionary:(NSDictionary *)dictionary{
    
    //赋值前加容错判断，字典中是否有该key，类型是否匹配等
    self.category=[dictionary objectForKey:@"category"];
    self.picUrl=[dictionary objectForKey:@"thumbnail_pic_s"];
    self.uniqueKey=[dictionary objectForKey:@"uniquekey"];
    self.title=[dictionary objectForKey:@"title"];
    self.date=[dictionary objectForKey:@"date"];
    self.authorName=[dictionary objectForKey:@"author_name"];
    self.articleUrl=[dictionary objectForKey:@"url"];
//    NSArray *arr = [[NSArray alloc] init];
//    self.articleUrl=[dictionary objectForKey:arr];
}

#pragma mark -

- (nonnull id<NSObject>)diffIdentifier {
    return _uniqueKey;
}

- (BOOL)isEqualToDiffableObject:(nullable id<IGListDiffable>)object {
    if (self == object) {
        return YES;
    }

    if (![((NSObject *)object) isKindOfClass:[ListItem class]]) {
        return NO;
    }
    
    return [_uniqueKey isEqualToString:((ListItem *)object).uniqueKey];
}

@end
