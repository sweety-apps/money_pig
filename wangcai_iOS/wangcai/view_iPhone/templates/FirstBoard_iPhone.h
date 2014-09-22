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
//  FirstBoard_iPhone.h
//  wangcai
//
//  Created by Lee Justin on 13-12-8.
//  Copyright (c) 2013年 1528studio. All rights reserved.
//

#import "Bee.h"
#import "ExchangeController.h"

@interface FirstBoard_iPhone : BeeUIBoard {
    ExchangeController* _exchangeController;
}

AS_SINGLETON( FirstBoard_iPhone )

@end
