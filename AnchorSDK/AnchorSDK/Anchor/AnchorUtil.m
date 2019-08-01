//
//  AnchorUtil.m
//  AnchorSDK
//
//  Created by chenlei on 2019/7/30.
//  Copyright © 2019 webeye. All rights reserved.
//

#import "AnchorUtil.h"
#import <UIKit/UIKit.h>

@implementation AnchorUtil

+ (BOOL)isFirstInstall {
    BOOL isFirst = NO;
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"WEIsFirstInstall"]) {
        isFirst = YES;
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"WEIsFirstInstall"];
    }
    return isFirst;
}

// 四种检查是否越狱的方法, 只要命中一个, 就说明已经越狱.
+ (BOOL)isJailBreak {
    BOOL result =  NO;
    
    result = [self detectJailBreakByJailBreakFileExisted];
    
    if (!result) {
        result = [self detectJailBreakByCydiaPathExisted];
    }
    
    if (!result) {
        result = [self detectJailBreakByAppPathExisted];
    }
    
    if (!result) {
        result = [self detectJailBreakByEnvironmentExisted];
    }
    
    return result;
}

/**
 * 判定常见的越狱文件
 * /Applications/Cydia.app
 * /Library/MobileSubstrate/MobileSubstrate.dylib
 * /bin/bash
 * /usr/sbin/sshd
 * /etc/apt
 * 这个表可以尽可能的列出来，然后判定是否存在，只要有存在的就可以认为机器是越狱了。
 */
const char* jailbreak_tool_pathes[] = {
    "/Applications/Cydia.app",
    "/Library/MobileSubstrate/MobileSubstrate.dylib",
    "/bin/bash",
    "/usr/sbin/sshd",
    "/etc/apt"
};

+ (BOOL)detectJailBreakByJailBreakFileExisted {
    for (int i = 0; i<sizeof(jailbreak_tool_pathes)/sizeof(jailbreak_tool_pathes[0]); i++) {
        if ([[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithUTF8String:jailbreak_tool_pathes[i]]]) {
            NSLog(@"The device is jail broken!");
            return YES;
        }
    }
    NSLog(@"The device is NOT jail broken!");
    return NO;
}

/**
 * 判断cydia的URL scheme.
 * URL scheme是可以用来在应用中呼出另一个应用，是一个资源的路径（详见《iOS中如何呼出另一个应用》），这个方法也就是在判定是否存在cydia这个应用。
 */
+ (BOOL)detectJailBreakByCydiaPathExisted {
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"cydia://"]]) {
        NSLog(@"The device is jail broken!");
        return YES;
    }
    NSLog(@"The device is NOT jail broken!");
    return NO;
}

/**
 * 读取系统所有应用的名称.
 * 这个是利用不越狱的机器没有这个权限来判定的。
 */
#define USER_APP_PATH                 @"/User/Applications/"
+ (BOOL)detectJailBreakByAppPathExisted {
    if ([[NSFileManager defaultManager] fileExistsAtPath:USER_APP_PATH]) {
        NSLog(@"The device is jail broken!");
        NSArray *applist = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:USER_APP_PATH error:nil];
        NSLog(@"applist = %@", applist);
        return YES;
    }
    NSLog(@"The device is NOT jail broken!");
    return NO;
}

/**
 * 这个DYLD_INSERT_LIBRARIES环境变量，在非越狱的机器上应该是空，越狱的机器上基本都会有Library/MobileSubstrate/MobileSubstrate.dylib.
 */
char* printEnv(void) {
    char *env = getenv("DYLD_INSERT_LIBRARIES");
    return env;
}

+ (BOOL)detectJailBreakByEnvironmentExisted {
    if (printEnv()) {
        NSLog(@"The device is jail broken!");
        return YES;
    }
    NSLog(@"The device is NOT jail broken!");
    return NO;
}

+ (NSString *)secondsFromGMTForDate {
    NSTimeZone *zone = [NSTimeZone systemTimeZone];//获得系统的时区
    NSDate *date = [NSDate date]; //获得时间对象
    NSTimeInterval time = [zone secondsFromGMTForDate:date]; //返回当前时间与系统格林尼治时间的差(以秒为单位)
    NSString *timeStr = [NSString stringWithFormat:@"%.0f", time];
    NSLog(@"secondsFromGMTForDate: %@", timeStr);
    return timeStr;
    
}

@end
