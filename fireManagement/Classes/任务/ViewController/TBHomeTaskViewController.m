//
//  TBHomeTaskViewController.m
//  fireManagement
//
//  Created by 王小腊 on 2017/8/21.
//  Copyright © 2017年 王小腊. All rights reserved.
//
//

static NSString *bannerName = @"collectMain_banner";

#import "TBHomeTaskViewController.h"
#import "TBHomeTaskCollectionViewCell.h"


@interface TBHomeTaskViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
//底层背景图
@property (nonatomic) CGSize cellSize;
@property (nonatomic, assign) CGFloat imageHight;
@property (nonatomic, strong) NSArray *backImageNameArray;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *layOut;
@property (nonatomic, strong) UIImageView *zoomImageView;
@property (nonatomic, assign) CGFloat  collectionViewContentInset;
//间隙
@property (nonatomic, assign) CGFloat cellClearance;
@property (nonatomic, strong) UIVisualEffectView *effectView;

@end

@implementation TBHomeTaskViewController
/* 基本视图初始化 */

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.layOut];
        [_collectionView registerClass:[TBHomeTaskCollectionViewCell class] forCellWithReuseIdentifier:@"TBHomeTaskCollectionViewCell_ID"];
        [_collectionView registerNib:[UINib nibWithNibName:@"TBHomeTaskCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:TBHomeTaskCollectionViewCellID];
        _collectionView.backgroundColor = RGB(245, 245, 245);
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.bounces = YES;
        _collectionView.alwaysBounceVertical = YES;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.bounces = YES;
    }
    return _collectionView;
}

/*设置ColllectionView约束*/

- (UICollectionViewFlowLayout *)layOut
{
    if (!_layOut) {
        _layOut = [[UICollectionViewFlowLayout alloc] init];
        _layOut.scrollDirection = UICollectionViewScrollDirectionVertical;
    }
    return _layOut;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"任务";
    // 初始化 顶部 背景视图
    [self initializeView];
}
- (void)initializeView
{
    
    CGFloat bannerWidth = 715;
    CGFloat bannerHeight = 394;
    CGFloat bannerImageHeight = _SCREEN_WIDTH*bannerHeight/bannerWidth;
    self.cellClearance = 30;
    
    CGFloat collectionViewHeight = _SCREEN_HEIGHT-64-bannerImageHeight-50;
    // collectionView 上间距
    self.collectionViewContentInset = collectionViewHeight*0.2/2+10;
    CGFloat collectionViewCellHeight = collectionViewHeight*0.8;
    
    CGFloat cellWidth = (_SCREEN_WIDTH - self.cellClearance*3)/2;
    CGFloat cellHeight = (collectionViewCellHeight - self.cellClearance)/2;
    self.cellSize = CGSizeMake(cellWidth, cellHeight);
    
    self.imageHight = bannerImageHeight;
    
    _layOut.minimumLineSpacing = self.cellClearance;
    _layOut.minimumInteritemSpacing = self.cellClearance;
    //配置ImageView
    self.zoomImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:bannerName]];
    self.zoomImageView.userInteractionEnabled = YES;
    self.zoomImageView.frame = CGRectMake(0, 0 , _SCREEN_WIDTH, self.imageHight);
    //设置autoresizesSubviews让子类自动布局
    self.zoomImageView.autoresizesSubviews = YES;
    self.zoomImageView.clipsToBounds = YES;
    self.zoomImageView.contentMode   = UIViewContentModeScaleAspectFill;
    [self.collectionView addSubview:self.zoomImageView];

    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    // 毛玻璃视图
   self.effectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    //添加到要有毛玻璃特效的控件中
    self.effectView.frame = self.zoomImageView.bounds;
    [self.collectionView addSubview:self.effectView];
    //设置模糊透明度
    self.effectView.alpha = 1.0f;
    
    
    MJWeakSelf
    //解决在nav 遮挡的时候 还会透明的显示问题;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self.view addSubview:self.collectionView];
    self.collectionView.backgroundColor = RGB(244, 244, 244);
    //设置contentInset属性（上左下右 的值）
    self.collectionView.contentInset = UIEdgeInsetsMake(self.collectionViewContentInset+self.imageHight, 0, 0, 0);
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(weakSelf.view);
    }];
    
    
    self.backImageNameArray =
     @[@{@"name":@"检验任务",@"image":@"home_ inspection"},
       @{@"name":@"巡检任务",@"image":@"home_ check"},
       @{@"name":@"评估任务",@"image":@"home_ assessment"},
       @{@"name":@"维修任务",@"image":@"home_ maintenance"}];
    
    
}
#pragma mark  ------  UICollectionViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat y = scrollView.contentOffset.y;
    CGFloat deltaY = fabs(y);
    CGFloat imageOffset = self.imageHight + self.collectionViewContentInset;
    CGFloat offsetHeight = _SCREEN_HEIGHT-64-50-imageOffset;
    // 高斯模糊度
    CGFloat imageAlpha = (deltaY-imageOffset)/offsetHeight*1.4;
    
    if(y < - imageOffset)
    {
        CGRect frame = self.zoomImageView.frame;
        frame.origin.y = y;
        frame.size.height = -y-self.collectionViewContentInset;
        
        self.zoomImageView.frame = frame;
        self.effectView.frame = frame;
        self.effectView.alpha = imageAlpha;
    }

}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.backImageNameArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TBHomeTaskCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:TBHomeTaskCollectionViewCellID forIndexPath:indexPath];

    if (self.backImageNameArray.count > indexPath.row)
    {
        NSDictionary *dic = [self.backImageNameArray objectAtIndex:indexPath.row];
        [cell cellAssignmentData:dic];
    }

    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.cellSize;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, _cellClearance, 0, _cellClearance);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{


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
