//
//  BottomView.m
//  CameraDemo
//
//  Created by Pisces on 2017/7/17.
//  Copyright © 2017年 Pisces. All rights reserved.
//

#import "BottomView.h"
#import "VideoTools.h"
#import "VideoProcessView.h"

#define kVideoMaxTime 10.0

@interface BottomView ()

@property (strong, nonatomic) VideoTools *tools;

@property (strong, nonatomic) UIButton *camareBtn;

@property (strong, nonatomic) UIButton *dismissBtn;

@property (strong, nonatomic) VideoProcessView *processView;

@property (nonatomic, assign) CGFloat timeCount;
@property (nonatomic, assign) CGFloat timeMargin;

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation BottomView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self configViews];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self configViews];
    }
    return self;
}

- (instancetype)init {
    if (self = [super init]) {
        [self configViews];
    }
    return self;
}

- (void)configViews {
    [self addSubview:self.camareBtn];
    self.processView.center = self.camareBtn.center;
    [self addSubview:self.processView];
    [self addSubview:self.dismissBtn];
}

//开始录制
- (void)startCameraRecording {
    __weak typeof(self)weakSelf = self;
    if ([weakSelf.delegate respondsToSelector:@selector(startCameraRecordingBtnClick)]) {
        [weakSelf.delegate startCameraRecordingBtnClick];
    }
}

//停止录制
- (void)stopCameraRecording {
   __weak typeof(self)weakSelf = self;
    if ([weakSelf.delegate respondsToSelector:@selector(stopCameraRecordingBtnClick)]) {
        [weakSelf.delegate stopCameraRecordingBtnClick];
    }
}

- (void)dismissController {
    __weak typeof(self)weakSelf = self;
    if ([weakSelf.delegate respondsToSelector:@selector(clickDismissButtonInBottomView)]) {
        [weakSelf.delegate clickDismissButtonInBottomView];
    }
}

#pragma mark - 开启定时器
- (void)startTime {
    self.processView.hidden = NO;
    CGFloat signleTime = kVideoMaxTime / 360;
    self.timeCount = 0;
    self.timeMargin = signleTime;
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:signleTime target:self selector:@selector(updateProgress) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

#pragma mark - 更新进度
- (void)updateProgress {
    if (self.timeCount >= kVideoMaxTime) {
        [self stopTime];
        [self stopCameraRecording];
        return;
    }
    
    self.timeCount += self.timeMargin;
    
    self.processView.progress = self.timeCount / kVideoMaxTime;
}

#pragma mark - 关闭定时器
- (void)stopTime {
    self.processView.progress = 0;
    [self.tools stopCapture];
    [self.timer invalidate];
    self.timer = nil;
}

#pragma mark - GET

- (VideoTools *)tools {
    if (_tools == nil) {
        _tools = [[VideoTools alloc] init];
    }
    return _tools;
}

- (UIButton *)camareBtn {
    if (_camareBtn == nil) {
        _camareBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.center.x - 32, 0, 64, 64)];
        _camareBtn.layer.cornerRadius = _camareBtn.frame.size.height * 0.5;
        _camareBtn.layer.masksToBounds = YES;
        [_camareBtn setImage:[UIImage imageNamed:@"camera_selc"] forState:UIControlStateNormal];
        [_camareBtn setImage:[UIImage imageNamed:@"camera_Nomarl"] forState:UIControlStateHighlighted];
        [_camareBtn addTarget:self action:@selector(startCameraRecording) forControlEvents:UIControlEventTouchDown];
        [_camareBtn addTarget:self action:@selector(stopCameraRecording) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _camareBtn;
}

- (VideoProcessView *)processView {
    if (_processView == nil) {
        CGFloat widthHeight = self.camareBtn.bounds.size.width +2*lineWidth;
        _processView = [[VideoProcessView alloc]initWithCenter:CGPointMake(widthHeight *0.5, widthHeight*0.5) radius:(widthHeight-lineWidth) *0.5];
        _processView.bounds =CGRectMake(0, 0, widthHeight, widthHeight);
        _processView.hidden = YES;
        
    }
    return _processView;
}

- (UIButton *)dismissBtn {
    if (_dismissBtn == nil) {
        _dismissBtn = [[UIButton alloc] initWithFrame:CGRectMake(8, self.camareBtn.frame.origin.y, 128, 64)];
        [_dismissBtn addTarget:self action:@selector(dismissController) forControlEvents:UIControlEventTouchUpInside];
        [_dismissBtn setImage:[UIImage imageNamed:@"向下边框三角"] forState:UIControlStateNormal];
    }
    return _dismissBtn;
}


@end
