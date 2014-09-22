package com.example.wangcai.dialog;

import android.app.AlertDialog;
import android.app.Dialog;

import com.example.request.Util;
import com.example.wangcai.R;
import com.example.wangcai.base.ManagedDialog;
import com.example.wangcai.base.ManagedDialogActivity;

public class CommonDialog extends ManagedDialog{

	public CommonDialog(ManagedDialogActivity owner) {
		super(owner);
	}
	
	public void SetInfo(String strTitle, String strText, String strPositiveButtonText, String strNegativeButtonText) {
		m_strTitle = strTitle;
		m_strText = strText;
		m_strPositiveButtonText = strPositiveButtonText;
		m_strNegativeButtonText = strNegativeButtonText;
	}

	
	public Dialog Create() {
		AlertDialog.Builder builder = new AlertDialog.Builder(m_ownerActivity);
		if (Util.IsEmptyString(m_strTitle)) {
			builder.setTitle(R.string.app_description);
		}
		else {
			builder.setTitle(m_strTitle);
		}
		builder.setMessage(m_strText);
		if (!Util.IsEmptyString(m_strPositiveButtonText)) {
			builder.setPositiveButton(m_strPositiveButtonText, this);			
		}
		if (!Util.IsEmptyString(m_strNegativeButtonText)) {
			builder.setNegativeButton(m_strNegativeButtonText, this);			
		}
		AlertDialog dlg = builder.create();
		return dlg;
	}

	@Override
	public void Prepare(Dialog dlg) {		
	}
	

	private String m_strTitle;
	private String m_strText;
	private String m_strPositiveButtonText;
	private String m_strNegativeButtonText;
}
