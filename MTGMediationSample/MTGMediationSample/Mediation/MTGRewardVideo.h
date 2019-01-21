//
//  MTGRewardVideo.h
//  MTGMediationSample
//
//  Created by CharkZhang on 2019/1/17.
//  Copyright © 2019 CharkZhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@protocol MTGRewardVideoDelegate <NSObject>


@end

@interface MTGRewardVideo : NSObject


+ (void)loadRewardVideoAdWithAdUnitID:(NSString *)adUnitID mediationSettings:(NSArray *)mediationSettings;

+ (BOOL)hasAdAvailableForAdUnitID:(NSString *)adUnitID;

+ (void)presentRewardVideoAdForAdUnitID:(NSString *)adUnitID fromViewController:(UIViewController *)viewController;


@end

NS_ASSUME_NONNULL_END
