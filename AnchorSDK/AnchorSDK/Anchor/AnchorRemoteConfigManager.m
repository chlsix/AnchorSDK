//
//  AnchorRemoteConfigManager.m
//  AnchorSDK
//
//  Created by chenlei on 2019/7/30.
//  Copyright © 2019 webeye. All rights reserved.
//

#import "AnchorRemoteConfigManager.h"

static const NSTimeInterval expirationTime = 1000; //remote config配置缓存更新时间
typedef void (^AnchorFIRRemoteConfigFetchCompletion)(NSInteger status, NSError *__nullable error);

@interface AnchorRemoteConfigManager ()

@property (nonatomic) BOOL canConnectFireBase;
@property (nonatomic, strong) NSDictionary *defaultDic;


@end

@implementation AnchorRemoteConfigManager

+ (instancetype)sharedManager {
    static AnchorRemoteConfigManager *sharedInstance = nil;
    @synchronized(self) {
        if (sharedInstance == nil) {
            sharedInstance = [[self alloc] init];
            sharedInstance.canConnectFireBase = NO;
        }
    }
    
    return sharedInstance;
}

- (void)initRemoteConfig {
    //配置远程控制
    Class remoteConfigClass = NSClassFromString(@"FIRRemoteConfig");
    SEL remoteConfigSel = NSSelectorFromString(@"remoteConfig");
    if ([remoteConfigClass respondsToSelector:remoteConfigSel]) {
        IMP imp = [remoteConfigClass methodForSelector:remoteConfigSel];
        Class (*func)(id, SEL) = (void *)imp;
        self.remoteConfig = func(remoteConfigClass, remoteConfigSel);
        SEL setDefaultsSel = NSSelectorFromString(@"setDefaults:");
        if ([self.remoteConfig respondsToSelector:setDefaultsSel]) {
            IMP imp = [self.remoteConfig methodForSelector:setDefaultsSel];
            void (*func)(id, SEL, NSDictionary *) = (void *)imp;
            func(self.remoteConfig, setDefaultsSel, self.defaultDic);
            [self fetchRemoteConfigFromFireBase];
        }
    }
}

#pragma mark 从firebase 后台获取配置
- (void)fetchRemoteConfigFromFireBase {
    SEL sel = NSSelectorFromString(@"fetchWithExpirationDuration:completionHandler:");
    if ([[AnchorRemoteConfigManager sharedManager].remoteConfig respondsToSelector:sel]) {
        IMP imp = [[AnchorRemoteConfigManager sharedManager].remoteConfig methodForSelector:sel];
        void (*func)(id, SEL, NSTimeInterval, id) = (void *)imp;
        AnchorFIRRemoteConfigFetchCompletion completionHandler = ^(NSInteger status, NSError * _Nullable error) {
            if (status == 1) {
                SEL activateFetchedSel = NSSelectorFromString(@"activateFetched");
                if ([[AnchorRemoteConfigManager sharedManager].remoteConfig respondsToSelector:activateFetchedSel]) {
                    IMP imp = [[AnchorRemoteConfigManager sharedManager].remoteConfig methodForSelector:activateFetchedSel];
                    BOOL (*func)(id, SEL) = (void *)imp;
                    func([AnchorRemoteConfigManager sharedManager].remoteConfig, activateFetchedSel);
                }

            }
        };
        func([AnchorRemoteConfigManager sharedManager].remoteConfig, sel, expirationTime, completionHandler);
    }
}

- (NSDictionary *)defaultDic {
    if (!_defaultDic) {
        NSDictionary *dic = @{
                              WE_R_FIREBASE: [NSNumber numberWithBool:YES],
                              WE_R_FACEBOOK: [NSNumber numberWithBool:YES],
                              WE_R_APPSFLYER: [NSNumber numberWithBool:YES],
                              WE_R_UMENG: [NSNumber numberWithBool:YES],
                              WE_R_ANCHOR: [NSNumber numberWithBool:YES],
                              };
        _defaultDic = [NSDictionary dictionaryWithDictionary:dic];
    }
    return _defaultDic;
}

+ (BOOL)remoteValueJudgeWithKey:(NSString *)key {
    BOOL value = YES;
    if (!([[AnchorRemoteConfigManager sharedManager].remoteConfig valueForKey:key] == nil)) {
        value = [[[AnchorRemoteConfigManager sharedManager].remoteConfig valueForKey:key] boolValue];
    }
    return value;
}

@end
