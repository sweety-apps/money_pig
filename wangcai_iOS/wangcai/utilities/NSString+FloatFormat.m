//
//  NSString+FloatFormat.m
//  wangcai
//
//  Created by Lee Justin on 13-12-27.
//  Copyright (c) 2013年 1528studio. All rights reserved.
//

#import "NSString+FloatFormat.h"

@implementation NSString (FloatFormat)

+ (NSString*) stringWithFloatRoundToPrecision:(float)num precision:(int)precision ignoreBackZeros:(BOOL)ignoreBackZeros
{
    if (precision < 1)
    {
        precision = 1;
    }
    NSString* format = [NSString stringWithFormat:@"%@.%df",@"%",precision];
    NSString* rawString = [NSString stringWithFormat:format,num];
    
    if (ignoreBackZeros)
    {
        NSString* digit = nil;
        int restDigitCount = [rawString length];
        do
        {
            restDigitCount--;
            NSRange range = {restDigitCount,1};
            digit = [rawString substringWithRange:range];
            if ([digit isEqualToString:@"."])
            {
                break;
            }
            if (![digit isEqualToString:@"0"]) {
                restDigitCount++;
                break;
            }
        }while (restDigitCount > 0);
        rawString = [rawString substringToIndex:restDigitCount];
    }
    
    return rawString;
}

@end
