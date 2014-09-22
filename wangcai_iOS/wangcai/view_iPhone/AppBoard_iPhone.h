//
//	 ______    ______    ______    
//	/\  __ \  /\  ___\  /\  ___\   
//	\ \  __<  \ \  __\_ \ \  __\_ 
//	 \ \_____\ \ \_____\ \ \_____\ 
//	  \/_____/  \/_____/  \/_____/ 
//
//	Powered by BeeFramework
//
//
//  AppBoard_iPhone.h
//  wangcai
//
//  Created by Lee Justin on 13-12-8.
//  Copyright (c) 2013年 1528studio. All rights reserved.
//

#import "Bee.h"
#import "YouMiView.h"

@interface AppBoard_iPhone : BeeUIBoard <UIAlertViewDelegate> {
    UIAlertView* _alertView;
    YouMiView*   _adView;
    
    NSString*    _remoteNotificationTitle;
    NSString*    _remoteNotificationUrl;
}

AS_SINGLETON( AppBoard_iPhone )

- (void)setPanable:(BOOL)panable;
- (void)onTouchedInvite:(BOOL)switchToFillInvitedCodeView;
- (void) openUrlFromRomoteNotification : (NSString*) title Url:(NSString*) url;
@end
