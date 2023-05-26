//
//  VideoCoverView.m
//  SimpleApp
//
//  Created by 崔雪瑶 on 2023/2/20.
//  展示一张占位图、播放按钮，点击cell播放视频

#import "VideoCoverView.h"
#import <AVFoundation/AVFoundation.h>
#import "VideoPlayer.h"
#import "VideoToolBar.h"

//
@interface VideoCoverView()<UIGestureRecognizerDelegate>

@property(nonatomic,strong,readwrite) UIImageView *coverView;
@property(nonatomic,strong,readwrite) UIImageView *playButton;
@property(nonatomic,copy,readwrite) NSString *videoUrl;
@property(nonatomic,copy,readwrite) VideoToolBar *toolBar;

@end

@implementation VideoCoverView

-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if(self){
        //初始化时在cell中加入coverView和playButton
        [self addSubview:({
            _coverView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height - VideoToolBarHeight)];
//            UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_tapToPlay)];
//            tapGesture.delegate=self;
//            [_coverView addGestureRecognizer:tapGesture];
            _coverView;
        })];
        
        //如果将播放按钮粘贴在self上，则视频播放过程中按钮也会一直显示在中间
        [_coverView addSubview:({
            _playButton=[[UIImageView alloc] initWithFrame:CGRectMake((frame.size.width-50)/2, (frame.size.height - VideoToolBarHeight - 50)/2, 50, 50)];
            _playButton.image=[UIImage imageNamed:@"icon.bundle/bofang_play@2x.png"];
            _playButton;
        })];
        
        [self addSubview:({
            _toolBar=[[VideoToolBar alloc] initWithFrame:CGRectMake(0, _coverView.bounds.size.height, frame.size.width, VideoToolBarHeight)];
        })];
        
        //给整个cell添加一个手势以响应点击
        UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_tapToPlay)];
        [self addGestureRecognizer:tapGesture];
        
        
        
    }
    return self;
}

-(void)dealloc{
    
    
    
}

#pragma mark - public method
//
-(void)layoutWithVideoCoverUrl:(NSString *)videoCoverUrl videoUrl:(NSString *)videoUrl{
    _coverView.image=[UIImage imageNamed:videoCoverUrl];
//    _playButton.image=[UIImage imageNamed:@"icon.bundle/bofang_play@3x.png"];
    _videoUrl=videoUrl;
    //在布局视频播放页面时，layouttoolBar，由于是假数据，model用nil代替
    [_toolBar layoutWithModel:nil];
}

#pragma mark - private method

-(void)_tapToPlay{
//    NSURL *videoURL=[NSURL URLWithString:_videoUrl];
    //每次播放只需调用player单例，单例调用播放视频，同时传入承载播放器画面的view即可
    [[VideoPlayer Player] playWithVideoUrl:_videoUrl attachView:_coverView];
}

@end
