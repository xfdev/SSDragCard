//
//  UIView+Frame.h
//  SSCardDemo
//
//  Created by sonny on 16/3/13.
//  Copyright © 2016年 sonny. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Frame)

/**
 View直接设置宽width,高height,位置,x,y
 */
@property (nonatomic, assign) float ssWidth;
@property (nonatomic, assign) float ssHeight;
@property (nonatomic, assign) float ssX;
@property (nonatomic, assign) float ssY;

@property (nonatomic, assign) float ssCenterX;
@property (nonatomic, assign) float ssCenterY;

@end
