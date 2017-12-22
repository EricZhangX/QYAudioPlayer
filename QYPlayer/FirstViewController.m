//
//  FirstViewController.m
//  QYPlayer
//
//  Created by ylb on 2017/12/20.
//  Copyright © 2017年 YLB. All rights reserved.
//

#import "FirstViewController.h"
#import "SongsVC.h"
#import "QYPlayer.h"

@interface FirstViewController ()<QYPlayerDelegate>

@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet UIButton *playBtn;
@property (weak, nonatomic) IBOutlet UILabel *currentTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *songNameLabel;

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation FirstViewController {
    QYPlayer *_player;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupBackgroundLayer];
    
    _player = [QYPlayer defaultPlayer];
    _player.delegate = self;
    _player.songs = [QYMusicManager getLocalSongs];
    self.slider.continuous = NO;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"list"] style:UIBarButtonItemStylePlain target:self action:@selector(listBtnAction:)];

}

- (void)dealloc {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

#pragma mark  SetupUI

- (void)setupBackgroundLayer {
    UIImageView *backImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"back"]];
    backImageView.contentMode = UIViewContentModeScaleAspectFill;
    backImageView.frame = self.view.bounds;
    [self.view insertSubview:backImageView atIndex:0];
//    UIImage *backImage = [UIImage imageNamed:@"back"];
//    self.view.layer.contents = (id)backImage.CGImage;
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = self.view.bounds;
    [gradientLayer setColors:@[
                               (id)[UIColor colorWithWhite:0 alpha:.8].CGColor,
                               (id)[UIColor clearColor].CGColor
                               ]];
    gradientLayer.startPoint = CGPointMake(0, 0.6);
    gradientLayer.endPoint = CGPointMake(0, 1);
    backImageView.layer.mask = gradientLayer;
}

- (void)setupPlayBtnState:(PlayState)state {
    switch (state) {
        case PlayStatePlaying: {
            self.playBtn.selected = YES;
        }
            break;
        case PlayStatePause: {
            self.playBtn.selected = NO;
        }
            break;
        default:
            break;
    }
}

- (NSString *)getFormatTimeByInterval:(NSTimeInterval)duration {
    NSInteger mins = duration / 60;
    NSInteger seconds = (NSInteger)duration % 60;
    NSString *minStr = mins < 10 ? [NSString stringWithFormat:@"0%@",@(mins)] : [NSString stringWithFormat:@"%@",@(mins)];
    NSString *secindStr = seconds < 10 ? [NSString stringWithFormat:@"0%@",@(seconds)] : [NSString stringWithFormat:@"%@",@(seconds)];
    NSString *formatTime = [NSString stringWithFormat:@"%@:%@",minStr, secindStr];
    return formatTime;
}

#pragma mark - QYPlayerDelegate
- (void)player:(QYPlayer *)player loadSong:(NSString *)song totalTime:(NSTimeInterval)duration {
    self.songNameLabel.text = song;
    self.currentTimeLabel.text = [self getFormatTimeByInterval:0];
    self.totalTimeLabel.text = [self getFormatTimeByInterval:duration];
    self.slider.value = 0;
}

- (void)player:(QYPlayer *)player playingCurrentSong:(NSString *)song totalTime:(NSTimeInterval)duration currentTime:(NSTimeInterval)currentTime {
    self.currentTimeLabel.text = [self getFormatTimeByInterval:currentTime];
    float percent = currentTime / duration;
    self.slider.value = percent;
}

- (void)player:(QYPlayer *)player playStateChanged:(PlayState)state {
    [self setupPlayBtnState:state];
}

#pragma mark - Actions

- (void)listBtnAction:(id)sender {
    SongsVC *vc = [[SongsVC alloc] init];
    vc.songs = _player.songs;
    [self.navigationController pushViewController:vc animated:YES];
//    UIViewAnimationOptions options = UIViewAnimationOptionTransitionFlipFromRight;
//    [UIView transitionFromView:self.view toView:vc.view duration:1.f options:options completion:^(BOOL finished) {
//    }];
}

- (IBAction)sliderAction:(UISlider *)sender {
    [_player playCurrentSongPercent:sender.value];
}

- (IBAction)playBtnAction:(UIButton *)sender {
    if (_player.songs.count == 0) {
        return;
    }
    sender.selected = !sender.selected;
    if (sender.selected) {// 暂停
        [_player play];
    } else {
        [_player pause];
    }
}

- (IBAction)lastsongBtnAction:(id)sender {
    if (_player.songs.count == 0) {
        return;
    }
    [_player playLastSong];
}

- (IBAction)nextsongBtnAction:(id)sender {
    if (_player.songs.count == 0) {
        return;
    }
    [_player playNextSong];
}

@end















