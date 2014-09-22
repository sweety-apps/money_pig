//
//  ExchangeController.h
//  wangcai
//
//  Created by 1528 on 13-12-18.
//  Copyright (c) 2013年 1528studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginAndRegister.h"
#import "UICustomAlertView.h"
#import "ExchangeControllerCell.h"
#import "EGORefreshTableHeaderView.h"
#import "HttpRequest.h"

@interface ExchangeController : UIViewController<UITableViewDataSource, UITableViewDelegate,
            BindPhoneDelegate, ExchangeControllerCellDelegate,
            UIAlertViewDelegate, BalanceChangeDelegate, EGORefreshTableHeaderDelegate, HttpRequestDelegate> {
    UITableView* _tableView;
    BeeUIStack* _beeStack;
    
    UILabel* _labelBalance;
    
    UICustomAlertView* _alertView;
    
    UIAlertView*    _alertBindPhone;
    UIAlertView*    _alertNoBalance;
              
    UIAlertView*    _alertExchange;
                
    BOOL _reloading;
    EGORefreshTableHeaderView* _refreshHeaderView;
                
    BOOL _firstRequest;
                
    HttpRequest* _request;
    HttpRequest* _requestExchange;
                
    NSMutableArray* _list;
                
    NSNumber* _prtType;
    NSString* _exchange_code;
    int             _price;
                
    UIView* _bingphoneTipsView;
    UIView* _jiaoyiTipsView;
}

@property (nonatomic,retain) IBOutlet UIButton* jiaoyiBtn;

- (id)init;

- (void) setUIStack :(BeeUIStack*) stack;

- (IBAction)clickBack:(id)sender;
- (IBAction)clickExchangeInfo:(id)sender;
- (IBAction)clickAttachPhone:(id)sender;

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;

- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;

@end
