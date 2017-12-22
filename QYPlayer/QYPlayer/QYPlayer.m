//
//  QYPlayer.m
//  QYPlayer
//
//  Created by ylb on 2017/12/20.
//  Copyright © 2017年 YLB. All rights reserved.
//

#import "QYPlayer.h"
#import <AVFoundation/AVFoundation.h>

@interface QYPlayer () <AVAudioPlayerDelegate> {
    AVAudioPlayer *_player;
    NSInteger _currentIndex;
    NSString *_currentSong;
    NSTimeInterval _currentSongDuration;
    
    NSTimer *_timer;
}

@end



@implementation QYPlayer

+ (instancetype)defaultPlayer {
    static QYPlayer *player = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        player = [[QYPlayer alloc] init];
    });
    return player;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.f target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleInterreption:) name:AVAudioSessionInterruptionNotification object:[AVAudioSession sharedInstance]];
    }
    return self;
}

- (void)dealloc {
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)timerAction {
    if (_player && _player.isPlaying) {
        if ([self.delegate respondsToSelector:@selector(player:playingCurrentSong:totalTime:currentTime:)]) {
            [self.delegate player:self playingCurrentSong:_currentSong totalTime:_currentSongDuration currentTime:_player.currentTime];
        }
    }
}

//处理中断事件
-(void)handleInterreption:(NSNotification *)sender {
    NSLog(@"通知:%@",sender.userInfo);
}

- (void)setState:(PlayState)state {
    _state = state;
    if ([self.delegate respondsToSelector:@selector(player:playStateChanged:)]) {
        [self.delegate player:self playStateChanged:_state];
    }
}


#pragma mark - Methods

- (void)playSongs:(NSArray *)songs byIndex:(NSInteger)index {
    
    if (songs.count) {
        self.songs = songs;
    } else {
        if (!self.songs) {
            return;
        }
    }
    _currentIndex = index? index : 0;
    [self newPlay];
}

- (void)play {
    if (!_player) {
        _player = [self createPlayer];
    }
    if (!_player.isPlaying) {
        [_player play];
        self.state = PlayStatePlaying;
    }
}

- (void)newPlay {
    _player = [self createPlayer];
    if (_player) {
        [_player play];
        self.state = PlayStatePlaying;
    }
}

- (void)pause {
    if (_player.isPlaying) {
        [_player pause];
        self.state = PlayStatePause;
    }
}

- (void)stop {
    [_player stop];
}

- (void)playLastSong {
    switch (self.repeatType) {
        case RepeatTypeRandom: {
            // 获取一个随机数
            NSInteger randomIndex = 0;
            do {
                randomIndex = random() % self.songs.count;
            } while (_currentIndex != randomIndex);
            _currentIndex = randomIndex;
        }
            break;
        default: {
            if (_currentIndex > 0) {
                _currentIndex --;
            } else {
                _currentIndex = self.songs.count - 1;
            }
        }
            break;
    }
    [self stop];
    [self newPlay];
}

- (void)playNextSong {
    switch (self.repeatType) {
        case RepeatTypeRandom: {
            // 获取一个随机数
            NSInteger randomIndex = 0;
            do {
                randomIndex = random() % self.songs.count;
            } while (_currentIndex != randomIndex);
            _currentIndex = randomIndex;
        }
            break;
        default: {
            if (_currentIndex < (self.songs.count - 1)) {
                _currentIndex ++;
            } else {
                _currentIndex = 0;
            }
        }
            break;
    }
    [self stop];
    [self newPlay];
}

- (void)playCurrentSongPercent:(float)percent {
    _player.currentTime = _currentSongDuration * percent;
}

- (AVAudioPlayer *)createPlayer{
    NSString *path = self.songs[_currentIndex];
    
    NSURL *url = [NSURL fileURLWithPath:path];
    NSError *error = nil;
    AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    
    if (error) {
        NSLog(@"播放器创建错误:%@",error);
        return nil;
    }
    player.delegate = self;
    [player prepareToPlay];//加载到缓存
    NSArray *arr = [path componentsSeparatedByString:@"/"];
    NSString *name = [arr lastObject];
    _currentSong = [name stringByReplacingOccurrencesOfString:@".mp3" withString:@""];
    _currentSongDuration = player.duration;
    NSLog(@"--歌曲名--<<%@>>",_currentSong);
    if ([self.delegate respondsToSelector:@selector(player:loadSong:totalTime:)]) {
        [self.delegate player:self loadSong:_currentSong totalTime:_currentSongDuration];
    }
    return player;
}

#pragma mark - AVAudioPlayerDelegate
/* audioPlayerDidFinishPlaying:successfully: is called when a sound has finished playing. This method is NOT called if the player is stopped due to an interruption. */
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    self.state = PlayStatePause;
    if (flag) { // 播放完成并成功
        switch (self.repeatType) {
            case RepeatTypeSequentialS: {
                if (_currentIndex < (self.songs.count - 1)) {
                    _currentIndex ++;
                } else {
                    _currentIndex = 0;
                }
            }
                break;
            case RepeatTypeOneSong: {
            }
                break;
            case RepeatTypeRandom: {
                // 获取一个随机数
                NSInteger randomIndex = 0;
                do {
                    randomIndex = random() % self.songs.count;
                } while (_currentIndex != randomIndex);
                _currentIndex = randomIndex;
            }
                break;
            default:
                break;
        }
        [self newPlay];
        
    } else {
        
    }
}

/* if an error occurs while decoding it will be reported to the delegate. */
- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError * __nullable)error {
    
}

@end






















