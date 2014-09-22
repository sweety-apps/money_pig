//
//  UtilityFunctions.m
//  wangcai
//
//  Created by Lee Justin on 13-12-27.
//  Copyright (c) 2013年 1528studio. All rights reserved.
//

#import "UtilityFunctions.h"

@implementation UtilityFunctions

+ (void)debugAlertView:(NSString*)title content:(NSString*)content
{
    UIAlertView* alert = [[[UIAlertView alloc] initWithTitle:title message:content delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles:nil, nil] autorelease];
    [alert show];
}

@end
