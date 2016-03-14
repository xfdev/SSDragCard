//
//  SSMenuView.h
//  SSCardDemo
//
//  Created by sonny on 16/3/12.
//  Copyright © 2016年 sonny. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SSMenuViewBlock)(NSInteger index);


@interface SSMenuView : UIView {
    
    NSInteger _maxI;
    NSInteger _maxJ;
    NSTimeInterval _time;
}

@property (nonatomic, copy) SSMenuViewBlock block;


+ (SSMenuView *)showInView:(UIView *)view selectBlock:(SSMenuViewBlock)block;

- (void)hiddenView;
- (void)showView;

@end
