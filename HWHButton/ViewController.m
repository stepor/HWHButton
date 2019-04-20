//
//  ViewController.m
//  GKButton
//
//  Created by 黄文鸿 on 2019/4/4.
//  Copyright © 2019 黄文鸿. All rights reserved.
//

#import "ViewController.h"
#import "HWHButton.h"

@interface ViewController ()


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    CGFloat centerX = CGRectGetMidX(self.view.bounds);
    HWHButton *rButton = [self createButtonWithStyle:HWHButtonLayoutStyleRight];
    rButton.center = CGPointMake(centerX, 150*1);
    [self.view addSubview:rButton];
    
    HWHButton *lButton = [self createButtonWithStyle:HWHButtonLayoutStyleLeft];
    lButton.center = CGPointMake(centerX, 150*2);
    [self.view addSubview:lButton];
    
    HWHButton *bButton = [self createButtonWithStyle:HWHButtonLayoutStyleBottom];
    bButton.center = CGPointMake(centerX, 150*3);
    [self.view addSubview:bButton];
    
    HWHButton *tButton = [self createButtonWithStyle:HWHButtonLayoutStyleTop];
    tButton.center = CGPointMake(centerX, 150*4);
    [self.view addSubview:tButton];
    
    NSLog(@"加载完成");
}

- (HWHButton *)createButtonWithStyle:(HWHButtonLayoutStyle)layoutStyle {
    HWHButton *btn = [HWHButton buttonWithLayoutStyle:layoutStyle title:@"normal" image:[UIImage imageNamed:@"icon"]];
    btn.frame = CGRectMake(0, 0, 100, 100);
    btn.center = self.view.center;
    btn.backgroundColor = [UIColor redColor];
    [btn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    btn.selectedImage = [UIImage imageNamed:@"icon1"];
    btn.selectedTitle = @"selected";
    return btn;
}

- (void)buttonAction:(HWHButton *)btn {
    btn.buttonState = 1 - btn.buttonState;
}


@end
