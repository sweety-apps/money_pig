package com.example.request;

import java.util.HashMap;
import java.util.Map;


public class Request_Lottery extends Requester{

    @Override
	public Requester.RequestInfo GetRequestInfo() {
		if (m_requestInfo == null) {
			Map<String, String> mapRequestInfo = new HashMap<String, String>();
			m_requestInfo = new Requester.RequestInfo(Config.GetLotteryUrl(), "", mapRequestInfo);
		}
		return m_requestInfo;
	}

    @Override
	public boolean ParseResponse(String strResponse) {
		if (!super.ParseResponse(strResponse) || m_rootObject == null) {
			return false;
		}
		m_nBonus =Util.ReadJsonInt(m_rootObject, "award");
    	return true;
    }
    public int GetBouns() {
    	return m_nBonus;
    }
    
    private int m_nBonus;
}
