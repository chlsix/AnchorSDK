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

//AppsFlyer AppKey
@property (nonatomic, strong) NSString *appKeyForAppsFlyer;
//AppsFlyer AppId
@property (nonatomic, strong) NSString *appIdForAppsFlyer;
//Umeng AppKey
@property (nonatomic, strong) NSString *appKeyForUmeng;

@end

NS_ASSUME_NONNULL_END
