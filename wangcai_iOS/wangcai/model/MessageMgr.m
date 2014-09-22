//
//  MessageMgr.m
//  wangcai
//
//  Created by NPHD on 14-5-10.
//  Copyright (c) 2014年 1528studio. All rights reserved.
//

#import "MessageMgr.h"

@implementation MessageMgr

static MessageMgr* _instance = nil;

+ (MessageMgr*) sharedInstance {
    if ( _instance == nil ) {
        _instance = [[MessageMgr alloc] init];
    }
    
    return _instance;
}

- (id) init {
    [super init];
    
    _nCurMaxID = 0; // 当前记录的最大值
    _nClickMaxID = 0; // 当前点击之后的最大值
    
    return self;
}

@end
