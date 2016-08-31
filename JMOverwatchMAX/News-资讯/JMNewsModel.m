//
//  JMNewsModel.m
//  JMOverwatchMAX
//
//  Created by Jin on 16/7/11.
//  Copyright © 2016年 Jin. All rights reserved.
//

#import "JMNewsModel.h"
#import "NSDate+XMGExtension.h"
@implementation JMNewsModel

+ (NSDictionary *)modelCustomPropertyMapper {
    
    return @{@"n_newUrl" : @"newUrl"};
}

- (NSString *)create_time {
    // 日期格式化类
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    // 设置日期格式(y:年,M:月,d:日,H:时,m:分,s:秒)
    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    // 帖子的创建时间
    // NSLog(@"%@",self.date);
    NSDate *create = [fmt dateFromString:self.date];
    // NSLog(@"%@",create);
    if (create.isThisYear) { // 今年
        if (create.isToday) { // 今天create_at
            NSDateComponents *cmps = [[NSDate date] deltaFrom:create];
            
            if (cmps.hour >= 1) { // 时间差距 >= 1小时
                return [NSString stringWithFormat:@"%zd小时前", cmps.hour];
            } else if (cmps.minute >= 1) { // 1小时 > 时间差距 >= 1分钟
                return [NSString stringWithFormat:@"%zd分钟前", cmps.minute];
            } else { // 1分钟 > 时间差距
                return @"刚刚";
            }
        } else if (create.isYesterday) { // 昨天
            fmt.dateFormat = @"昨天 HH:mm";
            return [fmt stringFromDate:create];
        } else { // 其他
            fmt.dateFormat = @"MM-dd HH:mm";
            return [fmt stringFromDate:create];
        }
    } else { // 非今年
        return _create_time;
    }

}
- (NSString *) timeFormatted:(int) totalSeconds
{
    NSDate  *date = [NSDate dateWithTimeIntervalSince1970:totalSeconds];
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
    [formatter1 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *showtimeNew = [formatter1 stringFromDate:date];
    
    return showtimeNew;
}

@end
