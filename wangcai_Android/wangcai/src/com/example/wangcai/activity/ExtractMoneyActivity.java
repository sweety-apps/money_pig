package com.example.wangcai.activity;

import com.example.wangcai.R;
import com.example.wangcai.R.drawable;
import com.example.wangcai.R.id;
import com.example.wangcai.R.layout;
import com.example.wangcai.base.ActivityHelper;
import com.example.wangcai.base.ManagedActivity;
import com.example.wangcai.ctrls.ExtraItem;

import android.os.Bundle;
import android.view.View;
import android.view.ViewGroup;
import android.view.View.OnClickListener;
import android.widget.Button;

public class ExtractMoneyActivity extends ManagedActivity implements ExtraItem.ExtractItemEvent{

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_extract);        

        InitView();
     }


    public void OnDoExtract(String strItemName) {
    	
    }

    private void InitView() {
    	((Button)this.findViewById(R.id.task_detail)).setOnClickListener(new OnClickListener(){
    		public void onClick(View v) {
    			ActivityHelper.ShowDetailActivity(ExtractMoneyActivity.this);
    		}
    	});
    	
    	ViewGroup parentView = (ViewGroup)this.findViewById(R.id.item_list);
    	AddItem(parentView, "PhoneBill", R.drawable.extract_phone, "手机话费");
    	AddItem(parentView, "AliPay", R.drawable.extract_alipay, "支付宝");
    	AddItem(parentView, "Qbi", R.drawable.extract_qbi, "腾讯Q币");
    }

    private void AddItem(ViewGroup parentView, String strItemName, int nIconId, String strName) {
    	ExtraItem item = new ExtraItem(strItemName);
    	item.SetItemEventLinstener(this);
    	View view = item.Create(getApplicationContext(), nIconId, strName);
    	parentView.addView(view);
    }
}
