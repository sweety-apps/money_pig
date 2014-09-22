package com.example.request;

import java.util.HashMap;
import java.util.Map;

public class Request_UpdateUserInfo extends Requester{

    @Override
	public Requester.RequestInfo GetRequestInfo() {
		if (m_requestInfo == null) {
			Map<String, String> mapRequestInfo = new HashMap<String, String>();
			mapRequestInfo.put("age", String.valueOf(m_nAge));
			mapRequestInfo.put("sex", String.valueOf(m_nSex));
			mapRequestInfo.put("interest", m_strInterest);
			m_requestInfo = new Requester.RequestInfo(Config.GetUpdateUserInfoUrl(), "", mapRequestInfo);
		}
		return m_requestInfo;
	}

    @Override
	public boolean ParseResponse(String strResponse) {
		if (!super.ParseResponse(strResponse) || m_rootObject == null) {
			return false;
		}

    	return true;
    }

    public void SetAge(int nAge) {
    	m_nAge = nAge;
    }
    public void SetSex(int nSex){
    	m_nSex = nSex;
    }
    public void SetInterest(String strInterest) {
    	m_strInterest = strInterest;
    }

    private int m_nAge;
    private int m_nSex;
    private String m_strInterest;
}
