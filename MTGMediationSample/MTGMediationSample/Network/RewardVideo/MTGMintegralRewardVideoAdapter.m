//
//  MTGMintegralRewardVideoAdapter.m
//  MTGMediationSample
//
//  Created by CharkZhang on 2019/1/21.
//  Copyright © 2019 CharkZhang. All rights reserved.
//

#import "MTGMintegralRewardVideoAdapter.h"

#import <MTGSDK/MTGSDK.h>
#import <MTGSDKReward/MTGRewardAdManager.h>

@interface MTGMintegralRewardVideoAdapter () <MTGRewardAdLoadDelegate,MTGRewardAdShowDelegate>

@property (nonatomic, copy) NSString *adUnit;
@property (nonatomic, copy) NSString *rewardId;

@end

@implementation MTGMintegralRewardVideoAdapter

- (void)requestRewardedVideoWithCustomEventInfo:(NSDictionary *)info{
    // The default implementation of this method does nothing. Subclasses must override this method
    // and implement code to load a rewarded video here.
    
    NSString *appId = [info objectForKey:@"appid"];
    NSString *appKey = [info objectForKey:@"apikey"];
    NSString *unitId = [info objectForKey:@"unitid"];
    
    NSString *errorMsg = nil;
    if (!appId) errorMsg = @"Invalid MTG appId";
    if (!appKey) errorMsg = @"Invalid MTG appKey";
    if (!unitId) errorMsg = @"Invalid MTG unitId";
    
    if (errorMsg) {
        NSError *error = [NSError errorWithDomain:@"com.mintegral" code:-1 userInfo:@{NSLocalizedDescriptionKey : errorMsg}];
        [self.delegate rewardedVideoDidFailToLoadAdForCustomEvent:self error:error];
         
        return;
    }
    
    self.adUnit = unitId;
    self.rewardId = [info objectForKey:@"rewardid"]; 
    
    [[MTGSDK sharedInstance] setAppID:appId ApiKey:appKey];
    [[MTGRewardAdManager sharedInstance] loadVideo:self.adUnit delegate:self];
    
}

- (BOOL)hasAdAvailable{
    // Subclasses must override this method and implement coheck whether or not a rewarded vidoe ad
    // is available for presentation.
    
    return [[MTGRewardAdManager sharedInstance] isVideoReadyToPlay:self.adUnit];
}

- (void)presentRewardedVideoFromViewController:(UIViewController *)viewController{
    // The default implementation of this method does nothing. Subclasses must override this method
    // and implement code to display a rewarded video here.
    
    if ([self hasAdAvailable]) {
        
        NSString *customerId = @"";
        
        if ([[MTGRewardAdManager sharedInstance] respondsToSelector:@selector(showVideo:withRewardId:userId:delegate:viewController:)]) {
            [[MTGRewardAdManager sharedInstance] showVideo:self.adUnit withRewardId:self.rewardId userId:customerId delegate:self viewController:viewController];
        }
        
    } else {
        NSError *error = [NSError errorWithDomain:@"com.mintegral" code:-1 userInfo:@{NSLocalizedDescriptionKey : @"loadFail"}];
        [self.delegate rewardedVideoDidFailToLoadAdForCustomEvent:self error:error];
    }
}


#pragma mark RewardVideoAdDelegate

/**
 *  Called when the ad is successfully load , and is ready to be displayed
 *
 *  @param unitId - the unitId string of the Ad that was loaded.
 */
- (void)onVideoAdLoadSuccess:(nullable NSString *)unitId{
    
    
    if ([self hasAdAvailable]) {
        [self.delegate rewardedVideoDidLoadAdForCustomEvent:self];
    }
    
}

/**
 *  Called when there was an error loading the ad.
 *
 *  @param unitId      - the unitId string of the Ad that failed to load.
 *  @param error       - error object that describes the exact error encountered when loading the ad.
 */
- (void)onVideoAdLoadFailed:(nullable NSString *)unitId error:(nonnull NSError *)error{
    
    
    [self.delegate rewardedVideoDidFailToLoadAdForCustomEvent:self error:error];
}

/**
 *  Called when the ad display success
 *
 *  @param unitId - the unitId string of the Ad that display success.
 */
- (void)onVideoAdShowSuccess:(nullable NSString *)unitId{
    
    
    /*
    [self.delegate rewardedVideoWillAppearForCustomEvent:self];
    [self.delegate rewardedVideoDidAppearForCustomEvent:self];
    
    
    if ([self.delegate respondsToSelector:@selector(trackImpression)]) {
        [self.delegate trackImpression];
    }
    */
}

/**
 *  Called when the ad failed to display for some reason
 *
 *  @param unitId      - the unitId string of the Ad that failed to be displayed.
 *  @param error       - error object that describes the exact error encountered when showing the ad.
 */
- (void)onVideoAdShowFailed:(nullable NSString *)unitId withError:(nonnull NSError *)error{
    
    /*
    [self.delegate rewardedVideoDidFailToPlayForCustomEvent:self error:error];
     */
}

/**
 *  Called when the ad is clicked
 *
 *  @param unitId - the unitId string of the Ad clicked.
 */
- (void)onVideoAdClicked:(nullable NSString *)unitId{
    
    /*
    [self.delegate rewardedVideoDidReceiveTapEventForCustomEvent:self];
    
    if ([self.delegate respondsToSelector:@selector(trackClick)]) {
        [self.delegate trackClick];
    } else {
        MPLogWarn(@"Delegate does not implement click tracking callback. Clicks likely not being tracked.");
    }
     */
}

/**
 *  Called when the ad has been dismissed from being displayed, and control will return to your app
 *
 *  @param unitId      - the unitId string of the Ad that has been dismissed
 *  @param converted   - BOOL describing whether the ad has converted
 *  @param rewardInfo  - the rewardInfo object containing an array of reward objects that should be given to your user.
 */
- (void)onVideoAdDismissed:(nullable NSString *)unitId withConverted:(BOOL)converted withRewardInfo:(nullable MTGRewardAdInfo *)rewardInfo{
    
    /*
    [self.delegate rewardedVideoWillDisappearForCustomEvent:self];
    [self.delegate rewardedVideoDidDisappearForCustomEvent:self];
    
    if (!converted || !rewardInfo) {
        return;
    }
    
    MPRewardedVideoReward *reward = [[MPRewardedVideoReward alloc] initWithCurrencyType:rewardInfo.rewardName amount:[NSNumber numberWithInteger:rewardInfo.rewardAmount]];
    [self.delegate rewardedVideoShouldRewardUserForCustomEvent:self reward:reward];
    */
    
}


@end
