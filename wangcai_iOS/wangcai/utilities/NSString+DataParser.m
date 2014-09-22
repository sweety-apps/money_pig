//
//  NSString+DataParser.m
//  wangcai
//
//  Created by Lee Justin on 13-12-27.
//  Copyright (c) 2013年 1528studio. All rights reserved.
//

#import "NSString+DataParser.h"

@implementation NSString (DataParser)

- (NSArray*)parseStringIntoArrayWithInterlacer:(NSString*)interlacer
{
    NSMutableArray* interest = [NSMutableArray array];
    if ([self length] > 0)
    {
        int last = 0;
        for (int i = 0; i < [self length]; ++i)
        {
            if (i - last > 0)
            {
                NSRange range = {last,i-last};
                NSString* subString = [self substringWithRange:range];
                if ([[subString substringFromIndex:[subString length] - [interlacer length]] isEqualToString:interlacer])
                {
                    [interest addObject:[subString substringToIndex:[subString length] - 1]];
                    last = i;
                }
            }
        }
        if(last < [self length])
        {
            NSRange range = {last,[self length]-last};
            NSString* subString = [self substringWithRange:range];
            [interest addObject:subString];
        }
    }
    return interest;
}

+ (NSString*)stringFromArray:(NSArray*)array withInterlacer:(NSString*)interlacer
{
    NSString* result = @"";
    if ([array count] > 0)
    {
        for (NSString* str in array)
        {
            result = [result stringByAppendingFormat:@"%@%@",interlacer,str];
        }
        result = [result substringFromIndex:[interlacer length]];
    }
    return result;
}

@end
