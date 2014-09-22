package com.example.wangcai.activity;

import com.example.wangcai.R;
import com.example.wangcai.base.ActivityHelper;
import com.example.wangcai.base.ActivityRegistry;
import com.example.wangcai.base.ManagedActivity;
import com.example.wangcai.base.ManagedDialogActivity;
import com.example.wangcai.dialog.CommonDialog;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;

public class RegisterSucceedActivity extends ManagedDialogActivity{

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

		ActivityRegistry.GetInstance().PushActivity(this);

        setContentView(R.layout.activity_register_succeed);        

        Intent intent = getIntent();
        int nBindDeviceCount = intent.getIntExtra(ActivityHelper.sg_strBindDeviceCount, 0);
		String strMsg = String.format(this.getString(R.string.hint_bind_phone_limit), nBindDeviceCount);
		//ActivityHelper.ShowToast(this, strMsg);
		
		CommonDialog dialog = new CommonDialog(this);
		dialog.SetInfo(getString(R.string.attention_text), strMsg, getString(R.string.ok_text), null);
		RegisterDialog(dialog);
		dialog.Show();
		
		findViewById(R.id.go_mainpage_button).setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View v) {
				//·µ»ØÖ÷Ò³Ãæ
				ActivityRegistry reg = ActivityRegistry.GetInstance();
				int nCount = reg.GetActivityCount();
				for (int i = nCount - 1; i >= 0; --i) {
					Activity ac = reg.GetActivity(i);
					if (!(ac instanceof MainActivity)) {
						ac.finish();
					}
					else {
						break;
					}
				}
			}});
     }

    @Override 
    protected void onDestroy() {
    	ActivityRegistry.GetInstance().PopActivity(this);
    	super.onDestroy();
    }
}
