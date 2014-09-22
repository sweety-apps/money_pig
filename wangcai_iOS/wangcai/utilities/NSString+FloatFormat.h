//
//  NSString+FloatFormat.h
//  wangcai
//
//  Created by Lee Justin on 13-12-27.
//  Copyright (c) 2013年 1528studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (FloatFormat)

+ (NSString*) stringWithFloatRoundToPrecision:(float)num precision:(int)precision ignoreBackZeros:(BOOL)ignoreBackZeros;

@end
