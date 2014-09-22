//
//  SiWeiBannerView.h
//  PushAd
//
//  Created by wisdome on 13-5-1.
//  Copyright (c) 2013年 wisdome. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SiWeiDelegate.h"
//  位置的定义
//  通过此参数开发者可以更方便设置广告条要显示的位置
typedef struct Position
{
    float x;
    float y;
}Position;

CG_INLINE Position
CGPositionMake(CGFloat x, CGFloat y)
{
    Position p; p.x = x; p.y = y; return p;
}
/****
// 
// 广告条尺寸枚举（请开发者选择适应屏幕尺寸的广告条）
// 
 ****/

typedef enum {
    SiWeiBannerContentSizeIdentifierUnknow     = 0, // 200*50
    SiWeiBannerContentSizeIdentifier320x50     = 1, // iPhone and iPod Touch ad size
    SiWeiBannerContentSizeIdentifier200x200    = 2, // 
    SiWeiBannerContentSizeIdentifier300x250    = 3, //
    SiWeiBannerContentSizeIdentifier468x60     = 4, //  ipad size
    SiWeiBannerContentSizeIdentifier728x90     = 5, //  iPad size
} SiWeiBannerContentSizeIdentifier;

@interface SiWeiBannerView : UIScrollView
@property (nonatomic, assign) id <SiWeiDelegate>siweiDelegate;

//广告条的初始化方法
//
//   参数 ：style 为广告条尺寸类型
//
// SiWeiBannerContentSizeIdentifierUnknow   --> size(200, 50)
// SiWeiBannerContentSizeIdentifier320x50   --> size(320, 50)
// SiWeiBannerContentSizeIdentifier200x200  --> size(200, 200)
// SiWeiBannerContentSizeIdentifier300x250  --> size(300, 250)
// SiWeiBannerContentSizeIdentifier468x60   --> size(468, 60)
// SiWeiBannerContentSizeIdentifier728x90   --> size(728, 90)
//
//
//    参数 ：position 为开发者设置的广告条的位置
//          CGPositionMake(0,0) -->指定广告条的位置在坐标（0,0）位置
//      
//
//  例子：SiWeiBannerView * banner = [[SiWeiBannerView alloc] initWithAdvertisingStyle:SiWeiBannerContentSizeIdentifier320x50 andPosition:CGPositionMake(0, 0)];
//
//
- (id)initWithAdvertisingStyle:(SiWeiBannerContentSizeIdentifier)style andPosition:(Position)position;
@end
