//
//  TBHomeTaskCollectionViewCell.h
//  fireManagement
//
//  Created by 王小腊 on 2017/8/21.
//  Copyright © 2017年 王小腊. All rights reserved.
//

extern NSString *const TBHomeTaskCollectionViewCellID;

#import <UIKit/UIKit.h>

@interface TBHomeTaskCollectionViewCell : UICollectionViewCell

/**
 cell赋值

 @param dic 字典
 */
- (void)cellAssignmentData:(NSDictionary *)dic;
@end
