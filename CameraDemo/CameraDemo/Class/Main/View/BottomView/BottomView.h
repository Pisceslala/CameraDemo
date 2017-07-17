//
//  BottomView.h
//  CameraDemo
//
//  Created by Pisces on 2017/7/17.
//  Copyright © 2017年 Pisces. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BottomViewDelegate <NSObject>

- (void)clickDismissButtonInBottomView;

- (void)startCameraRecordingBtnClick;

- (void)stopCameraRecordingBtnClick;

@end

@interface BottomView : UIView

@property (weak, nonatomic) id<BottomViewDelegate> delegate;


@end
