package com.example.request;

import java.util.HashMap;
import java.util.Map;


public class Request_BindPhone extends Requester{

	public void SetPhoneNumber(String strPhoneNumber) {
		m_strPhoneNumber = strPhoneNumber; 
	}
    @Override
	public Requester.RequestInfo GetRequestInfo() {
		if (m_requestInfo == null) {
			Map<String, String> mapRequestInfo = new HashMap<String, String>();
			mapRequestInfo.put("phone", m_strPhoneNumber);
			m_requestInfo = new Requester.RequestInfo(Config.GetSendCaptchaUrl(), "", mapRequestInfo);
		}
		return m_requestInfo;
	}

    @Override
	public boolean ParseResponse(String strResponse) {
		if (!super.ParseResponse(strResponse) || m_rootObject == null) {
			return false;
		}
		
		m_strToken =Util.ReadJsonString(m_rootObject, "token");
    	return true;
    }
    public String GetToken() {
    	return m_strToken;
    }
    
    private String m_strPhoneNumber;
    private String m_strToken;
}
