package com.example.request;

import java.util.HashMap;
import java.util.Map;

public class Request_ExtractAliPay extends Requester{

    @Override
	public Requester.RequestInfo GetRequestInfo() {
		if (m_requestInfo == null) {
			Map<String, String> mapRequestInfo = new HashMap<String, String>();
			
			m_requestInfo = new Requester.RequestInfo(Config.GetExtractAlipayUrl(), "", mapRequestInfo);
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

}