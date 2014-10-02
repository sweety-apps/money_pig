//
//  NibLoader.m
//  WechatLife
//
//  Created by graysonsun-nb.local on 5/14/14.
//  Copyright (c) 2014 quainli. All rights reserved.
//

#import "NibLoader.h"



@implementation NibLoader

+(id)createViewWithName:(NSString*)nibname
{
    UINib *nib = [UINib nibWithNibName:nibname bundle:nil];
    NSArray* array;
    array = [nib instantiateWithOwner:nil
                              options:nil];
    if([array count]>0)
        return array[0];
    else
        return nil;
}
+(UINib*)createNibWithName:(NSString*)nibname
{
    UINib *nib = [UINib nibWithNibName:nibname bundle:nil];
    return nib;
}

@end
