//
//  AnchorConfig.h
//  AnchorSDK
//
//  Created by chenlei on 2019/7/29.
//  Copyright © 2019 webeye. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AnchorConfig : NSObject

//是否允许上报 默认为YES
@property (nonatomic, assign) BOOL enableStatistics;
//打开Firebase统计 默认为YES, 需要上报时导入Firebase SDK
@property (nonatomic, assign) BOOL enableFirebase;
//打开Facebook统计 默认为YES, 需要上报时导入Facebook SDK
@property (nonatomic, assign) BOOL enableFacebook;
//打开AppsFlyer统计 默认为YES, 需要上报时导入AppsFlyer SDK
@property (nonatomic, assign) BOOL enableAppsFlyer;
//打开Umeng统计 默认为YES, 需要上报时导入Umeng SDK
@property (nonatomic, assign) BOOL enableUmeng;
//开启打印日志 默认为NO
@property (nonatomic, assign) BOOL logEnable;
//开启DEBUG状态下不上报 默认为NO
@property (nonatomic, assign) BOOL debugEnable;

//AppsFlyer AppKey
@property (nonatomic, strong) NSString *appKeyForAppsFlyer;
//AppsFlyer AppId
@property (nonatomic, strong) NSString *appIdForAppsFlyer;
//Umeng AppKey
@property (nonatomic, strong) NSString *appKeyForUmeng;



@end

NS_ASSUME_NONNULL_END
