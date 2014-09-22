package com.example.wangcai.activity;
import java.util.ArrayList;

import cn.sharesdk.framework.ShareSDK;
import cn.sharesdk.onekeyshare.OnekeyShare;

import com.example.request.Config;
import com.example.request.Request_GetUserInfo;
import com.example.request.Request_Lottery;
import com.example.request.Requester;
import com.example.request.RequesterFactory;
import com.example.request.TaskListInfo;
import com.example.request.RequestManager;
import com.example.request.UserInfo;
import com.example.wangcai.ConfigCenter;
import com.example.wangcai.R;
import com.example.wangcai.WangcaiApp;
import com.example.wangcai.base.ActivityHelper;
import com.example.wangcai.base.ActivityRegistry;
import com.example.wangcai.base.BuildSetting;
import com.example.wangcai.base.ManagedDialog;
import com.example.wangcai.base.ManagedDialogActivity;
import com.example.wangcai.ctrls.ItemBase;
import com.example.wangcai.ctrls.MainItem;
import com.example.wangcai.ctrls.SlidingLayout;
import com.example.wangcai.dialog.HintBindPhoneDialog;
import com.example.wangcai.dialog.HintTaskLevelDialog;

import android.content.Context;
import android.content.DialogInterface;
import android.os.Bundle;
import android.view.Gravity;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.TextView;


public class MainActivity extends ManagedDialogActivity implements ItemBase.ItemClickEvent, 
																				OnClickListener, 
																				RequestManager.IRequestManagerCallback,
																				WangcaiApp.WangcaiAppEvent{

    private final static int sg_ItemIdBase = 1818;
    private final static int sg_MyWangcai = sg_ItemIdBase + 0;
    private final static int sg_CashExtract = sg_ItemIdBase + 1;
    private final static int sg_TaskDetail = sg_ItemIdBase + 2;
    private final static int sg_ExchageGift = sg_ItemIdBase + 3;
    private final static int sg_Invite = sg_ItemIdBase + 4;
    private final static int sg_Options = sg_ItemIdBase + 5;
    private final static int sg_Help = sg_ItemIdBase +  6;
    
	SlidingLayout m_slidingLayout;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
    	ShareSDK.initSDK(this);
   
    	ActivityRegistry.GetInstance().PushActivity(this);
 
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
    	
        InitView();
        
        AtachEvents();
     }
	
    
    private void InitTaskList(TaskListInfo taskListInfo, boolean bShowCompleteTask) {
        
        ViewGroup taskListContainer = (ViewGroup)this.findViewById(R.id.tasks_list_container);

        int nTaskCount = taskListInfo.GetTaskCount();
        for (int i = 0; i < nTaskCount; ++i) {
        	TaskListInfo.TaskInfo taskInfo = taskListInfo.GetTaskInfo(i);
        	if (!ShouldAddTask(taskInfo)) {
        		continue;
        	}
        	if (TaskListInfo.IsComplete(taskInfo)) {
        		m_listCompleteTasks.add(taskInfo);
        		continue;
        	}
        	
        	InsertTaskItem(taskListContainer, taskInfo);
        } 
        if (bShowCompleteTask) {
	        for (TaskListInfo.TaskInfo taskInfo : m_listCompleteTasks) {
	        	InsertTaskItem(taskListContainer, taskInfo);
	        }
        }
    }
    private void InitMemuList() {
        Context context = getApplicationContext();
        ViewGroup meunPage = (ViewGroup)this.findViewById(R.id.menu_page);
        InsertMenuItem(meunPage, String.valueOf(sg_MyWangcai), R.drawable.ic_launcher, context.getString(R.string.my_wangcai));
        InsertMenuItem(meunPage, String.valueOf(sg_CashExtract), R.drawable.ic_launcher, context.getString(R.string.cash_extract));
        InsertMenuItem(meunPage, String.valueOf(sg_TaskDetail), R.drawable.ic_launcher, context.getString(R.string.task_detail));
        InsertMenuItem(meunPage, String.valueOf(sg_ExchageGift), R.drawable.ic_launcher, context.getString(R.string.exchange_gift));
        InsertMenuItem(meunPage, String.valueOf(sg_Invite), R.drawable.ic_launcher, context.getString(R.string.get_money_by_invite));
        InsertMenuItem(meunPage, String.valueOf(sg_Options), R.drawable.ic_launcher, context.getString(R.string.options));
        InsertMenuItem(meunPage, String.valueOf(sg_Help), R.drawable.ic_launcher, context.getString(R.string.help));    	
    }
    private void InitView() {
    	m_slidingLayout = (SlidingLayout)this.findViewById(R.id.main_wnd);

        ViewGroup mainClient = (ViewGroup)this.findViewById(R.id.main_client);
        m_slidingLayout.setScrollEvent(mainClient); 


        WangcaiApp app = WangcaiApp.GetInstance();
        
        UserInfo userInfo = app.GetUserInfo();

        //余额
        TextView balanceTextValue = (TextView)this.findViewById(R.id.balance_value);
        balanceTextValue.setText(String.valueOf((float)userInfo.GetBalance() / 100.0f));
        
        //今天还能赚
        TaskListInfo taskListInfo = app.GetTaskListInfo();
        int nRemainMoney = taskListInfo.GetRemainMoneyToday();
        TextView remainMoneyTextView = (TextView)this.findViewById(R.id.remain_taks_balance);
        remainMoneyTextView.setText(String.valueOf((float)nRemainMoney / 100.0f));
        
        //任务列表
        InitTaskList(taskListInfo, false);
        
        
        InitMemuList();
    }
    
    //显示菜单
    private void ShowMenu(boolean bShow) {
    	m_slidingLayout.scrollToLeftView();
    }
    //显示积分墙
    private void ShowAppWall() {
    	AppWallWin appWall = new AppWallWin(this);
    	View viewParent = this.findViewById(R.id.main_client);
    	appWall.showAtLocation(viewParent, Gravity.CENTER, 32, 132);
    }
 
    //对话框返回
	public void OnDialogFinish(ManagedDialog dlg, int inClickedViewId) {
		int nDialogId = dlg.GetDialogId();
		if (nDialogId == m_bindPhoneDialog.GetDialogId()) {
			//绑定手机
			if (inClickedViewId == DialogInterface.BUTTON_POSITIVE) {
				ActivityHelper.ShowRegisterActivity(this);
			}
		}
		else if (m_hintTaskLevelDialog != null && nDialogId == m_hintTaskLevelDialog.GetDialogId()) {
			if (inClickedViewId == DialogInterface.BUTTON_POSITIVE) {
				ActivityHelper.ShowMyWnagcaiActivity(this);
			}			
		}
	}
    private void HintDuplicateSignIn() {
		ActivityHelper.ShowToast(this, R.string.hint_duplicate_signin);
    }
	public void OnRequestComplete(int nRequestId, Requester req) {
		if (req instanceof Request_Lottery) {
			//请求抽奖
			Request_Lottery lotteryRequester = (Request_Lottery)req;
			int nBonus = lotteryRequester.GetBouns();
			
			if (!BuildSetting.sg_bIsDebug) {
				if (lotteryRequester.GetResult() != 0 || nBonus <= 0)
				{
					//todo 区分不同错误码
					//nfoxdebug
					HintDuplicateSignIn();
					return;
				}
			}

			ActivityHelper.ShowLotteryActivity(this, nBonus);
		}
		else if (req instanceof Request_GetUserInfo) {
			//请求以前的调查问卷
			Request_GetUserInfo getUserReq = (Request_GetUserInfo)req;
			int nResult = getUserReq.GetResult();

			int nAge = 0;
			int nSex = 0;
			String strInterest = "";
			if (nResult == 0) {
				nAge = getUserReq.GetAge();
				nSex = getUserReq.GetSex();
				strInterest = getUserReq.GetInterest();
			}
			ActivityHelper.ShowSurveyActivity(this, nAge, nSex, strInterest);
		}
	}
	public void onClick(View v) {
		int nId = v.getId();
		switch (nId) {
			case R.id.option_button:
				ShowMenu(true);
				break;
			case R.id.exchange_gift_button:
				//超值对话
				ActivityHelper.ShowExchageGiftActivity(this);
				break;
			case R.id.extract_cash:
				//提取现金
				ActivityHelper.ShowExtractActivity(this);
				break;
			case R.id.sign_in:
				//签到
				
				if (!BuildSetting.sg_bIsDebug) {
					if (ConfigCenter.GetInstance().GetHasSignInToday()) {
						HintDuplicateSignIn();
						break ;
					}
				}
				RequestManager requestManager = RequestManager.GetInstance();
				Request_Lottery request = (Request_Lottery)RequesterFactory.NewRequest(RequesterFactory.RequestType.RequestType_Lottery);
				requestManager.SendRequest(request, true, this);
				break ;
			case R.id.show_complete_task:
				//查看已领到的红包
				this.findViewById(R.id.show_complete_task).setVisibility(View.GONE);
				for (TaskListInfo.TaskInfo taskInfo:m_listCompleteTasks){
			        ViewGroup taskListContainer = (ViewGroup)this.findViewById(R.id.tasks_list_container);
		        	InsertTaskItem(taskListContainer, taskInfo);
				}
				break;
		}
	}
    private void AtachEvents() {
    	//左上角的菜单按钮
    	this.findViewById(R.id.option_button).setOnClickListener(this);
    	//右上角兑换按钮
    	this.findViewById(R.id.exchange_gift_button).setOnClickListener(this);
    	//提取现金按钮
    	this.findViewById(R.id.extract_cash).setOnClickListener(this);
    	//签到抽奖按钮
    	this.findViewById(R.id.sign_in).setOnClickListener(this);
    	//查看已领到的红包
    	this.findViewById(R.id.show_complete_task).setOnClickListener(this);
    }


	public void OnItemClicked(String strItemName)
	{
		int nTaskType = Integer.parseInt(strItemName);
		WangcaiApp app = WangcaiApp.GetInstance();
		TaskListInfo.TaskInfo taskInfo = app.GetTaskListInfo().GetTaskInfoByType(nTaskType);
		if (taskInfo == null) {
			return;
		}
	
		if (!BuildSetting.sg_bIsDebug) {
			int nCurrentLevel = app.GetUserInfo().GetCurrentLevel();
			if (nCurrentLevel < taskInfo.m_nLevel) {

				if (m_hintTaskLevelDialog == null) {
					m_hintTaskLevelDialog = new HintTaskLevelDialog(this, nCurrentLevel);
					RegisterDialog(m_bindPhoneDialog);
				}
				m_bindPhoneDialog.Show();
		
				ActivityHelper.ShowToast(this, String.format(getString(R.string.task_level_limit_hint), taskInfo.m_nLevel));
				return ;
			}
		}

		switch (nTaskType) {
		case TaskListInfo.TaskTypeInviteFriends:
			//填写邀请人
			if (!WangcaiApp.GetInstance().GetUserInfo().HasBindPhone()) {
				if (m_bindPhoneDialog == null) {
					m_bindPhoneDialog = new HintBindPhoneDialog(this);
					RegisterDialog(m_bindPhoneDialog);
				}
				m_bindPhoneDialog.Show();
			}
			else {
				ActivityHelper.ShowInviteActivity(this);
			}
			break;
		case TaskListInfo.TaskTypeOfferWall:
			//积分墙
			ShowAppWall();
			break;
		case TaskListInfo.TaskTypeUserInfo:
			//填写个人信息
			RequestManager requestManager = RequestManager.GetInstance();
			Request_GetUserInfo request = (Request_GetUserInfo)RequesterFactory.NewRequest(RequesterFactory.RequestType.RequestType_GetUserInfo);
			requestManager.SendRequest(request, true, this);			
			break;
		case TaskListInfo.TaskTypeCommetWangcai:
		case sg_MyWangcai:
			//好评旺财	todo
			ActivityHelper.ShowCommentActivity(this);
			break;
		case TaskListInfo.TaskTypeShare:
			//分享
			UserInfo userInfo = WangcaiApp.GetInstance().GetUserInfo();
			OnekeyShare oks = new OnekeyShare();
			oks.setNotification(R.drawable.ic_launcher, getString(R.string.app_description));
			oks.setTitle(getString(R.string.wangcai_share));
			
			String strInviteCode = userInfo.GetInviteCode();
			String strInviteUrl = userInfo.GetInviteTaskUrl();
			String strMsg = String.format(getString(R.string.share_content), (float)userInfo.GetBalance() / 100.0f, strInviteCode, strInviteUrl);
			oks.setText(strMsg);
			oks.show(this);
			break;
		case TaskListInfo.TaskTypeUpgrade:
			//我的旺财
			ActivityHelper.ShowMyWnagcaiActivity(this);
			break;
		case sg_CashExtract:
			//提取现金
			ActivityHelper.ShowExtractActivity(this);	
			break;
		case sg_TaskDetail:
			//任务详情
			ActivityHelper.ShowDetailActivity(this);
			break;
		case sg_ExchageGift:
			//超值兑换
			ActivityHelper.ShowExchageGiftActivity(this);
			break;
		case sg_Options:
			//设置
			ActivityHelper.ShowOptionActivity(this);
			break;
		case sg_Help:
			//客服帮助
			ActivityHelper.ShowHelpActivity(this);
			break;
		}
	}
    

    
    public void OnLoginComplete(int nResult, String strMsg) {
    }
    public void OnUserInfoUpdate() {
    	//todo
    }
    private void InsertMenuItem(ViewGroup parentView, String strItemName, int nIconId, String strText) {
    	com.example.wangcai.ctrls.MenuItem menuItem = new com.example.wangcai.ctrls.MenuItem(strItemName);
    	View itemView = menuItem.Create(getApplicationContext(), nIconId, strText);
    	menuItem.SetClickEventLinstener(this);
    	parentView.addView(itemView);
    }
    private boolean ShouldAddTask(TaskListInfo.TaskInfo taskInfo) {
   	 boolean bAdd = false;
   	switch (taskInfo.m_nTaskType) {
	    	case TaskListInfo.TypeInstallWangcai:
	    	case TaskListInfo.TaskTypeUserInfo:
	    	case TaskListInfo.TaskTypeInviteFriends:
	    	case TaskListInfo.TaskTypeOfferWall:
	    	case TaskListInfo.TaskTypeCommetWangcai:
	    	case TaskListInfo.TaskTypeUpgrade:
	    	case TaskListInfo.TaskTypeShare:
	    		bAdd = true;
	    		break;
   	}
   	return bAdd;
   }
   private int GetItemIcon(TaskListInfo.TaskInfo taskInfo) {
   	int nIconId = R.drawable.package_icon_many;
   	switch (taskInfo.m_nTaskType) {
   	case TaskListInfo.TypeInstallWangcai:
   		nIconId = R.drawable.main_about_wangcai_cell_icon;
   		break;
   	case TaskListInfo.TaskTypeUserInfo:
   		nIconId = R.drawable.main_person_info_icon;
   		break;
   	case TaskListInfo.TaskTypeInviteFriends:
   		nIconId = R.drawable.main_qrcode_cell_icon;
   		break;
   	case TaskListInfo.TaskTypeOfferWall:
   		nIconId = R.drawable.main_tiyanzhongxin_cell_icon;
   		break;
   	case TaskListInfo.TaskTypeCommetWangcai:
   		nIconId = R.drawable.main_rate_app_cell_icon;
   		break;
   	case TaskListInfo.TaskTypeUpgrade:
   		nIconId = R.drawable.main_upgrade;
   		break;
   	case TaskListInfo.TaskTypeShare:
   		nIconId = R.drawable.main_share_cell_icon;
   		break;
   	}
   	return nIconId;
   }
   private int GetMoneyIconId(TaskListInfo.TaskInfo taskInfo) {
   	int nIconId = R.drawable.package_icon_many;
   	switch (taskInfo.m_nMoney) {
   	case 10:
   		nIconId = R.drawable.package_icon_1mao;
   		break;
   	case 50:
   		nIconId = R.drawable.package_icon_1mao;
   		break;
   	case 100:
   		nIconId = R.drawable.package_icon_1;
   		break;
   	case 200:
   		nIconId = R.drawable.package_icon_2;
   		break;
   	case 300:
   		nIconId = R.drawable.package_icon_3;
   		break;
   	case 800:
   		nIconId = R.drawable.package_icon_8;
   		break;
   	}
   	return nIconId;
   }
   private void InsertTaskItem(ViewGroup parentView, String strItemName, int nIconId, String strTitle, String strTip, int nMoneyIconId, Boolean bComplete) {
   	MainItem mainItem = new MainItem(strItemName);
   	View itemView = mainItem.Create(getApplicationContext(), nIconId, strTitle, strTip, nMoneyIconId, bComplete);
   	mainItem.SetClickEventLinstener(this);
   	parentView.addView(itemView);
   }
   private void InsertTaskItem(ViewGroup mainClient, TaskListInfo.TaskInfo taskInfo) {
   	InsertTaskItem(mainClient, String.valueOf(taskInfo.m_nTaskType), GetItemIcon(taskInfo), 
   			taskInfo.m_strTitle, taskInfo.m_strDescription, GetMoneyIconId(taskInfo), TaskListInfo.IsComplete(taskInfo));
   }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        
        // Inflate the menu; this adds items to the action bar if it is present.
    	ShowMenu(true);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        // Handle action bar item clicks here. The action bar will
        // automatically handle clicks on the Home/Up button, so long
        // as you specify a parent activity in AndroidManifest.xml.
        int id = item.getItemId();
        if (id == R.id.action_settings) {
            return true;
        }
        return super.onOptionsItemSelected(item);
    }

    private HintTaskLevelDialog m_hintTaskLevelDialog;
    private HintBindPhoneDialog m_bindPhoneDialog;
    private ArrayList<TaskListInfo.TaskInfo> m_listCompleteTasks = new ArrayList<TaskListInfo.TaskInfo>();

    @Override 
    protected void onDestroy() {
    	ShareSDK.stopSDK(this);
  
    	ActivityRegistry.GetInstance().PopActivity(this);
    	super.onDestroy();
    }
}
