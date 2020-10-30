# AnchorSDK iOS集成文档
## 说明
SDK为聚合打点SDK，支持Firebase，Facebook，AppsFlyer，Umeng的打点事件。SDK采用反射实现多平台SDK打点，本身并未集成这四家的SDK，需要使用哪个平台采集事件的时候集成平台的SDK即可。

## 版本信息
### 已发布版本

| 版本号 |
| --- |
| 1.0.0 |
| 1.0.1 |
| 1.0.2.1 |
| 1.0.3 |
| 1.0.4 |
| 1.0.4.1 |
| 1.0.4.2 |
| 1.0.4.3 |
| 1.0.5 |


### 版本更新记录
| 版本| 发布时间 | 更新内容 |
| --- | --- | --- |
| 1.0.0 | 2019-08-02 | 第一次提交，完成打点聚合，添加开关配置和远程配置 |
| 1.0.1 | 2019-08-05 | 添加DEBUG模式开关，控制DEBUG模式下事件是否上报 |
| 1.0.2.1 | 2019-08-08 | Bug修复；添加bitcode支持1.0.32019-08-13解决AF不能上报的问题 |
| 1.0.4 | 2019-10-22 | 添加广告事件打点方法1.0.4.12019-10-29添加新的广告平台判断 |
| 1.0.4.1 | 2019-11-05 | 添加新的广告平台five;添加广告场景名称字段 |
| 1.0.4.3 | 2019-11-19 | 添加新的广告平台快手 |
| 1.0.5 | 2020-10-30 | 支持AppFlyer V6 |


## Cocoapods集成
### 集成AnchorSDK
``` 
#AnchorSDK
pod 'AnchorSDK'
```
### 集成各平台SDK
按照需求选择集成哪些平台的SDK
#### 集成Firebase
```
# Firebase
pod 'Firebase/Analytics'
```
#### 集成Facebook
```
# Facebook
pod 'FBSDKCoreKit'
```
#### 集成AppsFlyer
```
#AppsFlyer
pod 'AppsFlyerFramework'
```
#### 集成Umeng
```
#Umeng
pod 'UMCCommon'
pod 'UMCAnalytics'
```
## 初始化
在AppDelegate中导入头文件#import <AnchorSDK/AnchorSDK.h>
```
#import "AppDelegate.h"
#import <AnchorSDK/AnchorSDK.h>
```
在AppDelegate的-application:didFinishLaunchingWithOptions:方法中添加AnchorSDK的初始化方法
```
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    AnchorConfig *config = [[AnchorConfig alloc] init];
    config.appIdForAppsFlyer = <#appIdForAppsFlyer#>;//设置AppId 使用AppsFlyer时必填
    config.appKeyForAppsFlyer = <#appKeyForAppsFlyer#>;//设置AppKey 使用AppsFlyer时必填
    config.appKeyForUmeng = <#appKeyForUmeng#>;//设置AppKey 使用Umeng时必填
    [AnchorSDK initWithConfig:config application:application andLaunchOptions:launchOptions];
    return YES;
}
```
## 配置开关（可选）
### 1.代码配置
```
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
```
初始化时修改AnchorConfig的相关属性来控制
```
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    AnchorConfig *config = [[AnchorConfig alloc] init];
    config.appIdForAppsFlyer = <#appIdForAppsFlyer#>;//设置AppId 使用AppsFlyer时必填
    config.appKeyForAppsFlyer = <#appKeyForAppsFlyer#>;//设置AppKey 使用AppsFlyer时必填
    config.appKeyForUmeng = <#appKeyForUmeng#>;//设置AppKey 使用Umeng时必填
    config.enableStatistics = YES;//开启打点上报
    config.enableFirebase = YES;//开启Firebase平台事件上报
    config.enableFacebook = YES;//开启Facebook平台事件上报
    config.enableAppsFlyer = YES;//开启AppsFlyer平台事件上报
    config.enableUmeng = YES;//开启Umeng平台事件上报
    config.logEnable = YES;//开启打印日志
    config.debugEnable = YES;//开启DEBUG模式不上报事件

    [AnchorSDK initWithConfig:config application:application andLaunchOptions:launchOptions];
    return YES;
}
```
### 2.远程配置(需支持Firebase Remote Config）
#### 集成Firebase Remote Config
```
pod 'Firebase/RemoteConfig'
```
#### 打点平台开关
Firebase Remote Config后台配置：

| 字段名 | 值 | 说明 |
| --- | --- | --- |
| r_firebase | true/false | 设置为true时，打开该平台的打点事件上报开关;设置为false时，关闭该平台的打点事件上报开关 |
| r_facebook | true/false | 设置为true时，打开该平台的打点事件上报开关;设置为false时，关闭该平台的打点事件上报开关 |
| r_appsflyer | true/false | 设置为true时，打开该平台的打点事件上报开关;设置为false时，关闭该平台的打点事件上报开关 |
| r_umeng | true/false | 设置为true时，打开该平台的打点事件上报开关;设置为false时，关闭该平台的打点事件上报开关 |
| r_anchor | true/false | 设置为true时，允许上报打点（具体平台由其他参数控制）;设置为false时，禁止上报打点（关闭所有打点平台）|

#### 打点事件开关
firebase remote config后台配置：

| 字段名 | 值 | 说明 |
| --- | --- | --- |
| r_事件名 | true/false | 设置为true时，（重新）上报该打点事件;设置为false时，停止上报该打点事件 |
          
此处的事件名为：w_token_acquire
## 打点事件
### 通用事件
#### 1.用户体系事件 （有注册、登录行为的需要调用，for app developer）
```
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
```
#### 2.变现事件（有内购事件的需调用，for app developer）
```
/**
 请求内购时调用
 @param productId 内购项id
 @param value 价格，转化成USD，只上报数字
 @param target 订单id 没有传nil
 */
+ (void)reportPurchaseRequest:(NSString *)productId
                        value:(float)value
                       target:(nullable NSString *)target;

/**
 内购成功时调用
 @param productId 内购项id
 @param value 价格，转化成USD，只上报数字
 @param target 订单id 没有传nil
 */
+ (void)reportPurchaseSuccess:(NSString *)productId
                        value:(float)value
                       target:(nullable NSString *)target;

/**
 内购取消时调用
 @param productId 内购项id
 @param value 价格，转化成USD，只上报数字
 @param target 订单id 没有传nil
 */
+ (void)reportPurchaseCancel:(NSString *)productId
                       value:(float)value
                      target:(nullable NSString *)target;

/**
 内购失败时调用
 @param productId 内购项id
 @param value 价格，转化成USD，只上报数字
 @param target 订单id 没有传nil
 @param description 订单id 没有传nil
 */
+ (void)reportPurchaseFailed:(NSString *)productId
                       value:(float)value
                      target:(nullable NSString *)target
                 description:(NSString *)description;


/**
 请求订阅时调用
 @param productId 订阅项id
 @param value 价格，转化成USD，只上报数字
 @param target 订单id 没有传nil
 */
+ (void)reportSubRequest:(NSString *)productId
                   value:(float)value
                  target:(nullable NSString *)target;

/**
 订阅成功时调用
 @param productId 订阅项id
 @param value 价格，转化成USD，只上报数字
 @param target 订单id 没有传nil
 */
+ (void)reportSubSuccess:(NSString *)productId
                   value:(float)value
                  target:(nullable NSString *)target;

/**
 订阅取消时调用
 @param productId 订阅项id
 @param value 价格，转化成USD，只上报数字
 @param target 订单id 没有传nil
 */
+ (void)reportSubCancel:(NSString *)productId
                  value:(float)value
                 target:(nullable NSString *)target;

/**
 订阅失败时调用
 @param productId 订阅项id
 @param value 价格，转化成USD，只上报数字
 @param target 订单id 没有传nil
 @param description 订单id 没有传nil
 */
+ (void)reportSubFailed:(NSString *)productId
                  value:(float)value
                 target:(nullable NSString *)target
            description:(NSString *)description;
```
### 自定义事件
```
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
                andParams:(NSDictionary *)eventParams;
```
