//
//  NSString+DataParser.h
//  wangcai
//
//  Created by Lee Justin on 13-12-27.
//  Copyright (c) 2013年 1528studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (DataParser)

- (NSArray*)parseStringIntoArrayWithInterlacer:(NSString*)interlacer;
+ (NSString*)stringFromArray:(NSArray*)array withInterlacer:(NSString*)interlacer;

@end
