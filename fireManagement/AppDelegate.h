//
//  AppDelegate.h
//  fireManagement
//
//  Created by 王小腊 on 2017/8/18.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetworkReachabilityManager.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic) AFNetworkReachabilityStatus workStatus;//网络状态
@end

