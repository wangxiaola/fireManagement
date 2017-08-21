//
//  TBBaseListViewController.h
//  fireManagement
//
//  Created by 王小腊 on 2017/8/21.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "TBBaseViewController.h"

@interface TBBaseListViewController : TBBaseViewController

// 请求后缀
@property (nonatomic, strong) NSString *postUrl;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) Class modeClass;

@property (nonatomic, strong) NSMutableDictionary *parameter;

@property (nonatomic, strong) NSMutableArray *roots;

- (void)initData NS_REQUIRES_SUPER;
- (void)setUpView NS_REQUIRES_SUPER;
- (void)endDataRequest;//数据请求结束
- (void)updataTableView;

@end
