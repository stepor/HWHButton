//
//  HWHButton.h
//  GKButton
//
//  Created by 黄文鸿 on 2019/4/4.
//  Copyright © 2019 黄文鸿. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, HWHButtonLayoutStyle){
    HWHButtonLayoutStyleTop,//文字在上面
    HWHButtonLayoutStyleBottom,//文字在下面
    HWHButtonLayoutStyleLeft,//文字在左边
    HWHButtonLayoutStyleRight//文字在右边
};

typedef NS_ENUM(NSInteger, HWHButtonState) {
    HWHButtonStateNormal,
    HWHButtonStateSelected
};

/*
 使用 frame 布局
 */

@interface HWHButton : UIControl

+ (instancetype)buttonWithLayoutStyle:(HWHButtonLayoutStyle)layoutStyle title:(NSString *)title image:(UIImage *)imge;

/**
 使用自带的布局方式来定义 title 和 image 的位置，默认为 YES;
 如果为 NO，由使用者控制 titleLabel 和 imageView 的位置，可以用 frame 布局，也可以用 autolayout.
 */
@property (nonatomic, assign) BOOL useDefaultLayout;

@property (nonatomic, strong, readonly) UILabel *titleLabel;
@property (nonatomic, strong, readonly) UIImageView *imageView;

@property (nonatomic, assign) UIEdgeInsets contentEdgeInsets;//
@property (nonatomic, assign) CGFloat itemSpace;//title 和 image 之间的距离, 默认 8.0
@property (nonatomic, assign) HWHButtonLayoutStyle layoutStyle;
@property (nonatomic, assign) HWHButtonState buttonState;

@property (nonatomic, strong) UIImage *normalImage;
@property (nonatomic, copy) NSString *normalTitle;
@property (nonatomic, strong) UIImage *selectedImage;
@property (nonatomic, copy) NSString *selectedTitle;

@end

NS_ASSUME_NONNULL_END
