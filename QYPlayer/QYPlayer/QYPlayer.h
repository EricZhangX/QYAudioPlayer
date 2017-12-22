//
//  QYPlayer.h
//  QYPlayer
//
//  Created by ylb on 2017/12/20.
//  Copyright © 2017年 YLB. All rights reserved.
//  音乐播放控制器

#import <Foundation/Foundation.h>
#import "QYMusicManager.h"
/**
 循环模式
 
 - RepeatTypeSequentialS: 顺序播放
 - RepeatTypeOneSong: 单曲循环
 - RepeatTypeRandom: 随机播放
 */
typedef NS_ENUM(NSInteger, RepeatType) {
    RepeatTypeSequentialS = 0,
    RepeatTypeOneSong,
    RepeatTypeRandom
};

typedef NS_ENUM(NSInteger, PlayState) {
    PlayStatePause = 0,
    PlayStatePlaying
};


@class QYPlayer;
@protocol QYPlayerDelegate<NSObject>

@optional
- (void)player:(QYPlayer *)player loadSong:(NSString *)song totalTime:(NSTimeInterval)duration;

- (void)player:(QYPlayer *)player playingCurrentSong:(NSString *)song totalTime:(NSTimeInterval)duration currentTime:(NSTimeInterval)currentTime;

- (void)player:(QYPlayer *)player playStateChanged:(PlayState)state;

@end



@interface QYPlayer : NSObject

@property (nonatomic, weak) id<QYPlayerDelegate> delegate;
@property (nonatomic, strong) NSArray *songs;
@property (nonatomic, assign) RepeatType repeatType;
@property (nonatomic, assign) PlayState state;

+ (instancetype)defaultPlayer;

/**
 播放音乐列表

 @param songs 音乐列表
 @param index 要播放的音乐在列表中的位置
 */
- (void)playSongs:(NSArray *)songs byIndex:(NSInteger)index;

/**
 播放
 */
- (void)play;

/**
 暂停
 */
- (void)pause;

/**
 停止
 */
- (void)stop;

- (void)playLastSong;

- (void)playNextSong;

- (void)playCurrentSongPercent:(float)percent;


@end





























