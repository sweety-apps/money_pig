package com.example.wangcai.ctrls;

import com.example.wangcai.R;
import com.example.wangcai.R.id;
import com.example.wangcai.R.layout;
import com.example.wangcai.base.ViewHelper;

import android.content.Context;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.Button;

public class ExtraItem extends ItemBase implements OnClickListener
{
	public interface ExtractItemEvent{
		void OnDoExtract(String strItemName);
	}
	public ExtraItem(String strItemName) {
		super(strItemName);
	}

	public void SetItemEventLinstener(ExtractItemEvent eventLinstener) {
		m_itemEventLinstener = eventLinstener;
	}

	public ViewGroup Create(Context context, int nIconId, String strName) {
		super.CreateView(context, R.layout.ctrl_extract_item);
		InitView(nIconId, strName);
		return m_viewRoot;
	}

	
	public void onClick(View v) {
		int nId = v.getId();
		if (nId == R.id.recharge_button) {
			if (m_itemEventLinstener != null) {
				m_itemEventLinstener.OnDoExtract(m_strItemName);
			}
		}
	}
	
	
	private void InitView(int nIconId, String strName) {
		ViewHelper.SetIconId(m_viewRoot, R.id.type_icon, nIconId);
		ViewHelper.SetTextStr(m_viewRoot, R.id.type_name, strName);

		((Button)m_viewRoot.findViewById(R.id.recharge_button)).setOnClickListener(this);
	}

	ExtractItemEvent m_itemEventLinstener = null;
}


