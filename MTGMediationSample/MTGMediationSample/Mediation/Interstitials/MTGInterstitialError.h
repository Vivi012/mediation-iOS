//
//  MTGInterstitialError.h
//  MTGMediationSample
//
//  Created by CharkZhang on 2019/2/19.
//  Copyright © 2019 CharkZhang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    MTGInterstitialAdErrorUnknown = -1,
    MTGInterstitialAdErrorInvalidAdUnitID = -1000,
    MTGInterstitialAdErrorTimeout = -1001,
    MTGInterstitialAdErrorCurrentUnitIsLoading = -1002,
    MTGInterstitialAdErrorAdDataInValid = -1003,
    MTGInterstitialAdErrorNoAdsAvailable = -1100,
    MTGInterstitialAdErrorInvalidCustomEvent = -1200,
    
    MTGInterstitialAdUnLoaded = -2000,
    MTGInterstitialAdViewControllerInvalid = -2100,
    
} MTGInterstitialErrorCode;


extern NSString * const MTGInterstitialAdsSDKDomain;

