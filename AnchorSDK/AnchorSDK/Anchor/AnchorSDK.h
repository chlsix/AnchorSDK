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

+ (void)initWithConfig:(nullable AnchorConfig *)config application:(UIApplication *)application andLaunchOptions:(NSDictionary *)launchOptions;

@end

NS_ASSUME_NONNULL_END
