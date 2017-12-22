//
//  QYMusicResoures.h
//  QYPlayer
//
//  Created by ylb on 2017/12/20.
//  Copyright © 2017年 YLB. All rights reserved.
//  音频文件管理

#import <Foundation/Foundation.h>

@interface QYMusicManager: NSObject

+ (NSArray *)getLocalSongs;

+ (NSData *)songDataByPath:(NSString *)path;


@end
