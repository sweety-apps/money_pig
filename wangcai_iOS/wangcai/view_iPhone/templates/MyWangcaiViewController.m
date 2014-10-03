//
//  MyWangcaiViewController.m
//  wangcai
//
//  Created by Lee Justin on 14-2-15.
//  Copyright (c) 2014年 1528studio. All rights reserved.
//

#import "MyWangcaiViewController.h"
#import "MyWangcaiSkillCellViewController.h"
#import "LoginAndRegister.h"
#import "MobClick.h"
#import "PhoneValidationController.h"
#import "NSString+FloatFormat.h"


#define DOG_CELL_ADJUST_OFFSET_Y (30)

@interface MyWangcaiViewController ()
{
    NSArray* _iconImages;
    NSArray* _titleImages;
    NSArray* _descriptionImages;
    NSMutableArray* _isSkillLocks;
    NSInteger _currentlevel;
}

@end

@implementation MyWangcaiViewController

@synthesize tableView;
@synthesize dogImageView;
@synthesize jingyanView;
@synthesize jingyan2View;
@synthesize dengjiNumLabel;
@synthesize jiachengInfoLabel;
@synthesize bingphoneTipsView;
@synthesize dogCell;
@synthesize EXPLabel;
@synthesize dogcellContentView;

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
    
    _currentlevel = 1;
    _nDogHight = 0;
    _iconImages = [[NSArray arrayWithObjects:[UIImage imageNamed:@"mywangcai_cell_baifabaizhong"],[UIImage imageNamed:@"mywangcai_cell_xiongdibang"],[UIImage imageNamed:@"mywangcai_cell_dianshichengjin"], nil] retain];
    
    _titleImages = [[NSArray arrayWithObjects:[UIImage imageNamed:@"mywangcai_cell_baifabaizhong_title"],[UIImage imageNamed:@"mywangcai_cell_xiongdibang_title"],[UIImage imageNamed:@"mywangcai_cell_dianshichengjin_title"], nil] retain];
    
    _descriptionImages = [[NSArray arrayWithObjects:[UIImage imageNamed:@"mywangcai_cell_baifabaizhong_des"],[UIImage imageNamed:@"mywangcai_cell_xiongdibang_des"],[UIImage imageNamed:@"mywangcai_cell_dianshichengjin_des"], nil] retain];
    
    _isSkillLocks = [[NSMutableArray arrayWithArray:@[@YES,@YES,@YES]] retain];
    
    
    [self setLevel:[[LoginAndRegister sharedInstance] getUserLevel]];
    [self setEXP:[[LoginAndRegister sharedInstance] getCurrentExp]
    nextLevelEXP:[[LoginAndRegister sharedInstance] getNextLevelExp]
   withAnimation:YES];
    
    jingyan2View = [[UIImageView alloc] initWithFrame:self.jingyanView.frame];
    jingyan2View.image = jingyanView.image;
    jingyan2View.contentMode = jingyanView.contentMode;
    
    [self.dogCell.contentView addSubview:dogcellContentView];

    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(onLevelUp) name:kNotificationNameLevelUp object:nil];
}

- (void)onLevelUp
{
    [self setLevel:[[LoginAndRegister sharedInstance] getUserLevel]];
    [self setEXP:[[LoginAndRegister sharedInstance] getCurrentExp]
    nextLevelEXP:[[LoginAndRegister sharedInstance] getNextLevelExp]
   withAnimation:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self performSelector:@selector(moveContentViews) withObject:nil afterDelay:0.0];
    
    [self performSelector:@selector(adjustDogCell) withObject:nil afterDelay:0.0];
    [self hideBindTips:NO];
    
    [self setLevel:[[LoginAndRegister sharedInstance] getUserLevel]];
    [self setEXP:[[LoginAndRegister sharedInstance] getCurrentExp]
    nextLevelEXP:[[LoginAndRegister sharedInstance] getNextLevelExp]
   withAnimation:YES];
}

- (void)moveContentViews
{
    jiachengInfoLabel.hidden = NO;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self performSelector:@selector(onViewInit) withObject:nil afterDelay:0.1];
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
    
    [self playDogAnimation];
    [self setEXP:[[LoginAndRegister sharedInstance] getCurrentExp]
    nextLevelEXP:[[LoginAndRegister sharedInstance] getNextLevelExp]
   withAnimation:YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [tableView release];
    [dogImageView release];
    [jingyanView release];
    [dengjiNumLabel release];
    [jiachengInfoLabel release];
    [bingphoneTipsView release];
    [dogCell release];
    [_iconImages release];
    [_descriptionImages release];
    [_titleImages release];
    [_isSkillLocks release];
    [jingyan2View release];
    [EXPLabel release];
    [dogcellContentView release];
    [super dealloc];
}

- (void)setUIStack : (BeeUIStack*) beeStack {
    self->_beeStack = beeStack;
}

- (IBAction)onPressedBindPhone:(id)sender
{
    // 绑定手机
    [MobClick event:@"click_bind_phone" attributes:@{@"currentpage":@"我的赚钱小猪"}];
    PhoneValidationController* phoneVal = [PhoneValidationController shareInstance];
    [self->_beeStack pushViewController:phoneVal animated:YES];
}

- (IBAction)onPressedBack:(id)sender
{
    [[BeeUIRouter sharedInstance] open:@"wc_main" animated:YES];
}

- (void)showBindTips:(BOOL)animated;
{
    self.bingphoneTipsView.frame = CGRectMake(0, 5, self.bingphoneTipsView.frame.size.width, self.bingphoneTipsView.frame.size.height);
    
    void (^block)(void) = ^(){
        self.bingphoneTipsView.frame = CGRectMake(0, 52, self.bingphoneTipsView.frame.size.width, self.bingphoneTipsView.frame.size.height);
    };
    
    if (animated)
    {
        [UIView animateWithDuration:1.0 animations:block];
    }
    else
    {
        block();
    }
}

- (void)adjustDogCell
{
    CGRect rect = self.dogcellContentView.frame;
    if ([[[LoginAndRegister sharedInstance] getPhoneNum] length]> 0)
    {
        rect.origin = CGPointMake(0, -DOG_CELL_ADJUST_OFFSET_Y);
    }
    else
    {
        rect.origin = CGPointZero;
    }
    self.dogcellContentView.frame = rect;
    self.jiachengInfoLabel.frame = CGRectMake(132, 144, 163, 21);
    self.jiachengInfoLabel.textAlignment = NSTextAlignmentLeft;
    //[self.dogcellContentView setNeedsDisplay];
}

- (void)hideBindTips:(BOOL)animated;
{
    void (^block)(void) = ^(){
        self.bingphoneTipsView.frame = CGRectMake(0, 5, self.bingphoneTipsView.frame.size.width, self.bingphoneTipsView.frame.size.height);
    };
    
    if (animated)
    {
        [UIView animateWithDuration:1.0 animations:block];
    }
    else
    {
        block();
    }
}

- (void)playDogAnimation
{
    [self.dogImageView stopAnimating];
    
    NSMutableArray* imageArray = [NSMutableArray array];
    
    for (int i = 0; i < 14; ++i)
    {
        UIImage* image = [UIImage imageNamed:[NSString stringWithFormat:@"mywangcai_dog_%d",i+1]];
        [imageArray addObject:image];
    }
    
    self.dogImageView.animationImages = imageArray;
    self.dogImageView.animationDuration = 1.4;
    self.dogImageView.animationRepeatCount = 0;
    [self.dogImageView startAnimating];
}

- (void)setLevel:(int)level
{
    _currentlevel = level;
    
    int extraPlus = level;
    if ([[[LoginAndRegister sharedInstance] getPhoneNum] length]==0)
    {
        extraPlus = level;
    }
    
    self.dengjiNumLabel.text = [NSString stringWithFormat:@"%d",level];
    self.jiachengInfoLabel.text = [NSString stringWithFormat:@"可获得额外%d%@的红包",extraPlus,@"%"];
    self.jiachengInfoLabel.textAlignment = NSTextAlignmentLeft;
    
    
    [_isSkillLocks removeAllObjects];
    [_isSkillLocks addObjectsFromArray:@[@YES,@YES,@YES]];
    
    if (level >= 3)
    {
        [_isSkillLocks replaceObjectAtIndex:0 withObject:@NO];
    }
    
    if (level >= 5)
    {
        [_isSkillLocks replaceObjectAtIndex:1 withObject:@NO];
    }
    
    if (level >= 10)
    {
        [_isSkillLocks replaceObjectAtIndex:2 withObject:@NO];
    }
    
    [self.tableView reloadData];
}

- (void)setEXP:(float)EXP nextLevelEXP:(float)nextLevelEXP withAnimation:(BOOL)animated
{
    float ratio = 0.0f;
    if (nextLevelEXP > 0.0f)
    {
        ratio = EXP/nextLevelEXP;
    }
    
    float length = 138.f;
    
    length *= ratio;
    
    CGRect rectEXP = self.jingyanView.frame;
    rectEXP.size.width = 0.f;
    self.jingyan2View.frame = rectEXP;
    
    rectEXP.size.width = length;
    
    void (^block)(void) = ^(){
        self.jingyan2View.frame = rectEXP;
    };
    
    self.EXPLabel.text = [NSString stringWithFormat:@"￥%@ / ￥%@",[NSString stringWithFloatRoundToPrecision:EXP/100.f precision:2 ignoreBackZeros:YES],[NSString stringWithFloatRoundToPrecision:nextLevelEXP/100.f precision:2 ignoreBackZeros:YES]];
    
    if (animated)
    {
        [UIView animateWithDuration:0.3f animations:block];
    }
    else
    {
        block();
    }
}

#pragma mark <UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1+[_iconImages count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    UITableViewCell* cell = nil;
    if (row == 0)
    {
        cell = self.dogCell;
        [self adjustDogCell];
    }
    else
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"ContentCell"];
        if (cell == nil)
        {
            MyWangcaiSkillCellViewController* ctrl = [[[MyWangcaiSkillCellViewController alloc] initWithNibName:@"MyWangcaiSkillCellViewController" bundle:nil] autorelease];
            cell = ctrl.view;
        }
        
        MyWangcaiSkillCell* skillCell = (MyWangcaiSkillCell*)cell;
        skillCell.icon.image = [_iconImages objectAtIndex:row-1];
        skillCell.titleImg.image = [_titleImages objectAtIndex:row-1];
        skillCell.descriptionImg.image = [_descriptionImages objectAtIndex:row-1];
        
        skillCell.lockIcon.hidden = ![[_isSkillLocks objectAtIndex:row-1] boolValue];
    }
    
    return cell;
}

#pragma mark <UITableViewDelegate>

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    if (row == 0)
    {
        if ( _nDogHight == 0 ) {
            _nDogHight = self.dogCell.frame.size.height;
        }
        CGFloat height = _nDogHight;
        if ([[[LoginAndRegister sharedInstance] getPhoneNum] length]> 0)
        {
            height = height - DOG_CELL_ADJUST_OFFSET_Y;
        }
        return height;
    }
    else
    {
        return 80.f;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
