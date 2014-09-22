package com.example.wangcai.activity;

import com.example.request.Util;
import com.example.wangcai.R;
import com.example.wangcai.WangcaiApp;
import com.example.wangcai.base.ManagedDialog;
import com.example.wangcai.base.ManagedDialogActivity;
import com.example.wangcai.dialog.HintLoginErrorDialog;
import com.example.wangcai.dialog.HintNetwordErrorDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.os.Bundle;

public class StartupActivity extends ManagedDialogActivity implements WangcaiApp.WangcaiAppEvent{
	

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_startup);

        WangcaiApp app = WangcaiApp.GetInstance();
        app.Initialize(this.getApplicationContext());
        
        app.AddEventLinstener(this);
        
        app.Login();

     }
    
    public void OnLoginComplete(int nResult, String strMsg) {
        WangcaiApp app = WangcaiApp.GetInstance();
    	if (nResult == 0) {
    		if (app.NeedForceUpdate()) {
    			//强制升级
    		}else {
    			//正常启动
    			Intent it = new Intent(StartupActivity.this, MainActivity.class);
    			startActivity(it);
    			finish();
    		}

            app.RemoveEventLinstener(this);
    	} else {
    		//登陆失败
    		if (Util.IsEmptyString(strMsg)) {  
    			if (m_hintNetworkErrorDialog == null) {
    				m_hintNetworkErrorDialog = new HintNetwordErrorDialog(this);
    				RegisterDialog(m_hintNetworkErrorDialog);
    			}
    			m_hintNetworkErrorDialog.Show();			
    		}
    		else {
    			if (m_hintLoginErrorDialog == null) {
    				m_hintLoginErrorDialog = new HintLoginErrorDialog(this, strMsg);
    				RegisterDialog(m_hintLoginErrorDialog);
    			}
    			m_hintLoginErrorDialog.Show();	
    		}
    	}
    }
    //对话框返回
	public void OnDialogFinish(ManagedDialog dlg, int inClickedViewId) {
		if (dlg.GetDialogId() == m_hintNetworkErrorDialog.GetDialogId()) {
			//绑定手机
			if (inClickedViewId == DialogInterface.BUTTON_POSITIVE) {
		        WangcaiApp app = WangcaiApp.GetInstance();
		        app.Login();
			}
		}
		else if (dlg.GetDialogId() == m_hintLoginErrorDialog.GetDialogId()) {
			//绑定手机
			if (inClickedViewId == DialogInterface.BUTTON_POSITIVE) {
				finish();
			}
		}
	}
    public void OnUserInfoUpdate() {
    }

    HintNetwordErrorDialog m_hintNetworkErrorDialog;
    HintLoginErrorDialog m_hintLoginErrorDialog;
}
