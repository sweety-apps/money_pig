package com.example.wangcai.dialog;

import android.app.AlertDialog;
import android.app.Dialog;

import com.example.wangcai.R;
import com.example.wangcai.base.ManagedDialog;
import com.example.wangcai.base.ManagedDialogActivity;

public class HintNetwordErrorDialog extends ManagedDialog{

	public HintNetwordErrorDialog(ManagedDialogActivity owner) {
		super(owner);
	}

	public Dialog Create() {
		AlertDialog.Builder builder = new AlertDialog.Builder(m_ownerActivity);
		builder.setTitle(R.string.app_description);
		builder.setMessage(String.format(m_ownerActivity.getString(R.string.hint_network_error)));
		builder.setPositiveButton(R.string.retry_text, this);
		AlertDialog dlg = builder.create();
		return dlg;
	}

	@Override
	public void Prepare(Dialog dlg) {
		// TODO Auto-generated method stub
		
	}
	
}
