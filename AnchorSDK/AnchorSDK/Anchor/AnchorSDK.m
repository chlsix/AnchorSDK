//
//  AnchorSDK.m
//  AnchorSDK
//
//  Created by chenlei on 2019/7/29.
//  Copyright © 2019 webeye. All rights reserved.
//

#import "AnchorSDK.h"

@implementation AnchorSDK

+ (void)initWithConfig:(AnchorConfig *)config application:(UIApplication *)application andLaunchOptions:(NSDictionary *)launchOptions {
    
    [AnchorSDK initFirebase];
    [AnchorSDK initAppsFlyerWithConfig:config];
    [AnchorSDK initFacebookWithApplication:application andLaunchOptions:launchOptions];
    [AnchorSDK initUMengWithConfig:config];

}

+ (void)initFirebase {
    Class firebaseClass = NSClassFromString(@"FIRApp");
    if (firebaseClass) {
        SEL configure = NSSelectorFromString(@"configure");
        if ([firebaseClass respondsToSelector:configure]) {
            IMP imp = [firebaseClass methodForSelector:configure];
            void (*func)(id, SEL) = (void *)imp;
            func(firebaseClass, configure);
        }
    }
}

+ (void)initAppsFlyerWithConfig:(AnchorConfig *)config {
    Class appsflyerClass = NSClassFromString(@"AppsFlyerTracker");
    if (appsflyerClass) {
        if (config.appKeyForAppsFlyer && config.appIdForAppsFlyer) {
            SEL sharedTrackerSel = NSSelectorFromString(@"sharedTracker");
            if ([appsflyerClass respondsToSelector:sharedTrackerSel]) {
                IMP imp = [appsflyerClass methodForSelector:sharedTrackerSel];
                Class (*func)(id, SEL) = (void *)imp;
                Class sharedTracker = func(appsflyerClass, sharedTrackerSel);
                SEL setAppsFlyerDevKey =  NSSelectorFromString(@"setAppsFlyerDevKey:");
                if ([sharedTracker respondsToSelector:setAppsFlyerDevKey]) {
                    IMP imp = [sharedTracker methodForSelector:setAppsFlyerDevKey];
                    void (*func)(id, SEL, NSString *) = (void *)imp;
                    func(sharedTracker, setAppsFlyerDevKey, config.appKeyForAppsFlyer);
                }
                SEL setAppleAppID =  NSSelectorFromString(@"setAppleAppID:");
                if ([sharedTracker respondsToSelector:setAppleAppID]) {
                    IMP imp = [sharedTracker methodForSelector:setAppleAppID];
                    void (*func)(id, SEL, NSString *) = (void *)imp;
                    func(sharedTracker, setAppleAppID, config.appIdForAppsFlyer);
                }
                
#ifdef DEBUG
                SEL setIsDebug =  NSSelectorFromString(@"setIsDebug:");
                if ([sharedTracker respondsToSelector:setIsDebug]) {
                    IMP imp = [sharedTracker methodForSelector:setIsDebug];
                    void (*func)(id, SEL, BOOL) = (void *)imp;
                    func(sharedTracker, setIsDebug, YES);
                }
#endif
            }
            
        }
        
    }
}

+ (void)initFacebookWithApplication:(UIApplication *)application andLaunchOptions:(NSDictionary *)launchOptions {
    Class facebookClass = NSClassFromString(@"FBSDKApplicationDelegate");
    if (facebookClass) {
        SEL sharedInstanceSel = NSSelectorFromString(@"sharedInstance");
        if ([facebookClass respondsToSelector:sharedInstanceSel]) {
            IMP imp = [facebookClass methodForSelector:sharedInstanceSel];
            Class (*func)(id, SEL) = (void *)imp;
            Class sharedInstance = func(facebookClass, sharedInstanceSel);
            SEL sel =  NSSelectorFromString(@"application:didFinishLaunchingWithOptions:");
            if ([sharedInstance respondsToSelector:sel]) {
                IMP imp = [sharedInstance methodForSelector:sel];
                void (*func)(id, SEL, UIApplication *, NSDictionary *) = (void *)imp;
                func(sharedInstance, sel, application, launchOptions);
            }
        }
    }
}

+ (void)initUMengWithConfig:(AnchorConfig *)config {
    Class umengClass = NSClassFromString(@"UMConfigure");
    if (umengClass) {
        if (config.appKeyForUmeng) {
            SEL sel = NSSelectorFromString(@"initWithAppkey:channel:");
            if ([umengClass respondsToSelector:sel]) {
                IMP imp = [umengClass methodForSelector:sel];
                void (*func)(id, SEL, NSString *, NSString *) = (void *)imp;
                func(umengClass, sel, config.appKeyForAppsFlyer, @"AppStore");
            }
            Class mobClickClass = NSClassFromString(@"MobClick");
            SEL setScenarioType =  NSSelectorFromString(@"setScenarioType:");
            if ([mobClickClass respondsToSelector:setScenarioType]) {
                IMP imp = [mobClickClass methodForSelector:setScenarioType];
                void (*func)(id, SEL, NSUInteger) = (void *)imp;
                func(mobClickClass, setScenarioType, 0);
            }
            
#ifdef DEBUG
            SEL setLogEnabled = NSSelectorFromString(@"setLogEnabled:");
            if ([umengClass respondsToSelector:setLogEnabled]) {
                IMP imp = [umengClass methodForSelector:setLogEnabled];
                void (*func)(id, SEL, BOOL) = (void *)imp;
                func(umengClass, setLogEnabled, YES);
            }
#endif
        }
        
    }
}

@end
