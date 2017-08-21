//
//  ZKBaseClassViewMode.m
//  Emergency
//
//  Created by 王小腊 on 2017/5/3.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "ZKBaseClassViewMode.h"

@interface ZKBaseClassViewMode()

@end
@implementation ZKBaseClassViewMode

/**
 请求
 
 @param parameter 参数
 */
- (void)postDataParameter:(NSMutableDictionary *)parameter;
{
    TBWeakSelf
    [ZKPostHttp post:self.url params:parameter cacheType:ZKCacheTypeReloadIgnoringLocalCacheData success:^(NSDictionary *obj) {
        
        NSLog(@"\n\n 结果 == \n%@", obj);
        NSString *state = [obj valueForKey:@"state"];
        if ([state isEqualToString:@"success"])
        {
            if ([weakSelf.delegate respondsToSelector:@selector(originalData:)])
            {
                [weakSelf.delegate originalData:obj];
            }
            NSArray *data = [obj valueForKey:@"data"];
            [weakSelf dataCard:data];
            
        }
        else
        {
            if ([weakSelf.delegate respondsToSelector:@selector(postError:)])
            {
                [weakSelf.delegate postError:@"数据异常！"];
            }
        }
        
    } failure:^(NSError *error) {
        
        if ([weakSelf.delegate respondsToSelector:@selector(postError:)])
        {
            [weakSelf.delegate postError:@"网络异常！"];
        }
    }];
}
- (void)dataCard:(NSArray *)obj
{
    NSArray *root = obj;
    
    if ([self.delegate respondsToSelector:@selector(postDataEnd:)])
    {
        [self.delegate postDataEnd:root];
    }
    if (root.count < 20)
    {
        if ([self.delegate respondsToSelector:@selector(noMoreData)])
        {
            [self.delegate noMoreData];
        }
    }
    
}


@end
