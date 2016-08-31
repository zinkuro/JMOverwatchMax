//
//  JMLiveTableViewCell.m
//  JMOverwatchMAX
//
//  Created by Jin on 16/7/12.
//  Copyright © 2016年 Jin. All rights reserved.
//

#import "JMLiveTableViewCell.h"
#import "JMLiveModel.h"

@interface JMLiveTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *liveTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *onlineLabel;

@property (weak, nonatomic) IBOutlet UIImageView *avatarView;
@property (weak, nonatomic) IBOutlet UIImageView *avatarPositionView;


@end

@implementation JMLiveTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(JMLiveModel *)model {
    NSLog(@"%@",model.live_userimg);
    [self.avatarView setImageWithURL:[NSURL URLWithString:model.live_userimg] placeholderImage:[UIImage imageNamed:@"btn_user_normal"]];
    self.avatarView.layer.masksToBounds = YES;
    self.avatarView.layer.cornerRadius = self.avatarView.width / 2;
    self.avatarPositionView.layer.masksToBounds = YES;
    self.avatarPositionView.layer.cornerRadius = self.avatarPositionView.width / 2;
    [self.imgView setImageWithURL:[NSURL URLWithString:model.live_img] placeholderImage:[UIImage imageNamed:@""]];
    self.liveTitleLabel.text = model.live_title;
    self.liveTitleLabel.textColor = [UIColor whiteColor];
    self.liveTitleLabel.font = [UIFont boldSystemFontOfSize:16];
    self.nickNameLabel.text = model.live_nickname;
    self.nickNameLabel.textColor = [UIColor whiteColor];
    self.nickNameLabel.font = [UIFont boldSystemFontOfSize:14];
    self.onlineLabel.text = [NSString stringWithFormat:@"%ld人在观看",model.live_online];
    self.onlineLabel.textColor = [UIColor colorWithR:220 G:220 B:220];
    self.onlineLabel.font = [UIFont boldSystemFontOfSize:12];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
