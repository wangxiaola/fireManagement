//
//  TBStrategyViewController.m
//  Telecom
//
//  Created by 王小腊 on 2017/3/31.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "TBStrategyViewController.h"
#import "SDCycleScrollView.h"

@interface TBStrategyViewController ()
@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;

@end

@implementation TBStrategyViewController

- (SDCycleScrollView *)cycleScrollView
{
    if (!_cycleScrollView)
    {
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:self.view.bounds shouldInfiniteLoop:YES imageNamesGroup:@[@"strategy_1",@"strategy_2",@"strategy_3",@"strategy_4",@"strategy_5",@"strategy_6",@"strategy_7",@"strategy_8",@"strategy_9",@"strategy_10"]];
        _cycleScrollView.showPageControl = YES;
        _cycleScrollView.pageControlStyle =SDCycleScrollViewPageContolStyleAnimated;
        _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        _cycleScrollView.currentPageDotColor = [UIColor whiteColor];
        _cycleScrollView.pageDotColor = [UIColor whiteColor];
        _cycleScrollView.autoScrollTimeInterval = 6;
        _cycleScrollView.pageControlBottomOffset = 40;
        _cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleToFill;
    }
    return _cycleScrollView;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.cycleScrollView adjustWhenControllerViewWillAppera];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"新手教程";
    [self setUpView];
}
#pragma mark ---initView---
- (void)setUpView
{
    [self.view addSubview:self.cycleScrollView];
    [self.cycleScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
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
