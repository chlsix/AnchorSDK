//
//  WEEventManager.h
//  AnchorSDK
//
//  Created by chenlei on 2019/7/29.
//  Copyright © 2019 webeye. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, WEAnalyzePattern) {
    WEAnalyzePatternDebug,        //Debug模式，不跟踪页面和事件
    WEAnalyzePatternTrackAll,     //默认跟踪所有页面，可设置Controller中trackScreen为No不跟踪
    WEAnalyzePatternTrackNone,    //默认不跟踪页面，可设置Controller中trackScreen为YES跟踪
    WEAnalyzePatternTrackCustom,  //跟踪trackDictionary中的页面,Key为页面名，Value为统计数据中页面显示名。
};


/*
 *可同时使用多种方式
 */
typedef enum WEAnalyzeApproach {
    WEAnalyzeApproachNone         = 0,
    WEAnalyzeApproachFacebook     = 1 << 1,
    WEAnalyzeApproachFirebase     = 1 << 2,
    WEAnalyzeApproachAppsFlyer    = 1 << 3,
    WEAnalyzeApproachUMeng        = 1 << 4,
} WEAnalyzeApproach;

NS_ASSUME_NONNULL_BEGIN

@interface WEEventManager : NSObject

@property (nonatomic) WEAnalyzePattern trackPattern;

@property (nonatomic) WEAnalyzeApproach trackApproach;

@property (nonatomic, strong) NSDictionary * trackDictionary;

+ (instancetype) shareManager;

- (void)initFirebase;

- (void)initFacebookWithApplication:(UIApplication *)application
                   andLaunchOptions:(NSDictionary *)launchOptions;

- (void)initAppsFlyerWithAppsFlyerDevKey:(NSString *)appsFlyerDevKey
                           andAppleAppID:(NSString *)appleAppID;

- (void)initUMengWithAppkey:(NSString *)appkey
                 andChannel:(NSString *)channel
            andScenarioType:(NSUInteger)type;

- (void)activeTrack;

- (void)handleOpenURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation;

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation;

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
            options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options;

- (void)trackEvent:(NSString *)event;

- (void)trackEvent:(NSString *)event value:(nullable NSDictionary *)paramter;

- (void)trackScreen:(NSString *)screenName;

- (void)trackUMengBeginScreen:(NSString *)screenName;

- (void)trackUMengEndScreen:(NSString *)screenName;


@end

NS_ASSUME_NONNULL_END
