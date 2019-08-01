//
//  AnchorSDK.m
//  AnchorSDK
//
//  Created by chenlei on 2019/7/29.
//  Copyright © 2019 webeye. All rights reserved.
//

#import "AnchorSDK.h"
#import "WEEventManager.h"
#import "AnchorUtil.h"
#import "AnchorEventConst.h"
#import "AnchorRemoteConfigManager.h"
#import "AnchorLogManager.h"


static AnchorConfig *_defaultConfig;

static dispatch_source_t _timer;

#define WE_APP_START_TIME @"we_app_start_time"

@implementation AnchorSDK

+ (void)initWithConfig:(AnchorConfig *)config application:(UIApplication *)application andLaunchOptions:(NSDictionary *)launchOptions {
    if (config == nil) {
        _defaultConfig = [[AnchorConfig alloc] init];
    } else {
        _defaultConfig = config;
    }
    [AnchorLogManager setLogEnable:_defaultConfig.logEnable];
    Class remoteConfigClass = NSClassFromString(@"FIRRemoteConfig");
    SEL remoteConfigSel = NSSelectorFromString(@"remoteConfig");
    if ([remoteConfigClass respondsToSelector:remoteConfigSel]) {
        [[AnchorRemoteConfigManager sharedManager] initRemoteConfig];
        [AnchorRemoteConfigManager sharedManager].callbackBlock = ^(AnchorRemoteConfigManager * _Nonnull manager, BOOL canConnectFireBase) {
            [AnchorSDK commonSetWithConfig:_defaultConfig application:application andLaunchOptions:launchOptions];
        };
    } else {
        [AnchorSDK commonSetWithConfig:_defaultConfig application:application andLaunchOptions:launchOptions];
    }
   
}

+ (void)commonSetWithConfig:(AnchorConfig *)config application:(UIApplication *)application andLaunchOptions:(NSDictionary *)launchOptions {
    if (config.enableStatistics && [AnchorRemoteConfigManager remoteValueJudgeWithKey:WE_R_ANCHOR]) {
        if (config.enableFirebase && [AnchorRemoteConfigManager remoteValueJudgeWithKey:WE_R_FIREBASE]) {
            [AnchorSDK initFirebase];
        }
        if (config.enableAppsFlyer && [AnchorRemoteConfigManager remoteValueJudgeWithKey:WE_R_APPSFLYER]) {
            [AnchorSDK initAppsFlyerWithConfig:config];
        }
        if (config.enableFacebook && [AnchorRemoteConfigManager remoteValueJudgeWithKey:WE_R_FACEBOOK]) {
            [AnchorSDK initFacebookWithApplication:application andLaunchOptions:launchOptions];
        }
        if (config.enableUmeng && [AnchorRemoteConfigManager remoteValueJudgeWithKey:WE_R_UMENG]) {
            [AnchorSDK initUMengWithConfig:config];
        }
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onApplicationDidBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onApplicationWillResignActive) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onApplicationWillTerminate) name:UIApplicationWillTerminateNotification object:nil];
}

+ (void)onApplicationDidBecomeActive {
    [[WEEventManager shareManager] activeTrack];
    
    //打开APP
    [AnchorSDK reportCustomEvent:WE_APP_START];
    
    //首次打开
    if ([AnchorUtil isFirstInstall]) {
        [AnchorSDK reportCustomEvent:WE_FIRST_INSTALL];
    }
    
    //是否越狱
    NSString *isJailBreak =  [NSString stringWithFormat:@"%d", [AnchorUtil isJailBreak]];
    [AnchorSDK reportCustomEvent:WE_JUDGE andParams:@{@"description": @"1", @"result":isJailBreak}];
    
    //获取设备设置时区与GMT之前的差值
    NSString *seconds = [AnchorUtil secondsFromGMTForDate];
    [AnchorSDK reportCustomEvent:WE_OFFSET_ACQUIRE andParams:@{@"value": seconds}];
    
    [AnchorSDK startTimer];
}

+ (void)onApplicationWillResignActive {
    [AnchorSDK stopTimer];
}

+ (void)onApplicationWillTerminate {
    [self stopTimer];
}


+ (void)startTimer {
    //记录app进入活跃状态的时间
    [[NSUserDefaults standardUserDefaults] setValue:[NSDate date] forKey:WE_APP_START_TIME];
    
    //设置时间间隔
    NSTimeInterval period = 600.f;
    __block BOOL isFrist = YES;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), period * NSEC_PER_SEC, 0);
    // 事件回调
    dispatch_source_set_event_handler(_timer, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (isFrist) {
                isFrist = NO;
            } else {
                //上报
                [AnchorSDK reportCustomEvent:WE_ENGAGEMENT andParams:@{@"time": @"600"}];
                //上报一次后更新app进入活跃状态的时间
                [[NSUserDefaults standardUserDefaults] setValue:[NSDate date] forKey:WE_APP_START_TIME];
            }
        });
    });
    
    // 开启定时器
    dispatch_resume(_timer);
}

+ (void)stopTimer {
    dispatch_source_cancel(_timer);
    if ([[NSUserDefaults standardUserDefaults] valueForKey:WE_APP_START_TIME]) {
        NSDate *startDate = [[NSUserDefaults standardUserDefaults] valueForKey:WE_APP_START_TIME];
        NSDate *stopDate = [NSDate date];
        NSTimeInterval time = [stopDate timeIntervalSinceDate:startDate];
        NSString *timeStr = [NSString stringWithFormat:@"%.0f", time];
        [AnchorSDK reportCustomEvent:WE_ENGAGEMENT andParams:@{@"time": timeStr}];
    }
}


+ (void)initFirebase {
    [[WEEventManager shareManager] initFirebase];
}

+ (void)initAppsFlyerWithConfig:(AnchorConfig *)config {
    [[WEEventManager shareManager] initAppsFlyerWithAppsFlyerDevKey:config.appKeyForAppsFlyer andAppleAppID:config.appIdForAppsFlyer];
}

+ (void)initFacebookWithApplication:(UIApplication *)application andLaunchOptions:(NSDictionary *)launchOptions {
    [[WEEventManager shareManager] initFacebookWithApplication:application andLaunchOptions:launchOptions];
}

+ (void)initUMengWithConfig:(AnchorConfig *)config {
    [[WEEventManager shareManager] initUMengWithAppkey:config.appKeyForUmeng andChannel:@"App Store" andScenarioType:0];
}


+ (void)onHandleOpenURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    if (_defaultConfig.enableStatistics) {
        [[WEEventManager shareManager] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
    }
}

+ (BOOL)onApplication:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    BOOL handle = YES;
    if (_defaultConfig.enableStatistics) {
        handle = [[WEEventManager shareManager] application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
    }
    return handle;
}

+ (BOOL)onApplication:(UIApplication *)application openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    BOOL handle = YES;
    if (_defaultConfig.enableStatistics) {
        handle = [[WEEventManager shareManager] application:application openURL:url options:options];
    }
    return handle;
}

+ (void)reportCustomEvent:(NSString *)eventName {
    NSString *key = [NSString stringWithFormat:@"r_%@", eventName];
    if ([AnchorRemoteConfigManager remoteValueJudgeWithKey:key]) {
        [[WEEventManager shareManager] trackEvent:eventName];
    }
}

+ (void)reportCustomEvent:(NSString *)eventName andParams:(NSDictionary *)eventParams {
    NSString *key = [NSString stringWithFormat:@"r_%@", eventName];
    if ([AnchorRemoteConfigManager remoteValueJudgeWithKey:key]) {
        [[WEEventManager shareManager] trackEvent:eventName value:eventParams];
    }
}


+ (void)reportSignUpSuccess:(NSString *)type {
    [AnchorSDK reportCustomEvent:WE_SIGN_UP andParams:@{@"type": type, @"result": @"1", @"description": @"sign up success"}];
}

+ (void)reportSignUpFailed:(NSString *)type description:(NSString *)description {
    [AnchorSDK reportCustomEvent:WE_SIGN_UP andParams:@{@"type": type, @"result": @"0", @"description": description}];
}

+ (void)reportLogInSuccess:(NSString *)type {
    [AnchorSDK reportCustomEvent:WE_LOG_IN andParams:@{@"type": type, @"result": @"1", @"description": @"log in success"}];
    
}

+ (void)reportLogInFailed:(NSString *)type description:(NSString *)description {
    [AnchorSDK reportCustomEvent:WE_LOG_IN andParams:@{@"type": type, @"result": @"0", @"description": description}];
}

+ (void)reportLogOutSuccess:(NSString *)type {
    [AnchorSDK reportCustomEvent:WE_LOG_OUT andParams:@{@"type": type, @"result": @"1", @"description": @"log out success"}];
}

+ (void)reportLogOutFailed:(NSString *)type description:(NSString *)description {
    [AnchorSDK reportCustomEvent:WE_LOG_OUT andParams:@{@"type": type, @"result": @"0", @"description": description}];

}

+ (void)reportPurchaseRequest:(NSString *)productId value:(float)value target:(NSString *)target {
    if (target == nil) {
        target = @"";
    }
    [AnchorSDK reportCustomEvent:WE_PURCHASE_REQUEST andParams:@{@"item_id": productId, @"target": target, @"value": [NSString stringWithFormat:@"%f", value]}];
}

+ (void)reportPurchaseSuccess:(NSString *)productId value:(float)value target:(NSString *)target {
    if (target == nil) {
        target = @"";
    }
    [AnchorSDK reportCustomEvent:WE_PURCHASE_SUCCESS andParams:@{@"item_id": productId, @"target": target, @"value": [NSString stringWithFormat:@"%f", value]}];
}

+ (void)reportPurchaseCancel:(NSString *)productId value:(float)value target:(NSString *)target {
    if (target == nil) {
        target = @"";
    }
    [AnchorSDK reportCustomEvent:WE_PURCHASE_CANCEL andParams:@{@"item_id": productId, @"target": target, @"value": [NSString stringWithFormat:@"%f", value]}];
}

+ (void)reportPurchaseFailed:(NSString *)productId value:(float)value target:(NSString *)target description:(NSString *)description {
    if (target == nil) {
        target = @"";
    }
    [AnchorSDK reportCustomEvent:WE_PURCHASE_FAILED andParams:@{
                                                      @"item_id": productId,
                                                      @"target": target,
                                                      @"value": [NSString stringWithFormat:@"%f", value],
                                                      @"description": description
                                                      }];
}

+ (void)reportSubRequest:(NSString *)productId value:(float)value target:(NSString *)target {
    if (target == nil) {
        target = @"";
    }
    [AnchorSDK reportCustomEvent:WE_SUB_REQUEST andParams:@{@"item_id": productId, @"target": target, @"value": [NSString stringWithFormat:@"%f", value]}];
}

+ (void)reportSubSuccess:(NSString *)productId value:(float)value target:(NSString *)target {
    if (target == nil) {
        target = @"";
    }
    [AnchorSDK reportCustomEvent:WE_SUB_SUCCESS andParams:@{@"item_id": productId, @"target": target, @"value": [NSString stringWithFormat:@"%f", value]}];
}

+ (void)reportSubCancel:(NSString *)productId value:(float)value target:(NSString *)target {
    if (target == nil) {
        target = @"";
    }
    [AnchorSDK reportCustomEvent:WE_SUB_CANCEL andParams:@{@"item_id": productId, @"target": target, @"value": [NSString stringWithFormat:@"%f", value]}];
}

+ (void)reportSubFailed:(NSString *)productId value:(float)value target:(NSString *)target description:(NSString *)description {
    if (target == nil) {
        target = @"";
    }
    [AnchorSDK reportCustomEvent:WE_PURCHASE_FAILED andParams:@{
                                                      @"item_id": productId,
                                                      @"target": target,
                                                      @"value": [NSString stringWithFormat:@"%f", value],
                                                      @"description": description
                                                      }];
}


@end
