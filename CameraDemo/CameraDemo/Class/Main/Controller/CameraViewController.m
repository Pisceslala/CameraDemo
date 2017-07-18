//
//  CameraViewController.m
//  CameraDemo
//
//  Created by Pisces on 2017/7/17.
//  Copyright © 2017年 Pisces. All rights reserved.
//

#import "CameraViewController.h"
#import "VideoTools.h"
#import "VideoProcessView.h"
#import "BottomView.h"
#import "HeaderView.h"
#import "PreviewController.h"

#define kVideoMaxTime 10.0 // MAX TIME

@interface CameraViewController ()<HeaderViewDelegate>

@property (strong, nonatomic) AVCaptureVideoPreviewLayer *videoPreviewLayer;

@property (strong, nonatomic) VideoTools *tools;

@property (strong, nonatomic) UIView *bottomView;

@property (strong, nonatomic) UIButton *camareBtn;

@property (strong, nonatomic) UIButton *dismissBtn;

@property (strong, nonatomic) HeaderView *headerView;

@property (strong, nonatomic) VideoProcessView *processView;

@property (strong, nonatomic) PreviewController *previewVC;

@property (nonatomic, assign) CGFloat timeCount;
@property (nonatomic, assign) CGFloat timeMargin;

@property (nonatomic, strong) NSTimer *timer;
@property (assign, nonatomic) BOOL isFront;

@end

@implementation CameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
   
    [self.view addSubview:self.bottomView];
    [self.view addSubview:self.headerView];

    self.processView.center = self.camareBtn.center;
    [self.bottomView addSubview:self.processView];
    [self.bottomView addSubview:self.camareBtn];
    
    [self.bottomView addSubview:self.dismissBtn];

    [self.view.layer addSublayer:self.videoPreviewLayer];
    self.isFront = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openPreview:) name:@"openVideoPreview" object:nil];
    
}

- (void)openPreview:(NSNotification *)notifice {
    NSURL *url = notifice.object;
    
    self.view.backgroundColor = [UIColor orangeColor];
    self.previewVC = [[PreviewController alloc] init];
    self.previewVC.view.frame = [UIScreen mainScreen].bounds;
    [self.view addSubview:self.previewVC.view];
    self.previewVC.url = url;
    
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.bottomView setHidden:YES];
        [self.headerView setHidden:YES];
        [self.videoPreviewLayer removeFromSuperlayer];
    });
    
    __weak typeof(self)weakSelf = self;
    [self.previewVC setDismissController:^{
        [weakSelf dismissController];
    }];
}

//开始录制
- (void) startCameraRecording{
    [self startTime];
    [self.tools startCapture];
}

//停止录制
- (void)stopCameraRecording {
    [self stopTime];
    //[self.tools stopCapture];
    [self.tools stopRecordFunction];
    
}

- (void)dismissController {
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark - delegate
- (void)changeCameraInputDeviceisOnClick {
    [self.tools changeCameraInputDeviceisFront:self.isFront];
    self.isFront = !self.isFront;
}

- (void)changeCameraDriveFlashOnClick:(UIButton *)flashBtn {
    if (flashBtn.selected) {
        [self.tools openFlashLight];
    }else {
        [self.tools closeFlashLight];
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
- (AVCaptureVideoPreviewLayer *)videoPreviewLayer {
    if (_videoPreviewLayer == nil) {
        
        _videoPreviewLayer = [self.tools previewLayer];
        _videoPreviewLayer.frame = self.view.layer.bounds;
        _videoPreviewLayer.zPosition = -1;
        //开启录制功能
        [self.tools startRecordFunction];
        
    }
    return _videoPreviewLayer;
}

- (VideoTools *)tools {
    if (_tools == nil) {
        _tools = [[VideoTools alloc] init];
    }
    return _tools;
}

- (UIView *)bottomView {
    if (_bottomView == nil) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.view.frame) - 110, self.view.frame.size.width, 110)];
        //_bottomView.delegate = self;
        _bottomView.backgroundColor = [UIColor clearColor];
    }
    return _bottomView;
}

- (UIButton *)camareBtn {
    if (_camareBtn == nil) {
        _camareBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.bottomView.center.x - 32, 0, 64, 64)];
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

- (HeaderView *)headerView {
    if (_headerView == nil) {
        _headerView = [[HeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
        _headerView.delegate = self;
    }
    return _headerView;
}

- (void)dealloc {
    NSLog(@"dealloc");
}
@end
