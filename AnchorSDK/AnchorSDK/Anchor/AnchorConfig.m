//
//  AnchorConfig.m
//  AnchorSDK
//
//  Created by chenlei on 2019/7/29.
//  Copyright © 2019 webeye. All rights reserved.
//

#import "AnchorConfig.h"

static BOOL _enableStatistics = YES;
static BOOL _enableFirebase = NO;
static BOOL _enableFacebook = NO;
static BOOL _enableAppsFlyer = NO;
static BOOL _enableUmeng = NO;

@implementation AnchorConfig

- (BOOL)enableStatistics {
    return _enableStatistics;
}
- (void)setEnableStatistics:(BOOL)enableStatistics {
    _enableStatistics = enableStatistics;
}

- (BOOL)enableFirebase {
    return _enableFirebase;
}
- (void)setEnableFirebase:(BOOL)enableFirebase {
    _enableFirebase = enableFirebase;
}

- (BOOL)enableFacebook {
    return _enableFacebook;
}
- (void)setEnableFacebook:(BOOL)enableFacebook {
    _enableFacebook = enableFacebook;
}

- (BOOL)enableAppsFlyer {
    return _enableAppsFlyer;
}
- (void)setEnableAppsFlyer:(BOOL)enableAppsFlyer {
    _enableAppsFlyer = enableAppsFlyer;
}

- (BOOL)enableUmeng {
    return _enableUmeng;
}
- (void)setEnableUmeng:(BOOL)enableUmeng {
    _enableUmeng = enableUmeng;
}

@end
