//
//  DelCellView.m
//  SimpleApp
//
//  Created by 崔雪瑶 on 2023/2/18.
//  点击news cell中的delButton后，弹出该view

#import "DelCellView.h"

@interface DelCellView ()

//两个子view
//背景view
@property(nonatomic,strong,readwrite) UIView *backgroundView;
//
@property(nonatomic,strong,readwrite) UIButton *delButton;

@property(nonatomic,copy,readwrite) dispatch_block_t delBlock;
@end

@implementation DelCellView

-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if(self){
        [self addSubview:({
            _backgroundView=[[UIView alloc] initWithFrame:self.bounds];
            //给_backgroundView增加点击手势，点击背景view调用dismiss函数，view消失
            [_backgroundView addGestureRecognizer:({
                UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissDelView)];
                tapGesture;
            })];
            _backgroundView.backgroundColor=[UIColor blackColor];
            _backgroundView.alpha=0.5;
            _backgroundView;
        })];
        
        [self addSubview:({
            _delButton=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
            [_delButton addTarget:self action:@selector(_clickButton) forControlEvents:UIControlEventTouchUpInside];
            _delButton.backgroundColor=[UIColor blueColor];
            _delButton;
        })];
    }
    return self;
}

//该view何时出现何时消失的两个函数
-(void)showDelViewFromPoint:(CGPoint)point clickBlock:(dispatch_block_t) clickBlock{
    _delButton.frame=CGRectMake(point.x, point.y, 0, 0);
    //在点击时，持有参数中的block
    _delBlock=[clickBlock copy];
    
    //想要实现一个较为通用的组件，使该view不受其他view和controller的影响，要将该view添加到window中
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    //增加视图出现时的动画，从初始位置经过1s移动至结束位置
    //动画1
//    [UIView animateWithDuration:1.f animations:^{
//        self.delButton.frame=CGRectMake((self.bounds.size.width-200)/2, (self.bounds.size.height-200)/2, 200, 200);
//    }];
    //动画2
    [UIView animateWithDuration:1.f delay:0.f usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.delButton.frame=CGRectMake((self.bounds.size.width-200)/2, (self.bounds.size.height-200)/2, 200, 200);
    } completion:^(BOOL finished){
        NSLog(@"动画2");
    }];
}
-(void)dismissDelView{
    [self removeFromSuperview];
}

//点击delButton执行函数
-(void)_clickButton{
    
    //通过block将点击button的信息传递给cell->给show方法加上block参数
    //再点击delButton时执行block
    if(_delBlock){
        _delBlock();
    }
    [self removeFromSuperview];
}

@end
