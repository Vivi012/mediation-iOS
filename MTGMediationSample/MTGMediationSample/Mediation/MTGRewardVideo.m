//
//  MTGRewardVideo.m
//  MTGMediationSample
//
//  Created by CharkZhang on 2019/1/17.
//  Copyright © 2019 CharkZhang. All rights reserved.
//

#import "MTGRewardVideo.h"
#import "MTGRewardVideoAdManager.h"

static MTGRewardVideo *gSharedInstance = nil;

@interface MTGRewardVideo()<MTGRewardVideoAdManagerDelegate>

@property (nonatomic, strong) NSMutableDictionary *rewardedVideoAdManagers;
@property (nonatomic, weak) id<MTGRewardVideoDelegate> delegate;

+ (MTGRewardVideo *)sharedInstance;

@end

@implementation MTGRewardVideo

+ (void)loadRewardVideoAdWithAdUnitID:(NSString *)adUnitID mediationSettings:(NSArray *)mediationSettings{
    
    MTGRewardVideo *sharedInstance = [[self class] sharedInstance];
    
    if (![adUnitID length]) {
//        NSError *error = [NSError errorWithDomain:MoPubRewardedVideoAdsSDKDomain code:MPRewardedVideoAdErrorInvalidAdUnitID userInfo:nil];
//        [sharedInstance.delegate rewardedVideoAdDidFailToLoadForAdUnitID:adUnitID error:error];
        return;
    }

    MTGRewardVideoAdManager *adManager = sharedInstance.rewardedVideoAdManagers[adUnitID];
    
    if (!adManager) {
        adManager = [[MTGRewardVideoAdManager alloc] initWithAdUnitID:adUnitID delegate:sharedInstance];
        sharedInstance.rewardedVideoAdManagers[adUnitID] = adManager;
    }
    
    [adManager loadRewardedVideoAd];

}

+ (BOOL)hasAdAvailableForAdUnitID:(NSString *)adUnitID{

    MTGRewardVideo *sharedInstance = [[self class] sharedInstance];
    
    MTGRewardVideoAdManager *adManager = sharedInstance.rewardedVideoAdManagers[adUnitID];
    return [adManager hasAdAvailable];
}

+ (void)presentRewardVideoAdForAdUnitID:(NSString *)adUnitID fromViewController:(UIViewController *)viewController{
    
    MTGRewardVideo *sharedInstance = [[self class] sharedInstance];
    
    MTGRewardVideoAdManager *adManager = sharedInstance.rewardedVideoAdManagers[adUnitID];

    if (!adManager) {
//        MPLogWarn(@"The rewarded video could not be shown: "
//                  @"no ads have been loaded for adUnitID: %@", adUnitID);
        
        return;
    }
    
    if (!viewController) {
//        MPLogWarn(@"The rewarded video could not be shown: "
//                  @"a nil view controller was passed to -presentRewardedVideoAdForAdUnitID:fromViewController:.");
        
        return;
    }
    
    if (![viewController.view.window isKeyWindow]) {
//        MPLogWarn(@"Attempting to present a rewarded video ad in non-key window. The ad may not render properly.");
    }

    [adManager presentRewardedVideoFromViewController:viewController];
}

#pragma mark - Private

+ (MTGRewardVideo *)sharedInstance
{
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
        gSharedInstance = [[self alloc] init];
    });
    
    return gSharedInstance;
}

- (instancetype)init
{
    if (self = [super init]) {
        _rewardedVideoAdManagers = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

#pragma mark - MTGRewardVideoAdManagerDelegate




@end
