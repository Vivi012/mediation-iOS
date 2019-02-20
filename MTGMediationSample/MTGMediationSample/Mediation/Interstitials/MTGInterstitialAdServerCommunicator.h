//
//  MTGInterstitialAdServerCommunicator.h
//  MTGMediationSample
//
//  Created by CharkZhang on 2019/2/20.
//  Copyright © 2019 CharkZhang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol  MTGInterstitialAdServerCommunicatorDelegate;
@interface MTGInterstitialAdServerCommunicator : NSObject

@property (nonatomic,weak) id<MTGInterstitialAdServerCommunicatorDelegate> delegate;

- (id)initWithDelegate:(id<MTGInterstitialAdServerCommunicatorDelegate>)delegate;

- (void)requestAdUnitInfosWithAdUnit:(NSString *)adUnitId;

- (void)cancel;


@end


////////////////////////////////////////////////////////////////////////////////////////////////////

@protocol MTGInterstitialAdServerCommunicatorDelegate <NSObject>

@required
- (void)communicatorDidReceiveAdUnitInfos:(NSArray *)infos;
- (void)communicatorDidFailWithError:(NSError *)error;

@end

NS_ASSUME_NONNULL_END
