package com.example.request;

public class RequesterFactory {

	public static enum RequestType {
		RequestType_Login,					//登陆
		RequestType_Lottery,				//抽奖
		RequestType_BindPhone,			//绑定手机
		RequestType_ResendCaptcha,	//重发验证码
		RequestType_VerifyCaptcha,		//检查验证码
		RequestType_UpdateUserInfo,	//更新用户信息(问卷调查)
		RequestType_GetUserInfo,			//获取用户信息(问卷调查)
		RequestType_ExtractPhoneBill,	//话费充值
		RequestType_ExtractQBi,			//Q币充值
		RequestType_ExtractAliPay,		//支付宝充值
		RequestType_UpdateInviter,		//跟新邀请人
	}
	

	public static Requester NewRequest(RequestType enumRequestType) {
		Requester req = null;
		switch (enumRequestType){
		case RequestType_Login:
			req = new Request_Login();
			break;
		case RequestType_Lottery:
			req = new Request_Lottery();
			break;
		case RequestType_BindPhone:
			req = new Request_BindPhone();
			break;
		case RequestType_ResendCaptcha:
			req = new Request_ResendCaptcha();
			break;
		case RequestType_UpdateUserInfo:
			req = new Request_UpdateUserInfo();
			break;
		case RequestType_GetUserInfo:
			req = new Request_GetUserInfo();
			break;
		case RequestType_ExtractPhoneBill:
			req = new Request_ExtractPhoneBill();
			break;
		case RequestType_ExtractQBi:
			req = new Request_ExtractQBi();
			break;
		case RequestType_ExtractAliPay:
			req = new Request_ExtractAliPay();
			break;
		case RequestType_VerifyCaptcha:
			req = new Request_VerifyCaptcha();
			break;
		case RequestType_UpdateInviter:
			req = new Request_UpdateInviter();
			break;
		default:
			return req;
		}
		req.SetRequestType(enumRequestType);
		return req;
	}
	
	
}
