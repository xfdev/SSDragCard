//
//  SSMenuViewController.h
//  SSCardDemo
//
//  Created by sonny on 16/3/12.
//  Copyright © 2016年 sonny. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SSMenuView.h"

@interface SSMenuViewController : UIViewController {
    UIImageView *_effectImage;
    UIButton *_bottomBtn;
    
    SSMenuView *_menuView;
    NSInteger _imageIndex;
    CGFloat _screenWidth;
}

@end
