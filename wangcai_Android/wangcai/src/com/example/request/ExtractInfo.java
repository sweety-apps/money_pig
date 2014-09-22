package com.example.request;

import java.util.ArrayList;

public class ExtractInfo {
	public enum ExtractType {
		ExtractType_Phone,
		ExtractType_AliPay,
		ExtractType_QBi
	}
	public static class ExtractSubItem {
		public ExtractSubItem(int nAmount, int nPrice, boolean bHot) {
			m_nAmount = nAmount;
			m_nPrice = nPrice;
			m_bHot = bHot;
		}
		public int m_nAmount;
		public int m_nPrice;
		boolean m_bHot;
	}
	public static class ExtractItem {
		public ExtractItem(ExtractType enumType) {
			m_enumType = enumType;
		}
		public ExtractType m_enumType;
		public ArrayList<ExtractSubItem>  m_subItems = new ArrayList<ExtractSubItem>();
	}
	

	public int GetExtractItemCount() {
		return m_listExtractItems.size();
	}
	public ExtractItem GetExtractItem(int nIndex) {
		if (nIndex < 0 || nIndex >= m_listExtractItems.size()) {
			return null;
		}
		return m_listExtractItems.get(nIndex);
	}
	public void AddItem(ExtractItem item) {
		m_listExtractItems.add(item);
	}

	private ArrayList<ExtractItem> m_listExtractItems = new ArrayList<ExtractItem>();
}
