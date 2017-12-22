//
//  QYMusicResoures.m
//  QYPlayer
//
//  Created by ylb on 2017/12/20.
//  Copyright © 2017年 YLB. All rights reserved.
//

#import "QYMusicManager.h"

@implementation QYMusicManager

+ (NSArray *)getLocalSongs {
    NSArray *arr = [[NSBundle mainBundle] pathsForResourcesOfType:@"mp3" inDirectory:@"music"];
    return arr;
}

//+ (NSArray *)getLocalSongs {
//
//    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"songs" ofType:@"bundle"];
//    NSLog(@"songs = %@",bundlePath);
//
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    NSError *error = nil;
//    NSArray *songs = [fileManager contentsOfDirectoryAtPath:bundlePath error:&error];
//    if (error) {
//        NSLog(@"error = %@",error);
//    } else {
//        NSLog(@"resources = %@",songs);
//    }
//    return songs;
//}

+ (NSData *)songDataByPath:(NSString *)path {
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"songs" ofType:@"bundle"];
    NSBundle *songsBundle = [NSBundle bundleWithPath:bundlePath];
    path = [path substringToIndex:path.length - 4];
    NSLog(@"歌名:%@",path);
    NSURL *songUrl = [songsBundle URLForResource:path withExtension:@"mp3"];
    NSData *songData = [NSData dataWithContentsOfURL:songUrl];
    return songData;
}
@end
