package com.example.wangcai.activity;

import com.example.wangcai.R;
import com.example.wangcai.base.ActivityHelper;
import com.example.wangcai.base.ManagedActivity;
import com.example.wangcai.ctrls.ExchageGiftItem;

import android.os.Bundle;
import android.view.View;
import android.view.ViewGroup;
import android.view.View.OnClickListener;
import android.widget.Button;

public class ExchageGiftActivity extends ManagedActivity implements ExchageGiftItem.ExchageItemEvent {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_exchage_gift);        

        InitView();
     }
    

	public void OnDoExchage(String strItemName) {
		
	}


    private void InitView() {
    	((Button)this.findViewById(R.id.task_detail)).setOnClickListener(new OnClickListener(){
    		public void onClick(View v) {
    			ActivityHelper.ShowDetailActivity(ExchageGiftActivity.this);
    		}
    	});
    	
    	ViewGroup parentView = (ViewGroup)this.findViewById(R.id.item_list);
    	AddItem(parentView, "JingDong", R.drawable.gift, "50元京东礼品卡", 50, 32);
    	AddItem(parentView, "Xunlei", R.drawable.gift, "迅雷白金会员月卡", 10, 32);
    }

    private void AddItem(ViewGroup parentView, String strItemName, int nIconId, String strName, int nPrice, int nRemainCount) {
    	ExchageGiftItem item = new ExchageGiftItem(strItemName);
    	item.SetItemEventLinstener(this);
    	View view = item.Create(getApplicationContext(), nIconId, strName, nPrice, nRemainCount);
    	parentView.addView(view);
    }
}
