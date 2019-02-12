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
@property (nonatomic, strong) NSLock *lock;

+ (MTGRewardVideo *)sharedInstance;

@end

@implementation MTGRewardVideo

-(void)setDelegate:(id<MTGRewardVideoDelegate>)delegate{

    if (_delegate != delegate) {
        MTGRewardVideo *sharedInstance = [[self class] sharedInstance];
        sharedInstance.delegate = delegate;
        _delegate = delegate;
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
    dispatch_async(dispatch_get_main_queue(), ^{

        MTGRewardVideoAdManager *adManager = sharedInstance.rewardedVideoAdManagers[adUnitID];
        
        if (!adManager) {
            adManager = [[MTGRewardVideoAdManager alloc] initWithAdUnitID:adUnitID delegate:sharedInstance];
            sharedInstance.rewardedVideoAdManagers[adUnitID] = adManager;
        }
        
        [adManager loadRewardedVideoAd];

    });
}

+ (BOOL)hasAdAvailableForAdUnitID:(NSString *)adUnitID{

    MTGRewardVideo *sharedInstance = [[self class] sharedInstance];
    [sharedInstance.lock lock];
    MTGRewardVideoAdManager *adManager = sharedInstance.rewardedVideoAdManagers[adUnitID];
    [sharedInstance.lock unlock];

    return [adManager hasAdAvailable];
}

+ (void)presentRewardVideoAdForAdUnitID:(NSString *)adUnitID fromViewController:(UIViewController *)viewController{
    
    dispatch_async(dispatch_get_main_queue(), ^{

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
    });

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

-(NSLock *)lock{
    if (_lock) {
        return _lock;
    }
    _lock = [[NSLock alloc] init];
    return _lock;
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
