package com.example.request;

import java.util.HashMap;
import java.util.Map;

public class Request_ResendCaptcha extends Requester{

    @Override
	public Requester.RequestInfo GetRequestInfo() {
		if (m_requestInfo == null) {
			Map<String, String> mapRequestInfo = new HashMap<String, String>();
			mapRequestInfo.put("token", m_strOldToken);
			mapRequestInfo.put("code_length", "5");	//todo втвх?
			
			m_requestInfo = new Requester.RequestInfo(Config.GetResendCaptchaUrl(), "", mapRequestInfo);
		}
		return m_requestInfo;
	}

    @Override
	public boolean ParseResponse(String strResponse) {
		if (!super.ParseResponse(strResponse) || m_rootObject == null) {
			return false;
		}

		m_strNewToken =Util.ReadJsonString(m_rootObject, "token");
    	return true;
    }

    public void SetOldToken(String strToken) {
    	m_strOldToken = strToken;
    }
    public String GetNewToken() {
    	return m_strNewToken;
    }
    
    private String m_strOldToken;
    private String m_strNewToken;
}
