package com.example.wangcai.base;

import android.app.Activity;
import android.os.Bundle;

public class ManagedActivity extends Activity{
	@Override  
	protected void onCreate(Bundle savedInstanceState) {  
		ActivityRegistry.GetInstance().PushActivity(this);
		super.onCreate(savedInstanceState);  
	}  

    @Override 
    protected void onDestroy() {
    	ActivityRegistry.GetInstance().PopActivity(this);
    	super.onDestroy();
    }
}
