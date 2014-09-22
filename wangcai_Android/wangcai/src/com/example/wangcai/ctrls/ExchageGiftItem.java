package com.example.wangcai.ctrls;

import com.example.wangcai.R;
import com.example.wangcai.R.id;
import com.example.wangcai.R.layout;
import com.example.wangcai.R.string;
import com.example.wangcai.base.ViewHelper;

import android.content.Context;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.Button;

public class ExchageGiftItem extends ItemBase implements OnClickListener
{
	public interface ExchageItemEvent{
		void OnDoExchage(String strItemName);
	}
	public ExchageGiftItem(String strItemName) {
		super(strItemName);
	}

	public void SetItemEventLinstener(ExchageItemEvent eventLinstener) {
		m_itemEventLinstener = eventLinstener;
	}

	public ViewGroup Create(Context context, int nIconId, String strName, int nPrice, int nRemainCount) {
		super.CreateView(context, R.layout.ctrl_exchage_gift_item);
		InitView(context, nIconId, strName, nPrice, nRemainCount);
		return m_viewRoot;
	}

	public void onClick(View v) {
		int nId = v.getId();
		if (nId == R.id.recharge_button) {
			if (m_itemEventLinstener != null) {
				m_itemEventLinstener.OnDoExchage(m_strItemName);
			}
		}
	}
		
	private void InitView(Context context, int nIconId, String strName, int nPrice, int nRemainCount) {
		ViewHelper.SetIconId(m_viewRoot, R.id.type_icon, nIconId);

		ViewHelper.SetTextStr(m_viewRoot, R.id.type_name, strName);

		String strText = String.format(context.getString(R.string.gift_price_count), nPrice, nRemainCount);
		ViewHelper.SetTextStr(m_viewRoot, R.id.extract_price, strText);

		((Button)m_viewRoot.findViewById(R.id.recharge_button)).setOnClickListener(this);
	}

	
	ExchageItemEvent m_itemEventLinstener = null;
}


