package com.example.wangcai.activity;

import com.example.request.RequestManager;
import com.example.request.Request_UpdateInviter;
import com.example.request.Requester;
import com.example.request.RequesterFactory;
import com.example.request.UserInfo;
import com.example.request.Util;
import com.example.wangcai.R;
import com.example.wangcai.WangcaiApp;
import com.example.wangcai.base.ActivityHelper;
import com.example.wangcai.base.ManagedActivity;
import com.example.wangcai.ctrls.TitleCtrl;

import android.content.Context;
import android.os.Bundle;
import android.view.View;
import android.view.WindowManager;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.TextView;

public class InviteActivity extends ManagedActivity implements RequestManager.IRequestManagerCallback{

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_invite);

        AttachEvents();
        InitView();
     }

    private void InitView() {
    	//二维码
    	
    	WangcaiApp app = WangcaiApp.GetInstance();
    	UserInfo userInfo = app.GetUserInfo();
    	
    	//邀请码
    	String strInvideCode = userInfo.GetInviteCode();
    	if (!Util.IsEmptyString(strInvideCode)) {
        	TextView inviteCodeView = (TextView)this.findViewById(R.id.invite_code);    		
    		inviteCodeView.setText(strInvideCode);

        	ImageView qrcodeView = (ImageView)this.findViewById(R.id.qrcode);

            WindowManager wm = (WindowManager) getSystemService(Context.WINDOW_SERVICE);  
            int nScreenWidth = wm.getDefaultDisplay().getWidth();  
            
        	qrcodeView.setImageBitmap(Util.CreateQRCodeBitmap(strInvideCode, nScreenWidth * 3 / 4));
    	}

    	//邀请链接
    	TextView invateUrlView = (TextView)this.findViewById(R.id.invite_url);
    	String strInviteUrl = userInfo.GetInviteUrl();
    	if (!Util.IsEmptyString(strInviteUrl)) {
    		invateUrlView.setText(strInviteUrl);
    	}
    }
    
    private void AttachEvents() {    	
    	final View invitePanel = this.findViewById(R.id.invite_panel);
    	final View inviteCodePanel = this.findViewById(R.id.invite_code_panel);
    	
    	//邀请好友按钮
    	((Button)this.findViewById(R.id.invite_other)).setOnClickListener(new OnClickListener() {
            public void onClick(View v) {
            	invitePanel.setVisibility(View.VISIBLE);
            	inviteCodePanel.setVisibility(View.GONE);
            }
        });

    	//谁邀请我按钮
    	((Button)this.findViewById(R.id.the_one_invite_me)).setOnClickListener(new OnClickListener() {
            public void onClick(View v) {
            	invitePanel.setVisibility(View.GONE);
            	inviteCodePanel.setVisibility(View.VISIBLE);
            }
        });

    	//复制到剪贴板按钮
    	((Button)this.findViewById(R.id.copy_url_button)).setOnClickListener(new OnClickListener() {
            public void onClick(View v) {
            }
        });
    	
    	//分享赚红包按钮
    	((Button)this.findViewById(R.id.share_button)).setOnClickListener(new OnClickListener() {
            public void onClick(View v) {
            }
        });
    	
    	//领取赚x元按钮(绑定邀请人)
    	((Button)this.findViewById(R.id.get_reward_button)).setOnClickListener(new OnClickListener() {
            public void onClick(View v) {
            	EditText edit = (EditText)findViewById(R.id.code_editor);
            	String strInviteCode = edit.getText().toString();
            	if (Util.IsEmptyString(strInviteCode)) {
            		ActivityHelper.ShowToast(InviteActivity.this, R.string.hint_invlide_invite_code);
            		return;
            	}
				RequestManager requestManager = RequestManager.GetInstance();
				Request_UpdateInviter request = (Request_UpdateInviter)RequesterFactory.NewRequest(RequesterFactory.RequestType.RequestType_UpdateInviter);
				request.SetInviter(strInviteCode);
				requestManager.SendRequest(request, true, InviteActivity.this);
            }
        });
    }
    

	public void OnRequestComplete(int nRequestId, Requester req) {
		if (req instanceof Request_UpdateInviter) {
			int nResult = req.GetResult();
			String strMsg = req.GetMsg();
			if (nResult == 0) {
        		ActivityHelper.ShowToast(InviteActivity.this, R.string.hint_bind_invite_code_succeed);	
        		//nfoxtodo 加钱
			}
			else {
				if (Util.IsEmptyString(strMsg)) {
            		ActivityHelper.ShowToast(InviteActivity.this, R.string.hint_bind_invite_code_fail);					
				}
				else {
            		ActivityHelper.ShowToast(InviteActivity.this, strMsg);					
				}
			}
		}
	}

    @Override 
    protected void onDestroy() {
    	super.onDestroy();
    	TitleCtrl titleCtrl = (TitleCtrl)this.findViewById(R.id.title);
    	titleCtrl.SetEventLinstener(null);    	
    }
}
