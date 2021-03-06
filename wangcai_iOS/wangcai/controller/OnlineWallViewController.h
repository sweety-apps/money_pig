//
//  OnlineWallViewController.h
//  wangcai
//
//  Created by 1528 on 13-12-31.
//  Copyright (c) 2013年 1528studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AssetZoneManager.h"
#import "HttpRequest.h"
#import "UICustomAlertView.h"
#import "CommonYuENumSmallView.h"
#import "YouMiConfig.h"
#import <immobSDK/immobView.h>
#import "SiWeiWall.h"
#import "MopanAdWall.h"
#import "PBOfferWall.h"

#import "MyOfferAPI.h"

#import "DianRuAdWall.h"

@protocol OnlineWallViewControllerDelegate <NSObject>
- (void) onRequestAndConsumePointCompleted : (BOOL) suc Consume:(NSInteger) consume Level:(int) change wangcaiIncome:(int) income;
@end

@interface OnlineWallViewController : UIViewController<DianRuAdWallDelegate, AssetZoneManagerDelegate, immobViewDelegate, HttpRequestDelegate, PBOfferWallDelegate, MyOfferAPIDelegate> {
    AssetZoneManager* _offerWallManager;
    NSInteger                  _nConsume;
    id<OnlineWallViewControllerDelegate>        _delegate;
    
    UICustomAlertView* _alertView;
    
    NSInteger                  _remained;
    
    BOOL               _request;
    NSInteger          _allConsume;
    
    int                _offerwallIncome;
    
    UIViewController* _viewController;
    id _baseTaskTableViewController;
    
    SiWeiWall *_siweWall;
    
    MopanAdWall* _mopanAdWallControl;
    
    int         _nRecommend;
    
    UIView*     _moreView;
}

@property (nonatomic,assign) id<OnlineWallViewControllerDelegate>  delegate;

+ (OnlineWallViewController*) sharedInstance;

@property (nonatomic,retain) UIView* headerBgLongView;
@property (nonatomic, retain)immobView *adView_adWall;
@property (retain, nonatomic) IBOutlet UILabel *yueLbl;
@property (retain, nonatomic) IBOutlet CommonYuENumSmallView *yueView;
@property (retain, nonatomic) IBOutlet UITableView *tableView;

-(void)setViewController:(UIViewController*) viewController;
-(void)setTaskTableViewController:(id)taskTableViewController;
- (void)setNeedRefreshUI;

-(void)enterAdWall;
-(void)QueryScore;
-(void)ReduceScore;

- (void)setFullScreenWindow:(UIWindow*) window;
- (void)showWithModal;
- (void)requestAndConsumePoint;

- (IBAction)clickDomob:(id)sender;
- (IBAction)clickYoumi:(id)sender;
- (IBAction)clickLimei:(id)sender;
- (IBAction)clickMobsmar:(id)sender;
- (IBAction)clickMopan:(id)sender;
- (IBAction)clickPunchBox:(id)sender;
- (IBAction)clickMiidi:(id)sender;
- (IBAction)clickJupeng:(id)sender;
- (IBAction)clickDianru:(id)sender;
- (IBAction)clickAdwo:(id)sender;

- (IBAction)clickHelper:(id)sender;

- (IBAction)clickClose:(id)sender;

- (IBAction)onClickBack:(id)sender;

- (IBAction)onClickNaviback:(id)sender;

@end
