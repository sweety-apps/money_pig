package com.example.wangcai;

import java.util.ArrayList;

import com.example.request.Config;
import com.example.request.ExtractInfo;
import com.example.request.RequestManager;
import com.example.request.Request_Login;
import com.example.request.Requester;
import com.example.request.RequesterFactory;
import com.example.request.TaskListInfo;
import com.example.request.UserInfo;
import com.example.wangcai.base.SystemInfo;

import android.content.Context;
import android.telephony.TelephonyManager;

public class WangcaiApp implements RequestManager.IRequestManagerCallback{
	public interface WangcaiAppEvent {
		void OnLoginComplete(int nResult, String strMsg);
		void OnUserInfoUpdate();
	}
	public class TaskInfo {
		public int m_nId;
		public int m_nType;
		public String m_strTitle;
		public String m_strHintText;
		public String m_strIcon;
		public boolean m_bComplete;
		public int m_nMoney;
	}
	
	private static WangcaiApp m_sWangcaiApp = new WangcaiApp();
	public static WangcaiApp GetInstance() {
		return m_sWangcaiApp;
	}

	public void Initialize(Context context) {
		m_AppContext =  context;
		
		Config.Initlialize(Config.EnvType.EnvType_Formal);
		
		SystemInfo.Initialize(context);
		
		ConfigCenter.GetInstance().Initialize(context);
		RequestManager.GetInstance().Initialize(context.getResources().openRawResource(R.raw.cert));
	}

	public boolean NeedForceUpdate() {
		return m_bNeedForceUpdate;
	}
	
	public int GetTaskCount() {
		return m_listTaskInfos.size();
	}
	TaskInfo GetTaskInfo(int nIndex){
		if (nIndex < 0 || nIndex >= m_listTaskInfos.size()) {
			return null;
		}
		return m_listTaskInfos.get(nIndex);
	}
	
	public boolean HasLogin() {
		return m_bHasLogin;
	}

	public void OnRequestComplete(int nRequestId, Requester req) {
		if (req instanceof Request_Login) {
			Request_Login loginRequester = (Request_Login)req;
			m_bNeedForceUpdate = loginRequester.GetNeedForceUpdate();
			m_strHintMsg = loginRequester.GetMsg();
			m_userInfo = loginRequester.GetUserInfo();
			m_extractInfo = loginRequester.GetExtractInfo();
			m_taskListInfo = loginRequester.GetTaskListInfo();

			@SuppressWarnings("unchecked")
			ArrayList<WangcaiAppEvent> listEventLinsteners = (ArrayList<WangcaiAppEvent>) m_listEventLinsteners.clone();
			for (WangcaiAppEvent eventLinstener: listEventLinsteners) {
				eventLinstener.OnLoginComplete(loginRequester.GetResult(), loginRequester.GetMsg());
			}
		}
	}
	//µÇÂ½
	public boolean Login() {
		RequestManager requestManager = RequestManager.GetInstance();
		Request_Login request = (Request_Login)RequesterFactory.NewRequest(RequesterFactory.RequestType.RequestType_Login);
		requestManager.SendRequest(request, true, this);
		return true;
	}
	public Context GetContext() {
		return m_AppContext;
	}
	public void AddEventLinstener(WangcaiAppEvent eventLinstener) {
		int nCount = m_listEventLinsteners.size();
		for (int i = 0; i < nCount; ++i) {
			if (m_listEventLinsteners.get(i) == eventLinstener) {
				return;
			}
		}
		m_listEventLinsteners.add(eventLinstener);
	}
	public void RemoveEventLinstener(WangcaiAppEvent eventLinstener) {
		int nCount = m_listEventLinsteners.size();
		for (int i = 0; i < nCount; ++i) {
			if (m_listEventLinsteners.get(i) == eventLinstener) {
				m_listEventLinsteners.remove(i);
				break;
			}
		}
	}
	public String GetPhoneId() {
		if (m_strPhoneId == null) {
			TelephonyManager TelephonyMgr = (TelephonyManager)m_AppContext.getSystemService(Context.TELEPHONY_SERVICE); 
			m_strPhoneId = TelephonyMgr.getDeviceId(); 
		}
		return m_strPhoneId;
	}
	public String GetHintMsg() {
		return m_strHintMsg;
	}
	public void UpdateUserInfo(UserInfo  userInfo) {
		m_userInfo = userInfo;
		@SuppressWarnings("unchecked")
		ArrayList<WangcaiAppEvent> listEventLinsteners = (ArrayList<WangcaiAppEvent>) m_listEventLinsteners.clone();
		for (WangcaiAppEvent eventLinstener: listEventLinsteners) {
			eventLinstener.OnUserInfoUpdate();
		}		
	}
    public UserInfo GetUserInfo() {
    	return m_userInfo;
    }
    public ExtractInfo GetExtractInfo() {
    	return m_extractInfo;
    }
    public TaskListInfo GetTaskListInfo() {
    	return m_taskListInfo;
    }
    
	private UserInfo m_userInfo = null;
	private TaskListInfo m_taskListInfo = null;	
	private ExtractInfo m_extractInfo = null;

	private String m_strHintMsg;
	private String m_strPhoneId;	
	private boolean m_bNeedForceUpdate = false;
	private boolean m_bHasLogin;
	private ArrayList<TaskInfo> m_listTaskInfos;

		
	private Context m_AppContext;

	
	private ArrayList<WangcaiAppEvent> m_listEventLinsteners = new ArrayList<WangcaiAppEvent>();
}
