//
//  MTGRewardVideo.m
//  MTGMediationSample
//
//  Created by CharkZhang on 2019/1/17.
//  Copyright © 2019 CharkZhang. All rights reserved.
//

#import "MTGRewardVideo.h"
#import "MTGRewardVideoAdManager.h"
#import "MTGRewardVideoReward.h"

static MTGRewardVideo *gSharedInstance = nil;

@interface MTGRewardVideo()<MTGRewardVideoAdManagerDelegate>

@property (nonatomic, strong) NSMutableDictionary *rewardedVideoAdManagers;
@property (nonatomic, weak) id<MTGRewardVideoDelegate> delegate;

+ (MTGRewardVideo *)sharedInstance;

@end

@implementation MTGRewardVideo

+ (void)initializeWithDelegate:(id<MTGRewardVideoDelegate>)delegate
{
    MTGRewardVideo *sharedInstance = [[self class] sharedInstance];
    
    // Do not allow calls to initialize twice.
    if (sharedInstance.delegate) {
//        MPLogWarn(@"Attempting to initialize MPRewardedVideo when it has already been initialized.");
    } else {
        sharedInstance.delegate = delegate;
    }
}



+ (void)loadRewardVideoAdWithAdUnitID:(NSString *)adUnitID mediationSettings:(NSArray *)mediationSettings{
    
    MTGRewardVideo *sharedInstance = [[self class] sharedInstance];
    
    if (![adUnitID length]) {
//        NSError *error = [NSError errorWithDomain:MoPubRewardedVideoAdsSDKDomain code:MPRewardedVideoAdErrorInvalidAdUnitID userInfo:nil];
//        [sharedInstance.delegate rewardedVideoAdDidFailToLoadForAdUnitID:adUnitID error:error];
//        sharedInstance.delegate respondsToSelector:@selector(rewardvideoaddi )
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

#pragma mark -

- (void)loadFailedWithAdUnit:(NSString *)adUnitId error:(NSError *)error{
    
    if (_delegate && [_delegate respondsToSelector:@selector(rewardVideoAdDidFailToLoadForAdUnitID:error:)]) {
        [_delegate rewardVideoAdDidFailToLoadForAdUnitID:adUnitId error:error];
    }
}

- (void)showFailedWithAdUnit:(NSString *)adUnitId error:(NSError *)error{

    if (_delegate && [_delegate respondsToSelector:@selector(rewardVideoAdDidFailToPlayForAdUnitID:error:)]) {
        [_delegate rewardVideoAdDidFailToPlayForAdUnitID:adUnitId error:error];
    }
}



@end
