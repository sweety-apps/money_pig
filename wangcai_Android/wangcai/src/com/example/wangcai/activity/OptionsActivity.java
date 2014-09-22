package com.example.wangcai.activity;

import com.example.wangcai.R;
import com.example.wangcai.base.ManagedActivity;

import android.os.Bundle;

public class OptionsActivity extends ManagedActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_options);
        
        InitView();
     }

    private void InitView()
    {
    }
}
