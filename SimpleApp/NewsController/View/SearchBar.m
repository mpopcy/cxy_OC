//
//  SearchBar.m
//  SimpleApp
//
//  Created by 崔雪瑶 on 2023/2/28.
//

#import "SearchBar.h"
#import "Screen.h"

@interface SearchBar()<UITextFieldDelegate>

@property(nonatomic,strong,readwrite) UITextField *textField;

@end

@implementation SearchBar

-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if(self){
        [self addSubview:({
            _textField=[[UITextField alloc] initWithFrame:CGRectMake(UI(10), UI(5), frame.size.width-UI(10)*2, frame.size.height-UI(5)*2)];
            _textField.backgroundColor=[UIColor whiteColor];
            _textField.delegate=self;
            _textField.leftView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Search"]];
            _textField.leftViewMode=UITextFieldViewModeUnlessEditing;
            _textField.clearButtonMode=UITextFieldViewModeAlways;
            _textField.placeholder=@" 今日热点推荐";
            _textField;
        })];
    }
    return self;
}

#pragma mark - delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    //开始编辑
    [_textField becomeFirstResponder];
    NSLog(@"begin");
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    //结束编辑
    NSLog(@"end");
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    //输入的文字变化时
    //做一些字数判断等业务逻辑
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    //点击return时
    //收起键盘
    [_textField resignFirstResponder];
    return YES;
}
@end
