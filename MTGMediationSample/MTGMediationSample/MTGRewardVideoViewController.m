//
//  MTGRewardVideoViewController.m
//  MTGMediationSample
//
//  Created by CharkZhang on 2019/1/24.
//  Copyright © 2019 CharkZhang. All rights reserved.
//

#import "MTGRewardVideoViewController.h"
#import "MTGRewardVideo.h"

#import "MTGAdInfo.h"


@interface MTGRewardVideoViewController ()<MTGRewardVideoDelegate>
@property (weak, nonatomic) IBOutlet UIButton *loadButton;
@property (weak, nonatomic) IBOutlet UIButton *showButton;

@property (nonatomic,copy)  NSString *adUnitId;

@property (nonatomic,strong)  NSPort *emptyPort;
@end

@implementation MTGRewardVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"RewardVideo";
    self.showButton.userInteractionEnabled = NO;
    
    NSArray *adUnitInfos = [MTGAdInfo rewardVideoAdUnitIds];
    self.adUnitId = (adUnitInfos.count > 0)?adUnitInfos[0]: nil;
}

- (void)startTimeoutTimer:(NSTimeInterval)duration{
    
    if (duration < 1) {
        duration = 10;
    }

    NSRunLoop *runLoop = [NSRunLoop currentRunLoop];

    if (!_emptyPort) {
        _emptyPort = [NSPort port];
    }
    [runLoop addPort:_emptyPort forMode:NSDefaultRunLoopMode];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(timeout) object:nil];
    [runLoop runMode:NSRunLoopCommonModes beforeDate:[NSDate distantFuture]];
//    [runLoop run];
    [self performSelector:@selector(timeout) withObject:nil afterDelay:duration inModes:@[NSDefaultRunLoopMode]];
    
}


- (void)timeout{

    NSLog(@"%@",NSStringFromSelector(_cmd));
}

- (IBAction)loadRewardVideoAction:(id)sender {

//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        [self startTimeoutTimer:3];
//    });
//    return;
    

    if (!self.adUnitId) {
        NSString *msg = @"Your adUnitId is nil";
        [self showMsg:msg];
        return;
    }
    NSDictionary *mediationSettings = @{MTG_REWARDVIDEO_USER:@"Your userId"};
    [MTGRewardVideo registerRewardVideoDelegate:self];
    [MTGRewardVideo loadRewardVideoAdWithAdUnitID:self.adUnitId mediationSettings:mediationSettings];
}

- (IBAction)showRewardVideoAction:(id)sender {
//    MTGRewardVideoDelegate

    if ([MTGRewardVideo hasAdAvailableForAdUnitID:self.adUnitId]) {
        [MTGRewardVideo presentRewardVideoAdForAdUnitID:self.adUnitId fromViewController:self];
    }else{
        NSString *msg = @"video still not ready";
        [self showMsg:msg];
    }
}

- (void)showMsg:(NSString *)content{

    UIAlertController *vc = [UIAlertController alertControllerWithTitle:nil message:content preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"Got it" style:(UIAlertActionStyleDefault) handler:NULL];
    [vc addAction:action];

    [self presentViewController:vc animated:YES completion:NULL];
}

#pragma mark - MTGRewardVideoDelegate

- (void)rewardVideoAdDidLoadForAdUnitID:(NSString *)adUnitID{
    
    self.showButton.userInteractionEnabled = YES;
    NSString *msg = [NSString stringWithFormat:@"unit %@ loadSuccess",adUnitID];
    [self showMsg:msg];
}


- (void)rewardVideoAdDidFailToLoadForAdUnitID:(NSString *)adUnitID
                                        error:(NSError *)error{
    self.showButton.userInteractionEnabled = NO;
    NSString *msg = [NSString stringWithFormat:@"error: %@",error.description];
    [self showMsg:msg];
}

- (void)rewardVideoAdDidFailToPlayForAdUnitID:(NSString *)adUnitID
                                        error:(NSError *)error{
    
}

- (void)rewardVideoAdWillDisappearForAdUnitID:(NSString *)adUnitID{
    
}

- (void)rewardVideoAdShouldRewardForAdUnitID:(NSString *)adUnitID
                                      reward:(MTGRewardVideoReward *)reward{
    
}


- (void)rewardVideoAdDidReceiveTapEventForAdUnitID:(NSString *)adUnitID{
    
}

@end
