//
//  Location.m
//  SimpleApp
//
//  Created by 崔雪瑶 on 2023/2/26.
//

#import "Location.h"
#import <CoreLocation/CoreLocation.h>

@interface Location()<CLLocationManagerDelegate>

@property(nonatomic,strong,readwrite) CLLocationManager *manager;

@end

@implementation Location

//全局统一管理->实现成单例模式
+(Location *)locationManager{
    static Location *location;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        location=[[Location alloc] init];
    });
    return location;
}

-(instancetype)init{
    self=[super init];
    if(self){
        self.manager=[[CLLocationManager alloc] init];
        self.manager.delegate=self;
    }
    return self;
}

//在APP启动时判断是否获取位置权限
-(void)checkLocationAuthorization{
    //判断系统是否开启位置权限
    if(![CLLocationManager locationServicesEnabled]){
        //如果未开启，引导弹窗
    }
    //如果开启了，判断本APP是否指定开启多少权限
    //如果是未指定状态：
    if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusNotDetermined){
        //设置在使用APP期间能获取指定位置
        [self.manager requestWhenInUseAuthorization];
    }
    
}

#pragma mark - delegate
//改变授权状态的回调
-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    if(status==kCLAuthorizationStatusAuthorizedWhenInUse){
        //如果已授权，发起地理位置信息请求，获取成功或失败，都会通过delegate回调给self
        [self.manager startUpdatingLocation];
    }else if (status==kCLAuthorizationStatusDenied){
        //
    }
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    //地理信息
    CLLocation *location=[locations firstObject];
    CLGeocoder *coder=[[CLGeocoder alloc] init];
    
    [coder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error){
        //地标信息
    }];
    
    [self.manager stopUpdatingLocation];
}

@end
