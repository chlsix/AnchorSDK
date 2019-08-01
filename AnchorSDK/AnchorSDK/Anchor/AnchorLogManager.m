//
//  AnchorLogManager.m
//  AnchorSDK
//
//  Created by chenlei on 2019/8/1.
//  Copyright © 2019 webeye. All rights reserved.
//

#import "AnchorLogManager.h"

// 默认值为NO
static BOOL kLogEnable = NO;

@implementation AnchorLogManager

+ (void)setLogEnable:(BOOL)enable {
    kLogEnable = enable;
}

+ (BOOL)getLogEnable {
    return kLogEnable;
}

+ (void)customLogWithFunction:(const char *)function lineNumber:(int)lineNumber formatString:(NSString *)formatString {
    
    if ([self getLogEnable]) {
        // 开启了Log
        NSLog(@"%s%d: %@", function, lineNumber, formatString);
    }
}

@end
