//
//  HWHButton.m
//  GKButton
//
//  Created by 黄文鸿 on 2019/4/4.
//  Copyright © 2019 黄文鸿. All rights reserved.
//

#import "HWHButton.h"

#define  HWH_VerticalLayout (_layoutStyle == HWHButtonLayoutStyleTop || _layoutStyle == HWHButtonLayoutStyleBottom)
#define  HWH_HorizontalLayout (_layoutStyle == HWHButtonLayoutStyleLeft || _layoutStyle == HWHButtonLayoutStyleRight)

@interface HWHButton()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation HWHButton

#pragma mark - init
- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        _useDefaultLayout = YES;
        _layoutStyle = HWHButtonLayoutStyleLeft;
        _buttonState = HWHButtonStateNormal;
        _itemSpace = 8.0;
        _contentEdgeInsets = UIEdgeInsetsMake(2, 2, 2, 2);
        [self setupSubviews];
    }
    return self;
}

- (instancetype)initWithLayoutStyle:(HWHButtonLayoutStyle)layoutStyle
                              title:(NSString *)title
                              image:(UIImage *)image {
    if(self = [self initWithFrame:CGRectZero]) {
        self.layoutStyle = layoutStyle;
        self.normalTitle = title;
        self.normalImage = image;
    }
    return self;
}



+ (instancetype)buttonWithLayoutStyle:(HWHButtonLayoutStyle)layoutStyle
                                title:(NSString *)title
                                image:(UIImage *)imge {
    
    return [[self alloc] initWithLayoutStyle:layoutStyle title:title image:imge];
}

#pragma mark - setup
- (void)setupSubviews {
    self.titleLabel = ({
        UILabel *label = [UILabel new];
        label.font = [UIFont systemFontOfSize:16];
        label.textColor = [UIColor blackColor];
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
        label;
    });
    
    self.imageView = ({
        UIImageView *imageView = [UIImageView new];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:imageView];
        imageView;
    });
    
    [self layout];
}

- (void)layout {
    
    if(!_useDefaultLayout) return;
    
    //fixme:默认不应该用比例布局，应该根据传入的 image 和 title 的大小进行布局
    BOOL hasImg = YES;
    BOOL hasTitle = YES;
    switch (_buttonState) {
        case HWHButtonStateNormal: {
            hasImg = _normalImage!=nil;
            hasTitle = _normalTitle!=nil;
        }
            break;
        case HWHButtonStateSelected: {
            hasImg = _selectedImage != nil;
            hasTitle = _selectedTitle != nil;
        }
            break;
    }
    
    if(!hasImg && !hasTitle) return;
    
    
    CGSize titleSize = hasTitle ? [_titleLabel sizeThatFits:CGSizeMake(0, 0)] : CGSizeZero;
    CGSize imageSize = hasImg ? _imageView.image.size : CGSizeZero;
    
    //根据 bounds 的 大小，考虑 edge insets，title image 之间的距离
    CGFloat minX = _contentEdgeInsets.left;
    CGFloat maxX = CGRectGetWidth(self.bounds) - _contentEdgeInsets.right;
    CGFloat minY = _contentEdgeInsets.top;
    CGFloat maxY = CGRectGetHeight(self.bounds) - _contentEdgeInsets.bottom;
    
    //先考虑顺利情况
    //再考虑其他情况
    if(HWH_HorizontalLayout) {
        //算出 image 和 title 可以用的空间，进而确定 image 和 title 的大小，本身大小 或者 按照 “宽度” 比例缩小
        CGFloat wRatio = imageSize.width/titleSize.width;//宽度比 图片宽度 : 文字宽度
        CGFloat imageMaxWidth = (maxX - minX - _itemSpace) * (wRatio/(1.0+wRatio));
        CGFloat imageMaxHeight = maxY - minY;
        CGFloat titleMaxWidth = (maxX - minX - _itemSpace) * (1.0/(1+wRatio));
        CGFloat titleMaxHeight = maxY - minY;
        
        CGFloat imageRealWidth = imageSize.width < imageMaxWidth ? imageSize.width : imageMaxWidth;
        CGFloat imageRealHeight = imageSize.height < imageMaxHeight ? imageSize.height : imageMaxHeight;
        CGFloat titleRealWidth = titleSize.width < titleMaxWidth ? titleSize.width : titleMaxWidth;
        CGFloat titleRealHeight = titleSize.height < titleMaxHeight ? titleSize.height : titleMaxHeight;
        
        _imageView.bounds = CGRectMake(0, 0, imageRealWidth, imageRealHeight);
        _titleLabel.bounds = CGRectMake(0, 0, titleRealWidth, titleRealHeight);
        CGFloat totalWidth = imageRealWidth +  titleRealWidth + _itemSpace;//整体宽度，image宽度+title宽度+itemSpace，用于计算整体水平居中
        CGFloat sideSpace = ((maxX - minX) - totalWidth)/2.0;//整体居中后，左边距离 minX 或 右边 距离 maxX 的距离
        CGFloat centerY = minY + (maxY - minY)/2.0;
        if(_layoutStyle == HWHButtonLayoutStyleRight) {//文字在右
            _imageView.center = CGPointMake(minX+sideSpace+imageRealWidth/2.0, centerY);
            _titleLabel.center = CGPointMake(maxX-sideSpace-titleRealWidth/2.0, centerY);
        } else {                                        //文字在左
            _titleLabel.center = CGPointMake(minX+sideSpace+titleRealWidth/2.0, centerY);
            _imageView.center = CGPointMake(maxX-sideSpace-imageRealWidth/2.0, centerY);
        }
    } else {
        //算出 image 和 title 可以用的空间，进而确定 image 和 title 的大小，本身大小 或者 按照 ”高度“ 比例缩小
        CGFloat hRatio = imageSize.height/titleSize.height;//高度比 图片高度 : 文字高度
        CGFloat imageMaxHeight = (maxY - minY - _itemSpace) * (hRatio/(1.0+hRatio));
        CGFloat imageMaxWidth = maxX - minX;
        CGFloat titleMaxHeight = (maxY - minY - _itemSpace) * (1.0/(1+hRatio));
        CGFloat titleMaxWidth = maxX - minX;
        
        CGFloat imageRealWidth = imageSize.width < imageMaxWidth ? imageSize.width : imageMaxWidth;
        CGFloat imageRealHeight = imageSize.height < imageMaxHeight ? imageSize.height : imageMaxHeight;
        CGFloat titleRealWidth = titleSize.width < titleMaxWidth ? titleSize.width : titleMaxWidth;
        CGFloat titleRealHeight = titleSize.height < titleMaxHeight ? titleSize.height : titleMaxHeight;
        
        _imageView.bounds = CGRectMake(0, 0, imageRealWidth, imageRealHeight);
        _titleLabel.bounds = CGRectMake(0, 0, titleRealWidth, titleRealHeight);
        
        CGFloat totalHeight = imageRealHeight +  titleRealHeight + _itemSpace;//整体宽度，image高度+title高度+itemSpace，用于计算整体垂直居中
        CGFloat sideSpace = ((maxY - minY) - totalHeight)/2.0;//整体居中后，顶部距离 minY 或 底部 距离 maxY 的距离
        CGFloat centerX = minX + (maxX - minX)/2.0;
        if(_layoutStyle == HWHButtonLayoutStyleBottom) {    //文字在下
            _imageView.center = CGPointMake(centerX, minY+sideSpace+imageRealHeight/2.0);
            _titleLabel.center = CGPointMake(centerX, maxY-sideSpace-titleRealHeight/2.0);
        } else {                                            //文字在上
            _titleLabel.center = CGPointMake(centerX, minY+sideSpace+titleRealHeight/2.0);
            _imageView.center = CGPointMake(centerX, maxY-sideSpace-imageRealHeight/2.0);
        }
    }
}

#pragma mark - override
- (void)layoutSubviews {
    [self layout];
    [super layoutSubviews];
}

//- (void)setFrame:(CGRect)frame {
//    [super setFrame:frame];
//    [self layout];
//}

#pragma mark - setter && getter

- (void)setNormalTitle:(NSString *)normalTitle {
    _normalTitle = normalTitle;
    if(_buttonState == HWHButtonStateNormal) {
        _titleLabel.text = normalTitle;
    }
    [self setNeedsLayout];
}

- (void)setSelectedTitle:(NSString *)selectedTitle {
    _selectedTitle = selectedTitle;
    if(_buttonState == HWHButtonStateSelected) {
        _titleLabel.text = selectedTitle;
    }
    [self setNeedsLayout];
}

- (void)setNormalImage:(UIImage *)normalImage {
    _normalImage = normalImage;
    if(_buttonState == HWHButtonStateNormal) {
        _imageView.image = normalImage;
    }
    [self setNeedsLayout];
}

- (void)setSelectedImage:(UIImage *)selectedImage {
    _selectedImage = selectedImage;
    if(_buttonState == HWHButtonStateSelected) {
        _imageView.image = selectedImage;
    }
    [self setNeedsLayout];
}

- (void)setUseDefaultLayout:(BOOL)useDefaultLayout {
    if(_useDefaultLayout == useDefaultLayout) return;
    
    _useDefaultLayout = useDefaultLayout;
    [self setNeedsLayout];
}

- (void)setLayoutStyle:(HWHButtonLayoutStyle)layoutStyle {
    if(_layoutStyle == layoutStyle) return;
    
    _layoutStyle = layoutStyle;
    [self setNeedsLayout];
}

- (void)setButtonState:(HWHButtonState)buttonState {
    if(_buttonState == buttonState) return;
    
    _buttonState = buttonState;
    switch (buttonState) {
        case HWHButtonStateNormal: {
            _imageView.image = _normalImage;
            _titleLabel.text = _normalTitle;
        }
            break;
        case HWHButtonStateSelected: {
            _imageView.image = _selectedImage;
            _titleLabel.text = _selectedTitle;
        }
    }
    [self setNeedsLayout];
}

@end
