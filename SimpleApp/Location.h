//
//  Location.h
//  SimpleApp
//
//  Created by 崔雪瑶 on 2023/2/26.
//

#import <Foundation/Foundation.h>

//APP中统一的位置信息管理
NS_ASSUME_NONNULL_BEGIN

@interface Location : NSObject

+(Location *)locationManager;

-(void)checkLocationAuthorization;

@end

NS_ASSUME_NONNULL_END
