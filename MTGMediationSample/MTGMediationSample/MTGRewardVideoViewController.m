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

- (IBAction)loadRewardVideoAction:(id)sender {

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
