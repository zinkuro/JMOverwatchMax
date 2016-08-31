//
//  JMMenuScrollView.m
//  JMContainerViewControllerTest
//
//  Created by Jin on 16/7/1.
//  Copyright © 2016年 Jin. All rights reserved.
//

#import "JMMenuScrollView.h"

static const CGFloat JM_SCROLL_WIDTH  = 90;
static const CGFloat JM_SCROLL_MARGIN = 10;
static const CGFloat JM_INDICATOR_HEIGHT = 3;

@interface JMMenuScrollView ()


@property (nonatomic, strong) UIView *indicatorView;

@end

@implementation JMMenuScrollView

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        self.backgroundColor = _viewBackGroudColor;
        _scrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
        _scrollView.showsHorizontalScrollIndicator = NO;

    }
    return _scrollView;
}

- (UIView *)indicatorView {
    if (!_indicatorView) {
        _indicatorView = [[UIView alloc]init];
        _indicatorView.frame = CGRectMake(10, self.scrollView.frame.size.height - JM_INDICATOR_HEIGHT, JM_SCROLL_WIDTH, JM_INDICATOR_HEIGHT);
        _indicatorView.backgroundColor = self.itemIndicatorColor;

    }
    return _indicatorView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _viewBackGroudColor = [UIColor whiteColor];
        _itemFont = [UIFont systemFontOfSize:16];
        _itemTitleColor = [UIColor colorWithRed:0.8 green:0.8  blue:0.8  alpha:1.0];
        _itemSelectedTitleColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1.0];
        _itemIndicatorColor = [UIColor colorWithRed:0.168627 green:0.498039 blue:0.839216 alpha:1.0];
        
        [self addSubview:self.scrollView];
    }
    return self;
}

#pragma mark -- Setter

- (void)setViewBackGroudColor:(UIColor *)viewBackGroudColor

{
    if (!viewBackGroudColor) {
        return;
    }
    viewBackGroudColor = viewBackGroudColor;
    self.backgroundColor = viewBackGroudColor;
}

- (void)setItemfont:(UIFont *)itemfont
{
    if (!itemfont) {
        return;
    }
    _itemFont = itemfont;
    for (UILabel *label in _itemTitleArray) {
        label.font = itemfont;
    }
}

- (void)setItemTitleColor:(UIColor *)itemTitleColor
{
    if (!itemTitleColor) {
        return;
    }
    _itemTitleColor = itemTitleColor;
    for (UILabel *label in _itemTitleArray) {
        label.textColor = itemTitleColor;
    }
}

- (void)setItemIndicatorColor:(UIColor *)itemIndicatorColor
{
    if (!itemIndicatorColor) {
        return;
    }
    _itemIndicatorColor = itemIndicatorColor;
    self.indicatorView.backgroundColor = itemIndicatorColor;
}

- (void)setItemTitleArray:(NSArray *)itemTitleArray
{
    if (_itemTitleArray != itemTitleArray) {
        _itemTitleArray = itemTitleArray;
        NSMutableArray *views = [NSMutableArray array];
        
        for (int i = 0; i < itemTitleArray.count; i++) {
            CGRect frame = CGRectMake(0, 0, JM_SCROLL_WIDTH, CGRectGetHeight(self.frame));
            //自定义label==============================================
            UILabel *itemView = [[UILabel alloc] initWithFrame:frame];
            [self.scrollView addSubview:itemView];
            itemView.tag = i;
            itemView.text = itemTitleArray[i];
            itemView.userInteractionEnabled = YES;
            itemView.backgroundColor = [UIColor clearColor];
            itemView.textAlignment = NSTextAlignmentCenter;
            itemView.font = self.itemFont;
            itemView.textColor = _itemTitleColor;
            [views addObject:itemView];
            //========================================================
//            JMLabelView *itemView = [[JMLabelView alloc]initWithFrame:frame];
//            [self.scrollView addSubview:itemView];
//            itemView.tag = i;
//            itemView.label.text = itemTitleArray[i];
//            itemView.userInteractionEnabled = YES;
//            itemView.backgroundColor = [UIColor clearColor];
//            itemView.label.textAlignment = NSTextAlignmentCenter;
//            itemView.label.font = _itemFont;
//            itemView.label.textColor = _itemTitleColor;
//            [views addObject:itemView];
            
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(itemViewTapAction:)];
            [itemView addGestureRecognizer:tapGesture];
        }
        
        self.itemViewArray = [NSArray arrayWithArray:views];
        
        [self.scrollView addSubview:self.indicatorView];
    }
}

#pragma mark -- public

- (void)setIndicatorViewFrameWithRatio:(CGFloat)ratio isNextItem:(BOOL)isNextItem toIndex:(NSInteger)toIndex {
    CGFloat indicatorX = 0.0;
    if (isNextItem) {
        indicatorX = ((JM_SCROLL_MARGIN + JM_SCROLL_WIDTH) * ratio ) + (toIndex * JM_SCROLL_WIDTH) + ((toIndex + 1) * JM_SCROLL_MARGIN);
    } else {
        indicatorX =  ((JM_SCROLL_MARGIN + JM_SCROLL_WIDTH) * (1 - ratio) ) + (toIndex * JM_SCROLL_WIDTH) + ((toIndex + 1) * JM_SCROLL_MARGIN);
    }
    
    if (indicatorX < JM_SCROLL_MARGIN || indicatorX > self.scrollView.contentSize.width - (JM_SCROLL_MARGIN + JM_SCROLL_WIDTH)) {
        return;
    }
    self.indicatorView.frame = CGRectMake(indicatorX, self.scrollView.frame.size.height - JM_INDICATOR_HEIGHT, JM_SCROLL_WIDTH, JM_INDICATOR_HEIGHT);
    
}

- (void)setItemTextColor:(UIColor *)itemTextColor
   selectedItemTextColor:(UIColor *)selectedItemTextColor
            currentIndex:(NSInteger)currentIndex {
    if (itemTextColor) { _itemTitleColor = itemTextColor; }
    if (selectedItemTextColor) { _itemSelectedTitleColor = selectedItemTextColor; }
    
    for (int i = 0; i < self.itemViewArray.count; i++) {
        UILabel *label = self.itemViewArray[i];
        if (i == currentIndex) {
            label.alpha = 0.0;
            [UIView animateWithDuration:0.75
                                  delay:0.0
                                options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction
                             animations:^{
                                 label.alpha = 1.0;
                                 label.textColor = _itemSelectedTitleColor;
                             } completion:^(BOOL finished) {
                             }];
        } else {
            label.textColor = _itemTitleColor;
        }
    }
}

#pragma mark -- private


- (void)setLineView
{
    UIView *view = [[UIView alloc]init];
    view.frame = CGRectMake(0, self.frame.size.height - 0.5, CGRectGetWidth(self.frame), 0.5);
    view.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:view];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat x = JM_SCROLL_MARGIN;
    for (NSUInteger i = 0; i < self.itemViewArray.count; i++) {
        CGFloat width = JM_SCROLL_WIDTH;
        UIView *itemView = self.itemViewArray[i];
        itemView.frame = CGRectMake(x, 0, width, self.scrollView.frame.size.height);
        x += width + JM_SCROLL_MARGIN;
    }
    self.scrollView.contentSize = CGSizeMake(x, self.scrollView.frame.size.height);
    
    CGRect frame = self.scrollView.frame;
    if (self.frame.size.width > x) {
        frame.origin.x = (self.frame.size.width - x) / 2;
        frame.size.width = x;
    } else {
        frame.origin.x = 0;
        frame.size.width = self.frame.size.width;
    }
    self.scrollView.frame = frame;
}

- (void)itemViewTapAction:(UITapGestureRecognizer *)Recongnizer
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(scrollMenuViewSelectedIndex:)]) {
        [self.delegate scrollMenuViewSelectedIndex:[(UIGestureRecognizer*) Recongnizer view].tag];
    }
}

@end
