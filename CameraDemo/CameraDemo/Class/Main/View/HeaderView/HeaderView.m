//
//  HeaderView.m
//  CameraDemo
//
//  Created by Pisces on 2017/7/17.
//  Copyright © 2017年 Pisces. All rights reserved.
//

#import "HeaderView.h"
#import "VideoTools.h"
@interface HeaderView ()

@property (strong, nonatomic) UIButton *switchBtn;

@property (strong, nonatomic) UIButton *flashSwitchBtn;

@end

@implementation HeaderView

- (instancetype)init {
    if (self = [super init]) {
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

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self configViews];
    }
    return self;
}

- (void)configViews {
    self.switchBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.frame) - 64, 32, 32, 32)];
    [self.switchBtn setImage:[UIImage imageNamed:@"switch"] forState:UIControlStateNormal];
    [self.switchBtn addTarget:self action:@selector(clickSwitchBtn) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.switchBtn];
    
    self.flashSwitchBtn = [[UIButton alloc] initWithFrame:CGRectMake(8, self.switchBtn.frame.origin.y, 32, 32)];
    [self.flashSwitchBtn setImage:[UIImage imageNamed:@"闪光灯-关"] forState:UIControlStateNormal];
    [self.flashSwitchBtn setImage:[UIImage imageNamed:@"闪光灯"] forState:UIControlStateSelected];
    [self.flashSwitchBtn addTarget:self action:@selector(clickFlashSwitch) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.flashSwitchBtn];
    
    
}

- (void)clickSwitchBtn {
    __weak typeof(self)weakSelf = self;
    if ([weakSelf.delegate respondsToSelector:@selector(changeCameraInputDeviceisOnClick)]) {
        [weakSelf.delegate changeCameraInputDeviceisOnClick];
    }
}


- (void)clickFlashSwitch {
    self.flashSwitchBtn.selected = !self.flashSwitchBtn.selected;
    __weak typeof(self)weakSelf = self;
    if ([weakSelf.delegate respondsToSelector:@selector(changeCameraDriveFlashOnClick:)]) {
        [weakSelf.delegate changeCameraDriveFlashOnClick:self.flashSwitchBtn];
    }
}
@end
