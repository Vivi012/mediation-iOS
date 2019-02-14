//
//  MTGRewardVideoAdManager.h
//  MTGMediationSample
//
//  Created by CharkZhang on 2019/1/17.
//  Copyright © 2019 CharkZhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class MTGRewardVideoReward;
@protocol MTGRewardVideoAdManagerDelegate <NSObject>


- (void)rewardVideoAdDidLoadForAdUnitID:(NSString *)adUnitID;

- (void)rewardVideoAdDidFailToLoadForAdUnitID:(NSString *)adUnitID error:(NSError *)error;

- (void)rewardVideoAdDidShowForAdUnitID:(NSString *)adUnitID;

- (void)rewardVideoAdDidFailToPlayForAdUnitID:(NSString *)adUnitID error:(NSError *)error;

- (void)rewardVideoAdWillDisappearForAdUnitID:(NSString *)adUnitID;

- (void)rewardVideoAdShouldRewardForAdUnitID:(NSString *)adUnitID reward:(MTGRewardVideoReward *)reward;

- (void)rewardVideoAdDidReceiveTapEventForAdUnitID:(NSString *)adUnitID;

@end

@interface MTGRewardVideoAdManager : NSObject

@property (nonatomic, weak) id<MTGRewardVideoAdManagerDelegate> delegate;
@property (nonatomic, readonly) NSString *adUnitID;
@property (nonatomic, strong) NSDictionary *mediationSettings;


- (instancetype)initWithAdUnitID:(NSString *)adUnitID delegate:(id<MTGRewardVideoAdManagerDelegate>)delegate;


- (void)loadRewardedVideoAd;
- (BOOL)hasAdAvailable;
- (void)presentRewardedVideoFromViewController:(UIViewController *)viewController;


@end

NS_ASSUME_NONNULL_END
