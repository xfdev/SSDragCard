//
//  SSMenuView.m
//  SSCardDemo
//
//  Created by sonny on 16/3/12.
//  Copyright © 2016年 sonny. All rights reserved.
//

#import "SSMenuView.h"

@implementation SSMenuView

+ (SSMenuView *)showInView:(UIView *)view selectBlock:(SSMenuViewBlock)block {
    
    SSMenuView *v = [[self alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(view.frame), CGRectGetHeight(view.frame)) withBlock:block];
    [view addSubview:v];
    return v;
}

- (instancetype)initWithFrame:(CGRect)frame withBlock:(SSMenuViewBlock)block {
    self = [super initWithFrame:frame];
    if (self) {
        self.block = block;
        [self viewInstance];
    }
    return self;
}


- (void)viewInstance {
    
    UIControl *layerView = [[UIControl alloc] initWithFrame:self.frame];
    layerView.alpha = 0.8;
    [layerView addTarget:self action:@selector(closeButtonTouch:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:layerView];
    
    NSArray *titleArray = [NSArray arrayWithObjects:
                           @"第一",
                           @"第二",
                           @"第三",
                           @"第四",
                           @"第五",
                           @"第六",
                           @"第七",
                           @"第八",
                           @"第九",
                           @"第十", nil];
    NSArray *colorArray = [NSArray arrayWithObjects:
                           [UIColor yellowColor],
                           [UIColor redColor],
                           [UIColor blueColor],
                           [UIColor purpleColor],
                           [UIColor greenColor],
                           [UIColor cyanColor],
                           [UIColor grayColor],
                           [UIColor darkGrayColor],
                           [UIColor magentaColor],
                           [UIColor lightGrayColor], nil];
//    _______
//    |     |
//    | * * |
//    | * * |
//    | * * |
//    |     |
//    |  *  |
    // 布局方式
    _maxI = 3;// 行数
    _maxJ = 2;// 列数
    _time = 0.2;
    
    CGFloat width = self.frame.size.width/(_maxJ * 2 + 1);
    for (NSInteger i = 0; i < _maxI; i++) {
        for (NSInteger j = 0; j < _maxJ; j++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(width + j * 2*width, 100 + i * 2 * width, width, width);
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            // 索引位置
            NSInteger index = i * _maxJ + j;
            if (index >= titleArray.count || index >= colorArray.count) {
                break;
            }
            [button setTitle:[titleArray objectAtIndex:index] forState:UIControlStateNormal];
            button.backgroundColor = [colorArray objectAtIndex:index];
            button.tag = 20 + index;
            button.hidden = YES;
            [button.layer setCornerRadius:width/2];
            [button addTarget:self action:@selector(closeButtonTouch:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:button];
            
            // 动画时间
            NSTimeInterval duration = ((index + 1) * _time) / _maxI * _maxJ;
            [self performSelector:@selector(addViewAnimationWith:) withObject:button afterDelay:duration];
            
        }
    }
}
// 点击某菜单
- (void)closeButtonTouch:(UIButton *)button {
    [UIView animateWithDuration:_time + 0.2 animations:^{
        self.alpha = 0;
        if (button.tag > 10) {
            button.transform = CGAffineTransformMakeScale(1.8, 1.8);
        }
    } completion:^(BOOL finished) {
        [self hiddenView];
        if (_block) {
            _block(button.tag);
        }
    }];
}

// 显示动画
- (void)addViewAnimationWith:(UIButton *)button {
    
    button.hidden = NO;
    CAKeyframeAnimation *keyAnima = [CAKeyframeAnimation animation];
    keyAnima.keyPath = @"transform.scale";
    keyAnima.values = @[@(0.7),@(1.2),@(0.9),@(1.05),@(1.0)];
    keyAnima.removedOnCompletion = NO;
    keyAnima.fillMode = kCAFillModeBoth;
    keyAnima.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    keyAnima.duration = 0.8;
    keyAnima.repeatCount = 0;
    [button.layer addAnimation:keyAnima forKey:@"button"];
}

// 隐藏动画
- (void)hiddenView {
    
    for (NSInteger i = 0; i < _maxI*_maxJ; i++) {
        UIButton *button = [self viewWithTag:20 + i];
        [UIView animateWithDuration:_time + 0.2 animations:^{
            
            button.alpha = 0.1;
            self.alpha = 0.1;
            
        } completion:^(BOOL finished) {
            button.hidden = YES;
            button.alpha = 1;
            if (i == _maxI*_maxJ-1) {
                self.hidden = YES;
            }
        }];
    }
}
// 显示方法
- (void)showView {
    
    self.hidden = NO;
    [UIView animateWithDuration:_time animations:^{
        self.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
    
    for (NSInteger i = 0; i < _maxI*_maxJ; i++) {
        UIButton *button = [self viewWithTag:20 + i];
        // 动画时间
        NSTimeInterval duration = ((i + 1) * _time) / _maxI*_maxJ;
        [self performSelector:@selector(addViewAnimationWith:) withObject:button afterDelay:duration];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
