package com.example.wangcai.ctrls;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

public class ItemBase implements View.OnClickListener{
	public interface ItemClickEvent
	{
		void OnItemClicked(String strItemName);
	}
	public ItemBase(String strItemName) {
		m_strItemName = strItemName;
		m_viewRoot = null;
	}

	
	public void SetVisibility(int nVisibility) {
		if (m_viewRoot != null)	{
			m_viewRoot.setVisibility(nVisibility);
		}
	}
	
	public void SetClickEventLinstener(ItemClickEvent clickEventLinstener) {
		m_clickEventLinstener = clickEventLinstener;
	}
	
	public View GetView() {
		return m_viewRoot;
	}
	

    public void onClick(View v)
    {
    	if (m_clickEventLinstener != null)
    	{
    		m_clickEventLinstener.OnItemClicked(m_strItemName);
    	}
    }
	
	protected boolean CreateView(Context context, int nLayoutId){
		LayoutInflater inflater = (LayoutInflater)context.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
		m_viewRoot = (ViewGroup)inflater.inflate(nLayoutId, null);
		if (m_viewRoot == null)
		{
			return false;
		}
		
		m_viewRoot.setOnClickListener(this);

		return true;
	}
	
	protected String m_strItemName = null;
	protected ViewGroup m_viewRoot = null;
	protected ItemClickEvent m_clickEventLinstener = null;
}
