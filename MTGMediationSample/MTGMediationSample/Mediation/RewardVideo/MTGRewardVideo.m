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
#import "MTGRewardVideoError.h"

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
        NSError *error = [NSError errorWithDomain:MTGRewardVideoAdsSDKDomain code:MTGRewardVideoAdErrorInvalidAdUnitID userInfo:nil];
        [sharedInstance rewardVideoAdDidFailToLoadForAdUnitID:adUnitID error:error];
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{

        MTGRewardVideoAdManager *adManager = sharedInstance.rewardedVideoAdManagers[adUnitID];
        
        if (!adManager) {
            adManager = [[MTGRewardVideoAdManager alloc] initWithAdUnitID:adUnitID delegate:sharedInstance];
            sharedInstance.rewardedVideoAdManagers[adUnitID] = adManager;
        }
        adManager.mediationSettings = mediationSettings;
        [adManager loadRewardedVideoAd];

    });
}

+ (BOOL)hasAdAvailableForAdUnitID:(NSString *)adUnitID{

    if (![adUnitID length]) {
        return NO;
    }
    MTGRewardVideo *sharedInstance = [[self class] sharedInstance];
    [sharedInstance.lock lock];
    MTGRewardVideoAdManager *adManager = sharedInstance.rewardedVideoAdManagers[adUnitID];
    [sharedInstance.lock unlock];

    return [adManager hasAdAvailable];
}

+ (void)presentRewardVideoAdForAdUnitID:(NSString *)adUnitID fromViewController:(UIViewController *)viewController{
    
    if (![adUnitID length]) {
        NSError *error = [NSError errorWithDomain:MTGRewardVideoAdsSDKDomain code:MTGRewardVideoAdErrorInvalidAdUnitID userInfo:nil];
        [[[self class] sharedInstance] rewardVideoAdDidFailToLoadForAdUnitID:adUnitID error:error];
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{

        MTGRewardVideo *sharedInstance = [[self class] sharedInstance];
        
        MTGRewardVideoAdManager *adManager = sharedInstance.rewardedVideoAdManagers[adUnitID];
        
        if (!adManager) {
            NSLog(@"The reward video could not be shown: "
                  @"no ads have been loaded for adUnitID: %@", adUnitID);
            
            return;
        }
        
        if (!viewController) {
            NSLog(@"The reward video could not be shown: "
                              @"a nil view controller was passed to -presentRewardedVideoAdForAdUnitID:fromViewController:.");
            
            return;
        }
        
        if (![viewController.view.window isKeyWindow]) {
            NSLog(@"Attempting to present a rewarded video ad in non-key window. The ad may not render properly.");
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

- (void)rewardVideoAdDidLoadForAdUnitID:(nonnull NSString *)adUnitID {
    
    if (_delegate && [_delegate respondsToSelector:@selector(rewardVideoAdDidLoadForAdUnitID:)]) {
        [_delegate rewardVideoAdDidLoadForAdUnitID:adUnitID];
    }
}

- (void)rewardVideoAdDidFailToLoadForAdUnitID:(nonnull NSString *)adUnitID error:(nonnull NSError *)error {

    if (_delegate && [_delegate respondsToSelector:@selector(rewardVideoAdDidFailToLoadForAdUnitID:error:)]) {
        [_delegate rewardVideoAdDidFailToLoadForAdUnitID:adUnitID error:error];
    }
}

- (void)rewardVideoAdDidShowForAdUnitID:(nonnull NSString *)adUnitID {
    
    if (_delegate && [_delegate respondsToSelector:@selector(rewardVideoAdDidPlayForAdUnitID:)]) {
        [_delegate rewardVideoAdDidPlayForAdUnitID:adUnitID];
    }
}

- (void)rewardVideoAdDidFailToPlayForAdUnitID:(nonnull NSString *)adUnitID error:(nonnull NSError *)error {

    if (_delegate && [_delegate respondsToSelector:@selector(rewardVideoAdDidFailToPlayForAdUnitID:error:)]) {
        [_delegate rewardVideoAdDidFailToPlayForAdUnitID:adUnitID error:error];
    }
}


- (void)rewardVideoAdDidReceiveTapEventForAdUnitID:(nonnull NSString *)adUnitID {
    
    if (_delegate && [_delegate respondsToSelector:@selector(rewardVideoAdDidReceiveTapEventForAdUnitID:)]) {
        [_delegate rewardVideoAdDidReceiveTapEventForAdUnitID:adUnitID];
    }
}


- (void)rewardVideoAdShouldRewardForAdUnitID:(nonnull NSString *)adUnitID reward:(nonnull MTGRewardVideoReward *)reward {

    if (_delegate && [_delegate respondsToSelector:@selector(rewardVideoAdShouldRewardForAdUnitID:reward:)]) {
        [_delegate rewardVideoAdShouldRewardForAdUnitID:adUnitID reward:reward];
    }
}

- (void)rewardVideoAdWillDisappearForAdUnitID:(nonnull NSString *)adUnitID {

    if (_delegate && [_delegate respondsToSelector:@selector(rewardVideoAdWillDisappearForAdUnitID:)]) {
        [_delegate rewardVideoAdWillDisappearForAdUnitID:adUnitID];
    }
}

@end
