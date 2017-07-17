//
//  VideoProcessView.h
//  CameraDemo
//
//  Created by Pisces on 2017/7/17.
//  Copyright © 2017年 Pisces. All rights reserved.
//

#import <UIKit/UIKit.h>
#define lineWidth 10
@interface VideoProcessView : UIView

//初始化
- (instancetype)initWithCenter:(CGPoint )center radius:(CGFloat)radius;

@property  (nonatomic, assign) CGFloat progress;

@end
