//
//  JMNewsModel.h
//  JMOverwatchMAX
//
//  Created by Jin on 16/7/11.
//  Copyright © 2016年 Jin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JMNewsModel : NSObject<YYModel>

@property (nonatomic,strong) NSArray *imgs;
@property (nonatomic,strong) NSString *n_newUrl;
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *date;
@property (nonatomic,assign) NSInteger click;
@property (nonatomic,assign) NSInteger img_type;
@property (nonatomic,strong) NSString *create_at;
@property (nonatomic,strong) NSString *create_time;

@end
