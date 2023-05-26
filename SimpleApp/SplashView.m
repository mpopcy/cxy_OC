//
//  SplashView.m
//  SimpleApp
//
//  Created by 崔雪瑶 on 2023/2/24.
//  闪屏，广告位，有一个按钮可以点击关闭闪屏

#import "SplashView.h"

@interface SplashView()

@property(nonatomic,strong,readwrite) UIButton *button;

@end

@implementation SplashView

-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if(self){
        self.image=[UIImage imageNamed:@"icon.bundle/splash.png"];
        [self addSubview:({
            _button=[[UIButton alloc] initWithFrame:CGRectMake(330, 100, 60, 40)];
            _button.backgroundColor=[UIColor lightGrayColor];
            [_button setTitle:@"跳过" forState:UIControlStateNormal];
            //增加点击事件，点击后移除当前页面，闪屏消失
            [_button addTarget:self action:@selector(_removeSplashView) forControlEvents:UIControlEventTouchUpInside];
            _button;
        })];
        //该闪屏是一个UIimage，因此要额外设置其可以点击交互
        self.userInteractionEnabled=YES;
    }
    return self;
}

-(void)_removeSplashView{
    [self removeFromSuperview];
}

@end
