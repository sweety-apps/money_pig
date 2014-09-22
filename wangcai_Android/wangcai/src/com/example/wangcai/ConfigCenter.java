package com.example.wangcai;

import android.content.Context;
import android.content.SharedPreferences;
import android.content.SharedPreferences.Editor;
import android.text.format.Time;

public class ConfigCenter {
	private final static String sg_strConfigName = "WangcaiConfig";
	private final static String sg_strHasSignInKey = "HasSignIn";
	
	private static ConfigCenter sg_Object = null;
	public static ConfigCenter GetInstance() {
		if (sg_Object == null) {
			sg_Object = new ConfigCenter();
		}
		return sg_Object;
	}
	public void Initialize(Context context) {
		m_sharedPreference = context.getSharedPreferences(sg_strConfigName, Context.MODE_PRIVATE);
	}
	public void SetHasSignInToday() {
		Editor editor = m_sharedPreference.edit();
		editor.putString(sg_strHasSignInKey, String.valueOf(System.currentTimeMillis()));
		editor.commit();
	}
	public boolean GetHasSignInToday() {
		String strTime =  m_sharedPreference.getString(sg_strHasSignInKey, "0");
		
		//上次抽奖时间
		long nLastTime  = Long.parseLong(strTime);	

		Time time = new Time();

		long nCurrentTime = time.toMillis(false);

		long nDif = (time.hour * 3600 + time.minute * 60 + time.second) * 1000;
		long nTodayBeginTime = nCurrentTime - nDif;		//今天0点0分的时间
		return nLastTime < nTodayBeginTime || nLastTime > nCurrentTime;
	}
	
	
	private SharedPreferences m_sharedPreference;
}
