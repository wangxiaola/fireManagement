//
//  TBHomeMessageViewController.m
//  fireManagement
//
//  Created by 王小腊 on 2017/8/21.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "TBHomeMessageViewController.h"
#import "TBHomeMessageTableViewCell.h"
#import "TBHomeMessageMode.h"
@interface TBHomeMessageViewController ()

@end

@implementation TBHomeMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"消息";
}
#pragma mark  ----父类方法----
- (void)initData;
{
    self.postUrl = @"appBus/busList";
    self.modeClass = [TBHomeMessageMode class];
     [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TBHomeMessageTableViewCell class]) bundle:nil] forCellReuseIdentifier:TBHomeMessageTableViewCellID];
    [super initData];
}
#pragma mark  ----tableView----
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    TBHomeMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TBHomeMessageTableViewCellID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
