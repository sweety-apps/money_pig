package com.example.request;

public class Config {
	public enum EnvType {
		EnvType_Formal,
		EnvType_Dev
	}
	public static void Initlialize(EnvType enumEvnType) {
		m_enumEvnType = enumEvnType;
	}
	
	public static String GetLoginUrl() {
		if (m_enumEvnType == EnvType.EnvType_Dev) {
			return "https://dev.getwangcai.com/0/register";
		}
		else {
			return "https://ssl.getwangcai.com/0/register";
		}
	}
	public static String GetLotteryUrl() {
		if (m_enumEvnType == EnvType.EnvType_Dev) {
			return "https://ssl.getwangcai.com/0/task/check-in";
		}
		else {
			return "https://dev.getwangcai.com/0/task/check-in";
		}		
	}
	public static String GetSendCaptchaUrl() {
		if (m_enumEvnType == EnvType.EnvType_Dev) {
			return "https://dev.getwangcai.com/0/account/bind_phone";
		}
		else {
			return "https://ssl.getwangcai.com/0/account/bind_phone";			
		}
	}
	public static String GetResendCaptchaUrl() {
		if (m_enumEvnType == EnvType.EnvType_Dev) {
			return "https://dev.getwangcai.com/0/sms/resend_sms_code";
		}
		else {
			return "https://ssl.getwangcai.com/0/sms/resend_sms_code";			
		}		
	}
	public static String GetVerifyCaptchaUrl() {
		if (m_enumEvnType == EnvType.EnvType_Dev) {
			return "https://dev.getwangcai.com/0/account/bind_phone_confirm";
		}
		else {
			return "https://ssl.getwangcai.com/0/account/bind_phone_confirm";			
		}		
	}
	public static String GetUserInfoUrl() {
		if (m_enumEvnType == EnvType.EnvType_Dev) {
			return "https://dev.getwangcai.com/0/account/info";
		}
		else {
			return "https://ssl.getwangcai.com/0/account/info";			
		}
		
	}
	public static String GetUpdateUserInfoUrl() {
		if (m_enumEvnType == EnvType.EnvType_Dev) {
			return "https://dev.getwangcai.com/0/account/update_user_info";
		}
		else {
			return "https://ssl.getwangcai.com/0/account/update_user_info";			
		}
	}
	public static String GetUpdateInviterUrl() {
		if (m_enumEvnType == EnvType.EnvType_Dev) {
			return "https://dev.getwangcai.com/0/account/update_inviter";
		}
		else {
			return "https://ssl.getwangcai.com/0/account/update_inviter";			
		}
	}
	
	
	public static String GetExtractAlipayUrl() {
		if (m_enumEvnType == EnvType.EnvType_Dev) {
			return "https://dev.getwangcai.com/0/order/alipay";
		}
		else {
			return "https://ssl.getwangcai.com/0/order/alipay";			
		}
	}
	
	public static String GetExtractPhoneBillUrl() {
		if (m_enumEvnType == EnvType.EnvType_Dev) {
			return "https://dev.getwangcai.com/0/order/phone_pay";
		}
		else {
			return "https://ssl.getwangcai.com/0/order/phone_pay";			
		}
	}
	
	public static String GetExtractQbiUrl() {
		if (m_enumEvnType == EnvType.EnvType_Dev) {
			return "https://dev.getwangcai.com/0/order/qb_pay";
		}
		else {
			return "https://ssl.getwangcai.com/0/order/qb_pay";			
		}
	}

	
	public static String GetInviteUrl() {
		return "http://invite.getwangcai.com/index.php?code=%s";				
	}
	

	public static String GetInviteTaskUrl() {
		return "http://www.getwangcai.com/?code=%s&name=wangcai";				
	}
	
	
	
	
	
	private static EnvType m_enumEvnType = EnvType.EnvType_Formal;
}
