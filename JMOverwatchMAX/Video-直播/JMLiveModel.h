//
//  JMLiveModel.h
//  JMOverwatchMAX
//
//  Created by Jin on 16/7/12.
//  Copyright © 2016年 Jin. All rights reserved.
//

#import <Foundation/Foundation.h>
@class JMInfoModel;
@interface JMLiveModel : NSObject<YYModel>

@property (nonatomic,strong) NSString *live_nickname;
@property (nonatomic,strong) NSString *live_title;
@property (nonatomic,strong) NSString *live_name;
@property (nonatomic,strong) NSString *live_img;
@property (nonatomic,strong) NSString *live_userimg;
@property (nonatomic,strong) NSString *live_id;

@property (nonatomic,assign) NSInteger live_online;
@property (nonatomic,strong) JMInfoModel *url_info;

@end
