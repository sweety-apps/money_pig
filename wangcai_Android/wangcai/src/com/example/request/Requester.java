package com.example.request;

import java.util.Map;
import java.util.Map.Entry;

import org.json.JSONException;
import org.json.JSONObject;


public class Requester {

	public static class RequestInfo {
		public RequestInfo(String strUrl, String strCookie) {
			m_strUrl = strUrl;
			m_strCookie = strCookie;
			m_strRequestMethod = RequestManager.g_strGet;
		}
		public RequestInfo(String strUrl, String strCookie, String strPostData) {
			InitPostData(strUrl, strCookie, strPostData);
		}
		public RequestInfo(String strUrl, String strCookie, Map<String, String> mapPostData) {
			InitPostData(strUrl, strCookie, GetPostStringData(mapPostData));
		}
		private void InitPostData(String strUrl, String strCookie, String strPostData) {
			m_strUrl = strUrl;
			m_strCookie = strCookie;
			m_strRequestMethod = RequestManager.g_strPost;
			m_strPostData = strPostData;
		}
		public void AddData(Map<String, String> mapPostData) {
			if (mapPostData == null || mapPostData.size() <= 0) {
				return ;
			}
			String strData = GetPostStringData(mapPostData);
			if (!Util.IsEmptyString(m_strPostData)) {
				m_strPostData += "&";
			}
			m_strPostData += strData;
		}
		private String GetPostStringData(Map<String, String> mapPostData) {
			if (mapPostData.isEmpty()) {
				return "";
			}
			StringBuffer stringBuffer = new StringBuffer();
			for (Entry<String, String> entry : mapPostData.entrySet()) {
				   String strKey = entry.getKey().toString();
				   String strValue = entry.getValue().toString();
				   stringBuffer.append(strKey);
				   stringBuffer.append("=");
				   stringBuffer.append(strValue);
				   stringBuffer.append("&");
			}
			stringBuffer.deleteCharAt(stringBuffer.length() - 1);
			return stringBuffer.toString();
		}
		//data menber
		String m_strRequestMethod;
		String m_strUrl;
		String m_strCookie;
		String m_strPostData;
	}
	

	public RequestInfo GetRequestInfo() {
		return null;
	}
	public boolean ParseResponse(String strResponse) {
		if (strResponse == null) {
			m_nResult = -1;
			return false;
		}
		try {
			m_rootObject = new JSONObject(strResponse);
			m_nResult = Util.ReadJsonInt(m_rootObject, "res");
			m_strMsg = Util.ReadJsonString(m_rootObject, "msg");
		} catch (JSONException e) {
			m_rootObject = null;
			return false;
		}
		return true;
	}
	
	public void SetRequestType(RequesterFactory.RequestType enumRequestType) {
		m_enumRequestType = enumRequestType;
	}
	public RequesterFactory.RequestType GetRquestType() {
		return m_enumRequestType;
	}
	public int GetResult() {
		return m_nResult;
	}
	public String GetMsg() {
		return m_strMsg;
	}
	protected JSONObject m_rootObject;
	private int m_nResult = 0;
	private String m_strMsg;
	protected RequesterFactory.RequestType m_enumRequestType;
	protected RequestInfo m_requestInfo = null;
}
