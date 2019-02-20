//
//  IronSourceAdapterHelper.m
//  MTGMediationSample
//
//  Created by ym on 2019/2/20.
//  Copyright © 2019 CharkZhang. All rights reserved.
//

#import "IronSourceAdapterHelper.h"

static BOOL ironSourceSDKInitialized = NO;

@implementation IronSourceAdapterHelper

+(BOOL)isSDKInitialized{
    
    return ironSourceSDKInitialized;
}

+(void)sdkInitialized{
    
#ifdef DEBUG
    if (DEBUG) {
        NSLog(@"The version of current IronSource Adapter is: %@",IronSourceAdapterVersion);
    }
#endif
    ironSourceSDKInitialized = YES;
}

@end
