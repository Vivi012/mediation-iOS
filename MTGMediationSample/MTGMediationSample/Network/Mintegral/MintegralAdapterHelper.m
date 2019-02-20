//
//  MintegralAdapterHelper.m
//  MTGMediationSample
//
//  Created by ym on 2019/2/20.
//  Copyright © 2019 CharkZhang. All rights reserved.
//

#import "MintegralAdapterHelper.h"

static BOOL mintegralSDKInitialized = NO;

@implementation MintegralAdapterHelper

+(BOOL)isSDKInitialized{
    
    return mintegralSDKInitialized;
}

+(void)sdkInitialized{
    
    #ifdef DEBUG
    if (DEBUG) {
        NSLog(@"The version of current Mintegral Adapter is: %@",MintegralAdapterVersion);
    }
    #endif 
    mintegralSDKInitialized = YES;
}

@end
