package com.example.wangcai.ctrls;

import com.example.wangcai.R;
import com.example.wangcai.R.id;
import com.example.wangcai.R.layout;
import com.example.wangcai.R.styleable;

import android.app.Activity;
import android.content.Context;
import android.content.res.TypedArray;
import android.util.AttributeSet;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.Button;
import android.widget.FrameLayout;
import android.widget.TextView;

public class TitleCtrl extends FrameLayout {

	public interface TitleEvent{
		boolean OnRequestClose();	//return true表示close
	}
	
    public TitleCtrl(Context context) {
        super(context);
        DoInit(context);
     }
    public TitleCtrl(Context context, AttributeSet attrs) {  
        super(context, attrs);  

        DoInit(context);
 
        TypedArray typeArray = context.getTheme().obtainStyledAttributes(attrs, R.styleable.TitleCtrl, 0, 0);
        int nIndexCount = typeArray.getIndexCount();  
        for (int i = 0; i < nIndexCount; i++) {  
            int attr = typeArray.getIndex(i);  
            switch (attr) {  
	            case R.styleable.TitleCtrl_titleText:
	            	String strText = typeArray.getString(attr);
	            	TextView titleText = (TextView)this.findViewById(R.id.titile_text);
	            	titleText.setText(strText);
	            	break;
            }
        }
    }  
    public TitleCtrl(Context context, AttributeSet attrs, int defStyle) {
        super(context, attrs, defStyle);  
        
        DoInit(context);
    }  
  

    private void DoInit(Context context) {
        LayoutInflater inflater=(LayoutInflater) context.getSystemService(Context.LAYOUT_INFLATER_SERVICE);  
        inflater.inflate(R.layout.ctrl_title, this);
        

    	Button returnButton = (Button)this.findViewById(R.id.return_button);
    	if (returnButton != null) {
	    	returnButton.setOnClickListener(new OnClickListener() {
	            public void onClick(View v) {
	            	if (m_eventLinsterner != null) {
	            		if (m_eventLinsterner.OnRequestClose()) {
							Finish();
						}
	            	}
					else {
						Finish();
					}
	            }
	        });
    	}    		
    }
	
	private void Finish() {
		Activity ownerActivity = null;
		Context context = getContext();
		if (context != null && context instanceof Activity)
		{
			ownerActivity = (Activity)context;
		}
		if (ownerActivity != null) {
			ownerActivity.finish();
		}
		m_eventLinsterner = null;
	}

    public boolean SetEventLinstener(TitleEvent eventLinstener)
    {
    	m_eventLinsterner = eventLinstener;    	
    	return true;    	
    }
 

    private TitleEvent m_eventLinsterner = null;
}
