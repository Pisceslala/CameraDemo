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

@property (strong, nonatomic) UIProgressView *progressView;

@property (strong, nonatomic) UIButton *enterBtn;


@end

@implementation PreviewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    

    
    //http://www.jxvdy.com/file/upload/201405/05/18-24-58-42-627.mp4
}

- (void)setUrl:(NSURL *)url {
    _url = url;
    
    self.playItem = [AVPlayerItem playerItemWithURL:url];
    
    if([[UIDevice currentDevice] systemVersion].intValue>=10){
        //      增加下面这行可以解决iOS10兼容性问题了
        self.player.automaticallyWaitsToMinimizeStalling = NO;
    }
    
    [self.playItem addObserver:self forKeyPath:@"status" options:(NSKeyValueObservingOptionNew) context:nil]; // 观察status属性，

    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.view.layer addSublayer:self.playerLayer];
        
    });
    
    
    NSLog(@"%zd",self.playItem.status);
    
    
}


#pragma mark - 添加进度条
-(void)addProgressObserver{
    
    AVPlayerItem *playerItem = self.player.currentItem;
    
    UIProgressView *progress = [[UIProgressView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.view.frame) - 20, self.view.frame.size.width, 5)]; //这里设置每秒执行一次
    
    self.progressView = progress;
    
    progress.progressTintColor = [UIColor greenColor];
    
    [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 100.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
    
        float current=CMTimeGetSeconds(time);
        
        float total=CMTimeGetSeconds([playerItem duration]);
        
        if (current) {
        
            [progress setProgress:(current/total) animated:NO];
        }
        
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
}



- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
//AVPlayerItem *item = (AVPlayerItem *)object;
    if ([keyPath isEqualToString:@"status"]) {
        //获取更改后的状态
        AVPlayerStatus status = [[change objectForKey:@"new"] intValue];
        if (status == AVPlayerStatusReadyToPlay) {
  //          CMTime duration = item.duration; // 获取视频长度
            
            [self addProgressObserver];
            [self.view addSubview:self.progressView];
            [self.view addSubview:self.enterBtn];

            // 播放
            [self.player play];
        } else if (status == AVPlayerStatusFailed) {
            NSLog(@"AVPlayerStatusFailed");
        } else {
            NSLog(@"AVPlayerStatusUnknown");
        }
    } else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
        
    }
}


-(void)playbackFinished:(NSNotification *)notification{
    // 播放完成后重复播放
    // 跳到最新的时间点开始播放
    [_player seekToTime:CMTimeMake(0, 1)];
    [_player play];
}



#pragma mark - GET
- (AVPlayerLayer *)playerLayer {
    if (_playerLayer == nil) {
        _playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
        _playerLayer.frame = self.view.layer.bounds;
        _playerLayer.videoGravity=AVLayerVideoGravityResizeAspectFill;
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

- (UIButton *)enterBtn {
    if (_enterBtn == nil) {
        _enterBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.center.x - 32, CGRectGetMaxY(self.progressView.frame) - 80, 64, 64)];
        [_enterBtn setImage:[UIImage imageNamed:@"确定"] forState:UIControlStateNormal];
        [_enterBtn setImage:[UIImage imageNamed:@"确定_select"] forState:UIControlStateHighlighted];
        [_enterBtn addTarget:self action:@selector(dismissControllers) forControlEvents:UIControlEventTouchUpInside];
    }
    return _enterBtn;
}

- (void)dismissControllers {
    __weak typeof(self)weakSelf = self;
    weakSelf.dismissController();
    [weakSelf.player pause];
    
}

@end
