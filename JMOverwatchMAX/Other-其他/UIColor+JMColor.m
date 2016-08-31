//
//  UIColor+JMColor.m
//  JiaLeCommunity
//
//  Created by Jin on 16/7/5.
//  Copyright © 2016年 Jin. All rights reserved.
//

#import "UIColor+JMColor.h"

@implementation UIColor (JMColor)

+ (UIColor *)colorWithR:(CGFloat)r G:(CGFloat)g B:(CGFloat)b {
    return [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1];
}

+ (UIColor *)colorWithR:(CGFloat)r G:(CGFloat)g B:(CGFloat)b alpha:(CGFloat)alpha {
    return [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:alpha];
}

@end
