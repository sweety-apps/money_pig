//
//  ExchangeController.m
//  wangcai
//
//  Created by 1528 on 13-12-18.
//  Copyright (c) 2013年 1528studio. All rights reserved.
//

#import "ExchangeController.h"
#import "ExchangeControllerCell.h"
#import "WebPageController.h"
#import "Config.h"
#import "PhoneValidationController.h"
#import "MBHUDView.h"
#import "Common.h"
#import "MobClick.h"
#import "NSString+FloatFormat.h"

@interface ExchangeController ()

@end

@implementation ExchangeController
@synthesize jiaoyiBtn;


- (void) setUIStack :(BeeUIStack*) stack {
    _beeStack = stack;
}

- (id)init
{
    self = [super initWithNibName:@"ExchangeController" bundle:nil];
    if (self) {
        // Custom initialization
        self.view = [[[NSBundle mainBundle] loadNibNamed:@"ExchangeController" owner:self options:nil] firstObject];
        self->_firstRequest = YES;
        self->_request = nil;
        self->_alertView = nil;
        self->_alertBindPhone = nil;
        self->_alertNoBalance = nil;
        self->_list = nil;
        self->_prtType = nil;
        self->_requestExchange = nil;
        self->_exchange_code = nil;
        self->_alertExchange = nil;
        
        _bingphoneTipsView = [self.view viewWithTag:99];
        _jiaoyiTipsView = [self.view viewWithTag:98];
        _labelBalance = (UILabel*) [_jiaoyiTipsView viewWithTag:97];
        _tableView = (UITableView*)[self.view viewWithTag:89];
        _tableView.separatorStyle = NO;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        CGRect rect = [[UIScreen mainScreen]bounds];
        rect.origin.y = 96;
        rect.size.height -= 96;
        
        //[_tableView setHeight:rect.size.height];
        
        [_tableView setFrame:rect];
        
        [[LoginAndRegister sharedInstance] attachBindPhoneEvent:self];
        [[LoginAndRegister sharedInstance] attachBalanceChangeEvent:self];
        
        CGRect rt = CGRectMake(0.0f,
                                 0.0f-_tableView.bounds.size.height,
                                 _tableView.frame.size.width,
                                 _tableView.frame.size.height);
        EGORefreshTableHeaderView* view1 = [[EGORefreshTableHeaderView alloc]
                                            initWithFrame:rt];
        view1.delegate = self;
        [_tableView addSubview:view1];
        _refreshHeaderView = view1;
        [view1 release];
        
        [self requestList];
        
        if ( [[LoginAndRegister sharedInstance] isInReview] ) {
            [[self.view viewWithTag:73] setHidden:YES];
            [self.jiaoyiBtn setHidden:YES];
        }
        
        if ([[[LoginAndRegister sharedInstance] getPhoneNum] length] == 0) {
            [_jiaoyiTipsView setHidden:YES];
        }
        
        [self performSelector:@selector(onViewInit) withObject:nil afterDelay:0.1];
        
        [self updateBalance];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void) balanceChanged:(int) oldBalance New:(int) balance {
    [self updateBalance];
}


- (void)updateBalance {
    int nBalance = [[LoginAndRegister sharedInstance] getBalance];
    NSString* balance = [[NSString alloc] initWithFormat:@"可用余额：¥ %.2f元", (1.0*nBalance/100)];
    [_labelBalance setText:balance];
}

- (void)onViewInit
{
    if ([[[LoginAndRegister sharedInstance] getPhoneNum] length]> 0)
    {
        [self hideBindTips:NO];
    }
    else
    {
        [self showBindTips:YES];
    }
}

- (void)hideBindTips:(BOOL)animated;
{
    void (^block)(void) = ^(){
        _bingphoneTipsView.frame = CGRectMake(0, 5, _bingphoneTipsView.frame.size.width, _bingphoneTipsView.frame.size.height);
    };
    
    [_jiaoyiTipsView setHidden:NO];
    
    if (animated)
    {
        [UIView animateWithDuration:1.0 animations:block];
    }
    else
    {
        block();
    }
}


- (void)showBindTips:(BOOL)animated;
{
    _bingphoneTipsView.frame = CGRectMake(0, 5, _bingphoneTipsView.frame.size.width, _bingphoneTipsView.frame.size.height);
    
    void (^block)(void) = ^(){
        _bingphoneTipsView.frame = CGRectMake(0, 52, _bingphoneTipsView.frame.size.width, _bingphoneTipsView.frame.size.height);
    };
    
    [_jiaoyiTipsView setHidden:YES];
    
    if (animated)
    {
        [UIView animateWithDuration:1.0 animations:block];
    }
    else
    {
        block();
    }
}

- (void) dealloc {
    [[LoginAndRegister sharedInstance] detachBalanceChangeEvent:self];
    [[LoginAndRegister sharedInstance] detachBindPhoneEvent:self];
    
    _refreshHeaderView = nil;
    
    if ( _prtType != nil ) {
        [_prtType release];
        _prtType = nil;
    }
    
    if ( _request != nil ) {
        [_request release];
        _request = nil;
    }
    
    if ( _alertExchange != nil ) {
        [_alertExchange release];
        _alertExchange = nil;
    }
    
    if ( _exchange_code != nil ) {
        [_exchange_code release];
        _exchange_code = nil;
    }
    
    if ( _requestExchange != nil ) {
        [_requestExchange release];
        _requestExchange = nil;
    }
    
    if ( _alertView != nil ) {
        [_alertView release];
        _alertView = nil;
    }
    
    if ( _alertBindPhone != nil ) {
        [_alertBindPhone release];
    }
    
    if ( _alertNoBalance != nil ) {
        [_alertNoBalance release];
    }
    
    [super dealloc];
}

-(void) bindPhoneCompeted {
    [self hideBindTips:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickBack:(id)sender {
	[[BeeUIRouter sharedInstance] open:@"wc_main" animated:YES];
    //[self postNotification:@"showMenu"];
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    if ( row == 0 ) {
        UITableViewCell* cell = [[[NSBundle mainBundle] loadNibNamed:@"ExchangeController" owner:self options:nil] objectAtIndex:1];
        
        return cell;
    } else {
        ExchangeControllerCell* cell = [tableView dequeueReusableCellWithIdentifier:@"exchangeCell"];
        if (cell == nil)
        {
            cell = [[[ExchangeControllerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"exchangeCell"] autorelease];
            cell.delegate = self;
        }
        
        if ( cell ) {
            NSDictionary *info = [_list objectAtIndex:(row-1)];
            [cell setInfo:info];
        }
        
        return cell;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    if ( row == 0 ) {
        return 28;
    }
    
    return 103;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ( _list == nil ) {
        return 1;
    }
    
    return 1 + [_list count];
}

- (IBAction)clickExchangeInfo:(id)sender {
    NSString* device = [[[LoginAndRegister sharedInstance] getDeviceId] autorelease];
    NSString* sessionid = [[[LoginAndRegister sharedInstance] getSessionId] autorelease];
    NSString* userid = [[[LoginAndRegister sharedInstance] getUserId] autorelease];
    NSString* timestamp = [Common getTimestamp];
    
    NSString* url = [[[NSString alloc] initWithFormat:@"%@?device_id=%@&session_id=%@&userid=%@&timestamp=%@", WEB_EXCHANGE_INFO, device, sessionid, userid, timestamp] autorelease];
    
    //统计
    [MobClick event:@"click_trade_details" attributes:@{@"current_page":@"兑换"}];
    WebPageController* controller = [[WebPageController alloc] init:@"交易详情" Url:url Stack:_beeStack];
    [_beeStack pushViewController:controller animated:YES];
}

- (IBAction)clickAttachPhone:(id)sender {
    // 绑定手机
    [MobClick event:@"click_bind_phone" attributes:@{@"currentpage":@"兑换"}];
    
    PhoneValidationController* phoneVal = [PhoneValidationController shareInstance];
    
    [self->_beeStack pushViewController:phoneVal animated:YES];
}


-(void) checkExchange:(NSString*) text1 Text:(NSString*) text2 Tip:(NSString*) tip Button:(NSString*) btnText {
    if ( _alertView != nil ) {
        [_alertView release];
    }
    
    UIView* view = [[[[NSBundle mainBundle] loadNibNamed:@"TransferToAlipayAndPhoneController" owner:self options:nil] lastObject] autorelease];
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = 10.0;
    view.layer.borderWidth = 0.0;
    view.layer.borderColor = [[UIColor whiteColor] CGColor];
    
    UIColor *color = [UIColor colorWithRed:179.0/255 green:179.0/255 blue:179.0/255 alpha:1];
    
    UIButton* btn = (UIButton*)[view viewWithTag:11];
    [btn.layer setBorderWidth:0.5];
    [btn.layer setBorderColor:[color CGColor]];
    [btn setTitleColor:color forState:UIControlStateHighlighted];
    
    btn = (UIButton*)[view viewWithTag:12];
    [btn.layer setBorderWidth:0.5];
    [btn.layer setBorderColor:[color CGColor]];
    [btn setTitleColor:color forState:UIControlStateHighlighted];
    
    [btn setTitle:btnText forState:UIControlStateNormal];
    
    ((UILabel*)[view viewWithTag:21]).text = text1;
    ((UILabel*)[view viewWithTag:22]).text = text2;
    ((UILabel*)[view viewWithTag:23]).text = tip;
    
    _alertView = [[UICustomAlertView alloc]init:view];

    [_alertView show];
}

- (IBAction)clickCancel:(id)sender {
    if ( _alertView != nil ) {
        [_alertView hideAlertView];
    }
}

- (IBAction)clickContinue:(id)sender {
    if ( _alertView != nil ) {
        [_alertView hideAlertView];
    }
    
    //统计
    [MobClick event:@"click_exchange_item" attributes:@{@"exchange_type":[_prtType stringValue]}];
    if ([_prtType intValue] == 1)
    {
        //京东卡
        [MobClick event:@"click_buy_jingdong_card" attributes:@{@"exchange_type":[_prtType stringValue]}];
    }
    else if([_prtType intValue] == 2)
    {
        //迅雷白金会员卡
        [MobClick event:@"click_buy_xunlei_vip_card" attributes:@{@"exchange_type":[_prtType stringValue]}];
    }
    
    [self showLoading:@"处理中..."];
    
    // 提交请求到服务器
    if ( _requestExchange != nil ) {
        [_requestExchange release];
    }
    
    _requestExchange = [[HttpRequest alloc] init:self];
    
    NSMutableDictionary* dictionary = [[[NSMutableDictionary alloc] init] autorelease];
    [dictionary setObject:_prtType forKey:@"exchange_type"];

    [_requestExchange request:HTTP_EXCHANGE_CODE Param:dictionary];
}



-(BOOL) checkBalanceAndBindPhone :(float) fCoin {
    NSString* phoneNum = [[LoginAndRegister sharedInstance] getPhoneNum];
    if ( phoneNum == nil || [phoneNum isEqualToString:@""] ) {
        // 没有绑定手机号
        if ( _alertBindPhone != nil ) {
            [_alertBindPhone release];
        }
        
        _alertBindPhone = [[UIAlertView alloc] initWithTitle:@"提示" message:@"尚未绑定手机，请先绑定手机" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"绑定手机", nil];
        
        [_alertBindPhone show];
        
        if ( phoneNum != nil ) {
            [phoneNum release];
        }
        return NO;
    }
    
    [phoneNum release];
    
    float balance = (1.0*[[LoginAndRegister sharedInstance] getBalance]) / 100;
    if ( fCoin > balance ) {
        if ( _alertNoBalance != nil ) {
            [_alertNoBalance release];
        }
        
        _alertNoBalance = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您的余额不足以支付" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [_alertNoBalance show];
        
        return NO;
    }
    
    return YES;
}

-(void) onClickExchange : (id) sender {
    if ([[LoginAndRegister sharedInstance] getNoWithDraw] != 0)
    {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"休假通知" message:@"感谢各位对旺财的内测支持，春节期间由于假期关系，暂停取现充值功能，请在假期结束后（2月9日）执行相关操作，祝大家新年红包满满。" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    
    NSDictionary* info = [sender getInfo];
    
    NSString* name = [info objectAtPath:@"name"];
    NSNumber* price = [info objectAtPath:@"price"];
    NSNumber* type = [info objectAtPath:@"type"];
    NSNumber* remain = [info objectAtPath:@"remain"];
    
    int nPrice = [price intValue];
    _price = nPrice;
    
    if ( _prtType != nil ) {
        [_prtType release];
    }
    
    _prtType = [type copy];

    if ( [self checkBalanceAndBindPhone:(1.0*nPrice/100)] ) {
        // 判断数量是否为0
        if ( [remain intValue] <= 0 ) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"当前数量为0，无法完成兑换！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            [alert release];
            
            return ;
        }
        
        NSString* nsTitle = [[NSString alloc] initWithFormat:@"产品：%@", name];
        NSString* nsPrice = [[NSString alloc] initWithFormat:@"价格：%@元",[NSString stringWithFloatRoundToPrecision:(1.0f*((float)nPrice)/100.f) precision:2 ignoreBackZeros:YES]];
        
        [self checkExchange:nsTitle Text:nsPrice Tip:@"兑换需要1-3个工作日，请耐心等待" Button:@"继续兑换"];
        
        [nsTitle release];
        [nsPrice release];
    }
}

-(void) onShowOrder:(NSString*) orderNum {
    NSString* url = [[WEB_ORDER_INFO copy] autorelease];
    url = [url stringByAppendingFormat:@"?ordernum=%@", orderNum];
    
    WebPageController* controller = [[[WebPageController alloc] initOrder:orderNum Url:url Stack:_beeStack] autorelease];
    [_beeStack pushViewController:controller animated:YES];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ( _alertBindPhone != nil ) {
        if ( [_alertBindPhone isEqual:alertView] ) {
            if ( buttonIndex == 1 ) {
                [self onAttachPhone];
            }
        }
    }
    if ( _alertExchange != nil ) {
        if ( [_alertExchange isEqual:alertView] ) {
            if ( buttonIndex == 1 ) {
                // 显示交易详情
                [self onShowOrder:_exchange_code];
            }
        }
    }
}

-(void) onAttachPhone {
    // 绑定手机
    [MobClick event:@"click_bind_phone" attributes:@{@"currentpage":@"兑换"}];
    
    PhoneValidationController* phoneVal = [PhoneValidationController shareInstance];
    [self->_beeStack pushViewController:phoneVal animated:YES];
}

- (void) reloadTableViewDataSource{
    _reloading = NO;
    //这里引用你加载数据的方法
    
    [self requestList];
}

//加载结束事件
- (void)doneLoadingTableViewData{
    
    //  model should call this when its done loading
    _reloading = NO;
    
    if ( _list != nil ) {
        [self->_tableView reloadData];
    }else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"当前网络不可用，请检查网络连接" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self->_tableView];
}

#pragma mark -#pragma mark UIScrollViewDelegate Methods
//table也是scrollview所以只要滚动就会调用这个方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}

//滚动结束就会调用这个方法
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    
}

//释放更新
- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
    //
    //  [self reloadTableViewDataSource];
    [NSThread detachNewThreadSelector:@selector(reloadTableViewDataSource) toTarget:self withObject:nil];
    //  [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:3.0];
    
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
    return _reloading; // should return if data source model is reloading
    
}

- (void) showLoading:(NSString*) tip {
    [MBHUDView hudWithBody:tip type:MBAlertViewHUDTypeActivityIndicator hidesAfter:-1 show:YES];
}

- (void) hideLoading {
    [MBHUDView dismissCurrentHUD];
}

- (void) requestList {
    if ( _firstRequest ) {
        [self showLoading:@"请等待..."];
    }
    
    if ( _request != nil ) {
        [_request  release];
    }
    
    _request = [[HttpRequest alloc] init:self];
    NSMutableDictionary* dictionary = [[[NSMutableDictionary alloc] init] autorelease];
    NSString* timestamp = [Common getTimestamp];
    [dictionary setObject:timestamp forKey:@"stamp"];
    NSDictionary* dic = [[NSBundle mainBundle] infoDictionary];
    NSString* appVersion = [dic valueForKey:@"CFBundleVersion"];
    [dictionary setObject:appVersion forKey:@"ver"];
    [dictionary setObject:APP_NAME forKey:@"app"];
    
    [_request request:HTTP_EXCHANGE_LIST Param:dictionary method:@"get"];
}

-(void) HttpRequestCompleted : (id) request HttpCode:(int)httpCode Body:(NSDictionary*) body {
    if ( _requestExchange != nil && [request isEqual:_requestExchange] ) {
        [self hideLoading];
        if ( httpCode == 200 ) {
            [self onExchangeCompleted:body];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"当前网络不可用，请检查网络连接" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
        }
    } else if ( _request != nil && [request isEqual:_request] ) {
        if ( _firstRequest ) {
            [self hideLoading];
            _firstRequest = NO;
        }
    
        if ( httpCode == 200 ) {
            // 获取到返回的列表
            NSNumber* res = [body valueForKey: @"res"];
            int nRes = [res intValue];
            if (nRes == 0) {
                NSArray* list = [body valueForKey: @"exchange_list"];
                if ( _list != nil ) {
                    [_list release];
                }
            
                _list = [self copyList:list];
            }
        }
    
        [self doneLoadingTableViewData];
    }
}

- (NSMutableArray*) copyList:(NSArray*) list {
    NSMutableArray* retList = [[NSMutableArray alloc] init];
    for ( int i = 0; i < [list count]; i ++ ) {
        NSDictionary* tmp = [list objectAtIndex:i];
        NSMutableDictionary* dict = [[[NSMutableDictionary alloc] initWithDictionary:tmp] autorelease];
        
        [retList addObject:dict];
    }
    
    return retList;
}

- (void) onExchangeCompleted:(NSDictionary*) infos {
    NSNumber* res = [infos valueForKey: @"res"];
    int nRes = [res intValue];
    if (nRes == 0) {
        if ( _exchange_code != nil ) {
            [_exchange_code release];
        }
        
        _exchange_code = [[infos valueForKey: @"order_id"] copy];
        
        if ( _alertExchange != nil ) {
            [_alertExchange release];
            _alertExchange = nil;
        }
        
        //统计
        [MobClick event:@"money_get_from_all" attributes:@{@"RMB":[NSString stringWithFormat:@"%d",-1*_price],@"FROM": [NSString stringWithFormat:@"兑换 类型%d",[_prtType intValue]]}];
        
        [[LoginAndRegister sharedInstance] increaseBalance:(-1*_price)];
        
        [self exchangeCompleted:[_prtType intValue]];
        
        _alertExchange = [[UIAlertView alloc] initWithTitle:@"交易完成" message:@"恭喜您，换购请求已确认，请您耐心等待。" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"查看详细", nil];
        [_alertExchange show];
    } else {
        NSString* err = [infos valueForKey: @"msg"];
        UIAlertView *alert;
        if ( err == nil || [err length] == 0 ) {
            alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"兑换失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        } else {
            alert = [[UIAlertView alloc] initWithTitle:@"提示" message:err delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        }
        
        [alert show];
        [alert release];
    }
}

-(void) exchangeCompleted:(int) type {
    int count = [_list count];
    for (int i = 0; i < count; i ++ ) {
        NSMutableDictionary* dict = [_list objectAtIndex:i];
        NSNumber* tmp = [dict objectAtPath:@"type"];
        if ( [tmp intValue] == type ) {
            NSNumber* remain = [dict objectAtPath:@"remain"];
            int nRemain = [remain intValue];

            [dict setValue:[NSNumber numberWithInt:nRemain-1] forKey:@"remain"];
            
            [self->_tableView reloadData];
            break;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    id cell = [tableView cellForRowAtIndexPath:indexPath];
    [self onClickExchange:cell];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
