//
//  Screen.m
//  SimpleApp
//
//  Created by 崔雪瑶 on 2023/2/23.
//  根据获取的屏幕尺寸进行适配

#import "Screen.h"

@implementation Screen

//iphone xs max
+(CGSize)sizeFor65Inch{
    return CGSizeMake(414, 896);
}
//iphone xr
+(CGSize)sizeFor61Inch{
    return CGSizeMake(414, 896);
}
//iphone x
+(CGSize)sizeFor58Inch{
    return CGSizeMake(375, 812);
}

@end
