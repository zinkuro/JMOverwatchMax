//
//  JMMenuScrollView.h
//  JMContainerViewControllerTest
//
//  Created by Jin on 16/7/1.
//  Copyright © 2016年 Jin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JMScrollMenuViewDelegate <NSObject>

- (void)scrollMenuViewSelectedIndex:(NSInteger)index;

@end

@interface JMMenuScrollView : UIView

@property (nonatomic,weak) id<JMScrollMenuViewDelegate> delegate;

@property (nonatomic,strong) UIScrollView *scrollView;

@property (nonatomic,strong) NSArray *itemTitleArray;
@property (nonatomic,strong) NSArray *itemViewArray;

@property (nonatomic,strong) UIFont *itemFont;

@property (nonatomic,strong) UIColor *viewBackGroudColor;
@property (nonatomic,strong) UIColor *itemTitleColor;
@property (nonatomic,strong) UIColor *itemSelectedTitleColor;
@property (nonatomic,strong) UIColor *itemIndicatorColor;

- (void)setLineView;

- (void)setIndicatorViewFrameWithRatio:(CGFloat)ratio
                            isNextItem:(BOOL)isNextItem
                               toIndex:(NSInteger)toIndex;

- (void)setItemTextColor:(UIColor *)itemTextColor
   selectedItemTextColor:(UIColor *)selectedItemTextColor
            currentIndex:(NSInteger)currentIndex;

@end
