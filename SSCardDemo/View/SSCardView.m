//
//  SSCardView.m
//  SSCardDemo
//
//  Created by sonny on 16/3/13.
//  Copyright © 2016年 sonny. All rights reserved.
//

#import "SSCardView.h"

@implementation SSCardView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self viewInstance];
        [self panGesture];
    }
    return self;
}

- (void)setImage:(UIImage *)image {
    _image = image;
    _imageView.image = image;
}

- (void)setCardFrame:(CGRect)cardFrame {
    self.frame = cardFrame;
    _imageView.frame = CGRectMake(10, 10, self.frame.size.width - 20, self.frame.size.height - 20);
}

- (void)viewInstance {
    
    [self.layer setCornerRadius:4.0];
    self.backgroundColor = [UIColor whiteColor];
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(4,4);
    self.layer.shadowOpacity = 0.4;
    
    _imageView = [UIImageView new];
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    [_imageView.layer setCornerRadius:4.0];
    _imageView.clipsToBounds = YES;
    _imageView.layer.masksToBounds = YES;
    [self addSubview:_imageView];
    _imageView.frame = CGRectMake(10, 10, self.frame.size.width - 20, self.frame.size.height - 20);
//    [_imageView makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self).insets(UIEdgeInsetsMake(10, 10, 10, 10));
//    }];
}

#pragma mark - 添加手势,以及拖动相关。。。
- (void)panGesture {
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc]
                                                    initWithTarget:self
                                                    action:@selector(draggingPanGestureRecognizer:)];
    [self addGestureRecognizer:panGestureRecognizer];
}
- (void)draggingPanGestureRecognizer:(UIPanGestureRecognizer *)panGes {
    
    UIView *view = panGes.view;
//    NSLog(@"view.center = %@",NSStringFromCGPoint(view.center));
    if (panGes.state == UIGestureRecognizerStateBegan) {
        self.originalCenter = view.center;
        
        CGPoint panOrigin = [panGes locationInView:view];
        self.rotationDirection = panOrigin.y > view.center.y ? -1 : 1;
//        NSLog(@"self.rotationDirection = %ld",self.rotationDirection);
        
    } else if (panGes.state == UIGestureRecognizerStateEnded) {
        
        [self finalizePositionAgainstThreshold:100];
        
    } else {
        
        CGPoint translation = [panGes translationInView:view];
//        NSLog(@"translation = %@",NSStringFromCGPoint(translation));
        view.center = [self pointMakeAddWithPointA:self.originalCenter pointB:translation];
        view.transform = CGAffineTransformRotate(CGAffineTransformIdentity, [self rotationWithTranslation:translation]);
    }
}
// 滑动松开后。。。
- (void)finalizePositionAgainstThreshold:(CGFloat)threshold
{
    // 目前偏移量
    CGPoint translation = [self pointMakeSubtractWithPointA:self.center pointB:self.originalCenter];
    // 根据目前偏移，配合范围，是否要出去和方向
    SSCardViewType type = [self typeThresholdDirection:threshold];
    switch (type) {
        case SSCardViewTypeLeft:
        case SSCardViewTypeRight:
            [self exitSuperviewWithTranslation:translation direction:type];
            break;
        case SSCardViewTypeNormal:
            [self returnToCenter:self.originalCenter duration:0.3];
            break;
    }
}

- (void)returnToCenter:(CGPoint)center duration:(NSTimeInterval)duration{
    
    [UIView animateWithDuration:duration
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.transform = CGAffineTransformIdentity;
                         self.center = center;
                     } completion:^(BOOL finished) {
                         
                     }];
}

// 点相减
- (CGPoint)pointMakeSubtractWithPointA:(CGPoint)a pointB:(CGPoint)b {
    
    return CGPointMake(a.x - b.x, a.y - b.y);
}
// 点相加
- (CGPoint)pointMakeAddWithPointA:(CGPoint)a pointB:(CGPoint)b {
    return CGPointMake(a.x + b.x, a.y + b.y);
}
// 旋转度数
- (CGFloat)rotationWithTranslation:(CGPoint)translation {
    
    CGFloat rotation = M_PI * translation.x/180/20;// M_PI/180;
    return self.rotationDirection * rotation;
}

- (CGRect)rectOutOfBoundsWithRect:(CGRect)rect bounds:(CGRect)bounds translation:(CGPoint)translation {
    CGRect destination = rect;
    while (!CGRectIsNull(CGRectIntersection(bounds, destination))) {
        destination = CGRectMake(CGRectGetMinX(destination) + translation.x,
                                 CGRectGetMinY(destination) + translation.y,
                                 CGRectGetWidth(rect),
                                 CGRectGetHeight(rect));
    }
    return destination;
}

// 惯性划出
-(void)exitSuperviewWithTranslation:(CGPoint)translation direction:(SSCardViewType)type{
    
    CGRect destination = [self rectOutOfBoundsWithRect:self.frame bounds:self.superview.bounds translation:translation];
    
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.frame = destination;
                     } completion:^(BOOL finished) {
                         if (finished) {
                             if (self.block) {
                                 self.block(type, self.tag);
                             }
                         }
                     }];
}

//方向
- (SSCardViewType)typeThresholdDirection:(CGFloat)threshold {
    
    if (self.center.x > self.originalCenter.x + threshold) {
        
        return SSCardViewTypeRight;
        
    } else if (self.center.x < self.originalCenter.x - threshold) {
        
        return SSCardViewTypeLeft;
    } else {
        return SSCardViewTypeNormal;
    }
}

@end
