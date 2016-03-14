//
//  SSMenuViewController.m
//  SSCardDemo
//
//  Created by sonny on 16/3/12.
//  Copyright © 2016年 sonny. All rights reserved.
//

#import "SSMenuViewController.h"
#import "SSMenuViewController+ScreenImage.h"
#import "UIImage+Blur.h"
#import "SSCardView.h"
#import "UIView+Frame.h"

#define weakSelf(wSelf)  __weak __typeof(&*self)wSelf = self;

@interface SSMenuViewController ()

@property (nonatomic, strong) NSMutableArray *imageArray;

@end

@implementation SSMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor orangeColor];
    
    self.imageArray = [NSMutableArray array];
    for (NSInteger i = 0; i <= 10; i++) {
        NSString *name = [NSString stringWithFormat:@"card_%ld.jpg",i];
        UIImage *image = [UIImage imageNamed:name];
        [self.imageArray addObject:image];
    }
    
    _imageIndex = 4;
    _screenWidth = [[UIScreen mainScreen] bounds].size.width;
    
    // 卡片
    SSCardView *lastCard = nil;
    for (NSInteger i = 3; i >= 0; i--) {
        CGRect frame;
        if (lastCard) {
            frame = CGRectMake(0, CGRectGetMinY(lastCard.frame) - 15, CGRectGetWidth(lastCard.frame) + 10, CGRectGetHeight(lastCard.frame) + 10);
        } else {
            frame = CGRectMake(0, 150, 260 - i*10, 330 - i*10);
        }
        SSCardView *card = [[SSCardView alloc] initWithFrame:frame];
        CGPoint center = card.center;
        center.x = self.view.center.x;
        card.center = center;
        
        card.image = [self.imageArray objectAtIndex:i];
        card.tag = 100 + i;
        
        weakSelf(wSelf);
        card.block = ^(SSCardViewType type, NSInteger tag) {
            
            [wSelf changeCardFrameWithTag:tag];
        };
        [self.view addSubview:card];
        
//        [card makeConstraints:^(MASConstraintMaker *make) {
//            make.centerX.equalTo(self.view);
//            if (lastCard) {
//                make.top.equalTo(lastCard.top).offset(-15);
//                make.width.equalTo(lastCard.width).offset(10);
//                make.height.equalTo(lastCard.height).offset(10);
//            } else {
//                make.top.equalTo(100);
//                make.width.equalTo(260 - i*10);
//                make.height.equalTo(330 - i*10);
//            }
//        }];
        lastCard = card;
    }
    
    UIImage *eff = [UIImage imageNamed:@"card_effect"];// 88*88
    _effectImage = [UIImageView new];
    _effectImage.image = eff;
    [self.view addSubview:_effectImage];
    [_effectImage makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.size.equalTo(CGSizeMake(78, 78));
    }];
    
    CAKeyframeAnimation *keyAnima = [CAKeyframeAnimation animation];
    keyAnima.keyPath = @"transform.scale";
    keyAnima.values = @[@(1.0),@(1.25),@(1.0)];
    keyAnima.removedOnCompletion = NO;
    keyAnima.fillMode = kCAFillModeForwards;
    keyAnima.duration = 3.0;
    keyAnima.repeatCount = MAXFLOAT;
    [_effectImage.layer addAnimation:keyAnima forKey:@"_effectImage"];
    
    _bottomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_bottomBtn setImage:[UIImage imageNamed:@"card_shadow"] forState:UIControlStateNormal];
    [_bottomBtn addTarget:self action:@selector(clickBottomButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_bottomBtn];
    [_bottomBtn makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_effectImage.centerX);
        make.centerY.equalTo(_effectImage.centerY);
        make.size.equalTo(CGSizeMake(88, 88));
    }];
}
// 循环复用
- (void)changeCardFrameWithTag:(NSInteger)tag {
    
    // 之前最顶部的，移到最底部
    SSCardView *card = [self.view viewWithTag:tag];
    card.transform = CGAffineTransformIdentity;
    card.hidden = YES;
    card.tag = 50;// 临时值
    [self.view sendSubviewToBack:card];
    card.image = [self.imageArray objectAtIndex:_imageIndex];
    _imageIndex++;
    if (_imageIndex > self.imageArray.count-1) {
        _imageIndex = 0;
    }
    
    // 目前最顶图片
    SSCardView *cardSecond = [self.view viewWithTag:tag + 1];
    cardSecond.tag = 100;
    
//    SSCardView *lastCard = [self.view viewWithTag:tag + 3];
//    [card updateConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(lastCard.top).offset(15);
//        make.width.equalTo(lastCard.width).offset(-10);
//        make.height.equalTo(lastCard.height).offset(-10);
//    }];
    
    // 更改另外两张图片tag
    SSCardView *cardThree = [self.view viewWithTag:tag + 2];
    cardThree.tag = tag + 1;
    
    SSCardView *cardFour = [self.view viewWithTag:tag + 3];
    cardFour.tag = tag + 2;
    card.tag = 100 + 3;
    
    [UIView animateWithDuration:0.15 animations:^{
        cardSecond.cardFrame = CGRectMake((_screenWidth-260)/2, 105, 260, 330);
        cardThree.cardFrame = CGRectMake((_screenWidth-250)/2,  120, 250, 320);
        cardFour.cardFrame = CGRectMake((_screenWidth-240)/2,   135, 240, 310);
        card.cardFrame = CGRectMake((_screenWidth-230)/2,       150, 230, 300);
    } completion:^(BOOL finished) {
        if (finished) {
            card.hidden = NO;
        }
    }];
}

- (void)clickBottomButton:(UIButton *)button {
    
    if (!_menuView) {
        _menuView = [SSMenuView showInView:self.view selectBlock:^(NSInteger index) {
            NSLog(@"index = %ld",index);
        }];
        [self.view bringSubviewToFront:_effectImage];
        [self.view bringSubviewToFront:_bottomBtn];
        
        UIImage *screenImage = [self screenImage];
        _menuView.alpha = 1.f;
        _menuView.layer.contents = (id)screenImage.CGImage;
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0L), ^{
            UIImage *blur = [screenImage blurImageWithBlur:0.3 exclusionPath:nil];
            dispatch_async(dispatch_get_main_queue(), ^{
                _menuView.layer.contents = (id)blur.CGImage;
            });
        });
    } else {
        if (_menuView.hidden) {
            // 显示
            [_menuView showView];
        } else {
            // 隐藏
            [_menuView hiddenView];
        }
    }
}
- (void)goBack {
    
    if (!_menuView.hidden) {
        // 隐藏
        [_menuView hiddenView];
        [self performSelector:@selector(tmpPop) withObject:nil afterDelay:0.3];
    } else {
        [self tmpPop];
    }
}
- (void)tmpPop {
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
