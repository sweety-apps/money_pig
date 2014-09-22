//
//  MessageMgr.h
//  wangcai
//
//  Created by NPHD on 14-5-10.
//  Copyright (c) 2014年 1528studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageMgr : NSObject {
    int _nCurMaxID;
    int _nClickMaxID;
}

+ (MessageMgr*) sharedInstance;

@end
