//
//  TBNetworkPromptView.h
//  fireManagement
//
//  Created by 王小腊 on 2017/8/21.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TBNetworkPromptView : UIView

/**
 弹出网络异常提示框

 @param msg 消息
 */
+ (void)showPrompt:(NSString *)msg;

/**
 关闭
 */
+ (void)dismissNetworkPromptView;
@end
