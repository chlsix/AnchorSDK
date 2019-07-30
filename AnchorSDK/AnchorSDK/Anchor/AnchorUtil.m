//
//  AnchorUtil.m
//  AnchorSDK
//
//  Created by chenlei on 2019/7/30.
//  Copyright © 2019 webeye. All rights reserved.
//

#import "AnchorUtil.h"

@implementation AnchorUtil

+ (BOOL)isFirstInstall {
    BOOL isFirst = NO;
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"WEIsFirstInstall"]) {
        isFirst = YES;
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"WEIsFirstInstall"];
    }
    return isFirst;
}

+ (BOOL)isJailBreak {
    
    __block BOOL jailBreak = NO;
    
    NSArray *array = @[@"/Applications/Cydia.app",@"/private/var/lib/apt",@"/usr/lib/system/libsystem_kernel.dylib",@"Library/MobileSubstrate/MobileSubstrate.dylib",@"/etc/apt"];
    
    [array enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        BOOL fileExist = [[NSFileManager defaultManager] fileExistsAtPath:obj];
        
        if ([obj isEqualToString:@"/usr/lib/system/libsystem_kernel.dylib"]) {
            
            jailBreak |= !fileExist;
            
        }else{
            
            jailBreak |= fileExist;
            
        }
        
    }];
    return jailBreak;
}

+ (NSString *)secondsFromGMTForDate {
    NSTimeZone *zone = [NSTimeZone systemTimeZone];//获得系统的时区
    NSDate *date = [NSDate date]; //获得时间对象
    NSTimeInterval time = [zone secondsFromGMTForDate:date]; //返回当前时间与系统格林尼治时间的差(以秒为单位)
    NSString *timeStr = [NSString stringWithFormat:@"%f", time];
    NSLog(@"secondsFromGMTForDate: %@", timeStr);
    return timeStr;
    
}

@end
