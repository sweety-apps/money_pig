package com.example.wangcai.base;

import java.util.HashMap;
import java.util.Map;

import android.view.MotionEvent;
import android.view.View;
import android.view.View.OnTouchListener;
import android.widget.Button;

public class ViewDrawer implements OnTouchListener{
	
	public boolean AttachView(View view, int nNormalImgId, int nDownImgId, int nDisableId) {
		if (m_mapViewInfo == null) {
			m_mapViewInfo = new HashMap<View, ViewInfo>();
		}

		ViewInfo viewInfo = m_mapViewInfo.get(view);
		if (viewInfo == null) {
			view.setOnTouchListener(this);
			m_mapViewInfo.put(view, new ViewInfo(nNormalImgId, nDownImgId, nDisableId));
			if (view.isEnabled()) {
				view.setBackgroundResource(nNormalImgId);
			}
			else {
				view.setBackgroundResource(nDisableId);
			}
			return true;
		}
		else {
			return false;
		}
	}
	public boolean DetachView(View view) {
		if (m_mapViewInfo == null) {
			return false;
		}
		
		view.setOnTouchListener(null);
		ViewInfo viewInfo = m_mapViewInfo.remove(view);
		if (viewInfo != null) {
			view.setOnTouchListener(null);
			return true;
		}
		else {
			return false;
		}
	}
	public void DetachAll() {
		for (View view: m_mapViewInfo.keySet()) {  
			view.setOnTouchListener(null);
		} 
		m_mapViewInfo.clear();
	}

	@Override
	public boolean onTouch(View v, MotionEvent event) {
		// TODO Auto-generated method stub
		if (m_mapViewInfo == null) {
			return false;
		}
		ViewInfo viewInfo = m_mapViewInfo.get(v);
		if (viewInfo == null) {
			return false;
		}
		if (!v.isEnabled()) {
			if (viewInfo.m_nDisableId  > 0) {
				v.setBackgroundResource(viewInfo.m_nDisableId);
			}
			else {
				v.setBackgroundResource(viewInfo.m_nNormalImgId);
			}
			return false;
		}

		int nAction = event.getAction();
		switch (nAction) {
		case MotionEvent.ACTION_DOWN:
			v.setBackgroundResource(viewInfo.m_nDownImgId);
			break;
		case MotionEvent.ACTION_UP:
		case MotionEvent.ACTION_CANCEL:
			v.setBackgroundResource(viewInfo.m_nNormalImgId);
			break;
		}
		return false;
	}
	
	private class ViewInfo {
		ViewInfo(int nNormalImgId, int nDownImgId, int nDisableId) {
			m_nNormalImgId = nNormalImgId;
			m_nDownImgId = nDownImgId;
			m_nDisableId = nDisableId;
		}
		public int m_nNormalImgId;
		public int m_nDownImgId;
		public int m_nDisableId;
	}
	Map<View, ViewInfo> m_mapViewInfo;
}
