package com.example.wangcai.dialog;

import android.app.AlertDialog;
import android.app.Dialog;

import com.example.wangcai.R;
import com.example.wangcai.base.ManagedDialog;
import com.example.wangcai.base.ManagedDialogActivity;

public class HintLoginErrorDialog  extends ManagedDialog{

	public HintLoginErrorDialog(ManagedDialogActivity owner, String strMsg) {
		super(owner);
		m_strMsg = strMsg;
	}

	public Dialog Create() {
		AlertDialog.Builder builder = new AlertDialog.Builder(m_ownerActivity);
		builder.setTitle(R.string.app_description);
		builder.setMessage(m_strMsg);
		builder.setPositiveButton(R.string.exit_text, this);
		AlertDialog dlg = builder.create();
		return dlg;
	}
	
	public void Prepare(Dialog dlg) {
		
	}
	
	String m_strMsg;
}