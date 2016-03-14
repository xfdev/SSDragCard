//
//  SSMenuViewController+ScreenImage.m
//  SSCardDemo
//
//  Created by sonny on 16/3/12.
//  Copyright © 2016年 sonny. All rights reserved.
//

#import "SSMenuViewController+ScreenImage.h"

@implementation SSMenuViewController (ScreenImage)

- (UIImage *)screenImage {
    UIGraphicsBeginImageContext(self.view.bounds.size);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSData *imageData = UIImageJPEGRepresentation(image, 0.75);
    image = [UIImage imageWithData:imageData];
    
    return image;
}

@end
