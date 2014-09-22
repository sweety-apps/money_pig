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

@interface InviteController ()

@end

@implementation InviteController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
        self.view = [[[NSBundle mainBundle] loadNibNamed:nibNameOrNil owner:self options:nil] firstObject];
        
        [self load:nibNameOrNil];
        
        self._beeStack = nil;
        self.title = @"邀请送红包";
        _inviterUpdate = [[InviterUpdate alloc] init];
    }
    return self;
}

- (NSArray *)constrainSubview: (UIView *)subview toMatchWithSuperview: (UIView *)superview
{
    subview.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary* viewsDictionary = NSDictionaryOfVariableBindings(subview);
    
    NSArray* constraints = [NSLayoutConstraint constraintsWithVisualFormat: @"H:|[subview]|" options: 0 metrics: nil views: viewsDictionary];
    constraints = [constraints arrayByAddingObjectsFromArray: [NSLayoutConstraint constraintsWithVisualFormat: @"V:|[subview]|" options: 0 metrics: nil views: viewsDictionary]];
    [superview addConstraints: constraints];
    
    return constraints;
}

- (void) load:(NSString*)nibNameOrNil {
    self.inviteView = [[[NSBundle mainBundle] loadNibNamed:nibNameOrNil owner:self options:nil] objectAtIndex:1];
    self.invitedView = [[[NSBundle mainBundle] loadNibNamed:nibNameOrNil owner:self options:nil] objectAtIndex:2];
    
    self.containerView = [self.view viewWithTag:11];
    self.errorImage = (UIImageView*)[self.invitedView viewWithTag:12];
    self.errorMessage = (UILabel*)[self.invitedView viewWithTag:13];
    self.inviteCodeLabel = (UILabel*)[self.inviteView viewWithTag:14];
    self.invitedButton = (UIButton*)[self.invitedView viewWithTag:15];
    self.invitedPeopleTextfield = (UITextField*)[self.invitedView viewWithTag:16];
    self.inviterLabel = (UILabel*)[self.invitedView viewWithTag:17];
    self.inviteUrlTextField = (UITextField*)[self.inviteView viewWithTag:18];
    self.qrcodeView = (UIImageView*)[self.inviteView viewWithTag:20];
    self.segment = (UISegmentedControl*)[self.view viewWithTag:21];
    self.shareButton = (UIButton*)[self.inviteView viewWithTag:22];
    self.inputInviteTip = (UILabel*)[self.invitedView viewWithTag:33];
    
    
    self.inviteIncome = (UILabel*)[self.inviteView viewWithTag:41];
    self.inviteIncomeTip = (UILabel*)[self.inviteView viewWithTag:42];
    
    self.invitedPeopleTextfield.delegate = self;
    
    [self.containerView addSubview: self.inviteView];
    
    self.priorConstraints = [self constrainSubview: self.inviteView toMatchWithSuperview: self.containerView];
    
    UIImage* shareButtonBkg = [[UIImage imageNamed: @"invite_share_button"] resizableImageWithCapInsets: UIEdgeInsetsMake(8, 8, 8, 8)];
    [self.shareButton setBackgroundImage: shareButtonBkg forState:UIControlStateNormal];
    [self.invitedButton setBackgroundImage: shareButtonBkg forState: UIControlStateNormal];
    
    UIImage* segmentSelected = [[UIImage imageNamed: @"invite_seg_select"] resizableImageWithCapInsets: UIEdgeInsetsMake(9, 8, 9, 8)];
    
    UIImage* segmentUnselected = [[UIImage imageNamed: @"invite_seg_normal"] resizableImageWithCapInsets: UIEdgeInsetsMake(9, 8, 9, 8)];
    
    UIImage* segmentSelectedUnselected = [UIImage imageNamed: @"invite_seg_sel_unsel"];
    
    UIImage* segmentUnselectedSelected = [UIImage imageNamed: @"invite_seg_unsel_sel"];
    
    UIImage* segmentUnselectedUnselected = [UIImage imageNamed: @"invite_seg_unsel_unsel"];
    
    UIImage* segmentSelectedSelected = [UIImage imageNamed: @"invite_seg_sel_sel"];
    
    [self.segment setBackgroundImage: segmentUnselected forState: UIControlStateNormal barMetrics: UIBarMetricsDefault];
    [self.segment setBackgroundImage: segmentSelected forState: UIControlStateSelected barMetrics: UIBarMetricsDefault];
    [self.segment setBackgroundImage: segmentSelected forState: UIControlStateHighlighted barMetrics: UIBarMetricsDefault];
    
    [self.segment setDividerImage: segmentSelectedUnselected forLeftSegmentState: UIControlStateSelected rightSegmentState: UIControlStateNormal barMetrics: UIBarMetricsDefault];
    [self.segment setDividerImage: segmentUnselectedSelected forLeftSegmentState: UIControlStateNormal rightSegmentState: UIControlStateSelected barMetrics: UIBarMetricsDefault];
    [self.segment setDividerImage: segmentUnselectedUnselected forLeftSegmentState: UIControlStateNormal rightSegmentState: UIControlStateNormal barMetrics: UIBarMetricsDefault];
    
    [self.segment setDividerImage: segmentSelectedSelected forLeftSegmentState: UIControlStateHighlighted rightSegmentState: UIControlStateSelected barMetrics: UIBarMetricsDefault];
    [self.segment setDividerImage: segmentSelectedSelected forLeftSegmentState: UIControlStateSelected rightSegmentState: UIControlStateHighlighted barMetrics: UIBarMetricsDefault];
    
    NSDictionary* textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:17], UITextAttributeFont, [UIColor grayColor], UITextAttributeTextColor, nil];
    [self.segment setTitleTextAttributes:textAttributes forState:UIControlStateNormal];
    
    textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:17], UITextAttributeFont, [UIColor whiteColor], UITextAttributeTextColor, nil];
    [self.segment setTitleTextAttributes:textAttributes forState:UIControlStateSelected];
    
    NSString* inviteCode = [[LoginAndRegister sharedInstance] getInviteCode];
    if (inviteCode != nil)
    {
        [self setInviteCode: inviteCode];
    }
    
    NSString* inviter = [[LoginAndRegister sharedInstance] getInviter];
    if (!(inviter == nil || [inviter length] == 0))
    {
        [self.inputInviteTip setHidden:YES];
        [self setInvitedPeople: inviter];
        [self updateInvitersControls: YES];
    }
    else
    {
        [self.inputInviteTip setHidden:NO];
        [self updateInvitersControls: NO];
    }
    
    [self updateErrorMsg: NO msg: nil];
    
    
    int income = [[LoginAndRegister sharedInstance] getInviteIncome];
    if ( income < 0 ) {
        [[self.view viewWithTag:40] setHidden:YES];
        [[self.view viewWithTag:41] setHidden:YES];
    } else {
        NSString* nsIncome = [[NSString alloc]initWithFormat:@"%.2f元", 1.0*income/100];
    
        self.inviteIncome.text = nsIncome;
        [nsIncome release];
    }
    
    self.inviteIncomeTip.text = @"获得额外10%的好友任务奖励";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)updateViewConstraints
{
    [super updateViewConstraints];
}

- (void)updateErrorMsg: (BOOL)error msg: (NSString *)errMsg
{
    if (error)
    {
        [self.errorImage setHidden: NO];
        [self.errorMessage setHidden: NO];
        [self.errorMessage setText: errMsg];
    }
    else
    {
        [self.errorImage setHidden: YES];
        [self.errorMessage setHidden: YES];
    }
}

- (void)updateInvitersControls: (BOOL)hasInviter
{
    if (hasInviter)
    {
        self.invitedPeopleTextfield.enabled = NO;
        self.invitedButton.hidden = YES;
    }
    else
    {
        self.invitedPeopleTextfield.enabled = YES;
        self.invitedButton.hidden = NO;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    self._beeStack = nil;
    [self.inviteView release];
    [self.invitedView release];
    [self.inviteCode release];
    [self.invitedPeople release];
    [_inviterUpdate release];
    [super dealloc];
}

-(void) ShareCompleted : (id) share State:(SSResponseState) state Err:(id<ICMErrorInfo>) error {
}

- (IBAction)copyUrl:(id)sender
{
    UIPasteboard* pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.inviteUrlTextField.text;
    
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
    
    id<ISSContent> publishContent = [ShareSDK content: @"妈妈再也不用担心我的话费了" defaultContent:@"" image:[ShareSDK imageWithPath:imagePath] title: @"玩应用领红包" url: [NSString stringWithFormat: INVITE_URL, _inviteCode] description: @"旺财分享" mediaType: SSPublishContentMediaTypeNews];
    
    [ShareSDK showShareActionSheet: nil shareList: nil content: publishContent statusBarTips: YES authOptions: nil shareOptions: nil result: ^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end)
     {
         if (state == SSResponseStateSuccess)
         {
             // todo 分享成功
             [SettingLocalRecords saveLastShareDateTime:[NSDate date]];
         }
         else if (state == SSResponseStateFail)
         {
             // todo 分享失败
         }
     }];
}

- (IBAction)switchView:(id)sender
{
    UIView* fromView, *toView;
    
    if ([self.inviteView superview] != nil)
    {
        fromView = self.inviteView;
        toView = self.invitedView;
        self.segment.selectedSegmentIndex = 1;
    }
    else
    {
        fromView = self.invitedView;
        toView = self.inviteView;
        self.segment.selectedSegmentIndex = 0;
    }
    
    NSArray* priorConstraints = self.priorConstraints;
    [UIView transitionFromView: fromView toView: toView duration: 0.4 options: UIViewAnimationOptionTransitionCrossDissolve completion: ^(BOOL finished)
    {
        [self.containerView removeConstraints: priorConstraints];
    }];
    self.priorConstraints = [self constrainSubview: toView toMatchWithSuperview: self.containerView];
}

- (void)setInviteCode: (NSString *)inviteCode
{
    if (_inviteCode != inviteCode)
    {
        [_inviteCode release];
        _inviteCode = [inviteCode copy];
        
        self.inviteCodeLabel.text = _inviteCode;
        self.inviteUrlTextField.text = [NSString stringWithFormat: INVITE_URL, _inviteCode];
        self.qrcodeView.image = [self QRCodeGenerator: [NSString stringWithFormat: INVITE_URL, _inviteCode] andLightColor: [UIColor whiteColor] andDarkColor: [UIColor blackColor] andQuietZone: 1 andSize: 128];
    }
}

- (void)setInvitedPeople: (NSString *)invitedPeople
{
    if (_invitedPeople != invitedPeople)
    {
        [_invitedPeople release];
        _invitedPeople = [invitedPeople copy];
        
        self.invitedPeopleTextfield.text = _invitedPeople;
    }
}

- (void)setReceiveMoney:(NSUInteger)receiveMoney
{
    _receiveMoney = receiveMoney;
    self.receiveMoneyLabel.text = [NSString stringWithFormat: @"%lu", (unsigned long)_receiveMoney];
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

- (IBAction)clickBack:(id)sender
{
    [[BeeUIRouter sharedInstance] open:@"wc_main" animated:YES];
}

- (IBAction)hideKeyboard:(id)sender
{
    [_invitedPeopleTextfield resignFirstResponder];
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
    NSString* inviter = self.invitedPeopleTextfield.text;
    if (inviter != nil)
    {
        //统计
        [MobClick event:@"click_submit_invite_code" attributes:@{@"current_page":@"邀请",@"code":inviter}];
        
        [_inviterUpdate updateInviter: inviter delegate: self];
        [self showLoading];
    }
}

- (void)updateInviterCompleted:(BOOL)suc errMsg:(NSString *)errMsg
{
    [self hideLoading];
    if (suc)
    {
        // 发送成功
        [self setInvitedPeople: self.invitedPeopleTextfield.text];
        [self updateInvitersControls: YES];
        [self updateErrorMsg: NO msg: nil];
        
        UIGetRedBagAlertView* getMoneyAlertView = [UIGetRedBagAlertView sharedInstance];
        [getMoneyAlertView setRMBString:[NSString stringWithFloatRoundToPrecision:2 precision:2 ignoreBackZeros:YES]];
        [getMoneyAlertView setLevel:3];
        [getMoneyAlertView setTitle:@"邀请码红包"];
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
            [self updateErrorMsg: YES msg: @"绑定邀请人失败"];
        }
        else
        {
            [self updateErrorMsg: YES msg: errMsg];
        }
    }
}

#pragma mark - Text Field Delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self.inputInviteTip setHidden:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSString* text = textField.text;
    NSUInteger n = text.length;
    if ( n == 0 ) {
        [self.inputInviteTip setHidden:NO];
    } else {
        [self.inputInviteTip setHidden:YES];
    }
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {  // return NO to not change text
    if ([@"\n" isEqualToString:string] ) {
        [_invitedPeopleTextfield resignFirstResponder];
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

@end
