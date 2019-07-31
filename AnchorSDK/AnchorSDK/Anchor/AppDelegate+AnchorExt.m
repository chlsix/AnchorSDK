//
//  AppDelegate+AnchorExt.m
//  AnchorSDK
//
//  Created by chenlei on 2019/7/31.
//  Copyright © 2019 webeye. All rights reserved.
//

#import "AppDelegate+AnchorExt.h"
#import <objc/runtime.h>
#import "WEEventManager.h"
#import "AnchorEventConst.h"
#import "AnchorUtil.h"

static dispatch_source_t _timer;

#define WE_APP_START_TIME @"we_app_start_time"

@implementation AppDelegate (AnchorExt)

+ (void)load {
    [AppDelegate exchangeMethod:@selector(applicationDidBecomeActive:) targetSEL:@selector(ex_applicationDidBecomeActive:)];
    [AppDelegate exchangeMethod:@selector(applicationWillResignActive:) targetSEL:@selector(ex_applicationWillResignActive:)];
    [AppDelegate exchangeMethod:@selector(applicationWillTerminate:) targetSEL:@selector(ex_applicationWillTerminate:)];
    [AppDelegate exchangeMethod:@selector(application:openURL:options:) targetSEL:@selector(ex_application:openURL:options:)];

}

+ (void)exchangeMethod:(SEL)originSEL targetSEL:(SEL)targetSEL{
    
    Method originMethod = class_getInstanceMethod(self, originSEL);
    Method targetMethod = class_getInstanceMethod(self, targetSEL);
    
    IMP originIMP = class_getMethodImplementation(self, originSEL);
    IMP targetIMP = class_getMethodImplementation(self, targetSEL);
    
    BOOL didAddMethod = class_addMethod(self, originSEL, targetIMP, method_getTypeEncoding(originMethod));
    
    if (didAddMethod) {
        class_replaceMethod(self, targetSEL, originIMP, method_getTypeEncoding(originMethod));
    } else {
        method_exchangeImplementations(originMethod, targetMethod);
    }
}

- (void)ex_applicationDidBecomeActive:(UIApplication *)application {
    [self ex_applicationDidBecomeActive:application];
    
    [self onApplicationDidBecomeActive];
}

- (void)ex_applicationWillResignActive:(UIApplication *)application {
    [self ex_applicationWillResignActive:application];
    
    [self onApplicationWillResignActive];
}

- (void)ex_applicationWillTerminate:(UIApplication *)application {
    [self ex_applicationWillTerminate:application];
    
    [self onApplicationWillTerminate];
}

- (BOOL)ex_application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    [self ex_application:app openURL:url options:options];
    return [[WEEventManager shareManager] application:app openURL:url options:options];
}

- (void)onApplicationDidBecomeActive {
    [[WEEventManager shareManager] activeTrack];
        
    //打开APP
    [[WEEventManager shareManager] trackEvent:WE_APP_START];
        
    //首次打开
    if ([AnchorUtil isFirstInstall]) {
        [[WEEventManager shareManager] trackEvent:WE_FIRST_INSTALL];
    }
        
    //是否越狱
    NSString *isJailBreak =  [NSString stringWithFormat:@"%d", [AnchorUtil isJailBreak]];
    NSLog(@"isJailBreak: %@", isJailBreak);
    [[WEEventManager shareManager] trackEvent:WE_JUDGE value:@{@"description": @"1", @"result":isJailBreak}];
    
    //获取设备设置时区与GMT之前的差值
    NSString *seconds = [AnchorUtil secondsFromGMTForDate];
    [[WEEventManager shareManager] trackEvent:WE_OFFSET_ACQUIRE value:@{@"value": seconds}];
    
    [self startTimer];
}

- (void)onApplicationWillResignActive {
    [self stopTimer];
}

- (void)onApplicationWillTerminate {
    [self stopTimer];
}


- (void)startTimer {
    //记录app进入活跃状态的时间
    [[NSUserDefaults standardUserDefaults] setValue:[NSDate date] forKey:WE_APP_START_TIME];
    
    //设置时间间隔
    NSTimeInterval period = 600.f;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), period * NSEC_PER_SEC, 0);
    // 事件回调
    dispatch_source_set_event_handler(_timer, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"time out");
            //上报
            [[WEEventManager shareManager] trackEvent:WE_ENGAGEMENT value:@{@"time": @"600"}];
            //上报一次后更新app进入活跃状态的时间
            [[NSUserDefaults standardUserDefaults] setValue:[NSDate date] forKey:WE_APP_START_TIME];
        });
    });
    
    // 开启定时器
    dispatch_resume(_timer);
}

- (void)stopTimer {
    dispatch_source_cancel(_timer);
    if ([[NSUserDefaults standardUserDefaults] valueForKey:WE_APP_START_TIME]) {
        NSDate *startDate = [[NSUserDefaults standardUserDefaults] valueForKey:WE_APP_START_TIME];
        NSDate *stopDate = [NSDate date];
        NSTimeInterval time = [stopDate timeIntervalSinceDate:startDate];
        NSString *timeStr = [NSString stringWithFormat:@"%.f", time];
        [[WEEventManager shareManager] trackEvent:WE_ENGAGEMENT value:@{@"time": timeStr}];
    }
}

@end
