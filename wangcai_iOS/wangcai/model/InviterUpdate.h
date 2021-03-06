//
//  InviterUpdate.h
//  wangcai
//
//  Created by Song on 13-12-29.
//  Copyright (c) 2013年 1528studio. All rights reserved.
//

#import "Bee.h"
#import "HttpRequest.h"

@protocol InviterUpdateDelegate <NSObject>

- (void)updateInviterCompleted: (BOOL) suc errMsg: (NSString *)errMsg;

@end

@interface InviterUpdate : NSObject <HttpRequestDelegate>
{
    id _updateDelegate;
}

AS_SINGLETON(InviterUpdate)

-(id) init;

- (void) updateInviter: (NSString*)inviter delegate: (id) del;

@end
