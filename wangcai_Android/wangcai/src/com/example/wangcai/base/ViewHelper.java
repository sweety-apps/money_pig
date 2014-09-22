package com.example.wangcai.base;
import android.content.Context;
import android.graphics.drawable.Drawable;
import android.graphics.drawable.StateListDrawable;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

public class ViewHelper 
{
	public static Boolean SetIconId(View parentView, int nViewId, int nIconId) {
		ImageView imageView = (ImageView)parentView.findViewById(nViewId);
		if (imageView == null) {
			return false;
		}
		imageView.setImageResource(nIconId);
		return true;
	}
	public static Boolean SetViewBackground(View parentView, int nViewId, int nBkgId) {
		View view = (View)parentView.findViewById(nViewId);
		if (view == null) {
			return false;
		}
		view.setBackgroundResource(nBkgId);
		return true;
	}
	public static Boolean SetTextStr(View parentView, int nViewId, String strText) {
		TextView textView = (TextView)parentView.findViewById(nViewId);
		if (textView == null) {
			return false;
		}
		textView.setText(strText);
		return true;
	}
	public static Boolean SetChildVisibility(View parentView, int nViewId, int nVisibility) {
		View view = (View)parentView.findViewById(nViewId);
		if (view == null) {
			return false;
		}
		view.setVisibility(nVisibility);
		return true;
	}
	
	public static StateListDrawable newSelector(Context context, int nNormaImgId, int nDownImgId, int nFocusImgId, int nDisableImgId) {
		StateListDrawable selector = new StateListDrawable();
		Drawable normalDrawable = (nNormaImgId <= 0) ? null : context.getResources().getDrawable(nNormaImgId);
		Drawable downDrawable = (nDownImgId <= 0) ? null : context.getResources().getDrawable(nDownImgId);
		Drawable focusDrawable = (nFocusImgId <= 0) ? null : context.getResources().getDrawable(nFocusImgId);
		Drawable disableDrawable = (nDisableImgId <= 0) ? null : context.getResources().getDrawable(nDisableImgId);
		
		// View.PRESSED_ENABLED_STATE_SET
		selector.addState(new int[] { android.R.attr.state_pressed, android.R.attr.state_enabled }, downDrawable);
		
		// View.ENABLED_FOCUSED_STATE_SET
		selector.addState(new int[] { android.R.attr.state_enabled, android.R.attr.state_focused }, focusDrawable);
		
		// View.ENABLED_STATE_SET
		selector.addState(new int[] { android.R.attr.state_enabled }, normalDrawable);
		
		// View.FOCUSED_STATE_SET
		selector.addState(new int[] { android.R.attr.state_focused }, focusDrawable);
		
		// View.WINDOW_FOCUSED_STATE_SET
		selector.addState(new int[] { android.R.attr.state_window_focused }, disableDrawable);
		
		// View.EMPTY_STATE_SET
		selector.addState(new int[] {}, normalDrawable);
		return selector;
	}
	public static void SetStateViewBkg(View view, Context context, int nNormalImgId, int nDownImgId, int nFocusImgId, int nDisableImgId) {
		StateListDrawable selector = newSelector(context, nNormalImgId, nDownImgId, nFocusImgId, nDisableImgId);
		view.setBackgroundDrawable(selector);
	}
	public static void SetStateViewBkg(View view, Context context, int nNormalImgId, int nDownImgId, int nDisableImgId) {
		StateListDrawable selector = newSelector(context, nNormalImgId, nDownImgId, nNormalImgId, nDisableImgId);
		view.setBackgroundDrawable(selector);
	}
}
