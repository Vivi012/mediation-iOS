//
//  MTGRewardVideoError.h
//  MTGMediationSample
//
//  Created by CharkZhang on 2019/2/13.
//  Copyright © 2019 CharkZhang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    MTGRewardVideoAdErrorUnknown = -1,
    
    MTGRewardVideoAdErrorTimeout = -1000,
    MTGRewardVideoAdErrorAdDataInValid = -1001,
    MTGRewardVideoAdErrorNoAdsAvailable = -1100,
    MTGRewardVideoAdErrorInvalidCustomEvent = -1200,

} MTGRewardVideoErrorCode;


extern NSString * const MTGRewardVideoAdsSDKDomain;


