package com.example.request;


import java.util.Hashtable;

import android.annotation.SuppressLint;
import android.graphics.Bitmap;

import org.json.JSONException;
import org.json.JSONObject;

import com.google.zxing.BarcodeFormat;
import com.google.zxing.EncodeHintType;
import com.google.zxing.MultiFormatWriter;
import com.google.zxing.WriterException;
import com.google.zxing.common.BitMatrix;


public class Util {
	
	public static int ReadJsonInt(JSONObject jsonObj, String strKey) {
		try {
			return jsonObj.getInt(strKey);
		} catch (JSONException e) {
			return 0;
		}
	}
	public static String ReadJsonString(JSONObject jsonObj, String strKey) {
		try {
			return jsonObj.getString(strKey);
		} catch (JSONException e) {
			return "";
		}
	}
	
	@SuppressLint("NewApi") public static boolean IsEmptyString(String strVal) {
		return strVal == null || strVal.isEmpty() || strVal.equals("");
	}


	public static Bitmap CreateQRCodeBitmap(String strContent, int nSize) {
		Hashtable<EncodeHintType, String> hints = new Hashtable<EncodeHintType, String>();  
        hints.put(EncodeHintType.CHARACTER_SET, "utf-8"); 
		BitMatrix matrix = null;
		try {
			matrix = new MultiFormatWriter().encode(strContent,
					BarcodeFormat.QR_CODE, nSize, nSize);
		} catch (WriterException e) {
			return null;
		}
		int nWidth = matrix.getWidth();
		int nHeight = matrix.getHeight();
		int[] bufPixels = new int[nWidth * nHeight];
		
		for (int y = 0; y <  nHeight; y++) {
			int nBeginIndex= y * nWidth;
			for (int x = 0; x < nWidth; x++) {
				if (matrix.get(x, y)) {
					bufPixels[nBeginIndex + x] = 0xFF00000;
				}
			}
		}
		Bitmap bitmap = Bitmap.createBitmap(nWidth, nHeight, Bitmap.Config.ARGB_8888);
		bitmap.setPixels(bufPixels, 0, nWidth, 0, 0, nWidth, nHeight);
		return bitmap;
	}
}
