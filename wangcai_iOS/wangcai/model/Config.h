//
//  Config.h
//  wangcai
//
//  Created by 1528 on 13-12-9.
//  Copyright (c) 2013年 1528studio. All rights reserved.
//

#ifndef wangcai_Config_h
#define wangcai_Config_h

#define USE_NEW_OFFERWALL_REQUEST 1

#if TARGET_VERSION_LITE == 1 
#define APP_NAME   @"WangCai"
#define INVITE_URL @"http://invite.getwangcai.com/index.php?code=%@"

#define INVITE_TASK @"http://www.getwangcai.com/?code=%@&name=wangcai"

#define WEB_FORCE_UPDATE    @"http://wangcai.meme-da.com/web/update.php?app=wangcai&"


#define YOUMI_APP_ID    @"4a2807f06fd8d2df"
#define YOUMI_APP_SECRET    @"83b758c99c63593d"

#define DOMOB_PUBLISHER_ID @"96ZJ2I4gzeykPwTACk"

#define LIMEI_ID           @"6ec9f39b6b38ac4d8b6c1764d68b91e4"

#define MOBSMAR_APP_ID     @"dbfff8bedfbb85673317fdaeeb7776ba"

#define MOPAN_APP_ID       @"12408"
#define MOPAN_APP_SECRET   @"y5g1zmonrorhern6"

#define PUNCHBOX_APP_SECRET @"100142-99B3FD-3DD7-15B3-957E55CAD324"

#define UMENG_KEY   @"5334f6df56240b43b309cfaa"

#define APP_MIIDI_ID       @"17251"
#define APP_MIIDI_SECRET   @"dtl59j3m47wclc1g"

#define APP_JUPENG_ID      @"10073"
#define APP_JUPENG_SECRET  @"er6hqigbccbh9bvp"

#define APP_DIANRU_ID      @"00003215130000F0"

#define ADWO_OFFERWALL_BASIC_PID  @"b6e89ca0dad04766a03c0b04db24e182"

#elif TARGET_VERSION_LITE == 2

#define APP_NAME   @"WangCaiFriend"
#define INVITE_URL @"http://invite.getwangcai.com/index.php?app=wangcaifriend&code=%@"

#define INVITE_TASK @"http://www.getwangcai.com/?code=%@&name=wangcaifriend"

#define WEB_FORCE_UPDATE    @"http://wangcai.meme-da.com/web/update.php?app=wangcaifriend&"

#define YOUMI_APP_ID    @"c43af0b9f90601cf"


#define YOUMI_APP_SECRET    @"14706b7214e01b2b"

#define DOMOB_PUBLISHER_ID @"96ZJ0Q7gzeykPwTAVP"

#define LIMEI_ID           @"a0b29d7891bffc58f7618f6788d3aaaa"

#define MOBSMAR_APP_ID     @"4c90ded6f4a8d81c23e804ba169dc629"

#define MOPAN_APP_ID       @"12407"
#define MOPAN_APP_SECRET   @"urpq0gffsc6vbykq"

#define PUNCHBOX_APP_SECRET @"888177895-3D63E6-40EE-D4E0-9730BCE45"

#define UMENG_KEY   @"5334f7c756240b43a00a9aaa"


#define APP_MIIDI_ID       @"17250"
#define APP_MIIDI_SECRET   @"zujvxsva5xt3v9nr"

#define APP_JUPENG_ID      @"10072"
#define APP_JUPENG_SECRET  @"8s92a9febf2faxdr"

#define APP_DIANRU_ID      @"00003315130000F0"

#define ADWO_OFFERWALL_BASIC_PID  @"612388f9b2334244acc025db8e9ec0be"


#endif


#define AES_KEY     @"cd421509726b38a2ffd2997caed6dab9"



#define TEST 1

#if TEST == 0

#define DEBUG_PUSH 0

#define HTTP_LOGIN_AND_REGISTER @"https://ssl.getwangcai.com/0/register"
#define HTTP_BIND_PHONE         @"https://ssl.getwangcai.com/0/account/bind_phone"

#define HTTP_SEND_SMS_CODE      @"https://ssl.getwangcai.com/0/sms/resend_sms_code"
#define HTTP_CHECK_SMS_CODE     @"https://ssl.getwangcai.com/0/account/bind_phone_confirm"
#define HTTP_READ_ACCOUNT_INFO     @"https://ssl.getwangcai.com/0/account/info"
#define HTTP_WRITE_ACCOUNT_INFO     @"https://ssl.getwangcai.com/0/account/update_user_info"
#define HTTP_UPDATE_INVITER     @"https://ssl.getwangcai.com/0/account/update_inviter"

#define HTTP_READ_TASK_LIST     @"https://ssl.getwangcai.com/0/task/list"
#define HTTP_TAKE_AWARD     @"https://ssl.getwangcai.com/0/task/check-in"

#define HTTP_DOWNLOAD_APP       @"https://ssl.getwangcai.com/0/task/download_app"

#define HTTP_PHONE_PAY         @"https://ssl.getwangcai.com/0/order/phone_pay"
#define HTTP_ALIPAY_PAY         @"https://ssl.getwangcai.com/0/order/alipay"
#define HTTP_QQ_PAY             @"https://ssl.getwangcai.com/0/order/qb_pay"

#define HTTP_EXCHANGE_LIST         @"https://ssl.getwangcai.com/0/order/exchange_list"
#define HTTP_EXCHANGE_CODE         @"https://ssl.getwangcai.com/0/order/exchange_code"

#define HTTP_TASK_OFFERWALL         @"https://ssl.getwangcai.com/0/task/poll"

#define HTTP_TASK_COMMENT         @"https://ssl.getwangcai.com/0/task/comment"


#define HTTP_TASK_SHARE         @"https://ssl.getwangcai.com/0/task/share"

#define HTTP_BILLING_HISTORY         @"https://ssl.getwangcai.com/0/account/billing_history"


#define WEB_EXTRACT_MONEY @"http://wangcai.meme-da.com/web/extract_money.php"
#define WEB_TASK          @"http://wangcai.meme-da.com/web/task/app_task.php"
#define WEB_EXCHANGE_INFO @"http://wangcai.meme-da.com/web/exchange_info2.php"
#define WEB_ORDER_INFO    @"http://wangcai.meme-da.com/web/order_info.php"

#else

#define DEBUG_PUSH 0
#define SERVER_HOST_NAME(x)


#define HTTP_LOGIN_AND_REGISTER @"http://223.4.33.112/0/register"
#define HTTP_BIND_PHONE         @"http://223.4.33.112/0/account/bind_phone"

#define HTTP_SEND_SMS_CODE      @"http://223.4.33.112/0/sms/resend_sms_code"
#define HTTP_CHECK_SMS_CODE     @"http://223.4.33.112/0/account/bind_phone_confirm"
#define HTTP_READ_ACCOUNT_INFO     @"http://223.4.33.112/0/account/info"
#define HTTP_WRITE_ACCOUNT_INFO     @"http://223.4.33.112/0/account/update_user_info"
#define HTTP_UPDATE_INVITER     @"http://223.4.33.112/0/account/update_inviter"

#define HTTP_READ_TASK_LIST     @"http://223.4.33.112/0/task/list"
#define HTTP_TAKE_AWARD     @"http://223.4.33.112/0/task/check-in"

#define HTTP_DOWNLOAD_APP       @"http://223.4.33.112/0/task/download_app"

#define HTTP_PHONE_PAY         @"http://223.4.33.112/0/order/phone_pay"
#define HTTP_ALIPAY_PAY         @"http://223.4.33.112/0/order/alipay"
#define HTTP_QQ_PAY         @"http://223.4.33.112/0/order/qb_pay"

#define HTTP_EXCHANGE_LIST         @"http://223.4.33.112/0/order/exchange_list"
#define HTTP_EXCHANGE_CODE         @"http://223.4.33.112/0/order/exchange_code"

#define HTTP_TASK_OFFERWALL         @"http://223.4.33.112/0/task/poll"

#define HTTP_TASK_COMMENT         @"http://223.4.33.112/0/task/comment"

#define HTTP_TASK_SHARE         @"http://223.4.33.112/0/task/share"

#define HTTP_BILLING_HISTORY         @"http://223.4.33.112/0/account/billing_history"

#define WEB_EXTRACT_MONEY         @"http://dev.meme-da.com/web/extract_money.php"
#define WEB_TASK                  @"http://dev.meme-da.com/web/task/app_task.php"
#define WEB_EXCHANGE_INFO         @"http://dev.meme-da.com/web/exchange_info2.php"
#define WEB_ORDER_INFO            @"http://dev.meme-da.com/web/order_info.php"
#endif


#define HTTP_SERVICE_QUESTION   @"http://service.meme-da.com/index.php/mobile/shouce/list/hc_id/76"
#define HTTP_SERVICE_CENTER     @"http://service.meme-da.com/index.php/mobile/consulting"
#define WEB_SERVICE_VIEW @"http://service.meme-da.com/index.php/mobile/shouce/view/h_id/"

#endif
