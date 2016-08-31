//
//  JMLeftMenuView.h
//  JMOverwatchMAX
//
//  Created by Jin on 16/7/14.
//  Copyright © 2016年 Jin. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol HomeMenuViewDelegate <NSObject>

-(void)LeftMenuViewClick:(NSInteger)tag;

@end

@interface JMLeftMenuView : UIView

@property (nonatomic ,weak)id <HomeMenuViewDelegate> customDelegate;

@end
