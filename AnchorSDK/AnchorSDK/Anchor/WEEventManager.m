//
//  WEEventManager.m
//  AnchorSDK
//
//  Created by chenlei on 2019/7/29.
//  Copyright © 2019 webeye. All rights reserved.
//

#import "WEEventManager.h"


@implementation WEEventManager

+ (instancetype)shareManager {
    static dispatch_once_t onceToken;
    static WEEventManager * manager = nil;
    dispatch_once(&onceToken, ^{
        manager = [WEEventManager new];
        manager.trackPattern = WEAnalyzePatternTrackAll;
        manager.trackApproach = WEAnalyzeApproachNone;
    });
    
    return manager;
}

- (void)initFirebase {
    Class firebaseClass = NSClassFromString(@"FIRApp");
    if (firebaseClass) {
        SEL defaultAppSel = NSSelectorFromString(@"defaultApp");
        if ([firebaseClass respondsToSelector:defaultAppSel]) {
            IMP imp = [firebaseClass methodForSelector:defaultAppSel];
            Class (*func)(id, SEL) = (void *)imp;
            Class firApp = func(firebaseClass, defaultAppSel);
            if (firApp == nil) {
                SEL configure = NSSelectorFromString(@"configure");
                if ([firebaseClass respondsToSelector:configure]) {
                    IMP imp = [firebaseClass methodForSelector:configure];
                    void (*func)(id, SEL) = (void *)imp;
                    func(firebaseClass, configure);
                }
            }
            [WEEventManager shareManager].trackApproach |= WEAnalyzeApproachFirebase;
        }
    }
}

- (void)initFacebookWithApplication:(UIApplication *)application andLaunchOptions:(NSDictionary *)launchOptions {
    Class facebookClass = NSClassFromString(@"FBSDKApplicationDelegate");
    if (facebookClass) {
        SEL sharedInstanceSel = NSSelectorFromString(@"sharedInstance");
        if ([facebookClass respondsToSelector:sharedInstanceSel]) {
            IMP imp = [facebookClass methodForSelector:sharedInstanceSel];
            Class (*func)(id, SEL) = (void *)imp;
            Class sharedInstance = func(facebookClass, sharedInstanceSel);
            SEL sel =  NSSelectorFromString(@"application:didFinishLaunchingWithOptions:");
            if ([sharedInstance respondsToSelector:sel]) {
                [WEEventManager shareManager].trackApproach |= WEAnalyzeApproachFacebook;
                IMP imp = [sharedInstance methodForSelector:sel];
                void (*func)(id, SEL, UIApplication *, NSDictionary *) = (void *)imp;
                func(sharedInstance, sel, application, launchOptions);
            }
        }
    }
}

- (void)initAppsFlyerWithAppsFlyerDevKey:(NSString *)appsFlyerDevKey andAppleAppID:(NSString *)appleAppID {
    Class appsflyerClass = NSClassFromString(@"AppsFlyerTracker");
    if (appsflyerClass) {
        if (appsFlyerDevKey && appleAppID) {
            SEL sharedTrackerSel = NSSelectorFromString(@"sharedTracker");
            if ([appsflyerClass respondsToSelector:sharedTrackerSel]) {
                [WEEventManager shareManager].trackApproach |= WEAnalyzeApproachAppsFlyer;
                IMP imp = [appsflyerClass methodForSelector:sharedTrackerSel];
                Class (*func)(id, SEL) = (void *)imp;
                Class sharedTracker = func(appsflyerClass, sharedTrackerSel);
                SEL setAppsFlyerDevKey =  NSSelectorFromString(@"setAppsFlyerDevKey:");
                if ([sharedTracker respondsToSelector:setAppsFlyerDevKey]) {
                    IMP imp = [sharedTracker methodForSelector:setAppsFlyerDevKey];
                    void (*func)(id, SEL, NSString *) = (void *)imp;
                    func(sharedTracker, setAppsFlyerDevKey, appsFlyerDevKey);
                }
                SEL setAppleAppID =  NSSelectorFromString(@"setAppleAppID:");
                if ([sharedTracker respondsToSelector:setAppleAppID]) {
                    IMP imp = [sharedTracker methodForSelector:setAppleAppID];
                    void (*func)(id, SEL, NSString *) = (void *)imp;
                    func(sharedTracker, setAppleAppID, appleAppID);
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

- (void)initUMengWithAppkey:(NSString *)appkey andChannel:(NSString *)channel andScenarioType:(NSUInteger)type {
    Class umengClass = NSClassFromString(@"UMConfigure");
    if (umengClass) {
        if (appkey) {
            SEL sel = NSSelectorFromString(@"initWithAppkey:channel:");
            if ([umengClass respondsToSelector:sel]) {
                [WEEventManager shareManager].trackApproach |= WEAnalyzeApproachUMeng;
                IMP imp = [umengClass methodForSelector:sel];
                void (*func)(id, SEL, NSString *, NSString *) = (void *)imp;
                func(umengClass, sel, appkey, channel);
            }
            Class mobClickClass = NSClassFromString(@"MobClick");
            SEL setScenarioType =  NSSelectorFromString(@"setScenarioType:");
            if ([mobClickClass respondsToSelector:setScenarioType]) {
                IMP imp = [mobClickClass methodForSelector:setScenarioType];
                void (*func)(id, SEL, NSUInteger) = (void *)imp;
                func(mobClickClass, setScenarioType, type);
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

- (void)activeTrack {
    if ([WEEventManager shareManager].trackApproach & WEAnalyzeApproachFacebook) {
        Class class = NSClassFromString(@"FBSDKAppEvents");
        SEL activateAppSel = NSSelectorFromString(@"activateApp");
        if ([class respondsToSelector:activateAppSel]) {
            IMP imp = [class methodForSelector:activateAppSel];
            void (*func)(id, SEL) = (void *)imp;
            func(class, activateAppSel);
        }
    }
    
    if ([WEEventManager shareManager].trackApproach & WEAnalyzeApproachAppsFlyer) {
        Class appsflyerClass = NSClassFromString(@"AppsFlyerTracker");
        SEL sharedTrackerSel = NSSelectorFromString(@"sharedTracker");
        if ([appsflyerClass respondsToSelector:sharedTrackerSel]) {
            IMP imp = [appsflyerClass methodForSelector:sharedTrackerSel];
            Class (*func)(id, SEL) = (void *)imp;
            Class sharedTracker = func(appsflyerClass, sharedTrackerSel);
            SEL trackAppLaunchSel =  NSSelectorFromString(@"trackAppLaunch");
            if ([sharedTracker respondsToSelector:trackAppLaunchSel]) {
                IMP imp = [sharedTracker methodForSelector:trackAppLaunchSel];
                void (*func)(id, SEL) = (void *)imp;
                func(sharedTracker, trackAppLaunchSel);
            }
        }
    }
}

- (void)handleOpenURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    if ([WEEventManager shareManager].trackApproach & WEAnalyzeApproachAppsFlyer) {
        Class appsflyerClass = NSClassFromString(@"AppsFlyerTracker");
        SEL sharedTrackerSel = NSSelectorFromString(@"sharedTracker");
        if ([appsflyerClass respondsToSelector:sharedTrackerSel]) {
            IMP imp = [appsflyerClass methodForSelector:sharedTrackerSel];
            Class (*func)(id, SEL) = (void *)imp;
            Class sharedTracker = func(appsflyerClass, sharedTrackerSel);
            SEL sel =  NSSelectorFromString(@"handleOpenURL:sourceApplication:withAnnotation:");
            if ([sharedTracker respondsToSelector:sel]) {
                IMP imp = [sharedTracker methodForSelector:sel];
                void (*func)(id, SEL, NSURL *, NSString *, id) = (void *)imp;
                func(sharedTracker, sel, url, sourceApplication, annotation);
            }
        }
    }
}


- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    BOOL handle = YES;
    if ([WEEventManager shareManager].trackApproach & WEAnalyzeApproachFacebook) {
        Class facebookClass = NSClassFromString(@"FBSDKApplicationDelegate");
        if (facebookClass) {
            SEL sharedInstanceSel = NSSelectorFromString(@"sharedInstance");
            if ([facebookClass respondsToSelector:sharedInstanceSel]) {
                IMP imp = [facebookClass methodForSelector:sharedInstanceSel];
                Class (*func)(id, SEL) = (void *)imp;
                Class sharedInstance = func(facebookClass, sharedInstanceSel);
                SEL sel =  NSSelectorFromString(@"application:openURL:sourceApplication:annotation:");
                if ([sharedInstance respondsToSelector:sel]) {
                    [WEEventManager shareManager].trackApproach |= WEAnalyzeApproachFacebook;
                    IMP imp = [sharedInstance methodForSelector:sel];
                    BOOL (*func)(id, SEL, UIApplication *, NSURL *, NSString *, id) = (void *)imp;
                    handle = func(sharedInstance, sel, application, url, sourceApplication, annotation);
                }
            }
        }
    }
    return handle;
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
            options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    BOOL handle = YES;
    if ([WEEventManager shareManager].trackApproach & WEAnalyzeApproachAppsFlyer) {
        Class appsflyerClass = NSClassFromString(@"AppsFlyerTracker");
        SEL sharedTrackerSel = NSSelectorFromString(@"sharedTracker");
        if ([appsflyerClass respondsToSelector:sharedTrackerSel]) {
            IMP imp = [appsflyerClass methodForSelector:sharedTrackerSel];
            Class (*func)(id, SEL) = (void *)imp;
            Class sharedTracker = func(appsflyerClass, sharedTrackerSel);
            SEL sel =  NSSelectorFromString(@"handleOpenURL:options:");
            if ([sharedTracker respondsToSelector:sel]) {
                IMP imp = [sharedTracker methodForSelector:sel];
                void (*func)(id, SEL, NSURL *, id) = (void *)imp;
                func(sharedTracker, sel, url, options);
            }
        }
    }
  
    if ([WEEventManager shareManager].trackApproach & WEAnalyzeApproachFacebook) {
        Class facebookClass = NSClassFromString(@"FBSDKApplicationDelegate");
        if (facebookClass) {
            SEL sharedInstanceSel = NSSelectorFromString(@"sharedInstance");
            if ([facebookClass respondsToSelector:sharedInstanceSel]) {
                IMP imp = [facebookClass methodForSelector:sharedInstanceSel];
                Class (*func)(id, SEL) = (void *)imp;
                Class sharedInstance = func(facebookClass, sharedInstanceSel);
                SEL sel =  NSSelectorFromString(@"application:openURL:sourceApplication:annotation:");
                if ([sharedInstance respondsToSelector:sel]) {
                    [WEEventManager shareManager].trackApproach |= WEAnalyzeApproachFacebook;
                    IMP imp = [sharedInstance methodForSelector:sel];
                    BOOL (*func)(id, SEL, UIApplication *, NSURL *, NSString *, id) = (void *)imp;
                    handle = func(sharedInstance, sel, application, url, options[UIApplicationOpenURLOptionsSourceApplicationKey], options[UIApplicationOpenURLOptionsAnnotationKey]);
                }
            }
        }
    }
    return handle;
}


- (void)trackEvent:(NSString *)event {
    [self trackEvent:event value:nil];
}

- (void)trackEvent:(NSString *)event value:(NSDictionary *)paramter {
    if ([WEEventManager shareManager].trackPattern != WEAnalyzePatternDebug && [WEEventManager shareManager].trackApproach != WEAnalyzeApproachNone
        ) {
        if ([WEEventManager shareManager].trackApproach & WEAnalyzeApproachFirebase) {
            Class class = NSClassFromString(@"FIRAnalytics");
            SEL sel = NSSelectorFromString(@"logEventWithName:parameters:");
            if ([class respondsToSelector:sel]) {
                IMP imp = [class methodForSelector:sel];
                void (*func)(id, SEL, NSString *, id) = (void *)imp;
                func(class, sel, event, paramter);
            }
        }
        
        if ([WEEventManager shareManager].trackApproach & WEAnalyzeApproachUMeng) {
            Class class = NSClassFromString(@"MobClick");
            SEL sel = NSSelectorFromString(@"event:attributes:");
            if ([class respondsToSelector:sel]) {
                IMP imp = [class methodForSelector:sel];
                void (*func)(id, SEL, NSString *, id) = (void *)imp;
                func(class, sel, event, paramter);
            }
        }
        
        if ([WEEventManager shareManager].trackApproach & WEAnalyzeApproachAppsFlyer) {
            Class appsflyerClass = NSClassFromString(@"AppsFlyerTracker");
            SEL sharedTrackerSel = NSSelectorFromString(@"sharedTracker");
            if ([appsflyerClass respondsToSelector:sharedTrackerSel]) {
                IMP imp = [appsflyerClass methodForSelector:sharedTrackerSel];
                Class (*func)(id, SEL) = (void *)imp;
                Class sharedTracker = func(appsflyerClass, sharedTrackerSel);
                SEL sel = NSSelectorFromString(@"trackEvent:withValues");
                if ([sharedTracker respondsToSelector:sel]) {
                    IMP imp = [sharedTracker methodForSelector:sel];
                    void (*func)(id, SEL, NSString *, id) = (void *)imp;
                    func(sharedTracker, sel, event, paramter);
                }
            }
        }
        
        if ([WEEventManager shareManager].trackApproach & WEAnalyzeApproachFacebook) {
            Class class = NSClassFromString(@"FBSDKAppEvents");
            SEL sel = NSSelectorFromString(@"logEvent:parameters:");
            if ([class respondsToSelector:sel]) {
                IMP imp = [class methodForSelector:sel];
                void (*func)(id, SEL, NSString *, id) = (void *)imp;
                func(class, sel, event, paramter);
            }
        }
        
    }
}

- (void)trackScreen:(NSString *)screenName {
    WEEventManager *manager = [WEEventManager shareManager];
    if (manager.trackPattern != WEAnalyzePatternDebug) {
        Class class = NSClassFromString(@"FIRAnalytics");
        SEL sel = NSSelectorFromString(@"setScreenName:screenClass:");
        if ([[manager.trackDictionary allKeys] containsObject:screenName] && manager.trackPattern == WEAnalyzePatternTrackCustom) {
            if ([class respondsToSelector:sel]) {
                IMP imp = [class methodForSelector:sel];
                void (*func)(id, SEL, NSString *, NSString *) = (void *)imp;
                func(class, sel, [manager.trackDictionary objectForKey:screenName], screenName);
            }
        } else {
            if ([class respondsToSelector:sel]) {
                IMP imp = [class methodForSelector:sel];
                void (*func)(id, SEL, NSString *, NSString *) = (void *)imp;
                func(class, sel, screenName, screenName);
            }
        }
    }
}

- (void)trackUMengBeginScreen:(NSString *)screenName {
    WEEventManager *manager = [WEEventManager shareManager];
    if (manager.trackPattern != WEAnalyzePatternDebug) {
        Class class = NSClassFromString(@"MobClick");
        SEL sel = NSSelectorFromString(@"beginLogPageView:");
        if ([[manager.trackDictionary allKeys] containsObject:screenName] && manager.trackPattern == WEAnalyzePatternTrackCustom) {
            if ([class respondsToSelector:sel]) {
                IMP imp = [class methodForSelector:sel];
                void (*func)(id, SEL, NSString *) = (void *)imp;
                func(class, sel, [manager.trackDictionary objectForKey:screenName]);
            }
        } else {
            if ([class respondsToSelector:sel]) {
                IMP imp = [class methodForSelector:sel];
                void (*func)(id, SEL, NSString *) = (void *)imp;
                func(class, sel, screenName);
            }
        }
    }
}

- (void)trackUMengEndScreen:(NSString *)screenName {    
    WEEventManager *manager = [WEEventManager shareManager];
    if (manager.trackPattern != WEAnalyzePatternDebug) {
        Class class = NSClassFromString(@"MobClick");
        SEL sel = NSSelectorFromString(@"endLogPageView:");
        if ([[manager.trackDictionary allKeys] containsObject:screenName] && manager.trackPattern == WEAnalyzePatternTrackCustom) {
            if ([class respondsToSelector:sel]) {
                IMP imp = [class methodForSelector:sel];
                void (*func)(id, SEL, NSString *) = (void *)imp;
                func(class, sel, [manager.trackDictionary objectForKey:screenName]);
            }
        } else {
            if ([class respondsToSelector:sel]) {
                IMP imp = [class methodForSelector:sel];
                void (*func)(id, SEL, NSString *) = (void *)imp;
                func(class, sel, screenName);
            }
        }
    }

}

@end
