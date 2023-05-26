//
//  VideoPlayer.m
//  SimpleApp
//
//  Created by 崔雪瑶 on 2023/2/21.
//

#import "VideoPlayer.h"
#import <AVFoundation/AVFoundation.h>

@interface VideoPlayer()

//视频播放完成后需要将播放器从cell移除，因此将播放器作为一个属性
@property(nonatomic,strong,readwrite) AVPlayerItem *videoItem;
@property(nonatomic,strong,readwrite) AVPlayer *avPlayer;
@property(nonatomic,strong,readwrite) AVPlayerLayer *playerLayer;

@end

@implementation VideoPlayer

+(VideoPlayer *)Player{
    //使用GCD中的dispatch实现单例
    static VideoPlayer *player;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        player=[[VideoPlayer alloc] init];
    });
    return player;
}

-(void)playWithVideoUrl:(NSString *)videoUrl attachView:(UIView *)attachView{
    
    //为保证全局只有一个播放器，每次播放前将原来的销毁掉
    [self _stopPlay];
    
    NSURL *videoURL=[NSURL URLWithString:videoUrl];
    //asset持有的是一些视频资源属性的变量
    AVAsset *asset=[AVAsset assetWithURL:videoURL];
    //avPlayerItem可以封装一个asset也可以直接封装一个URL
    _videoItem=[AVPlayerItem playerItemWithAsset:asset];
    //对videoItem的播放状态属性进行监听，使用KVO即可
    [_videoItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    //监听其缓冲进度,loadedTimeRanges
    [_videoItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
    //获取videoItem的时长并转换为秒
    CMTime duration=_videoItem.duration;
    CGFloat videoDuration=CMTimeGetSeconds(duration);
    
    //avPlayer可以封装一个playerItem也可以直接封装一个URL
    _avPlayer=[AVPlayer playerWithPlayerItem:_videoItem];
    //通过avPlayer监听播放状态
    [_avPlayer addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:dispatch_get_main_queue() usingBlock:^(CMTime time){
        NSLog(@"播放进度：%@",@(CMTimeGetSeconds(time)));
    }];
    
    //通过player获取playerLayer（视频播放的画面），再将layer粘到当前页面的layer上
    //playerLayer只提供画面的展示，不会响应用户的操作
    _playerLayer=[AVPlayerLayer playerLayerWithPlayer:_avPlayer];
    //调整其大小
    _playerLayer.frame=attachView.bounds;
    [attachView.layer addSublayer:_playerLayer];
    
    //向notification的center注册需要监听的事件，注册的是一个单例化管理，生命周期是整个APP的生命周期，因此在本类销毁时，要将self从单例中移除
    //参数name是需要监听的事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_hundlePlayEnd) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    
    NSLog(@"player play");
}

//点击手势的响应函数
-(void)_stopPlay{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [_playerLayer removeFromSuperlayer];
    
    //在每次停止播放时移除监听
    [_videoItem removeObserver:self forKeyPath:@"status"];
    [_videoItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
    
    _videoItem=nil;
    _avPlayer=nil;
}

//notification center selector的方法
//视频播放完成后执行该方法，移除播放器
-(void)_hundlePlayEnd{
    
    //视频播放完成后，回到视频最开始重新播放
    [_avPlayer seekToTime:CMTimeMake(0, 1)];
    [_avPlayer play];
    
    NSLog(@"hundleToPlay");
}

#pragma mark - KVO
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    //判断keyPath是否为监听的status
    if([keyPath isEqualToString:@"status"]){
        //avPlayerItem的status有三种，未知、准备播放、播放失败
        if(((NSNumber *)[change objectForKey:NSKeyValueChangeNewKey]).integerValue == AVPlayerItemStatusReadyToPlay){
            [_avPlayer play];
        }else{
            NSLog(@"video play failed");
        }
    }else if ([keyPath isEqualToString:@"loadedTimeRanges"]){
        NSLog(@"缓冲：%@",[change objectForKey:NSKeyValueChangeNewKey]);
    }
}

@end
