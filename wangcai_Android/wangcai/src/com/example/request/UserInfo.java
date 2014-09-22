package com.example.request;

public class UserInfo {

	public String GetPhoneNumber() {
		return m_strPhoneNumber;
	}
	public void SetPhoneNumber(String strPhone) {
		m_strPhoneNumber = strPhone;
	}
	public void SetCurrentLevel(int nLevel) {
		m_nCurrentLevel = nLevel;
	}
	public int GetCurrentLevel() {
		return m_nCurrentLevel;
	}
	public void SetUserId(int nUserId) {
		m_nUserId = nUserId;
	}
	public int GetUserId() {
		return m_nUserId;
	}
	public void SetBalance(int nBalance) {
		m_nBalance = nBalance;
	}
	public int GetBalance() {
		return m_nBalance;
	}
	public void SetTotalIncome(int nTotalIncome) {
		m_nTotalIncome = nTotalIncome;
	}
	public int GetTotalIncome() {
		return m_nTotalIncome;
	}
	public void SetTotalOutgo(int nTotalOutgo) {
		m_nTotalOutgo = nTotalOutgo;
	}
	public int GetTotalOutgo() {
		return m_nTotalOutgo;
	}
	public void SetShareIncome(int nShareIncome) {
		m_nShareIncome = nShareIncome;
	}
	public int GetShareIncome() {
		return m_nShareIncome;
	}
	public void SetRecentIncome(int nRecentIncome) {
		m_nRecentIncome = nRecentIncome;
	}
	public int GetRecentIncome() {
		return m_nRecentIncome;
	}
	public void SetCanWithdrawal(boolean bCanWithdrawal) {
		m_bCanWithdrawal = bCanWithdrawal;
	}
	public boolean CanWithdrawal() {
		return m_bCanWithdrawal;
	}
	public void SetInviteCode(String strInviteCode) {
		m_strInviteCode = strInviteCode;
	}
	public String GetInviteCode() {
		return m_strInviteCode;
	}
	public void SetInviter(String strInviter) {
		m_strInviter = strInviter;
	}
	public String GetInviter() {
		return m_strInviter;
	}
	public int NextLevel() {
		return m_nNextLevel;
	}
	public void SetNextLevel(int nLevel) {
		m_nNextLevel = nLevel;
	}
	public int GetCurrentExperience() {
		return m_nCurrentExperience;
	}
	public void SetCurrentExperience(int nCurrentExperience) {
		m_nCurrentExperience = nCurrentExperience;
	}
	public int GetNextLevelExperience() {
		return m_nNextLevelExperience;
	}
	public void SetNextLevelExperience(int nNextLevelExperience) {
		m_nNextLevelExperience = nNextLevelExperience;
	}
	public void SetDeviceId(String strDeviceId) {
		m_strDeviceId = strDeviceId;
	}
	public String GetDeviceId() {
		return m_strDeviceId;
	}
	public boolean HasBindPhone() {
		return !Util.IsEmptyString(m_strPhoneNumber);
	}
	public String GetInviteTaskUrl() {
		if (Util.IsEmptyString(m_strInviteCode)) {
			return null;
		}
		String strInviteUrl = String.format(Config.GetInviteTaskUrl(), m_strInviteCode);
		return strInviteUrl;
	}
	public String GetInviteUrl() {
		if (Util.IsEmptyString(m_strInviteCode)) {
			return null;
		}
		String strInviteUrl = String.format(Config.GetInviteUrl(), m_strInviteCode);
		return strInviteUrl;
	}
	//data member
	private String m_strPhoneNumber;

	private int m_nNextLevel = 0;
	private String m_strInviter = "";
	private String m_strInviteCode = "";
	
	private int m_nUserId = 0;
	private int m_nBalance = 0;
	private int m_nTotalIncome = 0;
	private int m_nTotalOutgo = 0;
	private int m_nShareIncome = 0;
	private int m_nRecentIncome = 0;
	private int m_nCurrentLevel = 0;
	private boolean m_bCanWithdrawal = true;
	private int m_nCurrentExperience = 0;
	private int m_nNextLevelExperience = 0;
	private String m_strDeviceId;
}
