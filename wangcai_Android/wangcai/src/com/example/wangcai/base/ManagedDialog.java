package com.example.wangcai.base;

import android.app.Dialog;
import android.content.DialogInterface;


public abstract  class ManagedDialog implements DialogInterface.OnClickListener{
	public ManagedDialog(ManagedDialogActivity owner) {
		m_ownerActivity = owner;
	}

	public void SetId(int nId) {
		m_nDialogId = nId;
	}

	public boolean OnClickHook(int nId){
		return true;
	}
	
	public abstract Dialog Create() ;	
	
	public abstract void Prepare(Dialog dlg);
	
	public void Show() {
		m_ownerActivity.showDialog(GetDialogId());
	}
	
	public int GetDialogId() {
		return m_nDialogId;
	}

    public void onClick(DialogInterface dialog, int which) { 
    	if (OnClickHook(which)) {
    		m_ownerActivity.OnDialogFinish(this, which);
    	}
    }
	
	
	private int m_nDialogId;
	protected ManagedDialogActivity m_ownerActivity;
}
