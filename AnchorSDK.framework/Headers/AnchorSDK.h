//
//  AnchorSDK.h
//  AnchorSDK
//
//  Created by chenlei on 2019/7/29.
//  Copyright © 2019 webeye. All rights reserved.
//

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


/*广告事件*/
/**
 广告触发
 @param itemId 进行广告请求的场景id
 @param description 广告请求的场景描述
 @param result 触发广告的结果，1成功，0失败，2开始请求
 */
+ (void)reportADTrigger:(NSString *)itemId
            description:(NSString *)description
                 result:(NSString *)result;

/**
 广告请求 （暂时关闭上报）
 @param itemId 进行广告请求的场景id
 @param description 广告请求的场景描述
 @param type 广告类型 0：banner 1：插屏（interstial）2：激励视频（rewarded） 3：原生广告（native） 4：unknown 5：开屏（splash）6：信息流（Feed List）7：互动广告（巨掌、推啊、豆盟）
 @param ecpm 广告的ecpm的底线值，直接乘以国家系数，上报真实ecpm
 @param sdkName 广告的平台名称，只传代码
 @param pid 广告unitid，只要id，不要名字，不能出现中文字符串
 */
+ (void)reportADRequest:(NSString *)itemId
            description:(NSString *)description
                   type:(NSString *)type
                   ecpm:(NSString *)ecpm
                sdkName:(NSString *)sdkName
                    pid:(NSString *)pid;

/**
 广告填充
 @param itemId 进行广告请求的场景id
 @param description 广告请求的场景描述
 @param type 广告类型 0：banner 1：插屏（interstial）2：激励视频（rewarded） 3：原生广告（native） 4：unknown 5：开屏（splash）6：信息流（Feed List）7：互动广告（巨掌、推啊、豆盟）
 @param ecpm 广告的ecpm的底线值，直接乘以国家系数，上报真实ecpm
 @param sdkName 广告的平台名称，只传代码
 @param pid 广告unitid，只要id，不要名字，不能出现中文字符串
 */
+ (void)reportADFill:(NSString *)itemId
         description:(NSString *)description
                type:(NSString *)type
                ecpm:(NSString *)ecpm
             sdkName:(NSString *)sdkName
                 pid:(NSString *)pid;

/**
 客户端展示广告
 @param itemId 进行广告请求的场景id
 @param description 广告请求的场景描述
 @param type 广告类型 0：banner 1：插屏（interstial）2：激励视频（rewarded） 3：原生广告（native） 4：unknown 5：开屏（splash）6：信息流（Feed List）7：互动广告（巨掌、推啊、豆盟）
 @param ecpm 广告的ecpm的底线值，直接乘以国家系数，上报真实ecpm
 @param sdkName 广告的平台名称，只传代码
 @param pid 广告unitid，只要id，不要名字，不能出现中文字符串
 */
+ (void)reportADShow:(NSString *)itemId
         description:(NSString *)description
                type:(NSString *)type
                ecpm:(NSString *)ecpm
             sdkName:(NSString *)sdkName
                 pid:(NSString *)pid;

/**
 平台确认展示广告
 @param itemId 进行广告请求的场景id
 @param description 广告请求的场景描述
 @param type 广告类型 0：banner 1：插屏（interstial）2：激励视频（rewarded） 3：原生广告（native） 4：unknown 5：开屏（splash）6：信息流（Feed List）7：互动广告（巨掌、推啊、豆盟）
 @param ecpm 广告的ecpm的底线值，直接乘以国家系数，上报真实ecpm
 @param sdkName 广告的平台名称，只传代码
 @param pid 广告unitid，只要id，不要名字，不能出现中文字符串
 @param value 开白名单的mopub集成平台，上传返回的publisher_revenue的值
 @param currency 开白名单的mopub集成平台，上传返回的currency字段
 */
+ (void)reportADImp:(NSString *)itemId
        description:(NSString *)description
               type:(NSString *)type
               ecpm:(NSString *)ecpm
            sdkName:(NSString *)sdkName
                pid:(NSString *)pid
              value:(NSString *)value
           currency:(NSString *)currency;

/**
 广告视频看完（只有激励视频有）
 @param itemId 进行广告请求的场景id
 @param description 广告请求的场景描述
 @param type 2：激励视频（rewarded）
 @param ecpm 广告的ecpm的底线值，直接乘以国家系数，上报真实ecpm
 @param sdkName 广告的平台名称，只传代码
 @param pid 广告unitid，只要id，不要名字，不能出现中文字符串
 */
+ (void)reportADReward:(NSString *)itemId
           description:(NSString *)description
                  type:(NSString *)type
                  ecpm:(NSString *)ecpm
               sdkName:(NSString *)sdkName
                   pid:(NSString *)pid;

/**
 广告被点击
 @param itemId 进行广告请求的场景id
 @param description 广告请求的场景描述
 @param type 广告类型 0：banner 1：插屏（interstial）2：激励视频（rewarded） 3：原生广告（native） 4：unknown 5：开屏（splash）6：信息流（Feed List）7：互动广告（巨掌、推啊、豆盟）
 @param ecpm 广告的ecpm的底线值，直接乘以国家系数，上报真实ecpm
 @param sdkName 广告的平台名称，只传代码
 @param pid 广告unitid，只要id，不要名字，不能出现中文字符串
 */
+ (void)reportADClick:(NSString *)itemId
          description:(NSString *)description
                 type:(NSString *)type
                 ecpm:(NSString *)ecpm
              sdkName:(NSString *)sdkName
                  pid:(NSString *)pid;

/**
 广告关闭
 @param itemId 进行广告请求的场景id
 @param description 广告请求的场景描述
 @param type 广告类型 0：banner 1：插屏（interstial）2：激励视频（rewarded） 3：原生广告（native） 4：unknown 5：开屏（splash）6：信息流（Feed List）7：互动广告（巨掌、推啊、豆盟）
 @param ecpm 广告的ecpm的底线值，直接乘以国家系数，上报真实ecpm
 @param sdkName 广告的平台名称，只传代码
 @param pid 广告unitid，只要id，不要名字，不能出现中文字符串
 */
+ (void)reportADClose:(NSString *)itemId
          description:(NSString *)description
                 type:(NSString *)type
                 ecpm:(NSString *)ecpm
              sdkName:(NSString *)sdkName
                  pid:(NSString *)pid;

/**
 用户获得广告激励
 @param itemId 进行广告请求的场景id
 @param description 广告请求的场景描述
 @param itemType 用户获取奖励的类别 比如获得了金币 coin
 @param value 用户获取奖励的值 10
 */
+ (void)reportUserADReward:(NSString *)itemId
               description:(NSString *)description
                  itemType:(NSString *)itemType
                     value:(NSString *)value;


@end

NS_ASSUME_NONNULL_END
