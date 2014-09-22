//
//  ChoujiangViewController.m
//  wangcai
//
//  Created by Lee Justin on 13-12-30.
//  Copyright (c) 2013年 1528studio. All rights reserved.
//

#import "ChoujiangViewController.h"
#import "ChoujiangLogic.h"
#import "MBHUDView.h"
#import "SettingLocalRecords.h"
#import "MobClick.h"
#import <ShareSDK/ShareSDK.h>
#import "UIGetRedBagAlertView.h"
#import "NSString+FloatFormat.h"
#import "BaseTaskTableViewController.h"
#import "Config.h"

@interface ChoiceMoveNode : NSObject

@property (nonatomic,assign) float timeSec;
@property (nonatomic,assign) int fromIndex;
@property (nonatomic,assign) int toIndex;

@end

@implementation ChoiceMoveNode

@end


@interface ChoujiangViewController () <ChoujiangLogicDelegate,UIGetRedBagAlertViewDelegate> {
    NSArray* _choiceViews;
    int _beilv;
    NSMutableArray* _animaNodes;
    int _shineCount;
    int _choiceIndex;
}

@end

@implementation ChoujiangViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _choiceViews = [[NSArray arrayWithObjects:self.choice0,self.choice1,self.choice2,self.choice3,self.choice4,self.choice5,self.choice6,self.choice7,self.choice8,self.choice9,self.choice10,self.choice11, nil] retain];
    _beilv = 1;
    _share = NO;
    
    if ([SettingLocalRecords hasCheckInRecent2Days])
    {
        _beilv += 2;
    }
    else if([SettingLocalRecords hasCheckInYesterday])
    {
        _beilv += 1;
    }
    
    if ([SettingLocalRecords hasShareInRecent2Days])
    {
        _beilv += 2;
    }
    else if ([SettingLocalRecords hasShareToday])
    {
        _beilv += 1;
    }
    
    if (_beilv > 3)
    {
        _beilv = 3;
    }
    
    self.choiceBorder.hidden = YES;
    self.choiceCover.hidden = YES;
    
    [self resetViews];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.infoImage = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"choujiang_guize"]] autorelease];
    self.cloudImage = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"choujiang_bottom_cloud"]] autorelease];
    
    [self.backButton.superview insertSubview:self.cloudImage aboveSubview:self.backButton];
    [self.backButton.superview insertSubview:self.infoImage aboveSubview:self.cloudImage];
    
    CGFloat screenHeight = [[UIApplication sharedApplication] keyWindow].frame.size.height;
    
    CGRect rect = self.cloudImage.frame;
    rect.origin.y = screenHeight - rect.size.height;
    self.cloudImage.frame = rect;
    
    rect = self.infoImage.frame;
    rect.origin.y = screenHeight - rect.size.height;
    self.infoImage.frame = rect;
}

- (void)dealloc
{
    [_choiceViews release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setBeiLv:(int)beilvNum
{
    _beilv = beilvNum;
}

- (int)getBeiLv
{
    return _beilv;
}

- (IBAction)onPressedStartButton:(id)sender
{
#if 0
    int target = [self _getRandomIndexWithResultcode:kGetAwardType1Mao];
    [self startChoiceAnimations:target];
#else
    if ([[ChoujiangLogic sharedInstance] getAwardCode] == kGetAwardTypeNotGet)
    {
        self.startButton.enabled = NO;
        [MBHUDView hudWithBody:@"" type:MBAlertViewHUDTypeActivityIndicator hidesAfter:10000000000.f show:YES];
        [[ChoujiangLogic sharedInstance] requestChoujiang:self];
    }
    else
    {
        UIAlertView* alert = [[[UIAlertView alloc] initWithTitle:@"提示" message:@"今天已经签到过了，明天记得来哟" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil] autorelease];
        [alert show];
    }
#endif
}



- (IBAction)onPressedBackButton:(id)sender
{
    [self.stack popViewControllerAnimated:YES];
}

- (void)resetViews
{
    //倍率
    NSString* beilvs[3] = {@"choujiang_x1",@"choujiang_x2",@"choujiang_x3"};
    if (_beilv > 0)
    {
        beilvs[_beilv-1]= [beilvs[_beilv - 1] stringByAppendingString:@"selected"];
    }
    self.beilv1x.image = [UIImage imageNamed:beilvs[0]];
    self.beilv2x.image = [UIImage imageNamed:beilvs[1]];
    self.beilv3x.image = [UIImage imageNamed:beilvs[2]];
    
    //奖项
    NSString* jiangxiang[12] = {
        @"choujiang_5mao",  //0
        @"choujiang_thanks1",   //1
        @"choujiang_1mao",  //2
        @"choujiang_thanks4",   //3
        @"choujiang_8yuan", //4
        @"choujiang_thanks2",   //5
        @"choujiang_1mao",  //6
        @"choujiang_3yuan", //7
        @"choujiang_thanks3",   //8
        @"choujiang_5mao",  //9
        @"choujiang_1mao",  //10
        @"choujiang_thanks4"    //11
    };
    
    for (int i = 0; i < [_choiceViews count]; ++i)
    {
        UIImageView* choiceView = [_choiceViews objectAtIndex:i];
        choiceView.image = [UIImage imageNamed:jiangxiang[i]];
    }
}

- (void)startChoiceAnimations:(int)targetNum
{
    if (!_hasStarted)
    {
        _hasStarted = YES;
        _choiceIndex = targetNum;
        srand(time(NULL));
        int round = rand()%2;
        round += 2;
        
        float startInterval = 0.05f;
        float endInterval = 0.25f;
        
        NSMutableArray* animaNodes = [NSMutableArray array];
        
#define startRounds (2)
        
        for (int i = 0; i < startRounds; ++i)
        {
            for (int j = 0; j < [_choiceViews count]; ++j)
            {
                ChoiceMoveNode* node = [[[ChoiceMoveNode alloc] init] autorelease];
                node.timeSec = startInterval;
                node.fromIndex = j % [_choiceViews count];
                node.toIndex = (j+1) % [_choiceViews count];
                [animaNodes addObject:node];
            }
        }
        
        round -= startRounds;
        
        int  moveSteps = round * [_choiceViews count] + targetNum;
        float increaseStep = (endInterval - startInterval) / ((float)moveSteps);
        float currentInterval = startInterval;
        for (int i = 0; i < moveSteps; ++i)
        {
            ChoiceMoveNode* node = [[[ChoiceMoveNode alloc] init] autorelease];
            node.timeSec = currentInterval;
            node.fromIndex = i % [_choiceViews count];
            node.toIndex = (i+1) % [_choiceViews count];
            [animaNodes addObject:node];
            
            currentInterval += increaseStep;
        }
        
        if (_animaNodes)
        {
            [_animaNodes release];
            _animaNodes = nil;
        }
        _animaNodes = [animaNodes retain];
        
        [NSTimer scheduledTimerWithTimeInterval:0.5f target:self selector:@selector(onAnimaNodeStep) userInfo:nil repeats:NO];
    }
}

- (void)onAnimaNodeStep
{
    if ([_animaNodes count]>0)
    {
        ChoiceMoveNode* node = [[_animaNodes objectAtIndex:0] retain];
        self.choiceBorder.hidden = YES;
        self.choiceCover.hidden = NO;
        
        CGRect rectChoiceIndex = ((UIImageView*)[_choiceViews objectAtIndex:node.toIndex]).frame;
        self.choiceCover.frame = rectChoiceIndex;
        
        [_animaNodes removeObjectAtIndex:0];
        
        [NSTimer scheduledTimerWithTimeInterval:node.timeSec target:self selector:@selector(onAnimaNodeStep) userInfo:nil repeats:NO];
        
        [node release];
    }
    else if ([_animaNodes count] == 0)
    {
        [self onFinishedAnima];
    }
}

- (void)onFinishedAnima
{
    self.choiceCover.hidden = YES;
    self.choiceBorder.hidden = NO;
    
    CGRect rect = self.choiceCover.frame;
    rect.origin.x -= 4;
    rect.origin.y -= 4;
    rect.size.width = self.choiceBorder.frame.size.width;
    rect.size.height = self.choiceBorder.frame.size.height;
    self.choiceBorder.frame = rect;
    _shineCount = 4;
    
    [self onShineBlock0];
}

- (void)onShineBlock0
{
    if (_shineCount > 0)
    {
        self.choiceBorder.image = [UIImage imageNamed:@"choujiang_border_selected1"];
        _shineCount --;
        [NSTimer scheduledTimerWithTimeInterval:0.15 target:self selector:@selector(onShineBlock1) userInfo:nil repeats:NO];
    }
    else
    {
        [self onFinishedChoice];
    }
}

- (void)onShineBlock1
{
    self.choiceBorder.image = [UIImage imageNamed:@"choujiang_border_selected2"];
    [NSTimer scheduledTimerWithTimeInterval:0.15 target:self selector:@selector(onShineBlock0) userInfo:nil repeats:NO];
}

- (void)onFinishedChoice
{
    NSString* title = @"";
    NSString* msg = @"";
    int income = 0;
    int old_balance = [[LoginAndRegister sharedInstance] getBalance];
    
    _share = NO;
    switch (_choiceIndex)
    {
        case 1:
        case 3:
        case 5:
        case 8:
        case 11:
            //没中
            title = @"旺财你不给力啊:(";
            msg = @"两手空空";
            break;
        case 2:
        case 6:
        case 10:
            //1毛
            title = @"获得签到红包";
            msg = @"1毛";
            income = 10;
            //加钱
            [[LoginAndRegister sharedInstance] increaseBalance:10];
            //统计
            [MobClick event:@"money_get_from_all" attributes:@{@"RMB":[NSString stringWithFormat:@"%d",10],@"FROM":@"签到"}];
            break;
        case 0:
        case 9:
            //5毛
            title = @"获得签到红包";
            msg = @"5毛";
            income = 50;
            //加钱
            [[LoginAndRegister sharedInstance] increaseBalance:50];
            //统计
            [MobClick event:@"money_get_from_all" attributes:@{@"RMB":[NSString stringWithFormat:@"%d",50],@"FROM":@"签到"}];
            break;
        case 7:
            //3元
            title = @"获得签到红包";
            msg = @"3元";
            _share = YES;
            income = 300;
            //加钱
            [[LoginAndRegister sharedInstance] increaseBalance:300];
            //统计
            [MobClick event:@"money_get_from_all" attributes:@{@"RMB":[NSString stringWithFormat:@"%d",300],@"FROM":@"签到"}];
            break;
        case 4:
            //8元
            title = @"获得签到红包";
            msg = @"8元";
            income = 800;
            _share = YES;
            //加钱
            [[LoginAndRegister sharedInstance] increaseBalance:800];
            //统计
            [MobClick event:@"money_get_from_all" attributes:@{@"RMB":[NSString stringWithFormat:@"%d",800],@"FROM":@"签到"}];
            break;
            
        default:
            break;
    }
    
    _income = income;
    if (income > 0)
    {
        UIGetRedBagAlertView* getMoneyAlertView = [UIGetRedBagAlertView sharedInstance];
        [getMoneyAlertView setRMBString:[NSString stringWithFloatRoundToPrecision:((float)income)/100.f precision:2 ignoreBackZeros:YES]];
        [getMoneyAlertView setLevel:3];
        [getMoneyAlertView setTitle:title];
        [getMoneyAlertView setDelegate:self];
        [getMoneyAlertView setShowCurrentBanlance:old_balance andIncrease:income];
        [getMoneyAlertView show];
    }
    else
    {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:title message:msg delegate:self cancelButtonTitle:@"返回" otherButtonTitles:/*@"分享",*/ nil];
        
        [alertView show];
    }
}

- (int)_getRandomIndexWithResultcode:(GetAwardType)awardCode
{
    int target = 0;
    switch (awardCode)
    {
        case kGetAwardTypeNothing:
        {
            int indexs[5] = {1,3,5,8,11};
            srand(time(NULL));
            target = indexs[rand()%5];
        }
            break;
        case kGetAwardType1Mao:
        {
            int indexs[3] = {2,6,10};
            srand(time(NULL));
            target = indexs[rand()%3];
        }
            break;
        case kGetAwardType5Mao:
        {
            int indexs[2] = {0,9};
            srand(time(NULL));
            target = indexs[rand()%2];
        }
            break;
        case kGetAwardType3Yuan:
        {
            int indexs[1] = {7};
            srand(time(NULL));
            target = indexs[rand()%1];
        }
            break;
        case kGetAwardType8Yuan:
        {
            int indexs[1] = {4};
            srand(time(NULL));
            target = indexs[rand()%1];
        }
            break;
            
        default:
            break;
    }
    
    return target;
}

#pragma mark - <UIGetRedBagAlertViewDelegate>

- (void)onPressedCloseUIGetRedBagAlertView:(UIGetRedBagAlertView*)alertView
{
    //返回
#if 0
    if ([[LoginAndRegister sharedInstance] getUserLevel]>=5)
    {
        //双抽的话再拉下任务更新状态
        [BaseTaskTableViewController setNeedReloadTaskList];
    }
#endif
    
    if ( _share ) {
        [BaseTaskTableViewController setNeedShowChoujiangShare:_income];
        _share = NO;
    }
    
    [self onPressedBackButton:self.backButton];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
}

- (void)onPressedGetRmbUIGetRedBagAlertView:(UIGetRedBagAlertView*)alertView
{
    //返回
#if 0
    if ([[LoginAndRegister sharedInstance] getUserLevel]>=5)
    {
        //双抽的话再拉下任务更新状态
        [BaseTaskTableViewController setNeedReloadTaskList];
    }
#endif

    if ( _share ) {
        [BaseTaskTableViewController setNeedShowChoujiangShare:_income];
        _share = NO;
    }
    
    [self onPressedBackButton:self.backButton];
}

#pragma mark - <UIAlertViewDelegate>

#pragma mark - <ChoujiangLogicDelegate>

- (void)onFinishedChoujiangRequest:(ChoujiangLogic*)logic isRequestSucceed:(BOOL)isSucceed awardCode:(GetAwardType)awardCode resultCode:(NSInteger)result msg:(NSString*)msg
{
    [MBHUDView dismissCurrentHUD];
    if (isSucceed)
    {
/*
#if TEST == 1
        result = 0;
#endif
*/
        if (result == 0)
        {
            [SettingLocalRecords saveLastCheckInDateTime:[NSDate date]];
/*
#if TEST == 1
            awardCode = kGetAwardType8Yuan;
#endif
*/

            if (awardCode == kGetAwardTypeAlreadyGot)
            {
                UIAlertView* alert = [[[UIAlertView alloc] initWithTitle:@"提示" message:@"今天已经签到过了，明天记得来哟" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil] autorelease];
                [alert show];
            }
            else
            {
                //统计
                NSString* value = @"kGetAwardTypeNothing";
                switch (awardCode)
                {
                    case kGetAwardTypeNothing:
                        value = @"无";
                        break;
                    case kGetAwardType1Mao:
                        value = @"1毛";
                        break;
                    case kGetAwardType5Mao:
                        value = @"5毛";
                        break;
                    case kGetAwardType3Yuan:
                        value = @"3元";
                        break;
                    case kGetAwardType8Yuan:
                        value = @"8元";
                        break;
                    default:
                        break;
                }
                
                [MobClick event:@"daily_checkin" attributes:@{@"code":[NSString stringWithFormat:@"%d",awardCode],@"money":value}];
                
                int target = [self _getRandomIndexWithResultcode:awardCode];
                [self startChoiceAnimations:target];
            }
        }
        else
        {
            [SettingLocalRecords saveLastCheckInDateTime:[NSDate date]];
            UIAlertView* alert = [[[UIAlertView alloc] initWithTitle:@"请求失败" message:msg delegate:self cancelButtonTitle:@"返回" otherButtonTitles:nil] autorelease];
            [alert show];
        }
    }
    else
    {
        UIAlertView* alert = [[[UIAlertView alloc] initWithTitle:@"提示" message:@"当前网络不可用，请检查网络连接" delegate:nil cancelButtonTitle:@"重试" otherButtonTitles:nil, nil] autorelease];
        [alert show];
    }
}

@end
