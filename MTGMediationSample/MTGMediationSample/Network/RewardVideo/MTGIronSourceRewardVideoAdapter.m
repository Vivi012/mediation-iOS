//
//  MTGIronSourceRewardVideoAdapter.m
//  MTGMediationSample
//
//  Created by CharkZhang on 2019/1/21.
//  Copyright © 2019 CharkZhang. All rights reserved.
//

#import "MTGIronSourceRewardVideoAdapter.h"
#import "MTGRewardVideoReward.h"

#import <IronSource/IronSource.h>

#define USERID @"demoapp"

@interface MTGIronSourceRewardVideoAdapter () <ISRewardedVideoDelegate>
@property (nonatomic, strong) ISPlacementInfo   *rvPlacementInfo;
@property (nonatomic, assign) BOOL  rvIsReady;
@end

@implementation MTGIronSourceRewardVideoAdapter

- (void)requestRewardedVideoWithCustomEventInfo:(NSDictionary *)info{
    
    self.rvIsReady = NO;
    
    NSString *appKey = [info objectForKey:@"apikey"];
    NSString *unitId = [info objectForKey:@"unitid"];
    
    NSString *errorMsg = nil;
    if (!appKey) errorMsg = @"Invalid IRON appKey";
    if (!unitId) errorMsg = @"Invalid IRON unitId";
    
    if (errorMsg) {
        NSError *error = [NSError errorWithDomain:@"com.ironsource" code:-1 userInfo:@{NSLocalizedDescriptionKey : errorMsg}];
        [self.delegate rewardedVideoDidFailToLoadAdForCustomEvent:self error:error];
        
        return;
    }
    
    //The integrationHelper is used to validate the integration. Remove the integrationHelper before going live!
    [ISIntegrationHelper validateIntegration];
    
    [ISSupersonicAdsConfiguration configurations].useClientSideCallbacks = @(YES);
    
    [IronSource setRewardedVideoDelegate:self];
    
    NSString *userId = [IronSource advertiserId];
    if([userId length] == 0){
        //If we couldn't get the advertiser id, we will use a default one.
        userId = USERID;
    }
    
    // After setting the delegates you can go ahead and initialize the SDK.
    [IronSource setUserId:userId];
    
    if([unitId length] == 0){
        [IronSource initWithAppKey:appKey];
    }else{
        [IronSource initWithAppKey:appKey adUnits:@[unitId]];
    }
}

- (BOOL)hasAdAvailable{
    
    return self.rvIsReady;
}

- (void)presentRewardedVideoFromViewController:(UIViewController *)viewController{
    
   [IronSource showRewardedVideoWithViewController:viewController];
}

#pragma mark - Rewarded Video Delegate Functions

// This method lets you know whether or not there is a video
// ready to be presented. It is only after this method is invoked
// with 'hasAvailableAds' set to 'YES' that you can should 'showRV'.
- (void)rewardedVideoHasChangedAvailability:(BOOL)available {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    self.rvIsReady = YES;

    [self.delegate rewardedVideoDidLoadAdForCustomEvent:self];
}

// This method gets invoked after the user has been rewarded.
- (void)didReceiveRewardForPlacement:(ISPlacementInfo *)placementInfo {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    self.rvPlacementInfo = placementInfo;
}

// This method gets invoked when there is a problem playing the video.
// If it does happen, check out 'error' for more information and consult
// our knowledge center for help.
- (void)rewardedVideoDidFailToShowWithError:(NSError *)error {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    [self.delegate rewardVideoAdDidFailToPlayForCustomEvent:self error:error];
}

// This method gets invoked when we take control, but before
// the video has started playing.
- (void)rewardedVideoDidOpen {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

// This method gets invoked when we return controlback to your hands.
// We chose to notify you about rewards here and not in 'didReceiveRewardForPlacement'.
// This is because reward can occur in the middle of the video.
- (void)rewardedVideoDidClose {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    [self.delegate rewardVideoAdWillDisappearForCustomEvent:self];
    
    if (self.rvPlacementInfo) {
     
        MTGRewardVideoReward *reward = [[MTGRewardVideoReward alloc] initWithCurrencyType:self.rvPlacementInfo.rewardName amount:self.rvPlacementInfo.rewardAmount];
    
        [self.delegate rewardVideoAdShouldRewardForCustomEvent:self reward:reward];
        
        self.rvPlacementInfo = nil;
    }
}

// This method gets invoked when the video has started playing.
- (void)rewardedVideoDidStart {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    [self.delegate rewardVideoAdDidShowForCustomEvent:self];
}

// This method gets invoked when the video has stopped playing.
- (void)rewardedVideoDidEnd {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)didClickRewardedVideo:(ISPlacementInfo *)placementInfo {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    [self.delegate rewardVideoAdDidReceiveTapEventForCustomEvent:self];
}


@end
