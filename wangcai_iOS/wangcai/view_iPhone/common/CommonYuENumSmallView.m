//
//  CommonYuENumSmallView.m
//  wangcai
//
//  Created by Lee Justin on 14-10-1.
//  Copyright (c) 2014年 1528studio. All rights reserved.
//

#import "CommonYuENumSmallView.h"

@implementation CommonYuENumSmallView

- (void)initClassVars
{
    [super initClassVars];
    [_digitDict release];
    _digitDict = [[NSMutableDictionary dictionaryWithObjectsAndKeys:@"yue_s_0",@"0",@"yue_s_1",@"1",@"yue_s_2",@"2",@"yue_s_3",@"3",@"yue_s_4",@"4",@"yue_s_5",@"5",@"yue_s_6",@"6",@"yue_s_7",@"7",@"yue_s_8",@"8",@"yue_s_9",@"9",@"yue_s_dot",@".", nil] retain];
}

@end
