//
//  OpenViewController.m
//  CameraDemo
//
//  Created by Pisces on 2017/7/17.
//  Copyright © 2017年 Pisces. All rights reserved.
//

#import "OpenViewController.h"
#import "CameraViewController.h"
@interface OpenViewController ()

@end

@implementation OpenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)openCameraView:(id)sender {
    CameraViewController *vc = [[CameraViewController alloc] init];
    [self.navigationController presentViewController:vc animated:YES completion:nil];
}


@end
