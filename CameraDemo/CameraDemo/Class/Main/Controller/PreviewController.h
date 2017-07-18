//
//  PreviewController.h
//  CameraDemo
//
//  Created by Pisces on 2017/7/17.
//  Copyright © 2017年 Pisces. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>


@interface PreviewController : UIViewController
@property (nonatomic, copy) NSURL *url;

@property (strong, nonatomic) AVPlayerLayer *playerLayer; //播放界面

@property (nonatomic, copy) void (^dismissController)();
@end
