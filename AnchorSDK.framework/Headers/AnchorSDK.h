//
//  AnchorSDK.h
//  AnchorSDK
//
//  Created by chenlei on 2019/7/29.
//  Copyright © 2019 webeye. All rights reserved.
//
//v1.0.2
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AnchorConfig.h"

NS_ASSUME_NONNULL_BEGIN

@interface AnchorSDK : NSObject

/**
 初始化SDK
 */
+ (void)initWithConfig:(nullable AnchorConfig *)config
           application:(UIApplication *)application
      andLaunchOptions:(NSDictionary *)launchOptions;

/**
 自定义打点事件
 @params eventName 事件名称
 */
+ (void)reportCustomEvent:(NSString *)eventName;
/**
 自定义打点事件 带事件参数
 @params eventName   事件名称
 @params eventParams 事件参数
 */
+ (void)reportCustomEvent:(NSString *)eventName
                    value:(NSDictionary *)eventParams;

/**
 注册成功时调用
 @params type  注册类型，一般为第三方平台，邮箱，手机等
 */
+ (void)reportSignUpSuccess:(NSString *)type;

/**
 注册失败时调用
 @params type  注册类型，一般为第三方平台，邮箱，手机等
 @params description  失败原因
 */
+ (void)reportSignUpFailed:(NSString *)type
               description:(NSString *)description;

/**
 登录成功时调用
 @params type  登录类型，一般为第三方平台，邮箱，手机等
 */
+ (void)reportLogInSuccess:(NSString *)type;

/**
 登录失败时调用
 @params type  登录类型，一般为第三方平台，邮箱，手机等
 @params description  失败原因
 */
+ (void)reportLogInFailed:(NSString *)type
              description:(NSString *)description;

/**
 登出成功时调用
 @params type  登录类型，一般为第三方平台，邮箱，手机等
 */
+ (void)reportLogOutSuccess:(NSString *)type;

/**
 登出失败时调用
 @params type  登录类型，一般为第三方平台，邮箱，手机等
 @params description  失败原因
 */
+ (void)reportLogOutFailed:(NSString *)type
               description:(NSString *)description;

/**
 请求内购时调用
 @param productId 内购项id
 @param value 价格，转化成USD，只上报数字
 @param target 订单id 没有传nil
 */
+ (void)reportPurchaseRequest:(NSString *)productId
                        value:(NSString *)value
                       target:(nullable NSString *)target;

/**
 内购成功时调用
 @param productId 内购项id
 @param value 价格，转化成USD，只上报数字
 @param target 订单id 没有传nil
 */
+ (void)reportPurchaseSuccess:(NSString *)productId
                        value:(NSString *)value
                       target:(nullable NSString *)target;

/**
 内购取消时调用
 @param productId 内购项id
 @param value 价格，转化成USD，只上报数字
 @param target 订单id 没有传nil
 */
+ (void)reportPurchaseCancel:(NSString *)productId
                       value:(NSString *)value
                      target:(nullable NSString *)target;

/**
 内购失败时调用
 @param productId 内购项id
 @param value 价格，转化成USD，只上报数字
 @param target 订单id 没有传nil
 @param description 订单id 没有传nil
 */
+ (void)reportPurchaseFailed:(NSString *)productId
                       value:(NSString *)value
                      target:(nullable NSString *)target
                 description:(NSString *)description;


/**
 请求订阅时调用
 @param productId 订阅项id
 @param value 价格，转化成USD，只上报数字
 @param target 订单id 没有传nil
 */
+ (void)reportSubRequest:(NSString *)productId
                   value:(NSString *)value
                  target:(nullable NSString *)target;

/**
 订阅成功时调用
 @param productId 订阅项id
 @param value 价格，转化成USD，只上报数字
 @param target 订单id 没有传nil
 */
+ (void)reportSubSuccess:(NSString *)productId
                   value:(NSString *)value
                  target:(nullable NSString *)target;

/**
 订阅取消时调用
 @param productId 订阅项id
 @param value 价格，转化成USD，只上报数字
 @param target 订单id 没有传nil
 */
+ (void)reportSubCancel:(NSString *)productId
                  value:(NSString *)value
                 target:(nullable NSString *)target;

/**
 订阅失败时调用
 @param productId 订阅项id
 @param value 价格，转化成USD，只上报数字
 @param target 订单id 没有传nil
 @param description 订单id 没有传nil
 */
+ (void)reportSubFailed:(NSString *)productId
                  value:(NSString *)value
                 target:(nullable NSString *)target
            description:(NSString *)description;



@end

NS_ASSUME_NONNULL_END
