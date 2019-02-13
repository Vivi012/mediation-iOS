//
//  MTGRewardVideoAdapter.h
//  MTGMediationSample
//
//  Created by CharkZhang on 2019/1/18.
//  Copyright © 2019 CharkZhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class MTGRewardVideoReward;
@protocol MTGRewardVideoAdapterDelegate <NSObject>

- (void)rewardVideoAdDidLoadForAdUnitID:(NSString *)adUnitID;

- (void)rewardVideoAdDidFailToLoadForAdUnitID:(NSString *)adUnitID error:(NSError *)error;

- (void)rewardVideoAdDidShowForAdUnitID:(NSString *)adUnitID;

- (void)rewardVideoAdDidFailToPlayForAdUnitID:(NSString *)adUnitID error:(NSError *)error;

- (void)rewardVideoAdWillDisappearForAdUnitID:(NSString *)adUnitID;

- (void)rewardVideoAdShouldRewardForAdUnitID:(NSString *)adUnitID reward:(MTGRewardVideoReward *)reward;

- (void)rewardVideoAdDidReceiveTapEventForAdUnitID:(NSString *)adUnitID;

@end


@interface MTGRewardVideoAdapter : NSObject

- (id)initWithDelegate:(id<MTGRewardVideoAdapterDelegate>)delegate;

- (void)getAdWithInfo:(NSDictionary *)adInfo completionHandler:(void (^ __nullable)(BOOL success,NSError *error))completion;


/**
 * Tells the caller whether the underlying ad network currently has an ad available for presentation.
 */
- (BOOL)hasAdAvailable;

/**
 * Plays a rewarded video ad.
 *
 * @param viewController Presents the rewarded video ad from viewController.
 */
- (void)presentRewardedVideoFromViewController:(UIViewController *)viewController;

@end

NS_ASSUME_NONNULL_END
