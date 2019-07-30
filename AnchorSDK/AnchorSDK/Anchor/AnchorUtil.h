//
//  AnchorUtil.h
//  AnchorSDK
//
//  Created by chenlei on 2019/7/30.
//  Copyright © 2019 webeye. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AnchorUtil : NSObject

///判断是否首次打开
+ (BOOL)isFirstInstall;

///判断是否越狱
+ (BOOL)isJailBreak;

///获取设备设置时区与GMT之前的差值
+ (NSString *)secondsFromGMTForDate;


@end

NS_ASSUME_NONNULL_END
