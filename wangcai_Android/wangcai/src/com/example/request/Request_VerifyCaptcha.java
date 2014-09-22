package com.example.request;

import java.util.HashMap;
import java.util.Map;

public class Request_VerifyCaptcha  extends Requester{

    @Override
	public Requester.RequestInfo GetRequestInfo() {
		if (m_requestInfo == null) {
			Map<String, String> mapRequestInfo = new HashMap<String, String>();
			mapRequestInfo.put("token", m_strToken);
			mapRequestInfo.put("sms_code", m_strCaptcha);
			m_requestInfo = new Requester.RequestInfo(Config.GetVerifyCaptchaUrl(), "", mapRequestInfo);
		}
		return m_requestInfo;
	}

    @Override
	public boolean ParseResponse(String strResponse) {
		if (!super.ParseResponse(strResponse) || m_rootObject == null) {
			return false;
		}

		m_nUserId =Util.ReadJsonInt(m_rootObject, "userid");
		m_strInviteCode =Util.ReadJsonString(m_rootObject, "invite_code");
		m_strInviter =Util.ReadJsonString(m_rootObject, "inviter");
		m_nBalance =Util.ReadJsonInt(m_rootObject, "balance");
		m_nIncome =Util.ReadJsonInt(m_rootObject, "income");
		m_Outgo =Util.ReadJsonInt(m_rootObject, "outgo");
		m_nShareIncome =Util.ReadJsonInt(m_rootObject, "shared_income");
		m_nBindDeviceCount =Util.ReadJsonInt(m_rootObject, "total_device");
    	return true;
    }
    public void SetToken(String strToken) {
    	m_strToken = strToken;
    }
    public void SetCaptcha(String strCaptcha) {
    	m_strCaptcha = strCaptcha;
    }
    
    public int GetUserId() {
    	return m_nUserId;
    }
    public String GetInviteCode() {
    	return m_strInviteCode;
    }
    public String GetInviter() {
    	return m_strInviter;
    }
    public int GetBalance() {
    	return m_nBalance;
    }
    public int GetIncome() {
    	return m_nIncome;
    }
    public int GetOutgo() {
    	return m_Outgo;
    }
    public int GetShareIncome() {
    	return m_nShareIncome;
    }
    public int GetBindDeviceCount() {
    	return m_nBindDeviceCount;
    }
    
    private String m_strToken;
    private String m_strCaptcha;
    
    private int m_nUserId = 0;
    private String m_strInviteCode;
    private String m_strInviter;
    private int m_nBalance;
    private int m_nIncome;
    private int m_Outgo;
    private int m_nShareIncome;
    private int m_nBindDeviceCount;
}
