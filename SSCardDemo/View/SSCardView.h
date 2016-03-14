//
//  SSCardView.h
//  SSCardDemo
//
//  Created by sonny on 16/3/13.
//  Copyright © 2016年 sonny. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,SSCardViewType) {
    SSCardViewTypeNormal,
    SSCardViewTypeLeft,
    SSCardViewTypeRight,
};

typedef void(^SSCardViewBlock)(SSCardViewType type, NSInteger tag);

@interface SSCardView : UIView {
    
    UIImageView *_imageView;
}

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, assign) CGPoint originalCenter;       // 原始中心点
@property (nonatomic, assign) NSInteger rotationDirection;  // 旋转偏移方向

@property (nonatomic, copy) SSCardViewBlock block;  // 移除方向

@property (nonatomic, assign) CGRect cardFrame;// 重新设置frame

@end
