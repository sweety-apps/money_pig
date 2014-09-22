package com.example.wangcai.base;

import java.util.ArrayList;

import android.app.Activity;

public class ActivityRegistry {
	private static ActivityRegistry m_obj = new ActivityRegistry();

	public static ActivityRegistry GetInstance() {
		return m_obj;
	}
	
	public void PushActivity(Activity activity) {
		m_stackActivity.add(activity);
	}
	
	public boolean PopActivity(Activity activity) {
		return m_stackActivity.remove(activity);
	}
	
	public boolean Remove(int nIndex) {
		if (nIndex < 0 || nIndex >= m_stackActivity.size()) {
			return false;
		}
		m_stackActivity.remove(nIndex);
		return true;
	}
	
	public int GetActivityCount() {
		return m_stackActivity.size();
	}
	
	public Activity GetActivity(int nIndex) {
		if (nIndex < 0 || nIndex >= m_stackActivity.size()) {
			return null;
		}
		return m_stackActivity.get(nIndex);
	}

	private ArrayList<Activity> m_stackActivity = new ArrayList<Activity>();
}
