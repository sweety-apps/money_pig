/*
 * 官网地站:http://www.ShareSDK.cn
 * 技术支持QQ: 4006852216
 * 官方微信:ShareSDK   （如果发布新版本的话，我们将会第一时间通过微信将版本更新内容推送给您。如果使用过程中有任何问题，也可以通过微信与我们取得联系，我们将会在24小时内给予回复）
 *
 * Copyright (c) 2013年 ShareSDK.cn. All rights reserved.
 */

package cn.sharesdk.socialization.sample;

import java.io.File;
import java.io.FileOutputStream;
import cn.sharesdk.framework.Platform;
import cn.sharesdk.framework.ShareSDK;
import cn.sharesdk.framework.Platform.ShareParams;
import cn.sharesdk.framework.utils.UIHandler;
import cn.sharesdk.onekeyshare.OnekeyShare;
import cn.sharesdk.onekeyshare.ShareContentCustomizeCallback;
import cn.sharesdk.socialization.CommentFilter;
import cn.sharesdk.socialization.QuickCommentBar;
import cn.sharesdk.socialization.Socialization;
import cn.sharesdk.socialization.CommentFilter.FilterItem;
import cn.sharesdk.socialization.component.TopicTitle;
import android.os.Bundle;
import android.os.Message;
import android.os.Handler.Callback;
import android.app.Activity;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Bitmap.CompressFormat;
import android.text.TextUtils;
import android.view.View;
import android.view.View.OnClickListener;

/** 评论和赞功能的演示页面 */
public class MainActivity extends Activity implements Callback, OnClickListener {
	private static final String FILE_NAME = "/pic_glance_back.jpg";
	private String testImage;
	// 模拟的主题id
	private String topicId;
	// 模拟的主题标题
	private String topicTitle;
	// 模拟的主题发布时间
	private String topicPublishTime;
	// 模拟的主题作者
	private String topicAuthor;
	private OnekeyShare oks;
	private QuickCommentBar qcBar;
	private CommentFilter filter;

	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.page_comment_like);
		ShareSDK.initSDK(this);
		ShareSDK.registerService(Socialization.class);

		new Thread() {
			public void run() {
				initImagePath();
				UIHandler.sendEmptyMessageDelayed(1, 100, MainActivity.this);
			}
		}.start();
	}

	protected void onDestroy() {
		ShareSDK.stopSDK(this);
		super.onDestroy();
	}

	private void initImagePath() {
		try {
			String cachePath = cn.sharesdk.framework.utils.R.getCachePath(this, null);
			testImage = cachePath + FILE_NAME;
			File file = new File(testImage);
			if (!file.exists()) {
				file.createNewFile();
				Bitmap pic = BitmapFactory.decodeResource(getResources(), R.drawable.pic);
				FileOutputStream fos = new FileOutputStream(file);
				pic.compress(CompressFormat.JPEG, 100, fos);
				fos.flush();
				fos.close();
			}
		} catch(Throwable t) {
			t.printStackTrace();
			testImage = null;
		}
	}

	public boolean handleMessage(Message msg) {
		topicId = getString(R.string.comment_like_id);
		topicTitle = getString(R.string.comment_like_title);
		topicPublishTime = getString(R.string.comment_like_publich_time);
		topicAuthor = getString(R.string.comment_like_author);

		TopicTitle tt = (TopicTitle) findViewById(R.id.llTopicTitle);
		String topicTitle = getString(R.string.comment_like_title);
		tt.setTitle(topicTitle);
		tt.setPublishTime(getString(R.string.comment_like_publich_time));
		tt.setAuthor(getString(R.string.comment_like_author));

		Socialization service = ShareSDK.getService(Socialization.class);
		service.setCustomPlatform(new MyPlatform(this));
		initOnekeyShare();
		initQuickCommentBar();
		return false;
	}

	// Socialization服务依赖OnekeyShare组件，此方法初始化一个OnekeyShare对象
	// 此方法的代码从DemoPage中复制而来
	private void initOnekeyShare() {
		oks = new OnekeyShare();
		oks.setNotification(R.drawable.logo_sharesdk, getString(R.string.app_name));
		oks.setAddress("12345678901");
		oks.setTitle(getString(R.string.share));
		oks.setTitleUrl("http://sharesdk.cn");
		oks.setText(getString(R.string.share_content));
		oks.setImagePath(testImage);
		oks.setImageUrl("http://img.appgo.cn/imgs/sharesdk/content/2013/07/25/1374723172663.jpg");
		oks.setUrl("http://www.sharesdk.cn");
		oks.setFilePath(testImage);
		oks.setComment(getString(R.string.share));
		oks.setSite(getString(R.string.app_name));
		oks.setSiteUrl("http://sharesdk.cn");
		oks.setVenueName("ShareSDK");
		oks.setVenueDescription("This is a beautiful place!");
		oks.setLatitude(23.056081f);
		oks.setLongitude(113.385708f);
		oks.disableSSOWhenAuthorize();
		oks.setShareContentCustomizeCallback(new ShareContentCustomizeCallback() {
			public void onShare(Platform platform, ShareParams paramsToShare) {
				// 改写twitter分享内容中的text字段，否则会超长，
				// 因为twitter会将图片地址当作文本的一部分去计算长度
				if ("Twitter".equals(platform.getName())) {
					paramsToShare.setText(platform.getContext().getString(R.string.share_content_short));
				}
			}
		});
	}

	private void initQuickCommentBar() {
		qcBar = (QuickCommentBar) findViewById(R.id.qcBar);
		qcBar.setTopic(topicId, topicTitle, topicPublishTime, topicAuthor);
		qcBar.setTextToShare(getString(R.string.share_content));
		qcBar.getBackButton().setOnClickListener(this);
		qcBar.setAuthedAccountChangeable(false);
		CommentFilter.Builder builder = new CommentFilter.Builder();
		// 非空过滤器
		builder.append(new FilterItem() {
			// 返回true表示是垃圾评论
			public boolean onFilter(String comment) {
				if (TextUtils.isEmpty(comment)) {
					return true;
				} else if (comment.trim().length() <= 0) {
					return true;
				} else if (comment.trim().toLowerCase().equals("null")) {
					return true;
				}
				return false;
			}
		});
		// 字数上限过滤器
		builder.append(new FilterItem() {
			// 返回true表示是垃圾评论
			public boolean onFilter(String comment) {
				if (comment != null) {
					String pureComment = comment.trim();
					String wordText = cn.sharesdk.framework.utils.R.toWordText(pureComment, 140);
					if (wordText.length() != pureComment.length()) {
						return true;
					}
				}
				return false;
			}
		});
		filter = builder.build();
		qcBar.setCommentFilter(filter);
		qcBar.setOnekeyShare(oks);
	}

	public void onClick(View v) {
		if (v.equals(qcBar.getBackButton())) {
			finish();
		}
	}

}
