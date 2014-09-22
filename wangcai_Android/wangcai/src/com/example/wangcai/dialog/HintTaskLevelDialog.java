package com.example.wangcai.dialog;

import android.app.AlertDialog;
import android.app.Dialog;

import com.example.wangcai.R;
import com.example.wangcai.base.ManagedDialog;
import com.example.wangcai.base.ManagedDialogActivity;

public class HintTaskLevelDialog extends ManagedDialog{

	public HintTaskLevelDialog(ManagedDialogActivity owner, int nLevel) {
		super(owner);;
		m_nLevel = nLevel;
	}

	public Dialog Create() {
		AlertDialog.Builder builder = new AlertDialog.Builder(m_ownerActivity);
		builder.setTitle(R.string.app_description);
		builder.setMessage(String.format(m_ownerActivity.getString(R.string.task_level_limit_hint), m_nLevel));
		builder.setPositiveButton(R.string.my_level, this);
		builder.setNegativeButton(R.string.close_button, this);
		AlertDialog dlg = builder.create();
		return dlg;
	}

	@Override
	public void Prepare(Dialog dlg) {
		// TODO Auto-generated method stub
		
	}
	private int m_nLevel;
}
