package com.example.wangcai.activity;

import com.example.wangcai.R;
import com.example.wangcai.base.ManagedActivity;

import android.content.Intent;
import android.os.Bundle;
import android.webkit.WebView;

 public class WebviewActivity extends ManagedActivity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_web);
        
        InitView();
     }


    private void InitView() {
	   	WebView webView = (WebView)this.findViewById(R.id.web_view);
	   	webView.addJavascriptInterface(this, "ViewObject");
	   	
    	Intent intent = getIntent();
    	String strUrl = intent.getStringExtra("URL");
    	if (strUrl != null && !strUrl.endsWith("")) {
        	webView.loadUrl(strUrl);
    	}
    	
    	
    	
    }

    
}
