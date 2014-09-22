//
//  CommonYuENumView.m
//  wangcai
//
//  Created by Lee Justin on 13-12-13.
//  Copyright (c) 2013年 1528studio. All rights reserved.
//

#import "CommonYuENumView.h"

#define kStepInterval (0.05f)
#define kTimeLength (2.0f)
#define kMinStepNum (20)

@interface CommonYuENumView ()
{
    float _stepInterval;
}
@end

@implementation CommonYuENumView

- (void)initClassVars
{
    _digitDict = [[NSMutableDictionary dictionaryWithObjectsAndKeys:@"yue_0",@"0",@"yue_1",@"1",@"yue_2",@"2",@"yue_3",@"3",@"yue_4",@"4",@"yue_5",@"5",@"yue_6",@"6",@"yue_7",@"7",@"yue_8",@"8",@"yue_9",@"9",@"yue_dot",@".", nil] retain];
    _num = 0;
    _stepInterval = kStepInterval;
    _animaArray = [[NSMutableArray array] retain];
    self.backgroundColor = [UIColor clearColor];
}

- (id)init
{
    self = [super init];
    if (self) {
        [self initClassVars];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initClassVars];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initClassVars];
    }
    return self;
}

- (void)dealloc
{
    [_digitDict release];
    [_animaArray release];
    [super dealloc];
}

-(void)refreshView
{
    [self _refreshViewWithNum:_num];
}

-(void)_refreshViewWithNum:(float)num
{
    [self removeAllSubviews];
    NSString* numString = [NSString stringWithFormat:@"%.2f", 1.0*num/100];
    CGFloat offsetX = self.frame.size.width;
    for (int i = [numString length] - 1; i >= 0; i--)
    {
        NSRange range = {0};
        range.location = i;
        range.length = 1;
        NSString* digitKey = [numString substringWithRange:range];
        
        NSString* imageName = [_digitDict objectForKey:digitKey];
        UIImageView* imageView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]] autorelease];
        CGRect rect = imageView.frame;
        if ([digitKey isEqualToString:@"."])
        {
            offsetX -= rect.size.width*0.5;
            rect.origin.x = offsetX-rect.size.width*0.25;
        }
        else
        {
            offsetX -= rect.size.width;
            rect.origin.x = offsetX;
        }
        imageView.frame = rect;
        [self addSubview:imageView];
    }
}

- (void)animateStep
{
    if ([_animaArray count] > 0)
    {
        NSNumber* number = [_animaArray objectAtIndex:0];
        [self _refreshViewWithNum:[number floatValue]];
        [_animaArray removeObjectAtIndex:0];
        [NSTimer scheduledTimerWithTimeInterval:_stepInterval target:self selector:@selector(animateStep) userInfo:nil repeats:NO];
    }
}

-(void)setNum:(int)num
{
    [self setNum:num withAnimation:NO];
}

-(void)setNum:(int)num withAnimation:(BOOL)animated
{
    if (animated)
    {
        int count = abs((int)(num / 10.f) - (int)(_num / 10.f));
        if (count > 0)
        {
            float currentNum = _num;
            for (int i = 0; i < count; ++i)
            {
                if (num > _num)
                {
                    currentNum += 10;
                }
                else
                {
                    currentNum -= 10;
                }
                NSNumber* number = [NSNumber numberWithFloat:currentNum];
                [_animaArray addObject:number];
            }
        }
        if (count > kMinStepNum)
        {
            //抽调一些元素保证能够快速到达
            int left = count - kMinStepNum;
            NSMutableArray* newArray = [NSMutableArray array];
            int step = left / kMinStepNum;
            if ( step == 0 ) {
                step = 1;
            }
            for (int i = 0; i < left; ++i)
            {
                if (i % step == 0)
                {
                    [newArray addObject:[_animaArray objectAtIndex:i]];
                }
            }
            
            for (int i = left; i < [_animaArray count]; ++i)
            {
                [newArray addObject:[_animaArray objectAtIndex:i]];
            }
            [_animaArray removeAllObjects];
            [_animaArray addObjectsFromArray:newArray];
            _stepInterval = kTimeLength / ((float)[_animaArray count]);
        }
        _num = num;
        [NSTimer scheduledTimerWithTimeInterval:_stepInterval target:self selector:@selector(animateStep) userInfo:nil repeats:NO];
    }
    else
    {
        _num = num;
        [self refreshView];
    }
}

-(void)animateNumFrom:(int)oldNum to:(int)num withAnimation:(BOOL)animated
{
    [self setNum:oldNum];
    [self setNum:num withAnimation:animated];
}

-(int)getNum
{
    return _num;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
