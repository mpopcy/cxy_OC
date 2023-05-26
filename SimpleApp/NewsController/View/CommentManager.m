//
//  CommentManager.m
//  SimpleApp
//
//  Created by 崔雪瑶 on 2023/2/28.
//

#import "CommentManager.h"
#import <UIKit/UIKit.h>
#import "Screen.h"

@interface CommentManager()<UITextViewDelegate>

@property(nonatomic,strong,readwrite) UIView *backgroundView;
@property(nonatomic,strong,readwrite) UITextView *textView;

@end

@implementation CommentManager

+(CommentManager *)sharedManager{
    static CommentManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager=[[CommentManager alloc] init];
    });
    return manager;
}

-(instancetype)init{
    self=[super init];
    if(self){
        _backgroundView=[[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        _backgroundView.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
        //加一个gesture，点击时收起键盘
        [_backgroundView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_tapBackground)]];
        
        [_backgroundView addSubview:({
            _textView=[[UITextView alloc] initWithFrame:CGRectMake(0, _backgroundView.bounds.size.height, SCREEN_WIDTH, UI(100))];
            _textView.backgroundColor=[UIColor whiteColor];
            _textView.layer.borderColor=[UIColor lightGrayColor].CGColor;
            _textView.layer.borderWidth=5.f;
            _textView.delegate=self;
            _textView;
        })];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_doTextViewAnimationWithNocification:) name:UIKeyboardWillChangeFrameNotification object:nil];
        
    }
    return self;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - public method
-(void)showCommentView{
    [[UIApplication sharedApplication].keyWindow addSubview:_backgroundView];
    //弹出键盘
    [_textView becomeFirstResponder];
}

#pragma mark - tap gesture
-(void)_tapBackground{
    //收起键盘
    [_textView resignFirstResponder];
    [_backgroundView removeFromSuperview];
}

-(void)_doTextViewAnimationWithNocification:(NSNotification *)noti{
    CGFloat duration = [[noti.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGRect keyboardFrame = [[noti.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    if (keyboardFrame.origin.y >= SCREEN_HEIGHT) {
        //收起
        [UIView animateWithDuration:duration animations:^{
            self.textView.frame = CGRectMake(0, self.backgroundView.bounds.size.height, SCREEN_WIDTH, UI(100));
        }];
    }else{
        self.textView.frame = CGRectMake(0, self.backgroundView.bounds.size.height, SCREEN_WIDTH, UI(100));
        [UIView animateWithDuration:duration animations:^{
            self.textView.frame = CGRectMake(0, self.backgroundView.bounds.size.height - keyboardFrame.size.height - UI(100), SCREEN_WIDTH, UI(100));
        }];
    }
}

@end
