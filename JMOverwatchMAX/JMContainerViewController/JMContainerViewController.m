//
//  JMContainerViewController.m
//  JMContainerViewControllerTest
//
//  Created by Jin on 16/7/1.
//  Copyright © 2016年 Jin. All rights reserved.
//

#import "JMContainerViewController.h"
#import "JMMenuScrollView.h"

static const CGFloat JM_SCROLL_HEIGHT = 45;

@interface JMContainerViewController ()<UIScrollViewDelegate,JMScrollMenuViewDelegate>

@property (nonatomic,assign) CGFloat topBarHeight;
@property (nonatomic,assign) NSInteger currenIndex;
@property (nonatomic,strong) JMMenuScrollView *menuView;

@end

@implementation JMContainerViewController

- (JMMenuScrollView *)menuView {
    if (!_menuView) {
        _menuView = [[JMMenuScrollView alloc]initWithFrame:CGRectMake(0, _topBarHeight, self.view.frame.size.width, JM_SCROLL_HEIGHT)];
        _menuView.backgroundColor = [UIColor clearColor];
        _menuView.delegate = self;
        _menuView.viewBackGroudColor = self.menuBackGroudColor;
        _menuView.itemFont = self.menuItemFont;
        _menuView.itemTitleColor = self.menuItemTitleColor;
        _menuView.scrollView.scrollsToTop = NO;
        [_menuView setItemTitleArray:self.titles];

    }
    return _menuView;
}

- (UIScrollView *)contentScrollView {
    if (!_contentScrollView) {
        _contentScrollView = [[UIScrollView alloc]init];
        _contentScrollView.frame = CGRectMake(0, _topBarHeight + JM_SCROLL_HEIGHT, self.view.frame.size.width, self.view.frame.size.height - (_topBarHeight + JM_SCROLL_HEIGHT));
        _contentScrollView.backgroundColor = [UIColor clearColor];
        _contentScrollView.pagingEnabled = YES;
        _contentScrollView.delegate = self;
        _contentScrollView.showsHorizontalScrollIndicator = NO;
        _contentScrollView.scrollsToTop = NO;
        //_contentScrollView.backgroundColor = [UIColor cyanColor];
    }
    return _contentScrollView;
}

- (instancetype)initWithControllers:(NSArray *)controllers
                       topBarHeight:(CGFloat)topBarHeight
                parentViewController:(UIViewController *)parentViewController {
    
    if (self = [super init]) {
        [parentViewController addChildViewController:self];
        [self didMoveToParentViewController:parentViewController];
        _topBarHeight = topBarHeight;
        _titles = [NSMutableArray array];
        _childControllers = [NSMutableArray array];
        _childControllers = [controllers mutableCopy];
        
        NSMutableArray *titles = [NSMutableArray array];
        for (UIViewController *vc in _childControllers) {
            [titles addObject:[vc valueForKey:@"title"]];
        }
        _titles = [titles mutableCopy];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self creatUI];
}

- (void)creatUI {

    [self.view addSubview:self.contentScrollView];
    
    self.contentScrollView.contentSize = CGSizeMake(self.contentScrollView.frame.size.width * self.childControllers.count, self.contentScrollView.frame.size.height);
    
    for (int i = 0; i < self.childControllers.count; i++) {
        id obj = [self.childControllers objectAtIndex:i];
        if ([obj isKindOfClass:[UIViewController class]]) {
            UIViewController *controller = (UIViewController *)obj;
            CGFloat scrollW = self.contentScrollView.frame.size.width;
            CGFloat scrollH = self.contentScrollView.frame.size.height;
            controller.view.frame = CGRectMake(i * scrollW, 0, scrollW, scrollH);
            [self.contentScrollView addSubview:controller.view];
        }
    }
    [self.view addSubview:self.menuView];
    [self.menuView setLineView];
    [self scrollMenuViewSelectedIndex:0];
}

- (void)setChildViewControllerWithCurrentIndex:(NSInteger)currentIndex
{
    for (int i = 0; i < self.childControllers.count; i++) {
        id obj = self.childControllers[i];
        if ([obj isKindOfClass:[UIViewController class]]) {
            UIViewController *controller = (UIViewController*)obj;
            if (i == currentIndex) {
                [controller willMoveToParentViewController:self];
                [self addChildViewController:controller];
                [controller didMoveToParentViewController:self];
            } else {
                [controller willMoveToParentViewController:self];
                [controller removeFromParentViewController];
                [controller didMoveToParentViewController:self];
            }
        }
    }
}

- (void)scrollMenuViewSelectedIndex:(NSInteger)index {
    [self.contentScrollView setContentOffset:CGPointMake(index * self.contentScrollView.frame.size.width, 0.) animated:YES];
    
    [self.menuView setItemTextColor:self.menuItemTitleColor
              selectedItemTextColor:self.menuItemSelectedTitleColor
                       currentIndex:index];
    [self setChildViewControllerWithCurrentIndex:index];
    
    if (index == self.currenIndex) {
        return;
    }
    self.currenIndex = index;
    if (self.delegate && [self.delegate respondsToSelector:@selector(containerViewItemIndex:currentController:)]) {
        [self.delegate containerViewItemIndex:self.currenIndex currentController:_childControllers[self.currenIndex]];
    }

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat oldPointX = self.currenIndex * scrollView.frame.size.width;
    CGFloat ratio = (scrollView.contentOffset.x - oldPointX) / scrollView.frame.size.width;
    
    BOOL isToNextItem = (self.contentScrollView.contentOffset.x > oldPointX);
    NSInteger targetIndex = (isToNextItem) ? self.currenIndex + 1:self.currenIndex - 1;
    
    CGFloat nextItemOffsetX = 1.0f;
    CGFloat currentItemOffsetX = 1.0f;
    nextItemOffsetX = (self.menuView.scrollView.contentSize.width - self.menuView.scrollView.frame.size.width) * targetIndex / (self.menuView.itemViewArray.count - 1);
    
    if (targetIndex >= 0 && targetIndex < self.childControllers.count) {
        CGFloat indicatorUpdateRatio = ratio;
        if (isToNextItem) {
            CGPoint offset = self.menuView.scrollView.contentOffset;
            offset.x = (nextItemOffsetX - currentItemOffsetX) * ratio + currentItemOffsetX;
            [self.menuView.scrollView setContentOffset:offset animated:NO];
            
            indicatorUpdateRatio = indicatorUpdateRatio * 1;
            [self.menuView setIndicatorViewFrameWithRatio:indicatorUpdateRatio isNextItem:isToNextItem toIndex:self.currenIndex];
        }else {
            CGPoint offset = self.menuView.scrollView.contentOffset;
            offset.x = currentItemOffsetX - (nextItemOffsetX - currentItemOffsetX) * ratio;
            [self.menuView.scrollView setContentOffset:offset animated:NO];
            
            indicatorUpdateRatio = indicatorUpdateRatio * -1;
            [self.menuView setIndicatorViewFrameWithRatio:indicatorUpdateRatio isNextItem:isToNextItem toIndex:targetIndex];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    int currentIndex = scrollView.contentOffset.x / self.contentScrollView.frame.size.width;
    if (currentIndex == self.currenIndex) {
        return;
    }
    self.currenIndex = currentIndex;
    [self.menuView setItemTextColor:self.menuItemTitleColor
              selectedItemTextColor:self.menuItemSelectedTitleColor
                       currentIndex:currentIndex];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(containerViewItemIndex:currentController:)]) {
        [self.delegate containerViewItemIndex:self.currenIndex currentController:_childControllers[self.currenIndex]];
    }
    [self setChildViewControllerWithCurrentIndex:self.currenIndex];
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
