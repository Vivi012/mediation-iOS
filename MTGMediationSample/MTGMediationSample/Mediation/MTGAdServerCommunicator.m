//
//  MTGAdServerCommunicator.m
//  MTGMediationSample
//
//  Created by CharkZhang on 2019/1/18.
//  Copyright © 2019 CharkZhang. All rights reserved.
//

#import "MTGAdServerCommunicator.h"
#import "MTGAdInfo.h"

@protocol MTGAdServerCommunicatorDelegate;
@interface MTGAdServerCommunicator()

@property (nonatomic,weak) MTGAdServerCommunicatorDelegate *delegate;

@end

@implementation MTGAdServerCommunicator

- (id)initWithDelegate:(id<MTGAdServerCommunicatorDelegate>)delegate
{
    self = [super init];
    if (self) {
        self.delegate = delegate;
    }
    return self;
}

- (void)requestAdUnitInfosWithAdUnit:(NSString *)adUnitId{
    
    // request local configuration for ad infos
    NSArray *rewardVideoInfos = [MTGAdInfo rewardVideoInfosWithAdUnitId:adUnitId];
    if (rewardVideoInfos.count) {
        
        if (_delegate && [_delegate respondsToSelector:@selector(communicatorDidReceiveAdUnitInfos:)]) {
            [_delegate communicatorDidReceiveAdUnitInfos:rewardVideoInfos];
        }
        return;
    }
    // we will support send request for remote ad infos later
    if (_delegate && [_delegate respondsToSelector:@selector(communicatorDidFailWithError:)]) {
        NSError *error = nil;
        #warning  Chark TODO
        [_delegate communicatorDidFailWithError:error];
    }
}

- (void)cancel{
    
    //cancel request remote infos
}

#pragma mark -
/*
- (void)communicatorDidReceiveAdUnitInfos:(NSArray *)infos{
    
}
- (void)communicatorDidFailWithError:(NSError *)error{
    
}
*/

@end
