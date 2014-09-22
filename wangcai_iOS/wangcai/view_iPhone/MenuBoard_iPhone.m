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

#import "MenuBoard_iPhone.h"
#import "AppBoard_iPhone.h"
#import "LoginAndRegister.h"

#pragma mark -

@implementation MenuBoard_iPhone

DEF_SINGLETON( MenuBoard_iPhone )

SUPPORT_AUTOMATIC_LAYOUT( YES );
SUPPORT_RESOURCE_LOADING( YES );

#pragma mark -

ON_SIGNAL2( BeeUIBoard, signal )
{
	[super handleUISignal:signal];
	
	if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
	{
		//self.view.backgroundColor = [UIColor whiteColor];
		[self hideNavigationBarAnimated:NO];		
	}
	else if ( [signal is:BeeUIBoard.DELETE_VIEWS] )
	{
	}
    else if ( [signal is:BeeUIBoard.DID_APPEAR] )
	{
        [self resetSubviewsForLayoutXML];
	}
}

- (void)resetSubviewsForLayoutXML
{
    self.view.backgroundColor = [UIColor colorWithRed:33.f/255.f green:33.f/255.f blue:33.f/255.f alpha:1.0];
    
    [((BeeUIImageView*)$(@"item-left-icon-wodewangcai").view) setImage:[UIImage imageNamed:@"menu_icon_wodewangcai"]];
    
    [((BeeUIImageView*)$(@"item-left-icon-tixian").view) setImage:[UIImage imageNamed:@"menu_icon_tixian"]];
    [((BeeUIImageView*)$(@"item-left-icon-jiaoyimingxi").view) setImage:[UIImage imageNamed:@"menu_icon_jiaoyimingxi"]];
    [((BeeUIImageView*)$(@"item-left-icon-chaozhiduihuan").view) setImage:[UIImage imageNamed:@"menu_icon_chaozhiduihua"]];
    [((BeeUIImageView*)$(@"item-left-icon-tuhaobang").view) setImage:[UIImage imageNamed:@"menu_icon_tuhaobang"]];
    [((BeeUIImageView*)$(@"item-left-icon-setting").view) setImage:[UIImage imageNamed:@"menu_icon_setting"]];
    [((BeeUIImageView*)$(@"item-left-icon-setting1").view) setImage:[UIImage imageNamed:@"menu_icon_help"]];
    
    $(@"item-bg").view.hidden = YES;
}


- (void)selectItem:(NSString *)item animated:(BOOL)animated
{
	if ( animated )
	{
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationBeginsFromCurrentState:YES];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		[UIView setAnimationDuration:0.15f];
	}

	$(@"item-bg").view.frame = $(item).view.frame;
	
	if ( animated )
	{
		[UIView commitAnimations];
	}
    
    if ( [[LoginAndRegister sharedInstance] isInReview] ) {
        static int init = 0;
        if ( init == 0 ) {
            init = 1;

            self.view.LOAD_RESOURCE( @"MenuBoardInReview_iPhone" );
            [self sendUISignal:@"LAYOUT_VIEWS"];
            [self sendUISignal:@"WILL_APPEAR"];
            [self sendUISignal:@"DID_APPEAR"];
            [self resetSubviewsForLayoutXML];
        }
    }
}

@end
