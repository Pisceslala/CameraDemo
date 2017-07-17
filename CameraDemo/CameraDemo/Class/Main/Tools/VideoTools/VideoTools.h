//
//  ViedoTools.h
//  SmallViedo
//
//  Created by Pisces on 2017/7/15.
//  Copyright © 2017年 Pisces. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
@interface VideoTools : NSObject
@property (strong, nonatomic) NSString *videoPath;//视频路径


/**
 捕获到的视频呈现的layer

 @return layer
 */
- (AVCaptureVideoPreviewLayer *)previewLayer;

/**
 启动录制功能
 */
- (void)startRecordFunction;

/**
 关闭录制功能
 */
- (void)stopRecordFunction;

/**
 开始录制
 */
- (void) startCapture;


/**
 停止录制
 */
- (void) stopCapture;


/**
 开启闪光灯
 */
- (void)openFlashLight;

/**
 关闭闪光灯
 */
- (void)closeFlashLight;

/**
 切换前后置摄像头

 @param isFront 是否是前置
 */
- (void)changeCameraInputDeviceisFront:(BOOL)isFront;
@end
