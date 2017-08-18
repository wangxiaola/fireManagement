//
//  MyUncaughtExceptionHandler.h
//  Telecom
//
//  Created by 王小腊 on 2017/3/13.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 崩溃记录
 */
@interface MyUncaughtExceptionHandler : NSObject

+ (void)setDefaultHandler;
+ (NSUncaughtExceptionHandler *)getHandler;
+ (void)TakeException:(NSException *) exception;

@end
