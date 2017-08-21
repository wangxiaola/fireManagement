//
//  AppDelegate.m
//  fireManagement
//
//  Created by 王小腊 on 2017/8/18.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "AppDelegate.h"
#import "IQKeyboardManager.h"
#import "MyUncaughtExceptionHandler.h"
#import "TBUpdateTooltipView.h"
#import "ZKNavigationController.h"
#import "TBLogInViewController.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreLocation/CoreLocation.h>
#import "TBNetworkPromptView.h"
@interface AppDelegate ()<CLLocationManagerDelegate>
@property(nonatomic) CLLocationManager *locationManager;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self initSDK];
//    [self checkVersion];
    [self workReachability];
    ZKNavigationController *nav = [[ZKNavigationController alloc] initWithRootViewController:[[TBLogInViewController alloc] init]];
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    
    return YES;
}
- (void)initSDK
{
    // 设置键盘监听管理
    IQKeyboardManager *keyboardManager = [IQKeyboardManager sharedManager];
    [keyboardManager setEnable:YES];
    [keyboardManager setKeyboardDistanceFromTextField:0];
    [keyboardManager setEnableAutoToolbar:YES];
    [keyboardManager setToolbarManageBehaviour:IQAutoToolbarBySubviews];
    [keyboardManager setPlaceholderFont:[UIFont systemFontOfSize:14]];
    [keyboardManager setShouldResignOnTouchOutside:NO];
    [keyboardManager setToolbarTintColor:NAVIGATION_COLOR];
    
    [AMapServices sharedServices].apiKey = GDMAP_KEY;
    
    // 开启定位权限
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
#pragma mark -- 崩溃日志
    [MyUncaughtExceptionHandler setDefaultHandler];
    // 发送崩溃日志
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *dataPath = [path stringByAppendingPathComponent:@"Exception.txt"];
    NSData *data = [NSData dataWithContentsOfFile:dataPath];
    if (data != nil) {
        [self sendExceptionLogWithData:data path:dataPath];
    }

}
-(void)checkVersion{
    //版本更新
    [self versionInformationQuery];
}
#pragma mark --- 监听网络状态---
/**
 监听网络状态
 */
- (void)workReachability
{
    //创建网络监听管理者对象
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    //设置监听
    TBWeakSelf
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status)
     {
         weakSelf.workStatus = status;
         [weakSelf stateGrid:status];
     }];
    
    //开始监听
    [manager startMonitoring];
    
}
- (void)stateGrid:(AFNetworkReachabilityStatus)workStatus
{
    if (workStatus == AFNetworkReachabilityStatusUnknown)
    {
//        hudShowError(@"网络连接异常!");
        [TBNetworkPromptView showPrompt:@""];
    }
    else if (workStatus == AFNetworkReachabilityStatusNotReachable)
    {
        // 不可达的网络(未连接)
//        hudShowError(@"网络异常!");
        [TBNetworkPromptView showPrompt:@""];
    }
    else if (workStatus == AFNetworkReachabilityStatusReachableViaWWAN)
    {
        // 2G,3G,4G...的网络
        [TBNetworkPromptView dismissNetworkPromptView];
    }
    else if (workStatus == AFNetworkReachabilityStatusReachableViaWiFi)
    {
        // wifi的网络
        [TBNetworkPromptView dismissNetworkPromptView];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
#pragma mark -- 发送崩溃日志
- (void)sendExceptionLogWithData:(NSData *)data path:(NSString *)path {
    
    
    //#ifdef DEBUG
    //     删除文件
    NSFileManager *fileManger = [NSFileManager defaultManager];
    [fileManger removeItemAtPath:path error:nil];
    //#else
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    CFShow((__bridge CFTypeRef)(infoDictionary));
    // app名称
    NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    // app版本
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    // app build版本
    NSString *app_build = [infoDictionary objectForKey:@"CFBundleVersion"];
    // 手机系统版本：9.1
    NSString* phoneVersion = [[UIDevice currentDevice] systemVersion];
    // 手机类型：iPhone 6
    NSString* phoneModel = [ZKUtil deviceVersion];
    //获取用户账号
    NSString *phone = [NSString stringWithFormat:@"iPhone_%@",[UserInfo account].phone];
    phone = phone.length == 0?@"iPhone_未登陆":phone;
    
    NSString *result = [[NSString alloc] initWithData:data  encoding:NSUTF8StringEncoding];
    NSMutableDictionary *dic = [NSMutableDictionary params];
    [dic setObject:result forKey:@"info"];
    [dic setObject:phoneModel forKey:@"model"];
    [dic setObject:phoneVersion forKey:@"vers"];
    [dic setObject:app_build forKey:@"exs"];
    [dic setObject:phone forKey:@"name"];
    [dic setObject:app_Version forKey:@"releaser"];
    [dic setObject:app_Name forKey:@"projectr"];
    
    [ZKPostHttp postPath:@"http://tpanzhihua.m.geeker.com.cn/exception.do" params:dic success:^(id responseObj) {
        //     删除文件
        NSFileManager *fileManger = [NSFileManager defaultManager];
        [fileManger removeItemAtPath:path error:nil];
        
    } failure:^(NSError *error) {
        
    }];
    
}
#pragma mark  --CLLocationManager--
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
            if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
                
                [self.locationManager requestWhenInUseAuthorization];     //NSLocationWhenInUseDescription
                [self.locationManager requestAlwaysAuthorization];
                
            }
            break;
        default:
            break;
            
    }
}

/**
 更新查询
 */
- (void)versionInformationQuery
{
    NSString *appItunesUrlStr = [NSString stringWithFormat:@"https://itunes.apple.com/cn/lookup?id=%@",TELECOM_ID];
    NSURL *urlS = [NSURL URLWithString:appItunesUrlStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:urlS cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        if (data.length > 0) {
            //有返回数据
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:Nil];
            
            NSArray *results = [dic objectForKey:@"results"];
            
            if (results.count >0)
            {
                //appStore 版本
                NSString *newVersion = [[[dic objectForKey:@"results"] objectAtIndex:0]objectForKey:@"version"];
                NSString *updateContent = [NSString stringWithFormat:@"更新说明: %@",[[[dic objectForKey:@"results"] objectAtIndex:0]objectForKey:@"releaseNotes"]];
                //本地版本
                NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
                NSString *currentVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
                
                if (newVersion && ([newVersion compare:currentVersion] == 1))
                {
                    
                    TBUpdateTooltipView *updataView = [[TBUpdateTooltipView alloc] initShowPrompt:updateContent];
                    [updataView show];
                    
                    
                }
            }
            
        }
        
    }];
    
}


@end
