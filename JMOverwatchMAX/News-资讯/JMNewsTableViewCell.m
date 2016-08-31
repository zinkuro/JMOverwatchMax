//
//  JMNewsTableViewCell.m
//  JMOverwatchMAX
//
//  Created by Jin on 16/7/11.
//  Copyright © 2016年 Jin. All rights reserved.
//

#import "JMNewsTableViewCell.h"
#import "JMNewsModel.h"
@interface JMNewsTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *timeImageView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *clickImageView;
@property (weak, nonatomic) IBOutlet UILabel *clickLabel;

@end

@implementation JMNewsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

- (void)setModel:(JMNewsModel *)model {
    self.titleLabel.font = [UIFont systemFontOfSize:self.contentView.width * 1 / 25];
    
    [self.coverImageView setImageWithURL:[NSURL URLWithString:model.imgs[0]] placeholderImage:[UIImage imageNamed:@""]];
    self.titleLabel.text = model.title;
    self.timeLabel.text = model.create_time;
    self.clickLabel.text = [NSString stringWithFormat:@"%ld",model.click];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
