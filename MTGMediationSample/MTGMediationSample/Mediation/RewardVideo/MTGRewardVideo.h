//
//  MTGRewardVideo.h
//  MTGMediationSample
//
//  Created by CharkZhang on 2019/1/17.
//  Copyright © 2019 CharkZhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MTGRewardVideoConstants.h"


NS_ASSUME_NONNULL_BEGIN

@class MTGRewardVideoReward;
@protocol MTGRewardVideoDelegate <NSObject>

@optional
/**
 * This method is called after an ad loads successfully.
 *
 * @param adUnitID The ad unit ID of the ad associated with the event.
 */
- (void)rewardVideoAdDidLoadForAdUnitID:(NSString *)adUnitID;

/**
 * This method is called after an ad fails to load.
 *
 * @param adUnitID The ad unit ID of the ad associated with the event.
 * @param error An error indicating why the ad failed to load.
 */
- (void)rewardVideoAdDidFailToLoadForAdUnitID:(NSString *)adUnitID error:(NSError *)error;


/**
 * This method is called when an attempt to play a rewarded video success.
 *
 * @param adUnitID The ad unit ID of the ad associated with the event.
 */
- (void)rewardVideoAdDidPlayForAdUnitID:(NSString *)adUnitID;

/**
 * This method is called when an attempt to play a rewarded video fails.
 *
 * @param adUnitID The ad unit ID of the ad associated with the event.
 * @param error An error describing why the video couldn't play.
 */
- (void)rewardVideoAdDidFailToPlayForAdUnitID:(NSString *)adUnitID error:(NSError *)error;

/**
 * This method is called when a rewarded video ad will be dismissed.
 *
 * @param adUnitID The ad unit ID of the ad associated with the event.
 */
- (void)rewardVideoAdWillDisappearForAdUnitID:(NSString *)adUnitID;

/**
 * This method is called when the user should be rewarded for watching a rewarded video ad.
 *
 * @param adUnitID The ad unit ID of the ad associated with the event.
 * @param reward The object that contains all the information regarding how much you should reward the user.
 */
- (void)rewardVideoAdShouldRewardForAdUnitID:(NSString *)adUnitID reward:(MTGRewardVideoReward *)reward;

/**
 * This method is called when the user taps on the ad.
 *
 * @param adUnitID The ad unit ID of the ad associated with the event.
 */
- (void)rewardVideoAdDidReceiveTapEventForAdUnitID:(NSString *)adUnitID;


@end

@interface MTGRewardVideo : NSObject

+ (void)registerRewardVideoDelegate:(id<MTGRewardVideoDelegate>)delegate;

+ (void)loadRewardVideoAdWithAdUnitID:(NSString *)adUnitID mediationSettings:(NSDictionary *)mediationSettings;

+ (BOOL)hasAdAvailableForAdUnitID:(NSString *)adUnitID;

+ (void)presentRewardVideoAdForAdUnitID:(NSString *)adUnitID fromViewController:(UIViewController *)viewController;

@property (nonatomic,weak) id<MTGRewardVideoDelegate> delegate;


@end

NS_ASSUME_NONNULL_END
