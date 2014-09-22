<?php
include_once "../config.php";
include_once "../common.php";

parseParam();

// 返回任务信息
function getAppTaskInfo() {
	$data = get(TASK_DETAIL);
	$jsonObj = json_decode($data);

	$obj = array();
	if ( $jsonObj->res == 0 ) {
		$task = $jsonObj->task;
		$obj['title'] = $task->app_name;
		$obj['ico'] = $task->icon;
		$obj['desc'] = $task->intro;
		$obj['appid'] = $task->appid;
		$obj['thumb'] = $task->screenshots;
		$obj['class'] = $task->genre;
		$obj['redirect_url'] = $task->redirect_url;
	}
	
	$obj['stepNum'] = 3;	// 总的步骤数
	$obj['curStep'] = 1;	// 当前进入到第几步

	return $obj;
}

$appInfo = getAppTaskInfo();
?>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link rel="stylesheet" type="text/css" href="app_task.css" />
<script src="app_task.js"></script>
<script>
var stepNum = <?php echo $appInfo['stepNum']; ?>;
var step = <?php echo $appInfo['curStep']; ?>;
</script>
</head>

<body>
<div id="step1" class="step hide">
	<div class="appinfo" style="min-height:310px;">
		<div class="ico">
			<img width="78px" height="78px" src="<?php echo $appInfo['ico']; ?>" />
		</div>
		<div class="info">
			<div class="title"><?php echo $appInfo['title']; ?></div>
			<div class="class">类别：<?php echo $appInfo['class']; ?></div>
			<div class="descTitle">介绍</div>
			<div class="desc"><?php echo $appInfo['desc']; ?></div>
		</div>
		<div class="clear">
		</div>
	</div>
	<div class="install">
		<a href="/wangcai_js/install_app?appid=<?php echo $appInfo['appid']; ?>" target="_blank">
			<img src="../img/btnBkg.png" width="291px" />
		</a>
	</div>
</div>
<?php
if ( $appInfo['stepNum'] == 3 ) {
?>
<div class="step hide" id="step2">
	<div class="appinfo">
		<div class="ico">
			<img width="78px" height="78px" src="<?php echo $appInfo['ico']; ?>" />
		</div>
		<div class="info">
			<div class="title"><?php echo $appInfo['title']; ?></div><br />
			<div class="tip">安装成功，<br/>请继续完成注册</div>
		</div>
		<div class="clear">
		</div>
	</div>
	<div class="thumb">
		<img src="<?php echo $appInfo['thumb']; ?>" />
	</div>
</div>
<?php
}
?>

<div class="step hide" id="step<?php echo ($appInfo['stepNum']==3 ? 3 : 2); ?>">
	<div class="suc">
		<img src="../img/success.png" width="291px" />
	</div>
	<div class="install">
		<a href="" target="_blank">
			<img src="../img/award1.png" width="291px" />
		</a>
	</div>
</div>

</body>
</html>
