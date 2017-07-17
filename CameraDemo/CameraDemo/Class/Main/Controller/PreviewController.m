//
//  PreviewController.m
//  CameraDemo
//
//  Created by Pisces on 2017/7/17.
//  Copyright © 2017年 Pisces. All rights reserved.
//

#import "PreviewController.h"
#import <AVFoundation/AVFoundation.h>
@interface PreviewController ()

@property (strong, nonatomic) AVPlayer *player; //播放器

@property (strong, nonatomic) AVPlayerItem *playItem; //播放单元

@property (strong, nonatomic) AVPlayerLayer *playerLayer; //播放界面

@end

@implementation PreviewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    

    
}

- (void)setUrl:(NSURL *)url {
    _url = url;
    NSString *str = [NSString stringWithFormat:@"%@",url];
    NSURL *fileUrl = [NSURL fileURLWithPath:str];
    self.playItem = [AVPlayerItem playerItemWithURL:fileUrl];

    [self.view.layer addSublayer:self.playerLayer];
    [self.player play];
}


- (AVPlayerLayer *)playerLayer {
    if (_playerLayer == nil) {
        _playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
        _playerLayer.frame = self.view.layer.bounds;
    }
    return _playerLayer;
}

- (AVPlayer *)player {
    if (_player == nil) {
        _player = [AVPlayer playerWithPlayerItem:self.playItem];
    }
    return _player;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
