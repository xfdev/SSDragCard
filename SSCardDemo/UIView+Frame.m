//
//  UIView+Frame.m
//  SSCardDemo
//
//  Created by sonny on 16/3/13.
//  Copyright © 2016年 sonny. All rights reserved.
//

#import "UIView+Frame.h"

@implementation UIView (Frame)

//宽
- (float) ssWidth {
    return self.frame.size.width;
}
- (void)setSsWidth:(float)ssWidth {
    CGRect f = self.frame;
    f.size.width = ssWidth;
    self.frame = f;
}
//高
- (float) ssHeight {
    return self.frame.size.height;
    
}
- (void) setSsHeight:(float)height {
    CGRect f = self.frame;
    f.size.height = height;
    self.frame = f;
}
//x
- (float) ssX {
    return self.frame.origin.x;
}
- (void) setSsX:(float)x {
    CGRect f = self.frame;
    f.origin.x = x;
    self.frame = f;
}
//y
- (float) ssY {
    return self.frame.origin.y;
}
- (void) setSsY:(float)y {
    CGRect f = self.frame;
    f.origin.y = y;
    self.frame = f;
}
//centerX
- (void)setSsCenterX:(float)centerX {
    CGPoint cent = self.center;
    cent.x = centerX;
    self.center = cent;
}
- (float)ssCenterX {
    return self.center.x;
}
//centerY
- (void)setSsCenterY:(float)centerY {
    CGPoint cent = self.center;
    cent.y = centerY;
    self.center = cent;
}
- (float)ssCenterY {
    return self.center.y;
}


@end
