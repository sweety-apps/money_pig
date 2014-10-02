//
//  NibLoader.h
//  WechatLife
//
//  Created by graysonsun-nb.local on 5/14/14.
//  Copyright (c) 2014 quainli. All rights reserved.
//

#import <Foundation/Foundation.h>

#define CREATE_NIBVIEW(nibname) [NibLoader createViewWithName:(nibname)]
#define CREATE_NIBOBJECT(nibname) [NibLoader createNibWithName:(nibname)]

@interface NibLoader : NSObject

+(id)createViewWithName:(NSString*)nibname;
+(UINib*)createNibWithName:(NSString*)nibname;

@end
