//
//  TBHomeMyViewController.m
//  fireManagement
//
//  Created by 王小腊 on 2017/8/21.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "TBHomeMyViewController.h"
#import "TBVerifyViewController.h"
#import "ZKNavigationController.h"
#import "TBHeaderJellyView.h"
#import "TBMyBannerView.h"
#import "TBMoreReminderView.h"

@interface TBHomeMyViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) TBMyBannerView *bannerImageView;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSArray *lefInfoData;
@property (strong, nonatomic) NSArray *ritNumberArray;
@property (assign, nonatomic) CGFloat imageHeight;
@property (strong, nonatomic) TBHeaderJellyView *headerView;
@end

@implementation TBHomeMyViewController
- (NSArray *)ritNumberArray
{
    if (_ritNumberArray == nil)
    {
        
        _ritNumberArray = [NSArray arrayWithObjects:@[@"",@"",@""],@[@"",@""], nil];
        
    }
    return _ritNumberArray;
}
- (NSArray *)lefInfoData
{
    if (_lefInfoData == nil)
    {
        _lefInfoData = [NSArray arrayWithObjects:
                        @[@{@"name":@"清除缓存",@"image":@"mainMore_3"},],
                        @[@{@"name":@"设置密码",@"image":@"mainMore_4"},
                          @{@"name":@"退出账号",@"image":@"mainMore_5"}],nil];
    }
    return _lefInfoData;
}

- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] init];
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
    return _tableView;
}
- (void)initBannerView
{
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    CGFloat cellWidth = 960;
    CGFloat cellHeight = 586;
    self.imageHeight = _SCREEN_WIDTH*cellHeight/cellWidth;
    
    [self.view addSubview:self.tableView];
    
    self.headerView = [[TBHeaderJellyView alloc] initWithFrame:CGRectMake(0, 0, _SCREEN_WIDTH, self.imageHeight)];
    [self.view addSubview:self.headerView];
    
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _SCREEN_WIDTH , self.imageHeight+20)];
    self.tableView.tableHeaderView.backgroundColor = [UIColor whiteColor];
    
    self.bannerImageView = [[TBMyBannerView alloc] initWithFrame:CGRectMake(0, 0, _SCREEN_WIDTH, self.imageHeight)];
    self.bannerImageView.contenController = self;
    [self.view addSubview:self.bannerImageView];
    self.headerView.backgroundColor = [UIColor clearColor];
    // 手势
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(bannerPanAction:)];
    self.headerView.userInteractionEnabled = YES;
    self.bannerImageView.userInteractionEnabled = YES;
    [self.bannerImageView addGestureRecognizer:pan];
    
    TBWeakSelf
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view);
    }];
    [self.bannerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.right.equalTo(weakSelf.headerView);
        make.bottom.equalTo(weakSelf.headerView.mas_bottom).offset(0);
    }];
    
    [self.tableView reloadData];
}
- (void)setTableviewStyle
{
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.tableView.tableFooterView = [[UIView alloc] init];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *array = self.lefInfoData[section];
    return array.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 52;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] init];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    NSArray *array = self.lefInfoData[indexPath.section];
    NSDictionary *dic = array[indexPath.row];
    cell.backgroundColor = [UIColor whiteColor];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.imageView.image = [UIImage imageNamed:[dic valueForKey:@"image"]];
    cell.textLabel.text = [dic valueForKey:@"name"];
    cell.detailTextLabel.text = [self.ritNumberArray[indexPath.section] objectAtIndex:indexPath.row];
    cell.detailTextLabel.textColor = [UIColor grayColor];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath isEqual:[NSIndexPath indexPathForRow:0 inSection:0]])
    {
        [ZKUtil clearCache];
    }
    else if ([indexPath isEqual:[NSIndexPath indexPathForRow:0 inSection:1]])
    {
        TBVerifyViewController *passViewC = [[TBVerifyViewController alloc] init];
        [self.navigationController pushViewController:passViewC animated:YES];
    }
    else if ([indexPath isEqual:[NSIndexPath indexPathForRow:1 inSection:1]])
    {
        [self logOutClick];
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY < 0)
    {
        self.headerView.frame = CGRectMake(0,0, _SCREEN_WIDTH , self.imageHeight - offsetY);
    }
    else
    {
        self.headerView.frame = CGRectMake(0,-offsetY, _SCREEN_WIDTH , self.imageHeight);
    }
}
#pragma mark --- 退出登录---
- (void)logOutClick
{
    TBMoreReminderView *more = [[TBMoreReminderView alloc] initShowPrompt:@"亲，是否退出当前账号?"];
    [more showHandler:^{
        
        [self dataCleaning];
    }];
    
}
// 数据清理
- (void)dataCleaning
{
    [ZKUtil saveBoolForKey:VALIDATION valueBool:NO];
    [ZKUtil saveBoolForKey:START_PAGE valueBool:NO];
    [ZKUtil clearCache];
    [self pushMainViewController];
    
}
- (void)pushMainViewController
{
    hudDismiss();
    dispatch_async(dispatch_get_main_queue(), ^{
        ZKNavigationController *nav = [[ZKNavigationController alloc] initWithRootViewController:[NSClassFromString(@"TBLogInViewController") new]];
        [APPDELEGATE window].rootViewController = nav;
    });
}


#pragma mark ---bannerPanAction---
- (void)bannerPanAction:(UIPanGestureRecognizer *)pan
{
    [self.headerView handlePanAction:pan];
    // 禁止动画的时候滑动表格
    self.tableView.scrollEnabled = self.headerView.isAnimating;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:self.tabBarController.selectedIndex == 2];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.headerView endAnimation];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidAppear:(BOOL)animated;
{
    [super viewDidAppear:animated];
    [self.headerView endAnimation];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"我的";
    [self setTableviewStyle];
    [self initBannerView];
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
