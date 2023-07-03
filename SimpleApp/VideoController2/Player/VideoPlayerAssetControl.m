//
//  VideoPlayerAssetControl.m
//  SimpleApp
//
//  Created by 崔雪瑶 on 2023/6/19.
//

#import "VideoPlayerAssetControl.h"

static void *PlayerStatusContext = &PlayerStatusContext;
static void *ItemStatusContext = &ItemStatusContext;

@implementation VideoPlayerAssetControl {
    AVPlayer *_player;
    AVPlayerItem *_playerItem;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _player = [[AVPlayer alloc] init];
        [_player addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:PlayerStatusContext];//NSKeyValueObservingOptionNew是指把更改之前的值提供给处理方法，context上下文是可以带上的任何类型的参数
    }
    
    return self;
}

//将进度条显示的进度调整到传进来的时间参数
- (void)setCurrentTime:(float)currentTime {
    CMTime newTime = CMTimeMakeWithSeconds(currentTime, 1);
    [_player seekToTime:newTime toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];//将播放光标移动到指定时间，时间误差在time-toleranceBefore和time+toleranceAfter之间
}

//播放速率的set方法
- (void)setRate:(float)rate {
    [_player setRate:rate];
}

//播放速率的get方法
- (float)getRate {
    return [_player rate];
}

//获取当前player的item的视频总时长
- (float)getDuration {
    if (_player.currentItem == nil) return 0;//item为空，没有视频，返回0
    return CMTimeGetSeconds([_player.currentItem duration]);//返回player当前item的总时长（秒数）
}

//reset，把player和playerItem的观察者都移除掉，将二者置为nil
- (void)reset {
    if (_playerItem != nil) {
        [_playerItem removeObserver:self forKeyPath:@"status" context:ItemStatusContext];
        _playerItem = nil;
    }
    
    if (_player != nil) {
        [_player removeObserver:self forKeyPath:@"status" context:PlayerStatusContext];
        _player = nil;
    }
}

#pragma mark - Asset Control

//什么时候调用？
- (void)setVideoAsset:(AVAsset *)asset {
    if (_playerItem != nil) {
        [_playerItem removeObserver:self forKeyPath:@"status" context:ItemStatusContext];
    }
    
    if (asset != nil) {
        _playerItem = [AVPlayerItem playerItemWithAsset:asset];//利用传进来的asset创建playerItem
        [_playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:ItemStatusContext];
        [_player replaceCurrentItemWithPlayerItem:_playerItem];//将新创建的playerItem赋给player
    } else {//传进来的asset为空时，player的item和playerItem也都置为nil
        _playerItem = nil;
        [_player replaceCurrentItemWithPlayerItem:nil];
    }
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
                        change:(NSDictionary *)change context:(void *)context {
    
    if (context == ItemStatusContext) {//如果监听的是item的状态，判断player状态是否是ready
        if (_player.status == AVPlayerStatusReadyToPlay) {
            if (_delegate != nil) {
                [_delegate videoReadyToPlay:_player];//delegate不为空时，设置当前player为readyToPlayer状态
            }
        }
    } else if(context == PlayerStatusContext) {//如果监听的是player的状态（？）
        if (_delegate != nil) {
            [_delegate currentVideoDidChange:_player];//delegate不为空时，将当前player设置为调用方的playerLayer的player，以进行后续播放操作
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

@end
