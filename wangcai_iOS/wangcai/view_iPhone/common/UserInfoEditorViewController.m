//
//  UserInfoEditorViewController.m
//  wangcai
//
//  Created by Lee Justin on 13-12-21.
//  Copyright (c) 2013年 1528studio. All rights reserved.
//

#import "UserInfoEditorViewController.h"
#import "PhoneValidationController.h"
#import "UserInfoAPI.h"
#import "MBHUDView.h"
#import "CommonTaskList.h"
#import "BaseTaskTableViewController.h"
#import "MobClick.h"
#import "UIGetRedBagAlertView.h"
#import "NSString+FloatFormat.h"

@interface UserInfoEditorViewController () <UserInfoAPIDelegate,UIGetRedBagAlertViewDelegate>
{
    UILabel* _labelAgeSelected;
    UIView* _selectorView;
    BOOL _shouldAddMoney;
}

@end

@implementation UserInfoEditorViewController

@synthesize upSectionView;
@synthesize downSectionView;
@synthesize scrollView;

@synthesize ageSelectorView;

@synthesize hobbySelectorViews;

@synthesize commitButtonView;
@synthesize commitButton;
@synthesize commitButtonRedBag;

@synthesize bindPhoneView;

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
    self.ageSelectorView.backgroundColor = [UIColor clearColor];
    self.ageSelectorView.horizontalScrolling = YES;
    
    _rectSelectBgView = CGRectMake(110, 3, 37, 43);
    CGRect rect = CGRectOffset(_rectSelectBgView, self.ageSelectorView.frame.origin.x, self.ageSelectorView.frame.origin.y);
    UIImageView* selectorView = [[[UIImageView alloc] initWithFrame:rect] autorelease];
    selectorView.contentMode = UIViewContentModeCenter;
    selectorView.clipsToBounds = NO;
    selectorView.image = [UIImage imageNamed:@"user_sex_selected"];
    //[[self.ageSelectorView superview] insertSubview:selectorView belowSubview:self.ageSelectorView];
    
    [MBHUDView hudWithBody:@"" type:MBAlertViewHUDTypeActivityIndicator hidesAfter:10000000000.f show:YES];
    
    [self buildSelectorViews];
    
    [self performSelector:@selector(_doAgeInitSelections) withObject:nil afterDelay:0.05];
    
}

-(void)_doAgeInitSelections
{
    //[self.ageSelectorView selectItemAtIndex:17 animated:NO];
    [self _doSelectAgeAtIndex:21];
    //[self selectSex:YES];
    
    [[UserInfoAPI loginedUserInfo] fetchUserInfo:self];
}

- (void)_doSelectAgeAtIndex:(NSInteger)index
{
    if (index < 0)
    {
        _selectorView.alpha = 0.0f;
    }
    else
    {
        [self.ageSelectorView selectItemAtIndex:index animated:NO];
        _selectorView.alpha = 1.0f;
    }
}

- (void)buildSelectorViews
{
    self.hobbySelectorViews = [NSMutableArray array];
    
    NSArray* selectorTexts = [NSArray arrayWithObjects:@"休闲游戏",@"升级打宝",@"打折促销",@"结交朋友",@"旅行生活",@"竞技游戏",@"强身健体",@"美丽达人", nil];
    
    _interestIds = [[NSMutableArray arrayWithObjects:@"leisure_game",@"level_up",@"discount",@"friends",@"trevel",@"compete_game",@"physic_ex",@"beauty", nil] retain];
    
    CGRect rect = CGRectMake(15, 0, 140, 36);
    CGFloat maxY = 30.f;
    for (int i = 0; i < [selectorTexts count]; ++i)
    {
        NSString* selectText = [selectorTexts objectAtIndex:i];
        
        if (i%2 == 1)
        {
            rect.origin.x = CGRectGetMaxX(rect)+4;
        }
        else
        {
            rect.origin.x = 17;
            rect.origin.y = CGRectGetMaxY(rect)+5;
        }
        
        if (CGRectGetMaxY(rect) > maxY)
        {
            maxY = CGRectGetMaxY(rect);
        }
        
        UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = rect;
        
        [btn setBackgroundImage:[UIImage imageNamed:@"user_hobby_normal"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"user_hobby_selected"] forState:UIControlStateHighlighted];
        [btn setBackgroundImage:[UIImage imageNamed:@"user_hobby_selected"] forState:UIControlStateSelected];

        [btn setTitle:selectText forState:UIControlStateNormal];
        
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        
        [btn addTarget:self action:@selector(onPressedHobbySelect:) forControlEvents:UIControlEventTouchDown];
        
        [self.selectionContainerView addSubview:btn];
        [self.hobbySelectorViews addObject:btn];
    }
    
    maxY += 10.f;
    
    CGRect rectCommitButton = self.commitButtonView.frame;
    rectCommitButton.origin.y = self.selectionContainerView.frame.origin.y + maxY;
    self.commitButtonView.frame = rectCommitButton;
    
    maxY += self.commitButtonView.frame.size.height;
    
    maxY += 10.f;
    
    CGSize scrollViewSize = CGSizeMake(320, self.upSectionView.frame.size.height + self.selectionContainerView.frame.origin.y + maxY);
    
    self.scrollView.contentSize = scrollViewSize;
    
    CGRect rectDownSection = self.downSectionView.frame;
    rectDownSection.size.height = self.selectionContainerView.frame.origin.y + maxY;
    self.downSectionView.frame = rectDownSection;
    
    
    if ([[CommonTaskList sharedInstance] containsUnfinishedUserInfoTask])
    {
        [self.commitButton setTitle:@"确认并领取1元" forState:UIControlStateNormal];
    }
    else
    {
        [self.commitButton setTitle:@"确认" forState:UIControlStateNormal];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self hideNavigationBarAnimated:NO];
    [self resetContent];
}

- (void)resetContent
{
    CGRect rect = self.upSectionView.frame;
    NSString* phoneNum = [[LoginAndRegister sharedInstance] getPhoneNum];
    
    if (NO/* phoneNum == nil || [phoneNum isEqualToString:@""] */) {
        self.bindPhoneView.hidden = NO;
        
        CGFloat Y = 0;
        
        rect = self.upSectionView.frame;
        rect.origin.y = Y;
        
        self.upSectionView.frame = rect;
        Y = CGRectGetMaxY(self.upSectionView.frame);
        
        rect = self.downSectionView.frame;
        rect.origin.y = Y;
        
        self.downSectionView.frame = rect;
    } else {
        self.bindPhoneView.hidden = YES;
        
        CGFloat Y = 0;//-CGRectGetHeight(self.bindPhoneView.frame);
        
        rect = self.upSectionView.frame;
        rect.origin.y = Y;
        
        self.upSectionView.frame = rect;
        Y = CGRectGetMaxY(self.upSectionView.frame);
        
        rect = self.downSectionView.frame;
        rect.origin.y = Y;
        
        self.downSectionView.frame = rect;
    }
}


- (void)showUpSectionView:(BOOL)shouldShow
{
    
}

- (void)dealloc
{
    self.upSectionView = nil;
    self.downSectionView = nil;
    self.scrollView = nil;
    
    self.ageSelectorView = nil;
    self.selectionContainerView = nil;
    
    self.sexFamaleButton = nil;
    self.sexMaleButton = nil;
    self.hobbySelectorViews = nil;
    
    self.commitButtonView = nil;
    self.commitButtonRedBag = nil;
    
    [_interestIds release];
    
    [super dealloc];
}

- (IBAction)onPressedAttachPhone:(id)btn
{
    if (self.stack)
    {
        // 绑定手机
        [MobClick event:@"click_bind_phone" attributes:@{@"currentpage":@"用户详情页"}];
        
        PhoneValidationController* phoneVal = [PhoneValidationController shareInstance];
        
        [self.stack pushViewController:phoneVal animated:YES];
    }
}

- (IBAction)onPressedBackPhone:(id)btn
{
    if (self.stack)
    {
        [self.stack popBoardAnimated:YES];
    }
}

- (IBAction)onPressedMaleButton:(id)btn
{
    [self selectSex:YES];
}

- (IBAction)onPressedFamaleButton:(id)btn
{
    [self selectSex:NO];
}

- (IBAction)onPressedCommitButton:(id)btn
{
    BOOL isInfoValide = YES;
    
    NSString* errTitle = @"";
    NSString* errContent = @"";
    
    BOOL interestSelected = NO;
    for (UIButton* btn in self.hobbySelectorViews)
    {
        if (btn.selected)
        {
            interestSelected = YES;
            break;
        }
    }
    if (!interestSelected)
    {
        errTitle = @"请选择至少一个兴趣";
        errContent = @"";
        isInfoValide = NO;
    }
    
    if (_selectorView.alpha < 0.1f)
    {
        errTitle = @"请选择年龄";
        errContent = @"";
        isInfoValide = NO;
    }
    
    if (!self.sexMaleButton.selected && !self.sexFamaleButton.selected)
    {
        errTitle = @"请选择性别";
        errContent = @"";
        isInfoValide = NO;
    }
    
    if (isInfoValide)
    {
        if (self.sexMaleButton.selected)
        {
            [UserInfoAPI loginedUserInfo].uiSex = [NSNumber numberWithInt:kUserSexMale];
        }
        else
        {
            [UserInfoAPI loginedUserInfo].uiSex = [NSNumber numberWithInt:kUserSexFemale];
        }
        
        [UserInfoAPI loginedUserInfo].uiAge = [NSNumber numberWithInt:[self.ageSelectorView currentSelectedIndex] + 1];
        
        [UserInfoAPI loginedUserInfo].uiInterest = @"";
        for (int i = 0; i < [hobbySelectorViews count]; ++i)
        {
            UIButton* btn = [hobbySelectorViews objectAtIndex:i];
            if (btn.selected)
            {
                [[UserInfoAPI loginedUserInfo] addInterest:[_interestIds objectAtIndex:i]];
            }
        }
        
        [[UserInfoAPI loginedUserInfo] updateUserInfo:self];
        
        self.commitButton.enabled = NO;
    }
    else
    {
        UIAlertView* alert = [[[UIAlertView alloc] initWithTitle:errTitle message:errContent delegate:nil cancelButtonTitle:@"重试" otherButtonTitles:nil] autorelease];
        [alert show];
    }
    
}

- (void)selectSex:(BOOL)isMale
{
    if (isMale)
    {
        self.sexMaleButton.selected = YES;
        self.sexFamaleButton.selected = NO;
    }
    else
    {
        self.sexMaleButton.selected = NO;
        self.sexFamaleButton.selected = YES;
    }
}

- (void)selectInterestsWithUserInfo:(UserInfoAPI*)userInfo
{
    NSArray* Interests = [userInfo getInterests];
    for (UIButton* btn in self.hobbySelectorViews)
    {
        btn.selected = NO;
    }
    for (int i = 0; i < [Interests count]; ++i)
    {
        NSString* interest = [Interests objectAtIndex:i];
        for (int j = 0; j < [_interestIds count]; ++j)
        {
            if ([interest isEqualToString:[_interestIds objectAtIndex:j]])
            {
                UIButton* btn = [self.hobbySelectorViews objectAtIndex:j];
                btn.selected = YES;
            }
        }
    }
}

- (void)onPressedHobbySelect:(UIButton*)hobbyButton
{
    if (!hobbyButton.selected)
    {
        hobbyButton.selected = YES;
    }
    else
    {
        hobbyButton.selected = NO;
    }
}

#pragma IZValueSelector dataSource
- (NSInteger)numberOfRowsInSelector:(IZValueSelectorView *)valueSelector {
    return 99;
}



//ONLY ONE OF THESE WILL GET CALLED (DEPENDING ON the horizontalScrolling property Value)
- (CGFloat)rowHeightInSelector:(IZValueSelectorView *)valueSelector {
    return 43;
}

- (CGFloat)rowWidthInSelector:(IZValueSelectorView *)valueSelector {
    return 37;
}


- (UIView *)selector:(IZValueSelectorView *)valueSelector viewForRowAtIndex:(NSInteger)index {
    UILabel * label = nil;
    label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 37, self.ageSelectorView.frame.size.height)];
    label.text = [NSString stringWithFormat:@"%d",index+1];
    label.textAlignment =  NSTextAlignmentCenter;
    label.textColor = RGB(156, 156, 156);
    label.font = [UIFont systemFontOfSize:18];
    label.backgroundColor = [UIColor clearColor];
    return label;
}

- (UIView*)selectorViewForSelectorView:(IZValueSelectorView *)valueSelector
{
    UIImageView* selectorView = [[[UIImageView alloc] initWithFrame:_rectSelectBgView] autorelease];
    selectorView.contentMode = UIViewContentModeCenter;
    selectorView.clipsToBounds = NO;
    selectorView.image = [UIImage imageNamed:@"user_sex_selected"];
    
    UILabel * label = nil;
    label = [[UILabel alloc] initWithFrame:CGRectMake(0, -3, 37, self.ageSelectorView.frame.size.height)];
    label.text = @"";
    label.textAlignment =  NSTextAlignmentCenter;
    label.textColor = RGB(255, 255, 255);
    label.font = [UIFont systemFontOfSize:18];
    label.backgroundColor = [UIColor clearColor];
    [selectorView addSubview:label];
    _labelAgeSelected = label;
    _selectorView = selectorView;
    //_selectorView.alpha = 0.0f;
    _selectorView.alpha = 1.0f;
    
    return selectorView;
}

#pragma IZValueSelector delegate
- (void)selector:(IZValueSelectorView *)valueSelector didSelectRowAtIndex:(NSInteger)index {
    _labelAgeSelected.text = [NSString stringWithFormat:@"%d",index+1];
    NSLog(@"Selected index %d",index);
}

- (void)selector:(IZValueSelectorView *)valueSelector selectorPassRowAtIndex:(NSInteger)index
{
    _labelAgeSelected.text = [NSString stringWithFormat:@"%d",index+1];
    if (_selectorView.alpha < 0.1f)
    {
        [UIView animateWithDuration:0.3 animations:^(){_selectorView.alpha = 1.0f;} completion:^(BOOL finished){}];
    }
    
    //NSLog(@"Pass-over index %d",index);
}

#pragma mark <UserInfoAPIDelegate>

- (void)onFinishedFetchUserInfo:(UserInfoAPI*)userInfo isSucceed:(BOOL)succeed
{
    [MBHUDView dismissCurrentHUD];
    if (succeed)
    {
        if (userInfo.uiSex)
        {
            if ([userInfo.uiSex intValue] == kUserSexMale)
            {
                [self selectSex:YES];
            }
            else if([userInfo.uiSex intValue] == kUserSexFemale)
            {
                [self selectSex:NO];
            }
        }
        int ageIndex = [userInfo.uiAge intValue] - 1;
        if (ageIndex < 0)
        {
            ageIndex = 21;
        }
        [self _doSelectAgeAtIndex:ageIndex];
        [self selectInterestsWithUserInfo:userInfo];
        
        if ([userInfo.uiAge intValue] <= 0)
        {
            [self.commitButton setTitle:@"确认并领取1元" forState:UIControlStateNormal];
            _shouldAddMoney = YES;
        }
        else
        {
            [self.commitButton setTitle:@"确认" forState:UIControlStateNormal];
        }
    }
    else
    {
        [MBHUDView hudWithBody:@":(\n用户信息获取失败" type:MBAlertViewHUDTypeImagePositive  hidesAfter:2.0 show:YES];
        [self.commitButton setTitle:@"确认" forState:UIControlStateNormal];
    }
}

- (void)onFinishedUpdateUserInfo:(UserInfoAPI*)userInfo isSucceed:(BOOL)succeed
{
    self.commitButton.enabled = YES;
    if (succeed)
    {
        [BaseTaskTableViewController setNeedReloadTaskList];
        //[MBHUDView hudWithBody:@"用户信息提交成功！" type:MBAlertViewHUDTypeCheckmark  hidesAfter:2.0 show:YES];
        // 给用户加一块钱
        if (_shouldAddMoney)
        {
            NSString* strIncome = [NSString stringWithFloatRoundToPrecision:1.f precision:2 ignoreBackZeros:YES];
            UIGetRedBagAlertView* getMoneyAlertView = [UIGetRedBagAlertView sharedInstance];
            [getMoneyAlertView setRMBString:strIncome];
            [getMoneyAlertView setLevel:3];
            [getMoneyAlertView setDelegate:self];
            [getMoneyAlertView setTitle:@"获得问卷红包"];
            [getMoneyAlertView setShowCurrentBanlance:[[LoginAndRegister sharedInstance] getBalance] andIncrease:100];
            [getMoneyAlertView show];
            //统计
            [MobClick event:@"money_get_from_all" attributes:@{@"RMB":@"100",@"FROM":@"填写用户信息"}];
            [[LoginAndRegister sharedInstance] increaseBalance:100];
        }
        else
        {
            [self onPressedBackPhone:nil];
        }
    }
    else
    {
        [MBHUDView hudWithBody:@":(\n用户信息提交失败" type:MBAlertViewHUDTypeImagePositive  hidesAfter:2.0 show:YES];
    }
}

#pragma mark - <UIGetRedBagAlertViewDelegate>

- (void)onPressedCloseUIGetRedBagAlertView:(UIGetRedBagAlertView*)alertView
{
    [self onPressedBackPhone:nil];
}

- (void)onPressedGetRmbUIGetRedBagAlertView:(UIGetRedBagAlertView*)alertView
{
    [self onPressedBackPhone:nil];
}

@end
