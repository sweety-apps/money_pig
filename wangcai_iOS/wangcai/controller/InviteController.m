//
//  InviteController.m
//  wangcai
//
//  Created by 1528 on 13-12-11.
//  Copyright (c) 2013年 1528studio. All rights reserved.
//

#import "InviteController.h"
#import "LoginAndRegister.h"
#import "MBHUDView.h"
#import <ShareSDK/ShareSDK.h>
#import "qrencode.h"
#import "WebPageController.h"
#import "Config.h"
#import "SettingLocalRecords.h"
#import "BaseTaskTableViewController.h"
#import "MobClick.h"
#import "UIGetRedBagAlertView.h"
#import "NSString+FloatFormat.h"
#import "InviteViewTableViewCell.h"

@interface InviteController ()

@property (nonatomic, retain) UITapGestureRecognizer * tapGestureRecognizer;
@property (nonatomic, retain) InviteViewTableViewCell* inviteCell;
@property (nonatomic, retain) NSString* inviteCode;
@property (nonatomic, retain) NSString* inviteUrl;

@end

@implementation InviteController

@synthesize inviteCode = _inviteCode;

- (void) _setupCell:(InviteViewTableViewCell*)cell
{
    self.inviteCell = cell;
    
    NSString* inviteCode = [[LoginAndRegister sharedInstance] getInviteCode];
    if (inviteCode != nil)
    {
        [self setInviteCode: inviteCode toCell:cell];
    }
    
    NSString* inviter = [[LoginAndRegister sharedInstance] getInviter];
    if (!(inviter == nil || [inviter length] == 0))
    {
        [cell setHasBindCode:YES];
        cell.otherCodeField.text = inviter;
    }
    else
    {
        [cell setHasBindCode:NO];
        cell.otherCodeField.text = nil;
    }
    
    int income = [[LoginAndRegister sharedInstance] getInviteIncome];
    
    if ( income < 0 )
    {
        income = 0;
    }
    
    NSNumber* nsIncome = [NSNumber numberWithFloat:((float)income)/100.f];
    NSString* inviteIncomeContent = [NSString stringWithFormat:@"小伙伴帮你赚了￥%@哦！",nsIncome];
    
    cell.friendShareEarnLabel.text = inviteIncomeContent;
    
    cell.otherCodeField.delegate = self;
    
    [cell.commitOtherCodeBtn addTarget:self action:@selector(updateInviter:) forControlEvents:UIControlEventTouchUpInside];
    [cell.shareButton addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
}

+ (InviteController*) controller
{
    InviteController* ret = [[[InviteController alloc] initWithNibName:@"CommonPullRefreshViewController" bundle:nil] autorelease];
    return ret;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self _setupHeaderFooterNavibar];
    self.tapGestureRecognizer = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard:)] autorelease];
    [self.view addGestureRecognizer:self.tapGestureRecognizer];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"InviteViewTableViewCell" bundle:nil] forCellReuseIdentifier:@"InviteViewTableViewCell"];
    
    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void) _setupHeaderFooterNavibar
{
    self.navigationBarView.backgroundColor = RGB(168, 207, 73);
    self.navigationBarTitleLabel.text = @"分享赚钱";
    
    self.header.scrollView = nil;
    self.header.hidden = YES;
    self.footer.scrollView = nil;
    self.footer.hidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    self._beeStack = nil;
    self.inviteCode = nil;
    self.inviteUrl = nil;
    self.inviteCell = nil;
    self.tapGestureRecognizer = nil;
    [super dealloc];
}

-(void) ShareCompleted : (id) share State:(SSResponseState) state Err:(id<ICMErrorInfo>) error
{
}

- (IBAction)copyUrl:(id)sender
{
    UIPasteboard* pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.inviteUrl;
    
    //统计
    [MobClick event:@"click_copy_to_clipboard" attributes:@{@"current_page":@"邀请",@"content":pasteboard.string}];
    
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle: @"复制成功" message: nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alertView show];
    [alertView release];
}

- (IBAction)share:(id)sender
{
    //统计
    [MobClick event:@"click_invite_redbag" attributes:@{@"current_page":@"邀请"}];
    
    NSString* imagePath = [[NSBundle mainBundle] pathForResource:@"Icon@2x" ofType:@"png"];
    
    id<ISSContent> publishContent = [ShareSDK content: [NSString stringWithFormat:@"真金白银的福利哦！ %@",self.inviteUrl] defaultContent:@"" image:[ShareSDK imageWithPath:imagePath] title: @"玩应用领红包" url: self.inviteUrl description: @"来玩小猪猪哟！" mediaType: SSPublishContentMediaTypeNews];
    
    id<ISSContainer> container = [ShareSDK container];
    NSArray *sharelist = [ShareSDK getShareListWithType:ShareTypeWeixiTimeline,ShareTypeWeixiSession,ShareTypeQQ,ShareTypeSMS,ShareTypeCopy, nil];
    [container setIPhoneContainerWithViewController:self];
    [ShareSDK showShareActionSheet:container  shareList: sharelist content: publishContent statusBarTips: YES authOptions: nil shareOptions: nil result: ^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end)
     {
         NSString* msg = @"分享";
         if (type == ShareTypeCopy)
         {
             msg = @"复制";
         }
         if (state == SSResponseStateSuccess)
         {
             // todo 分享成功
             msg = [msg stringByAppendingString:@"成功！"];
             [SettingLocalRecords saveLastShareDateTime:[NSDate date]];
             [MBHUDView hudWithBody:msg type:MBAlertViewHUDTypeCheckmark hidesAfter:1.5 show:YES];
         }
         else if (state == SSResponseStateFail)
         {
             // todo 分享失败
             msg = [msg stringByAppendingString:@"失败:("];
             UIAlertView* av = [[[UIAlertView alloc] initWithTitle:msg message:nil delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles:nil] autorelease];
             [av show];
         }
     }];
}

- (void)setInviteCode: (NSString *)inviteCode toCell:(InviteViewTableViewCell*)cell
{
    if (_inviteCode != inviteCode)
    {
        [_inviteCode release];
        _inviteCode = [inviteCode copy];
        
        cell.myCodeLabel.text = _inviteCode;
        self.inviteUrl = [NSString stringWithFormat: INVITE_URL, _inviteCode];
        cell.qrcodeImageView.image = [self QRCodeGenerator: [NSString stringWithFormat: INVITE_URL, _inviteCode] andLightColor: [UIColor whiteColor] andDarkColor: [UIColor blackColor] andQuietZone: 1 andSize: 128];
    }
}

- (UIImage *)QRCodeGenerator: (NSString *)iData andLightColor: (UIColor *)iLightColor andDarkColor: (UIColor *)iDarkColor andQuietZone: (NSInteger)iQuietZone andSize: (NSInteger)iSize
{
    UIImage* ret = nil;
    QRcode* qr = QRcode_encodeString([iData UTF8String], 0, QR_ECLEVEL_L, QR_MODE_8, 1);
    int logQRSize = qr->width;
    int phyQRSize = (int)(logQRSize + (2 * iQuietZone));
    int scale = (int)(iSize / phyQRSize);
    int imgSize = phyQRSize * scale;
    
    if (scale < 1)
    {
        scale = 1;
    }
    UIGraphicsBeginImageContext(CGSizeMake(imgSize, imgSize));
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect bounds = CGRectMake(0, 0, imgSize, imgSize);
    CGContextSetFillColorWithColor(ctx, iLightColor.CGColor);
    CGContextFillRect(ctx, bounds);
    
    int x, y;
    CGContextSetFillColorWithColor(ctx, iDarkColor.CGColor);
    for (y = 0; y < logQRSize; y++)
    {
        for (x = 0; x < logQRSize; x ++)
        {
            if (qr->data[y*logQRSize + x] & 1)
            {
                CGContextFillRect(ctx, CGRectMake((iQuietZone + x) * scale, (iQuietZone + y) * scale, scale, scale));
            }
        }
    }
    
    CGImageRef imgRef = CGBitmapContextCreateImage(ctx);
    ret = [UIImage imageWithCGImage: imgRef];
    
    CGImageRelease(imgRef);
    UIGraphicsEndImageContext();
    QRcode_free(qr);
    
    return ret;
}

- (IBAction)hideKeyboard:(id)sender
{
    [self.inviteCell.otherCodeField resignFirstResponder];
}

- (void)showLoading
{
    [MBHUDView hudWithBody: @"请等待..." type:MBAlertViewHUDTypeActivityIndicator hidesAfter: -1 show: YES];
}

- (void)hideLoading
{
    [MBHUDView dismissCurrentHUD];
}

- (IBAction)updateInviter:(id)sender
{
    NSString* inviter = self.inviteCell.otherCodeField.text;
    if ([inviter length] > 0)
    {
        //统计
        [MobClick event:@"click_submit_invite_code" attributes:@{@"current_page":@"邀请",@"code":inviter}];
        
        [[InviterUpdate sharedInstance] updateInviter: inviter delegate: self];
        [self showLoading];
    }
}

- (void)updateInviterCompleted:(BOOL)suc errMsg:(NSString *)errMsg
{
    [self hideLoading];
    if (suc)
    {
        // 发送成功
        [[LoginAndRegister sharedInstance] setInviter:self.inviteCell.otherCodeField.text];
        [[LoginAndRegister sharedInstance] login];
        [self.tableView reloadData];
        
        UIGetRedBagAlertView* getMoneyAlertView = [UIGetRedBagAlertView sharedInstance];
        [getMoneyAlertView setRMBString:[NSString stringWithFloatRoundToPrecision:2 precision:2 ignoreBackZeros:NO]];
        [getMoneyAlertView setLevel:3];
        [getMoneyAlertView setTitle:@"邀请红包"];
        [getMoneyAlertView setShowCurrentBanlance:[[LoginAndRegister sharedInstance] getBalance] andIncrease:200];
        [getMoneyAlertView show];
        
        //统计
        [MobClick event:@"money_get_from_all" attributes:@{@"RMB":[NSString stringWithFormat:@"%d",200],@"FROM": @"绑定邀请人成功"}];
        
        // 给用户加二块钱
        [[LoginAndRegister sharedInstance] increaseBalance:200];
        [BaseTaskTableViewController setNeedReloadTaskList];
    }
    else
    {
        // 发送失败
        if (errMsg == nil)
        {
            errMsg = @"绑定邀请人失败";
        }
        
        UIAlertView* av = [[UIAlertView alloc] initWithTitle:errMsg message:nil delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles:nil];
        [av show];
    }
}

#pragma mark - Text Field Delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    //NSString* text = textField.text;
    //NSUInteger n = text.length;
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {  // return NO to not change text
    if ([@"\n" isEqualToString:string] ) {
        [self.inviteCell.otherCodeField resignFirstResponder];
        return NO;
    }
    return YES;
}

- (IBAction)clickTextLink:(id)sender {
    BeeUIStack* stack = self._beeStack;
    
    NSString* url = [[[NSString alloc] initWithFormat:@"%@123", WEB_SERVICE_VIEW] autorelease];
    
    WebPageController* controller = [[[WebPageController alloc] init:@"如何成为推广员"
                                                                 Url:url Stack:stack] autorelease];
    [stack pushViewController:controller animated:YES];
}

#pragma mark 子类覆盖
- (void) onStartHeaderRefresh
{
    //[[BillingHistoryList sharedInstance] requestOrderDetailWithOrderid:self.orderid delegate:self];
}

- (void) onStartFooterRefresh
{
    //[[BillingHistoryList sharedInstance] requestGetMoreBillingHis:self];
}

#pragma mark - <UITableViewDelegate>
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 370;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - <UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = indexPath.row;
    UITableViewCell* retCell = nil;
    
    InviteViewTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"InviteViewTableViewCell" forIndexPath:indexPath];
    if (cell == nil)
    {
        cell = CREATE_NIBVIEW(@"InviteViewTableViewCell");
    }
    retCell = cell;
    
    [self _setupCell:cell];
    
    return retCell;
}

@end
