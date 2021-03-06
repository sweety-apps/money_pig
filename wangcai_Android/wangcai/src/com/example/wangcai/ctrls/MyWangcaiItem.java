package com.example.wangcai.ctrls;

import com.example.wangcai.R;
import com.example.wangcai.R.id;
import com.example.wangcai.R.layout;
import com.example.wangcai.base.ViewHelper;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

public class MyWangcaiItem 
{
	public MyWangcaiItem()  {
		m_viewRoot = null;
	}

	public ViewGroup Create(Context context, int nBkgImgId, int nUnlockTipImgId, int nPrivilegeImgId) {
		LayoutInflater inflater = (LayoutInflater)context.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
		m_viewRoot = (ViewGroup)inflater.inflate(R.layout.ctrl_my_wangcai_item,null);
		InitView(nBkgImgId, nUnlockTipImgId, nPrivilegeImgId);
		return m_viewRoot;
	}
	
	public void SetVisibility(int nVisibility) {
		if (m_viewRoot != null) {
			m_viewRoot.setVisibility(nVisibility);
		}
	}
	public View GetView() {
		return m_viewRoot;
	}
	
	private void InitView(int nBkgImgId, int nUnlockTipImgId, int nPrivilegeImgId) {
		ViewHelper.SetIconId(m_viewRoot, R.id.item_bkg, nBkgImgId);
		ViewHelper.SetIconId(m_viewRoot, R.id.level_unlock_tip, nUnlockTipImgId);
		ViewHelper.SetIconId(m_viewRoot, R.id.level_privilege_tip, nPrivilegeImgId);
	}
	
	
	private ViewGroup m_viewRoot;
}


