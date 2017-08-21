//
//  TBHomeMessageTableViewCell.m
//  fireManagement
//
//  Created by 王小腊 on 2017/8/21.
//  Copyright © 2017年 王小腊. All rights reserved.
//

NSString *const TBHomeMessageTableViewCellID = @"TBHomeMessageTableViewCellID";
#import "TBHomeMessageTableViewCell.h"

@implementation TBHomeMessageTableViewCell
{
    __weak IBOutlet UILabel *taskTypeLabel;
    __weak IBOutlet UILabel *timeLabel;
    __weak IBOutlet UILabel *infoLabel;

}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
