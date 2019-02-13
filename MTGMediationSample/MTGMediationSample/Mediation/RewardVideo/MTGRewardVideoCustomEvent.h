//
//  MTGRewardVideoCustomEvent.h
//  MTGMediationSample
//
//  Created by CharkZhang on 2019/1/21.
//  Copyright © 2019 CharkZhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol MTGRewardVideoCustomEventDelegate;

@interface MTGRewardVideoCustomEvent : NSObject


@property (nonatomic, weak) id<MTGRewardVideoCustomEventDelegate> delegate;

- (void)requestRewardedVideoWithCustomEventInfo:(NSDictionary *)info;

- (BOOL)hasAdAvailable;

- (void)presentRewardedVideoFromViewController:(UIViewController *)viewController;

@end



@class MTGRewardVideoReward;
@protocol MTGRewardVideoCustomEventDelegate <NSObject>

- (void)rewardedVideoDidLoadAdForCustomEvent:(MTGRewardVideoCustomEvent *)customEvent;

- (void)rewardedVideoDidFailToLoadAdForCustomEvent:(MTGRewardVideoCustomEvent *)customEvent error:(NSError *)error;

- (void)rewardVideoAdDidShowForCustomEvent:(MTGRewardVideoCustomEvent *)customEvent;

- (void)rewardVideoAdDidFailToPlayForCustomEvent:(MTGRewardVideoCustomEvent *)customEvent error:(NSError *)error;

- (void)rewardVideoAdWillDisappearForCustomEvent:(MTGRewardVideoCustomEvent *)customEvent;

- (void)rewardVideoAdShouldRewardForCustomEvent:(MTGRewardVideoCustomEvent *)customEvent reward:(MTGRewardVideoReward *)reward;

- (void)rewardVideoAdDidReceiveTapEventForCustomEvent:(MTGRewardVideoCustomEvent *)customEvent;


@end


NS_ASSUME_NONNULL_END
