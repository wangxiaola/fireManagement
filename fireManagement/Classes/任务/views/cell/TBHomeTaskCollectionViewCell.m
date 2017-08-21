//
//  TBHomeTaskCollectionViewCell.m
//  fireManagement
//
//  Created by 王小腊 on 2017/8/21.
//  Copyright © 2017年 王小腊. All rights reserved.
//

NSString *const TBHomeTaskCollectionViewCellID = @"TBHomeTaskCollectionViewCell";

#import "TBHomeTaskCollectionViewCell.h"
@implementation TBHomeTaskCollectionViewCell
{
    __weak IBOutlet UIImageView *backImageView;
    __weak IBOutlet UILabel *tagLabel;
    __weak IBOutlet UILabel *nameLabel;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    tagLabel.layer.masksToBounds = YES;
    tagLabel.layer.cornerRadius = 8;
    tagLabel.adjustsFontSizeToFitWidth = YES;
    
    self.layer.cornerRadius = 4;
    self.layer.masksToBounds = YES;
    self.layer.borderColor = BODER_COLOR.CGColor;
    self.layer.borderWidth = 1;
}
/**
 cell赋值
 
 @param dic 字典
 */
- (void)cellAssignmentData:(NSDictionary *)dic;
{
    if (dic)
    {
        NSString *name      = [dic valueForKey:@"name"];
        NSString *imageName = [dic valueForKey:@"image"];
        nameLabel.text = name;
        backImageView.image = [UIImage imageNamed:imageName];
    }
}
@end
