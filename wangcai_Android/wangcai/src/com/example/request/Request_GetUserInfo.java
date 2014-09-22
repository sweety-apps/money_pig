package com.example.request;

import java.util.HashMap;
import java.util.Map;

public class Request_GetUserInfo extends Requester{

    @Override
	public Requester.RequestInfo GetRequestInfo() {
		if (m_requestInfo == null) {
			Map<String, String> mapRequestInfo = new HashMap<String, String>();
			
			m_requestInfo = new Requester.RequestInfo(Config.GetUserInfoUrl(), "", mapRequestInfo);
		}
		return m_requestInfo;
	}

    @Override
	public boolean ParseResponse(String strResponse) {
		if (!super.ParseResponse(strResponse) || m_rootObject == null) {
			return false;
		}
		
		m_nAge = Util.ReadJsonInt(m_rootObject, "age");
		m_nSex = Util.ReadJsonInt(m_rootObject, "interest");
		m_strInterest = Util.ReadJsonString(m_rootObject, "interest");

    	return true;
    }
    public int GetAge() {
    	return m_nAge;
    }
    public int GetSex(){
    	return m_nSex;
    }
    public String GetInterest() {
    	return m_strInterest;
    }

    private int m_nAge;
    private int m_nSex;
    private String m_strInterest;
}