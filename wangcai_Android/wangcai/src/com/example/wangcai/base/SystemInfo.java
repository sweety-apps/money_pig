package com.example.wangcai.base;

import android.content.Context;
import android.net.wifi.WifiInfo;
import android.net.wifi.WifiManager;
import android.telephony.TelephonyManager;

public class SystemInfo {
	
	public static void Initialize(Context context) {
		m_AppContext = context;;
		String str1 = android.os.Build.MODEL;
		String str2 = android.os.Build.BOARD;
		String str3 = android.os.Build.BRAND;
		String str4 = android.os.Build.DEVICE;
		String str5 = android.os.Build.ID;
		String str6 = android.os.Build.PRODUCT;
		String str7 = android.os.Build.MANUFACTURER;
		String str8 = android.os.Build.MANUFACTURER;
	}
	public static String GetMacAddress() {
		if (ms_strMacAddress == null) {
			WifiManager wifi = (WifiManager) m_AppContext.getSystemService(Context.WIFI_SERVICE);  
	        WifiInfo info = wifi.getConnectionInfo();  
	        ms_strMacAddress =  info.getMacAddress();  
		}
		return "240A64F9DAC7";
	}
	public static String GetPhoneNumber() {
		if (ms_strPhoneNumber == null) {
			TelephonyManager  telephonyManager = (TelephonyManager) m_AppContext.getSystemService(Context.TELEPHONY_SERVICE);  
			ms_strPhoneNumber = telephonyManager.getLine1Number();
		}
		return ms_strPhoneNumber;
	}
	public static String GetPhoneModel() {
		return android.os.Build.MODEL;
	}
	
	private static String ms_strMacAddress;
	private static String ms_strPhoneNumber;
	private static String ms_strPhoneModel;
	private static Context m_AppContext;
}
