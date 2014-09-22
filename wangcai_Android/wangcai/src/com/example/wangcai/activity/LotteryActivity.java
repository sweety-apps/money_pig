package com.example.wangcai.activity;

import java.util.ArrayList;
import java.util.Random;

import com.example.wangcai.R;
import com.example.wangcai.base.ActivityHelper;
import com.example.wangcai.base.ManagedActivity;

import android.annotation.SuppressLint;
import android.content.Intent;
import android.os.AsyncTask;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.ImageView;

public class LotteryActivity extends ManagedActivity {
	final static int sg_nBaseTimerElapse = 100;
	final static int sg_nSlowdownItems = 10;	//剩下多少个item开始减速
	final static int sg_nSlowSpeed = 80;
	
	final static int sg_nFlashTimerElapse = 100;
	final static int sg_nTotalFlashTimes = 8;
	
	final static int sg_nUpdateMsg = 1;
	final static int sg_nMinLoops = 2;
	final static int sg_nMaxLoops = 4;
	
	private class BonusInfo {
		public BonusInfo(int nBonus, int nViewId) {
			m_nViewId = nViewId;
			m_nBonus = nBonus;
		}
		int m_nViewId;
		int m_nBonus;
	}
	private final BonusInfo sg_bonusArray[] = {
			new BonusInfo(50, R.id.icon11),
			new BonusInfo(0, R.id.icon12),
			new BonusInfo(10, R.id.icon13),
			new BonusInfo(0, R.id.icon14),
			new BonusInfo(800, R.id.icon24),
			new BonusInfo(0, R.id.icon34),
			new BonusInfo(10, R.id.icon44),
			new BonusInfo(300, R.id.icon43),
			new BonusInfo(0, R.id.icon42),
			new BonusInfo(50, R.id.icon41),
			new BonusInfo(10, R.id.icon31),
			new BonusInfo(0, R.id.icon21)
	};
	private int GetItemIndex(int nBouns) {
		ArrayList<Integer> listItems = new ArrayList<Integer>();
		
		int nItemCount = sg_bonusArray.length;
		for (int i = 0; i < nItemCount; ++i) {
			BonusInfo bonusInfo = sg_bonusArray[i];
			if (bonusInfo.m_nBonus == nBouns) {
				listItems.add(i);
			}
		}
		int nRand = new Random().nextInt(listItems.size());
		return listItems.get(nRand);
	}

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_lottery);
        
        Intent intent = this.getIntent();
        m_nBonus = intent.getIntExtra(ActivityHelper.sg_strBonus, 0);
        int nLoopCount = new Random().nextInt(sg_nMaxLoops - sg_nMinLoops) + sg_nMinLoops;
        m_nTotalAnimationTimes = nLoopCount * sg_bonusArray.length + GetItemIndex(m_nBonus);

        m_imageCover =  (ImageView)findViewById(R.id.select_cover);
        m_imageBorder = (ImageView)findViewById(R.id.select_border);
        AttachEvents();

     }
    
    private void AttachEvents()
    {
    	//抽奖按钮
    	this.findViewById(R.id.lottery_button).setOnClickListener(new OnClickListener() {
            public void onClick(View v) {
            	if (m_animationTask != null) {
            		return;
            	}
            	m_animationTask = new AnimationTask();
            	m_animationTask.execute(m_nTotalAnimationTimes); 
            }
        });
    	
    	this.findViewById(R.id.return_button).setOnClickListener(new OnClickListener() {
            public void onClick(View v) {
            	finish();
            }
        });
    
    }
    
    private class AnimationTask extends AsyncTask<Integer, Integer, Integer> {

  		@Override
  		protected Integer doInBackground(Integer... params) {
  			int nSwitchIndex = 0;
  			//转圈
  			while (nSwitchIndex < m_nTotalAnimationTimes) {
  			
  				int nSleepMiniSec = sg_nBaseTimerElapse;
  				int nRemainAnimationTimes = m_nTotalAnimationTimes - nSwitchIndex; 
  				if (nRemainAnimationTimes <=  sg_nSlowdownItems) {
  					//快完了就减速, 越接近, 速度越慢
  					nSleepMiniSec += (sg_nSlowdownItems - nRemainAnimationTimes) * sg_nSlowSpeed;
  				}
  				try {
					Thread.sleep(nSleepMiniSec);
				} catch (InterruptedException e) {
				}
  				nSwitchIndex ++;

                publishProgress(nSwitchIndex);
  			}
  			m_bLoopComplete = true;
  			
  			//闪烁
  			int nFlashTimes = 0;
  			while (nFlashTimes < sg_nTotalFlashTimes) {

                publishProgress(nFlashTimes);
				try {
					Thread.sleep(sg_nFlashTimerElapse);
				} catch (InterruptedException e) {
				}
  				nFlashTimes ++;
  			}
  			return 0;
  		}
  		@SuppressLint("NewApi") @Override  
        protected void onProgressUpdate(Integer... nCurrentIndexs) {
  			int nCurrentIndex= nCurrentIndexs[0];
  			if (m_bLoopComplete) {
  				//转完了, 闪烁下
  	  	       	m_imageCover.setVisibility(View.GONE);
  	  	        	
  		       	BonusInfo bonusInfo = sg_bonusArray[m_nTotalAnimationTimes % sg_bonusArray.length];	        	
  		       	ImageView targetImage = (ImageView)findViewById(bonusInfo.m_nViewId);
  
  		       	m_imageBorder.setTop(targetImage.getTop());
  		       	m_imageBorder.setLeft(targetImage.getLeft());
  		        m_imageBorder.setRight(targetImage.getRight());
  		        m_imageBorder.setBottom(targetImage.getBottom());
  	        	int nImgId = R.drawable.choujiang_border_selected1;
  	        	if (nCurrentIndex % 2 == 0) {
  	        		nImgId = R.drawable.choujiang_border_selected2;
  	        	}
  	        	m_imageBorder.setBackgroundResource(nImgId);
  	  	       	m_imageBorder.setVisibility(View.VISIBLE);
  			}
  			else {
  				//正在转
	          	BonusInfo bonusInfo = sg_bonusArray[nCurrentIndex % sg_bonusArray.length];	        	
	        	ImageView targetImage = (ImageView)findViewById(bonusInfo.m_nViewId);
	        	
	        	m_imageCover.setTop(targetImage.getTop());
	        	m_imageCover.setLeft(targetImage.getLeft());
	        	m_imageCover.setRight(targetImage.getRight());
	        	m_imageCover.setBottom(targetImage.getBottom());
	        	m_imageCover.setVisibility(View.VISIBLE);
  			}
        }  
        @Override  
        protected void onPostExecute(Integer nItemIndex) {
        	m_animationTask = null;
	        m_imageCover.setVisibility(View.GONE);
	        m_imageBorder.setVisibility(View.GONE);
        }
    }

    @Override 
    protected void onDestroy() {
    	if (m_animationTask != null) {
    		m_animationTask.cancel(true);
    		m_animationTask = null;
    	}
    	super.onDestroy();
     }
    
    //private boolean m_bTaskRunning = false;
    private int m_nBonus = 0;
    private int m_nTotalAnimationTimes = 0;
    private AnimationTask m_animationTask = null;
    private boolean m_bLoopComplete = false;
    private ImageView m_imageCover;
    private ImageView m_imageBorder;
}




