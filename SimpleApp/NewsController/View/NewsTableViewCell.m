//
//  NewsTableViewCell.m
//  SimpleApp
//
//  Created by 崔雪瑶 on 2023/2/17.
//

#import "NewsTableViewCell.h"
#import "ListItem.h"
#import <SDWebImage.h>
#import "Screen.h"

@interface NewsTableViewCell ()

//每个cell中的几个UIlabel
@property(nonatomic,strong,readwrite) UILabel *titleLabel;
@property(nonatomic,strong,readwrite) UILabel *sourceLabel;
@property(nonatomic,strong,readwrite) UILabel *commentLabel;
@property(nonatomic,strong,readwrite) UILabel *timeLabel;

@property(nonatomic,strong,readwrite) UIImageView *rightImageView;

@property(nonatomic,strong,readwrite) UIButton *delButton;

@end

@implementation NewsTableViewCell

//重写初始化方法
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        //在初始化时将几个label粘到UIContentView(cell的superView)中
        [self.contentView addSubview:({
            self.titleLabel=[[UILabel alloc] initWithFrame:UIRect(20, 15, 270, 50)];
//            self.titleLabel.backgroundColor=[UIColor redColor];
            self.titleLabel.font=[UIFont systemFontOfSize:16];
            self.titleLabel.textColor=[UIColor blackColor];
            self.titleLabel.numberOfLines=2;
            self.titleLabel.lineBreakMode=NSLineBreakByTruncatingTail;
            self.titleLabel;
        })];
        
        [self.contentView addSubview:({
            self.sourceLabel=[[UILabel alloc] initWithFrame:UIRect(20, 70, 50, 20)];
//            self.sourceLabel.backgroundColor=[UIColor redColor];
            self.sourceLabel.font=[UIFont systemFontOfSize:12];
            self.sourceLabel.textColor=[UIColor blackColor];
            self.sourceLabel;
        })];
        
        [self.contentView addSubview:({
            self.commentLabel=[[UILabel alloc] initWithFrame:UIRect(80, 70, 50, 20)];
//            self.commentLabel.backgroundColor=[UIColor redColor];
            self.commentLabel.font=[UIFont systemFontOfSize:12];
            self.commentLabel.textColor=[UIColor blackColor];
            self.commentLabel;
        })];
        
        [self.contentView addSubview:({
            self.timeLabel=[[UILabel alloc] initWithFrame:UIRect(140, 70, 50, 20)];
//            self.timeLabel.backgroundColor=[UIColor redColor];
            self.timeLabel.font=[UIFont systemFontOfSize:12];
            self.timeLabel.textColor=[UIColor blackColor];
            self.timeLabel;
        })];
        
        [self.contentView addSubview:({
            self.rightImageView=[[UIImageView alloc] initWithFrame:UIRect(300, 10, 90, 60)];
//            self.rightImageView.backgroundColor=[UIColor redColor];
//            self.rightImageView.contentMode=UIViewContentModeScaleAspectFit;
            self.rightImageView;
        })];
        
//        [self.contentView addSubview:({
//            self.delButton=[[UIButton alloc] initWithFrame:UIRect(290, 80, 30, 20)];
//            [self.delButton setTitle:@"X" forState:UIControlStateNormal];
//            [self.delButton setTitle:@"H" forState:UIControlStateHighlighted];
//            //点击按钮，就会调用delButtonClick方法
//            [self.delButton addTarget:self action:@selector(_delButtonClick) forControlEvents:UIControlEventTouchUpInside];
//
//            //通过CALayer设置圆角和边界
//            self.delButton.layer.cornerRadius=10;
//            self.delButton.layer.masksToBounds=YES;
//            self.delButton.layer.borderColor=[UIColor lightGrayColor].CGColor;
//            self.delButton.layer.borderWidth=2;
//            self.delButton;
//        })];
    }
    return self;
}

-(void)layoutTableViewCellWithItem:(ListItem *)item{
    //如果文章状态已读：通过设置的key获取已读状态标记位
    BOOL hasRead=[[NSUserDefaults standardUserDefaults] boolForKey:item.title];
//    BOOL hasRead=NO;
    if(hasRead){
        self.titleLabel.textColor=[UIColor lightGrayColor];
    }else{
        self.titleLabel.textColor=[UIColor blackColor];
    }
    
    self.titleLabel.text=item.title;
    
    self.sourceLabel.text=item.authorName;
    [self.sourceLabel sizeToFit];
    
    self.commentLabel.text=item.category;
    [self.commentLabel sizeToFit];
    self.commentLabel.frame=CGRectMake(self.sourceLabel.frame.origin.x + self.sourceLabel.frame.size.width +UI(15), self.commentLabel.frame.origin.y, self.commentLabel.frame.size.width, self.commentLabel.frame.size.height);
    
    self.timeLabel.text=item.date;
    [self.timeLabel sizeToFit];
    self.timeLabel.frame=CGRectMake(self.commentLabel.frame.origin.x + self.commentLabel.frame.size.width +UI(15), self.timeLabel.frame.origin.y, self.timeLabel.frame.size.width, self.timeLabel.frame.size.height);
   
//#warning
    //    self.rightImageView.image=[UIImage imageNamed:@"icon.bundle/icon.png"];
    //在主线程通过网络拉取图片会造成卡顿失帧
//    UIImage *image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:item.picUrl]]];
//    self.rightImageView.image=image;
    
    
    //使用block的方式创建自定义线程
//    NSThread *downloadImageThread=[[NSThread alloc] initWithBlock:^{
//        //会提示UI操作应该放在主线程中
//        UIImage *image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:item.picUrl]]];
//        self.rightImageView.image=image;
//    }];
//    downloadImageThread.name=@"downloadImageThread";
//    [downloadImageThread start];
    
    
    //使用GCD加载并展示图片，加载图片在非主线程，展示图片（UI操作）在主线程
    //先取一个系统提供的global队列，优先级设为default，再获取主队列
//    dispatch_queue_global_t downloadQueue=dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    dispatch_queue_main_t mainQueue=dispatch_get_main_queue();
//
//    //将从网络获取图片资源的操作放进非主队列的block中
//    dispatch_async(downloadQueue, ^{
//        UIImage *image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:item.picUrl]]];
//        //将image渲染到self的view上，通过主队列进行该操作
//        dispatch_async(mainQueue, ^{
//            self.rightImageView.image=image;
//        });
//    });
    
    
    //使用SDWebImage加载图片url
    [self.rightImageView sd_setImageWithURL:[NSURL URLWithString:item.picUrl] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL){
            NSLog(@ "SDWebImage");
    }];
    
    
    
}

-(void)_delButtonClick{
    //判断self是否有delegate，是否实现了tableViewCell:clickDelButton:方法，再调用该函数
    if(self.delegate && [self.delegate respondsToSelector:@selector(tableViewCell:clickDelButton:)]){
        [self.delegate tableViewCell:self clickDelButton:self.delButton];
    }
}

@end
