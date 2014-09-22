//
//	 ______    ______    ______
//	/\  __ \  /\  ___\  /\  ___\
//	\ \  __<  \ \  __\_ \ \  __\_
//	 \ \_____\ \ \_____\ \ \_____\
//	  \/_____/  \/_____/  \/_____/
//
//
//	Copyright (c) 2013-2014, {Bee} open source community
//	http://www.bee-framework.com
//
//
//	Permission is hereby granted, free of charge, to any person obtaining a
//	copy of this software and associated documentation files (the "Software"),
//	to deal in the Software without restriction, including without limitation
//	the rights to use, copy, modify, merge, publish, distribute, sublicense,
//	and/or sell copies of the Software, and to permit persons to whom the
//	Software is furnished to do so, subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in
//	all copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//	FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
//	IN THE SOFTWARE.
//

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import "Bee_Precompile.h"
#import "Bee_UISignal.h"

#pragma mark -

@interface BeeUITabBar : UITabBar<UITabBarDelegate>

AS_SIGNAL( HIGHLIGHT_CHANGED )	// 高亮改变

@property (nonatomic, assign) NSInteger		selectedIndex;
@property (nonatomic, retain) NSString *	selectedName;
@property (nonatomic, retain) UIImage *		backgroundImage;

- (void)addImage:(UIImage *)image;
- (void)addImage:(UIImage *)image signal:(NSString *)signal;
- (void)addImage:(UIImage *)image name:(NSString *)name;
- (void)addImage:(UIImage *)image name:(NSString *)name signal:(NSString *)signal;

- (void)addTitle:(NSString *)title;
- (void)addTitle:(NSString *)title signal:(NSString *)signal;
- (void)addTitle:(NSString *)title name:(NSString *)name;
- (void)addTitle:(NSString *)title name:(NSString *)name signal:(NSString *)signal;

- (void)addTitle:(NSString *)title image:(UIImage *)image;
- (void)addTitle:(NSString *)title image:(UIImage *)image signal:(NSString *)signal;
- (void)addTitle:(NSString *)title image:(UIImage *)image name:(NSString *)name;
- (void)addTitle:(NSString *)title image:(UIImage *)image name:(NSString *)name signal:(NSString *)signal;

- (void)setImage:(UIImage *)image name:(NSString *)name;
- (void)setTitle:(NSString *)title name:(NSString *)name;
- (void)setTitle:(NSString *)title image:(UIImage *)image name:(NSString *)name;

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
