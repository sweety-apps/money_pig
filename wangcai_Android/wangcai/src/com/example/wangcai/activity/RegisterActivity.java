package com.example.wangcai.activity;


import java.lang.ref.WeakReference;
import java.util.Timer;
import java.util.TimerTask;

import com.example.request.Request_VerifyCaptcha;
import com.example.request.RequestManager;
import com.example.request.Request_BindPhone;
import com.example.request.Request_ResendCaptcha;
import com.example.request.Requester;
import com.example.request.RequesterFactory;
import com.example.request.UserInfo;
import com.example.request.Util;
import com.example.wangcai.R;
import com.example.wangcai.WangcaiApp;
import com.example.wangcai.base.ActivityHelper;
import com.example.wangcai.base.BuildSetting;
import com.example.wangcai.base.ManagedActivity;
import com.example.wangcai.base.SmsReader;
import com.example.wangcai.base.ViewDrawer;
import com.example.wangcai.base.ViewHelper;

import android.app.ProgressDialog;
import android.content.Context;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.text.Editable;
import android.text.TextWatcher;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.View.OnFocusChangeListener;
import android.view.inputmethod.InputMethodManager;
import android.widget.EditText;
import android.widget.TextView;


public class RegisterActivity extends ManagedActivity implements OnClickListener, 
														RequestManager.IRequestManagerCallback,
														SmsReader.SmsEvent{

	private final static int sg_nUpdateMsg = 1818;
	private final static int sg_nTimerElapse = 1000;
	private final static int sg_nTotalCountDownSeconds = 60;
	
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_register);        

        SmsReader.AddListener(this);
        
        InitView();
    }
    
    
    private void InitView() {
    	//"获取验证码"
    	View viewGetCaptchaButton = findViewById(R.id.get_captcha_button);
    	ViewHelper.SetStateViewBkg(viewGetCaptchaButton, this, R.drawable.register_get_captcha, R.drawable.register_get_captcha_down, 0);
        viewGetCaptchaButton.setOnClickListener(this);
        
        //下一步按钮
        final View viewNextButton = findViewById(R.id.next_button);
        viewNextButton.setEnabled(false);
        
        ViewHelper.SetStateViewBkg(viewNextButton, this, R.drawable.register_next_button_normal, R.drawable.register_next_button_down, R.drawable.register_next_button_normal, R.drawable.register_next_button_disable);
        //m_viewerDrawer.AttachView(viewNextButton, R.drawable.register_next_button_normal, R.drawable.register_next_button_down, R.drawable.register_next_button_disable);
        viewNextButton.setOnClickListener(this);
        
        //"重新发送"
        findViewById(R.id.resend_text).setOnClickListener(this);
        
        //手机号编辑框
        final EditText editPhoneNumber = (EditText)this.findViewById(R.id.phone_number_edit);
        editPhoneNumber.setOnFocusChangeListener(new OnFocusChangeListener() {
			@Override
			public void onFocusChange(View v, boolean hasFocus) {
				if (!hasFocus) {
					InputMethodManager imm = (InputMethodManager)getSystemService(Context.INPUT_METHOD_SERVICE); 
					imm.hideSoftInputFromWindow(editPhoneNumber.getWindowToken(),0);
				}
			}});
        
        //验证码编辑框
        final EditText editCaptcha = (EditText)this.findViewById(R.id.captcha_edit);
        editCaptcha.addTextChangedListener(new TextWatcher(){  
        	@Override  
        	public void afterTextChanged(Editable s) {  
        	}  
  
        	@Override  
        	public void beforeTextChanged(CharSequence s, int start, int count, int after) {                
        	}  
  
        	@Override  
        	public void onTextChanged(CharSequence s, int start, int before, int count) {
        		String strMsg = s.toString();
        		if (strMsg.length() == 5) {
        			viewNextButton.setEnabled(true);
        		}
        		else {
        			viewNextButton.setEnabled(false);
        		}
        	}          
        });
    }

 
    
	@Override
	public void onClick(View v) {
		int nId = v.getId();
		if (nId == R.id.get_captcha_button) {
			//获取验证码按钮
	        EditText editPhoneNumber = (EditText)this.findViewById(R.id.phone_number_edit);
	        String strPhoneNumber = editPhoneNumber.getText().toString();
	        if (!CheckPhoneNumber(strPhoneNumber)) {
	        	ActivityHelper.ShowToast(this, R.string.hint_invlide_phoneNumber);
	        	return;
	        }

	        Request_BindPhone req = (Request_BindPhone)RequesterFactory.NewRequest(RequesterFactory.RequestType.RequestType_BindPhone);
	        req.SetPhoneNumber(strPhoneNumber);
	        
	        RequestManager.GetInstance().SendRequest(req, false, this);
	        
	        m_progressDialog = ActivityHelper.ShowLoadingDialog(this);
		}
		else if (nId == R.id.next_button) {
			//下一步按钮
	        EditText editCaptcha = (EditText)this.findViewById(R.id.captcha_edit);
	        String strCaptcha = editCaptcha.getText().toString();
	        if (strCaptcha.length() != 5) {
	        	ActivityHelper.ShowToast(this, R.string.hint_invite_captcha);
	        	return;	        	
	        }

	        Request_VerifyCaptcha req = (Request_VerifyCaptcha)RequesterFactory.NewRequest(RequesterFactory.RequestType.RequestType_VerifyCaptcha);
	        req.SetToken(m_strToken);
	        req.SetCaptcha(strCaptcha);
	        RequestManager.GetInstance().SendRequest(req, false, this);
	        
	        m_progressDialog = ActivityHelper.ShowLoadingDialog(this, getString(R.string.hint_verifying_captcha));
		}
		else if (nId == R.id.resend_text) {
			//重新发送
	        Request_ResendCaptcha req = (Request_ResendCaptcha)RequesterFactory.NewRequest(RequesterFactory.RequestType.RequestType_ResendCaptcha);
	        req.SetOldToken(m_strToken);
	        RequestManager.GetInstance().SendRequest(req, false, this);	

	        m_progressDialog = ActivityHelper.ShowLoadingDialog(this);
		}
	}

	private void OnRequestCaptcha() {
		TextView view = (TextView)findViewById(R.id.count_down_text);
		view.setText(String.format(getString(R.string.bind_phone_count_down), m_nRemainSeconds));
		view.setVisibility(View.VISIBLE);

		findViewById(R.id.resend_text).setVisibility(View.GONE);
		findViewById(R.id.get_captcha_button).setVisibility(View.GONE);
		findViewById(R.id.captcha_edit).setVisibility(View.VISIBLE);
		StartTimer();		
	}
	private void OnRequestCaptchaComplete(int nResult, String strMsg, String strToken) {
		if (nResult == 0) {
			m_strToken = strToken;
			OnRequestCaptcha();
		}
		else {
			if (Util.IsEmptyString(strMsg)) {
				ActivityHelper.ShowToast(this, R.string.hint_send_sms_fail);
			}
			else {
				ActivityHelper.ShowToast(this, strMsg);
			}
		}		
	}
	
	@Override
	public void OnRequestComplete(int nRequestId, Requester req) {
		if (m_progressDialog != null) {
			m_progressDialog.dismiss();
			m_progressDialog = null;
		}
		if (req instanceof Request_BindPhone) {
			//请求验证码
			Request_BindPhone bindReq = (Request_BindPhone)req;
			OnRequestCaptchaComplete(req.GetResult(), req.GetMsg(), bindReq.GetToken());
		}
		else if (req instanceof Request_ResendCaptcha){
			//重发验证码
			Request_ResendCaptcha resendReq = (Request_ResendCaptcha)req;
			OnRequestCaptchaComplete(req.GetResult(), req.GetMsg(), resendReq.GetNewToken());			
		}
		else if (req instanceof Request_VerifyCaptcha){
			//检查验证码
			Request_VerifyCaptcha verifyReq = (Request_VerifyCaptcha)req;
			int nResult = verifyReq.GetResult();
			if (nResult == 0) {
				UserInfo userInfo = WangcaiApp.GetInstance().GetUserInfo();
				userInfo.SetUserId(verifyReq.GetUserId());
				userInfo.SetInviteCode(verifyReq.GetInviteCode());
				userInfo.SetInviter(verifyReq.GetInviter());
				userInfo.SetBalance(verifyReq.GetBalance());
				userInfo.SetTotalIncome(verifyReq.GetIncome());
				userInfo.SetTotalOutgo(verifyReq.GetOutgo());
				userInfo.SetShareIncome(verifyReq.GetShareIncome());
				//更新UserInfo以刷新界面
				WangcaiApp.GetInstance().UpdateUserInfo(userInfo);
				
				int nBindDeviceCount = verifyReq.GetBindDeviceCount();
				ActivityHelper.ShowRegisterSucceedActivity(this, nBindDeviceCount);
			}
			else {
				String strMsg = verifyReq.GetMsg();
				if (Util.IsEmptyString(strMsg)) {
					ActivityHelper.ShowToast(this, R.string.hint_verify_captcha_fail);
				}
				else {
					ActivityHelper.ShowToast(this, strMsg);
				}
			}			
		}
	}

    
	private boolean CheckPhoneNumber(String strPhoneNumber) {
        if (strPhoneNumber.length() != 11) {
        	return false;
        }
        if (!isNumeric(strPhoneNumber)) {
        	return false;
        }
		return true;
	}
	private boolean isNumeric(String str){  
		for (int i = str.length() - 1; i>=0; i--){    
			if (!Character.isDigit(str.charAt(i))){  
				return false;  
			}  
		}  
		return true;  
	} 
	

    @Override 
    protected void onDestroy() {
    	SmsReader.RemoveListener(this);
    	StopTimer();
    	//m_viewerDrawer.DetachAll();
    	super.onDestroy();
    }

    private static class TimerHandler extends Handler {
    	TimerHandler(RegisterActivity owner) {
    		m_owner = new WeakReference<RegisterActivity>(owner);
    	}
		@Override  
		public void handleMessage(Message msg) {  
			if (msg.what == sg_nUpdateMsg) {
				RegisterActivity activity = m_owner.get();
				if (activity == null) {
					return;
				}
				activity.m_nRemainSeconds--;
				if (activity.m_nRemainSeconds < 0) {
					activity.StopTimer();
					activity.findViewById(R.id.resend_text).setVisibility(View.VISIBLE);
					activity.findViewById(R.id.count_down_text).setVisibility(View.GONE);
					return;
				}
				String strText = String.format(activity.getString(R.string.bind_phone_count_down), activity.m_nRemainSeconds);
		    	TextView countDownText = (TextView)activity.findViewById(R.id.count_down_text);
				countDownText.setText(strText);
			}  
		}  
		private WeakReference<RegisterActivity> m_owner;
    }
    private void StartTimer() {   
    	m_nRemainSeconds = sg_nTotalCountDownSeconds;
    	if (m_handler == null) {
	    	m_handler = new TimerHandler(this);
    	}

    	if (m_timerTask == null) {  
    		m_timerTask = new TimerTask() {  
    			@Override  
    			public void run() {
	    			sendMessage(sg_nUpdateMsg);  
    			}
    		}; 
    	} 
    	if (m_timer == null) {  
    		m_timer = new Timer();  
        }  
    	m_timer.schedule(m_timerTask, 0, sg_nTimerElapse);
    }
    private void StopTimer() {
    	if (m_timer != null) {  
    		m_timer.cancel();  
    		m_timer = null;  
		}  
		 
		if (m_timerTask != null) {  
			m_timerTask.cancel();  
			m_timerTask = null;  
		}
	}
    public void sendMessage(int id){  
        if (m_handler != null) {  
            Message message = Message.obtain(m_handler, id);     
            m_handler.sendMessage(message);   
        }  
    } 
    


    //您的验证码是：【22425】。请不要把验证码泄露给其他人。如非本人操作，可不用理会！【旺财】
  	public void OnNewSms(String strMsg){
  		//收到短信
   	   if (BuildSetting.sg_bIsDebug) {
  		   strMsg = "您的验证码是：【22425】。请不要把验证码泄露给其他人。如非本人操作，可不用理会！【旺财】";
  	   }
  	   if (!strMsg.contains("【旺财】")) {
  		   return;
  	   }

  	   int nIndex = strMsg.indexOf("验证码");
  	   if (nIndex < 0){
  		   return;
  	   }
  	   
  	   int nBeginIndex = strMsg.indexOf("【", nIndex);
  	   int nEndIndex = strMsg.indexOf("】", nBeginIndex);
  	   String strCode = strMsg.substring(nBeginIndex + 1, nEndIndex);

         EditText editCaptcha = (EditText)this.findViewById(R.id.captcha_edit);
         editCaptcha.setText(strCode);
  	}
  	
  
    //data member
    private int m_nRemainSeconds = sg_nTotalCountDownSeconds;
    private Handler m_handler = null;
    private Timer m_timer = null;  
    private TimerTask m_timerTask = null;  

    private ProgressDialog m_progressDialog;
	//private ViewDrawer m_viewerDrawer = new ViewDrawer();
	private String m_strToken;
}
