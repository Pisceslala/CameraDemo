//
//  HeaderView.h
//  CameraDemo
//
//  Created by Pisces on 2017/7/17.
//  Copyright © 2017年 Pisces. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HeaderViewDelegate <NSObject>

- (void)changeCameraInputDeviceisOnClick;

- (void)changeCameraDriveFlashOnClick:(UIButton *)flashBtn;

@end

@interface HeaderView : UIView

@property (weak, nonatomic) id<HeaderViewDelegate> delegate;


@end
