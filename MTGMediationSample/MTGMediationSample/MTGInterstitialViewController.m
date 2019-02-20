//
//  MTGInterstitialViewController.m
//  MTGMediationSample
//
//  Created by CharkZhang on 2019/1/24.
//  Copyright © 2019 CharkZhang. All rights reserved.
//

#import "MTGInterstitialViewController.h"
#import "MTGInterstitialAdManager.h"

#import "MTGAdInfo.h"

@interface MTGInterstitialViewController ()<MTGInterstitialAdManagerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *loadButton;
@property (weak, nonatomic) IBOutlet UIButton *showButton;

@property (nonatomic,copy)  NSString *adUnitId;

@property (nonatomic,strong)  MTGInterstitialAdManager *interstitialManager;
@end

@implementation MTGInterstitialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Interstitial";
    self.showButton.userInteractionEnabled = NO;
    
    NSArray *adUnitInfos = [MTGAdInfo interstitialAdUnitIds];
    self.adUnitId = (adUnitInfos.count > 0)?adUnitInfos[0]: nil;

}

-(MTGInterstitialAdManager *)interstitialManager{
    if (_interstitialManager) {
        return _interstitialManager;
    }
    _interstitialManager = [[MTGInterstitialAdManager alloc] initWithAdUnitID:self.adUnitId delegate:self];
    return _interstitialManager;
}


- (IBAction)loadInterstitialAction:(id)sender {

    if (!self.adUnitId) {
        NSString *msg = @"Your adUnitId is nil";
        [self showMsg:msg];
        return;
    }
    [self.interstitialManager loadInterstitial];
}

- (IBAction)showInterstitialAction:(id)sender {

    if ([self.interstitialManager ready]) {
        [self.interstitialManager presentInterstitialFromViewController:self];
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

#pragma mark - MTGInterstitialAdManagerDelegate

- (void)manager:(MTGInterstitialAdManager *)manager didFailToLoadInterstitialWithError:(NSError *)error {
    self.showButton.userInteractionEnabled = NO;
    NSString *msg = [NSString stringWithFormat:@"error: %@",error.description];
    [self showMsg:msg];
}

- (void)managerDidLoadInterstitial:(MTGInterstitialAdManager *)manager {
    
    self.showButton.userInteractionEnabled = YES;
    NSString *msg = [NSString stringWithFormat:@"unit %@ loadSuccess",manager];
    [self showMsg:msg];
}

- (void)managerDidPresentInterstitial:(MTGInterstitialAdManager *)manager {
    //
}

- (void)manager:(MTGInterstitialAdManager *)manager didFailToPresentInterstitialWithError:(NSError *)error {
    //
}

- (void)managerDidReceiveTapEventFromInterstitial:(MTGInterstitialAdManager *)manager {
    //
}

- (void)managerWillDismissInterstitial:(MTGInterstitialAdManager *)manager {
    //
}

-(NSDictionary *)managerReceiveMediationSetting{
    
    NSDictionary *mediationSettings = @{MTG_INTERSTITIAL_USER:@"Your userId"};
    return mediationSettings;
}

@end
