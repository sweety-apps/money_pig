package com.example.request;

import java.io.DataOutputStream;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.URL;
import java.security.SecureRandom;
import java.util.HashMap;
import java.util.Map;

import javax.net.ssl.HttpsURLConnection;
import javax.net.ssl.SSLContext;
import javax.net.ssl.TrustManager;



import android.os.AsyncTask;

public class RequestManager {
	public static final String g_strPost = "POST";
	public static final String g_strGet = "GET";
	
	
	private static RequestManager sg_requestManager = new RequestManager();
	public static RequestManager GetInstance() {
		return sg_requestManager;
	}
	private class RequestRecord {
		RequestRecord(int nRequestId, Requester requester, IRequestManagerCallback pCallback) {
			m_nRequestId = nRequestId;
			m_pCallback = pCallback;
			m_requester = requester;
		}
		Requester m_requester;
		int m_nRequestId = 0;
		IRequestManagerCallback m_pCallback;
	}
	
	public interface IRequestManagerCallback {
		void OnRequestComplete(int nRequestId, Requester req);
	}
	
	
	@SuppressWarnings("deprecation")
	public void Initialize(InputStream caInput) {
		// Load CAs from an InputStream
		// (could be from a resource or ByteArrayInputStream or ...)
		/*
		try {
			CertificateFactory cf = CertificateFactory.getInstance("X.509");
			// From https://www.washington.edu/itconnect/security/ca/load-der.crt
			java.security.cert.Certificate ca = null;
			try {
			    ca = cf.generateCertificate(caInput);
			} catch(Exception ex) {
				String strMsg = ex.toString();
				String strTemp  = strMsg + "xxxx";
			    return ;
			}
			finally {
			    caInput.close();
			}
	
			// Create a KeyStore containing our trusted CAs
			String keyStoreType = KeyStore.getDefaultType();
			KeyStore keyStore = KeyStore.getInstance(keyStoreType);
			keyStore.load(null, null);
			keyStore.setCertificateEntry("ca", ca);
	
			// Create a TrustManager that trusts the CAs in our KeyStore
			String tmfAlgorithm = TrustManagerFactory.getDefaultAlgorithm();
			TrustManagerFactory tmf = TrustManagerFactory.getInstance(tmfAlgorithm);
			tmf.init(keyStore);
	
			// Create an SSLContext that uses our TrustManager
			m_sslContext = SSLContext.getInstance("TLS");
			m_sslContext.init(null, tmf.getTrustManagers(), null);
		}catch(Exception ex) {
			String strMsg = ex.toString();
			String strTemp  = strMsg + "xxxx";
		}
		*/
	}
	
	public int SendRequest(Requester req, boolean bOverwrite, IRequestManagerCallback pCallback) {
		//todo 去重
		int nRequestId = m_idGen.NewId();
		RequestRecord pRecord = new RequestRecord(nRequestId, req, pCallback);
		Map<String, String> mapData = new HashMap<String, String>();
		if (!Util.IsEmptyString(m_strDeviceId)) {
			mapData.put("device_id", m_strDeviceId);
		}
		if (!Util.IsEmptyString(m_strSessionId)) {
			mapData.put("session_id", m_strSessionId);
		}
		if (m_nUserId >= 0) {
			mapData.put("userid", String.valueOf(m_nUserId));
		}
		if (mapData.size() > 0) {
			pRecord.m_requester.GetRequestInfo().AddData(mapData);
		}
        new RequestTask().execute(pRecord); 
		return nRequestId;
	}

	private String GetCookie() {
		String strCookie = "iPhone 5s_7.0.4; os=android; net=wifi; app=wangcai; ver=2.2; local_ip=10.66.149.88";
		return strCookie;
	}

    private class RequestTask extends AsyncTask<RequestRecord, RequestRecord, RequestRecord> {

		@Override
		protected RequestRecord doInBackground(RequestRecord... params) {
			//todo 会不会有多个?
			RequestRecord reqRecord = DoRequest(params[0]);
			return reqRecord;
		}
		//background
		private RequestRecord DoRequest(RequestRecord reqRecord) {
			try {
				Requester.RequestInfo requestInfo = reqRecord.m_requester.GetRequestInfo();
                SSLContext sc = SSLContext.getInstance("TLS"); 
                sc.init(null, new TrustManager[]{new HttpsHelper.MyTrustManager()}, new SecureRandom());
                HttpsURLConnection.setDefaultSSLSocketFactory(sc.getSocketFactory()); 
                HttpsURLConnection.setDefaultHostnameVerifier(new HttpsHelper.MyHostnameVerifier());
				URL url = new URL(requestInfo.m_strUrl);

				HttpsURLConnection connection = (HttpsURLConnection)url.openConnection(); 
				connection.setConnectTimeout(10 * 1000);
				if (!Util.IsEmptyString(requestInfo.m_strCookie)) {
                	connection.addRequestProperty("Cookie", requestInfo.m_strCookie);
                }else {//todo
                	connection.addRequestProperty("Cookie", GetCookie());
                }
 
				connection.setRequestMethod(requestInfo.m_strRequestMethod);
				connection.setDoInput(true);
				
				String strPostData = requestInfo.m_strPostData;
				if (strPostData != null && requestInfo.m_strRequestMethod.equals(g_strPost)) {
					connection.setDoOutput(true);
					DataOutputStream streamWriter = new DataOutputStream(connection.getOutputStream());
					streamWriter.writeBytes(strPostData);
					streamWriter.flush();
					streamWriter.close();
				}
				InputStream inputStream = connection.getInputStream();
				InputStreamReader streamReader = new InputStreamReader(inputStream);
				//BufferedReader bufferedReader = new BufferedReader(streamReader);
				
				StringBuffer stringBuffer = new StringBuffer();
				final int nBufferSize = 1024;
				char[] buffer = new char[nBufferSize];
				while (true) {
					int nReadCount = 0;
					try {
						nReadCount = streamReader.read(buffer, 0, nBufferSize);
					}
					catch(IndexOutOfBoundsException e) {
						nReadCount = -1;
					}
					if (nReadCount <= 0) {
						break;
					}
					stringBuffer.append(buffer, 0, nReadCount);
					if (nReadCount < nBufferSize) {
						break;	//读完了
					}
				}
				String strRespData = stringBuffer.toString();
				reqRecord.m_requester.ParseResponse(strRespData);
			}
			catch(Exception ex){
				reqRecord.m_requester.ParseResponse(null);
			}
			return reqRecord;
		}

        @Override  
	    protected void onPreExecute() {
	    }
        @Override  
        protected void onCancelled() {
        }
        @Override  
        protected void onProgressUpdate(RequestRecord... reqRecord) {  
        }  
        @Override  
        protected void onPostExecute(RequestRecord reqRecord) {
        	if (reqRecord != null && reqRecord.m_pCallback != null) {
        		reqRecord.m_pCallback.OnRequestComplete(reqRecord.m_nRequestId, reqRecord.m_requester);
        	}
        }
    }
	

    private class IdGenerator {
    	public int NewId() {
    		return ++m_id;
    	}
    	private int m_id = 1;
    }
	public void SetUserId(int nUserId) {
		m_nUserId = nUserId;
	}
	public void SetSessionId(String strSessionId) {
		m_strSessionId = strSessionId;
	}
	public void SetDeviceId(String strDeviceId) {
		m_strDeviceId = strDeviceId;
	}
	
    private IdGenerator m_idGen = new IdGenerator();
    private SSLContext m_sslContext;
	private String m_strSessionId;
	private String m_strDeviceId;
	private int m_nUserId = -1;
}
