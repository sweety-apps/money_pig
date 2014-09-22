package com.example.wangcai.dialog;

import com.example.wangcai.R;
import com.example.wangcai.R.string;
import com.example.wangcai.base.ManagedDialog;
import com.example.wangcai.base.ManagedDialogActivity;

import android.app.AlertDialog;
import android.app.Dialog;

public class HintBindPhoneDialog extends ManagedDialog{

	public HintBindPhoneDialog(ManagedDialogActivity owner) {
		super(owner);
	}

	public Dialog Create() {
		AlertDialog.Builder builder = new AlertDialog.Builder(m_ownerActivity);
		builder.setTitle(R.string.app_description);
		builder.setMessage(R.string.hint_bind_phone);
		builder.setPositiveButton(R.string.bind_phone, this);
		builder.setNegativeButton(R.string.cancel_text, this);
		AlertDialog dlg = builder.create();
		return dlg;
	}
	
	public void Prepare(Dialog dlg) {
		
	}
	
}
