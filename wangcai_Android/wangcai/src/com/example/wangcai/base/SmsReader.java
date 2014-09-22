


package com.example.wangcai.base;

import java.util.ArrayList;

import com.example.request.Util;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.telephony.SmsMessage;


public class SmsReader extends BroadcastReceiver
{
    public static final String TAG = "ImiChatSMSReceiver";
    public static final String SMS_RECEIVED_ACTION = "android.provider.Telephony.SMS_RECEIVED";
    
    
	public interface SmsEvent {
		void OnNewSms(String strMsg);
	}
	private static ArrayList<SmsEvent> m_listSmsEvents;
	
	
	public static void AddListener(SmsEvent eventListener) {
		if (m_listSmsEvents == null) {
			m_listSmsEvents = new ArrayList<SmsEvent>();
		}

		if (m_listSmsEvents.contains(eventListener)) {
			return ;
		}
		m_listSmsEvents.add(eventListener);
	}
	public static void RemoveListener(SmsEvent eventListener) {
		if (m_listSmsEvents == null) {
			return;
		}
		
		m_listSmsEvents.remove(eventListener);
	}
	
	@Override
    public void onReceive(Context context, Intent intent)
    {
    	if (m_listSmsEvents == null || m_listSmsEvents.isEmpty()) {
    		return;
    	}
       if (intent.getAction().equals(SMS_RECEIVED_ACTION))
       {
           SmsMessage[] arraySmsMsgs = GetMessagesFromIntent(intent);
           for (SmsMessage message : arraySmsMsgs) {
        	   //getMessageBody
        	   String strMsg = "";
        	   try {
            	   strMsg = message.getDisplayMessageBody();        		   
        	   }
        	   catch (Exception e) {
        	   }
        	   
        	   if (Util.IsEmptyString(strMsg)) {
        		   continue;
        	   }
        	   for (SmsEvent eventListener:m_listSmsEvents) {
        		   eventListener.OnNewSms(strMsg);
        		}        	   
           }
       }
    }
   

    public final SmsMessage[] GetMessagesFromIntent(Intent intent)
    {
        Object[] arrayMsgs = (Object[]) intent.getSerializableExtra("pdus");
        byte[][] pduObjs = new byte[arrayMsgs.length][];
        for (int i = 0; i < arrayMsgs.length; i++)
        {
            pduObjs[i] = (byte[]) arrayMsgs[i];
        }

        byte[][] pdus = new byte[pduObjs.length][];
        int pduCount = pdus.length;
        SmsMessage[] msgs = new SmsMessage[pduCount];
        for (int i = 0; i < pduCount; i++)
        {
            pdus[i] = pduObjs[i];
            msgs[i] = SmsMessage.createFromPdu(pdus[i]);
        }
        return msgs;
    }
    
    
     
}






