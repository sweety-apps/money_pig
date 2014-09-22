package com.example.wangcai.ctrls;

import com.example.wangcai.R;
import com.example.wangcai.R.id;
import com.example.wangcai.R.layout;
import com.example.wangcai.base.ViewHelper;

import android.content.Context;
import android.view.View;

public class MainItem extends ItemBase
{
	public MainItem(String strItemName) {
		super(strItemName);
	}

	public View Create(Context context, int nItemIconId, String strTitle, String strTip, int nMoneyIconId, Boolean bComplete) {
		super.CreateView(context, R.layout.ctrl_main_item);
		InitView(nItemIconId, strTitle, strTip, nMoneyIconId, bComplete);
		return m_viewRoot;
	}
	
	private void InitView(int nItemIconId, String strTitle, String strTip, int nMoneyIconId, Boolean bComplete) {
		ViewHelper.SetIconId(m_viewRoot, R.id.main_item_icon, nItemIconId);
		ViewHelper.SetTextStr(m_viewRoot, R.id.main_item_title, strTitle);
		ViewHelper.SetTextStr(m_viewRoot, R.id.main_item_tip, strTip);
		if (bComplete)
		{
			ViewHelper.SetChildVisibility(m_viewRoot, R.id.main_item_money_icon, View.GONE);
			ViewHelper.SetChildVisibility(m_viewRoot, R.id.main_item_task_status, View.VISIBLE);
		}
		else
		{
			ViewHelper.SetChildVisibility(m_viewRoot, R.id.main_item_task_status, View.GONE);
			ViewHelper.SetChildVisibility(m_viewRoot, R.id.main_item_money_icon, View.VISIBLE);
			ViewHelper.SetIconId(m_viewRoot, R.id.main_item_money_icon, nMoneyIconId);
		}
	}
	
	
}


