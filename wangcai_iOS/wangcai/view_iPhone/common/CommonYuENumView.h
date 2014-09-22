//
//  CommonYuENumView.h
//  wangcai
//
//  Created by Lee Justin on 13-12-13.
//  Copyright (c) 2013年 1528studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommonYuENumView : UIView
{
    int _num;
    NSMutableDictionary* _digitDict;
    NSMutableArray* _animaArray;
}

-(void)setNum:(int)num;
-(int)getNum;

-(void)setNum:(int)num withAnimation:(BOOL)animated;

-(void)animateNumFrom:(int)oldNum to:(int)num withAnimation:(BOOL)animated;

@end
