package com.example.request;

import java.io.IOException;
import java.net.InetAddress;
import java.net.Socket;
import java.net.UnknownHostException;
import java.security.KeyManagementException;
import java.security.KeyStore;
import java.security.KeyStoreException;
import java.security.NoSuchAlgorithmException;
import java.security.UnrecoverableKeyException;
import java.security.cert.CertificateException;
import java.security.cert.X509Certificate;

import javax.net.ssl.HostnameVerifier;
import javax.net.ssl.HttpsURLConnection;
import javax.net.ssl.SSLContext;
import javax.net.ssl.SSLSession;
import javax.net.ssl.SSLSocketFactory;
import javax.net.ssl.TrustManager;
import javax.net.ssl.X509TrustManager;



public class HttpsHelper {

	public static class MytmArray implements X509TrustManager {  
	    public X509Certificate[] getAcceptedIssuers() {  
	        // return null;  
	        return new X509Certificate[] {};  
	    }  
	  
	    @Override  
	    public void checkClientTrusted(X509Certificate[] chain, String authType)  
	            throws CertificateException {  
	        // TODO Auto-generated method stub  
	  
	    }  
	  
	    @Override  
	    public void checkServerTrusted(X509Certificate[] chain, String authType)  
	            throws CertificateException {  
	        // TODO Auto-generated method stub  
	        // System.out.println("cert: " + chain[0].toString() + ", authType: "  
	        // + authType);  
	    }  
	};  
	public static TrustManager[] xtmArray = new MytmArray[] { new MytmArray() };  
  
    /** 
     * 信任所有主机-对于任何证书都不做检查 
     */  
    public static void trustAllHosts() {  
        // Create a trust manager that does not validate certificate chains  
        // Android 采用X509的证书信息机制  
        // Install the all-trusting trust manager  
        try {  
            SSLContext sc = SSLContext.getInstance("TLS");  
            sc.init(null, xtmArray, new java.security.SecureRandom());  
            HttpsURLConnection  
                    .setDefaultSSLSocketFactory(sc.getSocketFactory());  
            // HttpsURLConnection.setDefaultHostnameVerifier(DO_NOT_VERIFY);//  
            // 不进行主机名确认  
        } catch (Exception e) {  
            e.printStackTrace();  
        }  
    }  
  
    static HostnameVerifier DO_NOT_VERIFY = new HostnameVerifier() {  
        @Override  
		public boolean verify(String hostname, SSLSession session) { 
            return true;  
        }
    };  
    

	public static class SSLSocketFactoryEx extends SSLSocketFactory {
        
        SSLContext sslContext = SSLContext.getInstance("TLS");
        
        public SSLSocketFactoryEx(KeyStore truststore) 
                        throws NoSuchAlgorithmException, KeyManagementException, KeyStoreException, UnrecoverableKeyException {
                super();
                
                TrustManager tm = new X509TrustManager() {
                        public java.security.cert.X509Certificate[] getAcceptedIssuers() {return null;}  
    
			            @Override  
			            public void checkClientTrusted(
			                            java.security.cert.X509Certificate[] chain, String authType)
			                                            throws java.security.cert.CertificateException {}  
			    
			            @Override  
			            public void checkServerTrusted(
			                            java.security.cert.X509Certificate[] chain, String authType)
			                                            throws java.security.cert.CertificateException {}
			        };  
	        sslContext.init(null, new TrustManager[] { tm }, null);  
	    }  
		    
	    @Override  
	    public Socket createSocket(Socket socket, String host, int port,boolean autoClose) throws IOException, UnknownHostException {  
	            return sslContext.getSocketFactory().createSocket(socket, host, port,autoClose);  
	    }  
	    
	    @Override  
	    public Socket createSocket() throws IOException {  
	        return sslContext.getSocketFactory().createSocket();  
	    }
	
		@Override
		public String[] getDefaultCipherSuites() {
			// TODO Auto-generated method stub
			return null;
		}
	
		@Override
		public String[] getSupportedCipherSuites() {
			// TODO Auto-generated method stub
			return null;
		}
	
		@Override
		public Socket createSocket(String host, int port) throws IOException,
				UnknownHostException {
			// TODO Auto-generated method stub
			return null;
		}
	
		@Override
		public Socket createSocket(String host, int port, InetAddress localHost,
				int localPort) throws IOException, UnknownHostException {
			// TODO Auto-generated method stub
			return null;
		}
	
		@Override
		public Socket createSocket(InetAddress host, int port) throws IOException {
			// TODO Auto-generated method stub
			return null;
		}
	
		@Override
		public Socket createSocket(InetAddress address, int port,
				InetAddress localAddress, int localPort) throws IOException {
			// TODO Auto-generated method stub
			return null;
		}  
	}

	public static class MyHostnameVerifier implements HostnameVerifier{
                @Override
                public boolean verify(String hostname, SSLSession session) {
                        return true;
                 }

    }

    public static class MyTrustManager implements X509TrustManager{
                @Override
                public void checkClientTrusted(X509Certificate[] chain, String authType)
                                throws CertificateException {
                }
                @Override
                public void checkServerTrusted(X509Certificate[] chain, String authType)
                                throws CertificateException {                        
                }
                @Override
                public X509Certificate[] getAcceptedIssuers() {
                        return null;
                }        
    }  

}
