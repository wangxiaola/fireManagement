//
//  TBNetworkPromptView.m
//  fireManagement
//
//  Created by 王小腊 on 2017/8/21.
//  Copyright © 2017年 王小腊. All rights reserved.
//

static CGFloat viewHeight  = 44;
static NSMutableDictionary *_tempDict;
#import "TBNetworkPromptView.h"

@interface TBNetworkPromptView ()


@end
@implementation TBNetworkPromptView

+ (void)initialize
{
    _tempDict = [NSMutableDictionary dictionary];
}

+ (void)showPrompt:(NSString *)msg;
{
    
    TBNetworkPromptView *viewHUD = _tempDict[@"TipView"];
    [viewHUD removeFromSuperview];
    viewHUD = nil;
    if (viewHUD == nil)
    {
        viewHUD = [[TBNetworkPromptView alloc] init];
        viewHUD.frame = CGRectMake(0, 64, _SCREEN_WIDTH, 0.0f);
        viewHUD.backgroundColor = RGB(252, 211, 210);
        [[APPDELEGATE window] addSubview:viewHUD];
        _tempDict[@"TipView"] = viewHUD;
        UIButton *bty = [UIButton buttonWithType:UIButtonTypeCustom];
        [bty addTarget:viewHUD action:@selector(netWorkClick) forControlEvents:UIControlEventTouchUpInside];
        [viewHUD addSubview:bty];
        
        UIButton *promptButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [promptButton setTitle:@"   网络不给力，请检查网络设置。" forState:UIControlStateNormal];
        [promptButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        promptButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [promptButton setImage:[UIImage imageNamed:@"warning"] forState:UIControlStateNormal];
        [viewHUD addSubview:promptButton];
        
        UIImageView *lefView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"right_ arrow"]];
        [viewHUD addSubview:lefView];
        
        [bty mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(viewHUD);
        }];
        [promptButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(viewHUD.mas_left).offset(10);
            make.centerY.equalTo(viewHUD.mas_centerY);
        }];
        [lefView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(viewHUD.mas_right).offset(-8);
            make.centerY.equalTo(viewHUD.mas_centerY);
        }];
        viewHUD.clipsToBounds = YES;
        viewHUD.layer.opacity = 0.7;
    }

    [viewHUD showAnimated:YES];
    
}
#pragma ---netWorkClick--
- (void)netWorkClick
{
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] ];
    
}
- (void)showAnimated:(BOOL)animated
{
    if (animated)
    {
        [UIView animateWithDuration:0.5f animations:^{
            
         self.frame = CGRectMake(0, 64, _SCREEN_WIDTH, viewHeight);
        }];
        
    }
}
+ (void)dismissNetworkPromptView;
{
    TBNetworkPromptView *viewHUD = _tempDict[@"TipView"];
    [UIView animateWithDuration:0.5f animations:^{
        
        viewHUD.frame = CGRectMake(0, 64, _SCREEN_WIDTH, 0.0);
        [viewHUD layoutIfNeeded];
    } completion:^(BOOL finished) {
        
        [viewHUD removeFromSuperview];
        [_tempDict removeAllObjects];
        
    }];
    
}
@end
