//
//  AnchorRemoteConfigManager.h
//  AnchorSDK
//
//  Created by chenlei on 2019/7/30.
//  Copyright © 2019 webeye. All rights reserved.
//

#import <Foundation/Foundation.h>

//远程配置的key
#define WE_R_FIREBASE           @"r_firebase"
#define WE_R_FACEBOOK           @"r_facebook"
#define WE_R_APPSFLYER          @"r_appsflyer"
#define WE_R_UMENG              @"r_umeng"
#define WE_R_ANCHOR             @"r_anchor"

NS_ASSUME_NONNULL_BEGIN

@interface AnchorRemoteConfigManager : NSObject

@property (nonatomic, strong) Class remoteConfig;

@property (copy, nonatomic) void(^callbackBlock)(AnchorRemoteConfigManager *manager, BOOL canConnectFireBase);



+ (instancetype)sharedManager;

- (void)initRemoteConfig;

//远程配置返回值判断 nil 返回YES 否则返回原值
+ (BOOL)remoteValueJudgeWithKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
