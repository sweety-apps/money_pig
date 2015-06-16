//
//  BaseTaskTableViewController.h
//  wangcai
//
//  Created by Lee Justin on 13-12-14.
//  Copyright (c) 2013年 1528studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TaskInfoTableViewCell.h"
#import "CommonZhanghuYuETableViewCell.h"
#import "MJRefresh.h"
#import "OnlineWallViewController.h"
#import "RateAppLogic.h"
#import "CommonTaskTableViewCell.h"
#import "UIGetRedBagAlertView.h"

@class BaseTaskTableViewController;

@protocol BaseTaskTableViewControllerDelegate <NSObject>

- (void)taskTableViewController:(BaseTaskTableViewController*)ctrl
            scrollViewDidScroll:(UIScrollView *)scrollView;

@end

@interface BaseTaskTableViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,OnlineWallViewControllerDelegate, UIAlertViewDelegate,RateAppLogicDelegate, HttpRequestDelegate, UIGetRedBagAlertViewDelegate>
{
    CommonZhanghuYuETableViewCell* _zhanghuYuEHeaderCell;
    TaskInfoTableViewCell* _infoCell;
    UITableView* _containTableView;
    UIView* _containTableViewFooterView;
    UIActivityIndicatorView* _containTableViewFooterJuhuaView;
    CGRect _tableViewFrame;
    BeeUIStack* _beeStack;
    BOOL _bounceHeader;
    NSMutableArray* _staticCells;
    BOOL _isUIZhuanJuhuaing;
    BOOL _hasLoadedHistoricalFinishedList;
    NSInteger _curCellCount;
    NSInteger _hisCellCount;
    
    MJRefreshHeaderView *_header;
    CommonTaskTableViewCell* _levelCell;
    
    float _increasedNum;
    
    UIAlertView* _alertBalanceTip;
    
    BOOL _needUpdateApp;
    BOOL _needRetry;
    BOOL _needBindPhone;
    BOOL _needAddCommentIncome;
    
    int _levelChange;
    
    UIAlertView* _alertLevel;
    UIAlertView* _alertChoujiangeShare;
    UICustomAlertView* _alertInstallApp;
    NSString*    _installUrl;
}

@property (nonatomic,retain) IBOutlet CommonZhanghuYuETableViewCell* zhanghuYuEHeaderCell;
@property (nonatomic,retain) UIView* headerBgLongView;
@property (nonatomic,retain) IBOutlet TaskInfoTableViewCell* infoCell;
@property (nonatomic,retain) IBOutlet UITableView* containTableView;
@property (nonatomic,retain) IBOutlet UIView* containTableViewFooterView;
@property (nonatomic,retain) IBOutlet UILabel* containTableViewFooterViewTextLabel;
@property (nonatomic,retain) IBOutlet UIButton* containTableViewFooterViewButton;
@property (nonatomic,retain) IBOutlet UIActivityIndicatorView* containTableViewFooterJuhuaView;
@property (nonatomic,assign) CGRect tableViewFrame;
@property (nonatomic,retain) BeeUIStack* beeStack;

@property (nonatomic,assign) BOOL bounceHeader;
@property (nonatomic,retain) NSMutableArray* staticCells;

@property (nonatomic,assign) id<BaseTaskTableViewControllerDelegate> delegate;

@property (nonatomic,assign) BeeUIBoard* parentUIBoard;

- (IBAction)onPressedLoadHisButton:(id)sender;
- (IBAction)onPressedQiandaoChoujiangButton:(id)sender;
- (IBAction)onPressedTiquxianjinButton:(id)sender;

- (void)enableQiandaoButton:(BOOL)enabled;
- (void)enableTixianButton:(BOOL)enabled;

//带动画和声音设置余额
- (void)setYuENumberWithAnimationFrom:(int)oldNum toNum:(int)newNum;
- (void)updateLevel;

+ (void)setNeedReloadTaskList;
+ (void)setNeedShowChoujiangShare:(int)choujiang;


- (IBAction)onClickCancelInstall:(id)sender;
- (IBAction)onClickInstall:(id)sender;
- (IBAction)onPressedBindPhone:(id)sender;
- (void)onPressedOffWall;
- (void)onPressedArticle;

@end
