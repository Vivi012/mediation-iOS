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

@protocol MTGRewardVideoAdManagerDelegate <NSObject>

@end

@interface MTGRewardVideoAdManager : NSObject

@property (nonatomic, weak) id<MTGRewardVideoAdManagerDelegate> delegate;
@property (nonatomic, readonly) NSString *adUnitID;
@property (nonatomic, strong) NSArray *mediationSettings;
@property (nonatomic, copy) NSString *customerId;


- (instancetype)initWithAdUnitID:(NSString *)adUnitID delegate:(id<MTGRewardVideoAdManagerDelegate>)delegate;


- (void)loadRewardedVideoAd;
- (BOOL)hasAdAvailable;
- (void)presentRewardedVideoFromViewController:(UIViewController *)viewController;


@end

NS_ASSUME_NONNULL_END
