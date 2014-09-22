package com.example.request;
import java.util.HashMap;
import java.util.Map;

import org.json.JSONArray;
import org.json.JSONObject;

import com.example.wangcai.base.SystemInfo;


public class Request_Login extends Requester{	
	public Request_Login() {
	}

    @Override
	public Requester.RequestInfo GetRequestInfo() {
		if (m_requestInfo == null) {
			Map<String, String> mapRequestInfo = new HashMap<String, String>();
			mapRequestInfo.put("idfa", "3461AC00-92DC-5B5C-9464-7971F01F4961");
			mapRequestInfo.put("mac", SystemInfo.GetMacAddress());		
			mapRequestInfo.put("timestamp", String.valueOf(System.currentTimeMillis()));
			m_requestInfo = new Requester.RequestInfo(Config.GetLoginUrl(), "", mapRequestInfo);
		}
		return m_requestInfo;
	}
    

    @Override
	public boolean ParseResponse(String strResponse) {
		if (!super.ParseResponse(strResponse) || m_rootObject == null) {
			return false;
		}
		
		m_bNeedForceUpdate = (Util.ReadJsonInt(m_rootObject, "force_update") != 0);

		RequestManager requestManager = RequestManager.GetInstance();
		requestManager.SetSessionId(Util.ReadJsonString(m_rootObject, "session_id"));
		requestManager.SetDeviceId(Util.ReadJsonString(m_rootObject, "device_id"));
		requestManager.SetUserId(Util.ReadJsonInt(m_rootObject, "userid"));
		
		m_userInfo = ReadUserInfo();
		m_extractInfo = ReadExtractInfo();
		m_taskListInfo = ReadTaskListInfo();

    	return true;
	}
    
    //读用户信息
    private UserInfo ReadUserInfo() {
    	UserInfo userInfo = null;

    	try {
    		userInfo = new UserInfo();
			
			userInfo.SetNextLevel(Util.ReadJsonInt(m_rootObject, "exp_next_level"));
			userInfo.SetCanWithdrawal(Util.ReadJsonInt(m_rootObject, "no_withdraw") == 0);
			
			userInfo.SetShareIncome(Util.ReadJsonInt(m_rootObject, "shared_income"));
			
			userInfo.SetTotalOutgo(Util.ReadJsonInt(m_rootObject, "outgo"));
			
			userInfo.SetTotalIncome(Util.ReadJsonInt(m_rootObject, "income"));
			userInfo.SetRecentIncome(Util.ReadJsonInt(m_rootObject, "recent_income"));
			//Util.ReadJsonInt(m_rootObject, "in_review");
			 Util.ReadJsonInt(m_rootObject, "polling_interval");	//todo
			 Util.ReadJsonInt(m_rootObject, "offerwall_income");	//todo
			
			userInfo.SetCurrentLevel(Util.ReadJsonInt(m_rootObject, "level"));
			userInfo.SetUserId(Util.ReadJsonInt(m_rootObject, "userid"));
			userInfo.SetBalance(Util.ReadJsonInt(m_rootObject, "balance"));
			userInfo.SetNextLevelExperience(Util.ReadJsonInt(m_rootObject, "exp_next_level"));
			userInfo.SetCurrentExperience(Util.ReadJsonInt(m_rootObject, "exp_current"));
			
			userInfo.SetInviteCode(Util.ReadJsonString(m_rootObject, "invite_code"));
			userInfo.SetInviter(Util.ReadJsonString(m_rootObject, "inviter"));
			
			userInfo.SetDeviceId(Util.ReadJsonString(m_rootObject, "device_id"));
			userInfo.SetPhoneNumber(Util.ReadJsonString(m_rootObject, "phone"));
    	}catch(Exception e) {
    		userInfo = null;
    	}
    	return userInfo;
    }
    //读提取现金的设置
    private ExtractInfo ReadExtractInfo() {
    	ExtractInfo extractInfo = new ExtractInfo();

		try {
			JSONArray jsonArray = m_rootObject.getJSONArray("withdraw_config");
		
			int nLength = jsonArray.length();
			for (int i = 0;  i < nLength; i++) {
				JSONObject itemObj = jsonArray.getJSONObject(i);

				int nType = Util.ReadJsonInt(itemObj, "type");
				ExtractInfo.ExtractType enumType = ExtractInfo.ExtractType.ExtractType_Phone;
				switch (nType) {
				case 1:
					enumType = ExtractInfo.ExtractType.ExtractType_Phone;
					break;
				case 2:
					enumType = ExtractInfo.ExtractType.ExtractType_AliPay;
					break;
				case 3:
					enumType = ExtractInfo.ExtractType.ExtractType_QBi;
					break;
				}
				ExtractInfo.ExtractItem extractItem = new ExtractInfo.ExtractItem(enumType);
				
				JSONArray subItemArray = itemObj.getJSONArray("info");
				int nSubItemCount = subItemArray.length();
				for (int j = 0; j < nSubItemCount; j++) {
					JSONObject subItemObj = subItemArray.getJSONObject(j);
					int nAmount = Util.ReadJsonInt(subItemObj, "amount");
					int nPrice = Util.ReadJsonInt(subItemObj, "price");
					int nHot = Util.ReadJsonInt(subItemObj, "hot");
					ExtractInfo.ExtractSubItem subItem = new ExtractInfo.ExtractSubItem(nAmount, nPrice, nHot != 0);
					extractItem.m_subItems.add(subItem);
				}
				extractInfo.AddItem(extractItem);
			}
		}catch(Exception e) {
			extractInfo = null;
		}
    	return extractInfo;
    }
    //读任务列表
    private TaskListInfo ReadTaskListInfo() {
    	TaskListInfo taskListInfo = new TaskListInfo();

		try {
			JSONArray jsonArray = m_rootObject.getJSONArray("task_list");
			int nLength = jsonArray.length();
			for (int i = 0;  i < nLength; i++) {
				JSONObject itemObj = jsonArray.getJSONObject(i);
				TaskListInfo.TaskInfo taskInfo = new TaskListInfo.TaskInfo();
				taskInfo.m_nTaskType = Util.ReadJsonInt(itemObj, "type");
				taskInfo.m_nTaskStatus = Util.ReadJsonInt(itemObj, "status");
				taskInfo.m_nId = Util.ReadJsonInt(itemObj, "id");
				taskInfo.m_nLevel = Util.ReadJsonInt(itemObj, "level");
				taskInfo.m_nMoney = Util.ReadJsonInt(itemObj, "money");				
				taskInfo.m_strTitle = Util.ReadJsonString(itemObj, "title");
				taskInfo.m_strDescription = Util.ReadJsonString(itemObj, "desc");
				taskInfo.m_strIntroduction = Util.ReadJsonString(itemObj, "intro");
				taskInfo.m_strIconUrl = Util.ReadJsonString(itemObj, "icon");
				taskInfo.m_strRedirctUrl = Util.ReadJsonString(itemObj, "rediect_url");
				taskListInfo.AddTaskInfo(taskInfo);
			}
		}catch (Exception e) {
			taskListInfo = null;
		}
		return taskListInfo;
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
    public boolean GetNeedForceUpdate() {
    	return m_bNeedForceUpdate;
    }

    private boolean m_bNeedForceUpdate;
	private UserInfo m_userInfo = null;
	private TaskListInfo m_taskListInfo = null;	
	private ExtractInfo m_extractInfo = null;
}


