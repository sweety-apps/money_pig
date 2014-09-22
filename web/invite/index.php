<?php
$code = $_GET['code'];
?>
<!DOCTYPE html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<link rel="stylesheet" type="text/css" href="index.css" />
<meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no"/>

<script>
window.onload = function() {
	var installbtn = document.getElementById("installbtn");
	var codeText = document.getElementById("codeText");
	
	var width = document.body.clientWidth;
	
	installbtn.style.top = (width * 0.4) + "px";
	installbtn.style.height = (width * 0.2) + "px";
	
	codeText.style.top = (width * 0.98) + "px";
	codeText.style.height = (width * 0.23) + "px";
}

window.onresize = function(){
	var installbtn = document.getElementById("installbtn");
	var codeText = document.getElementById("codeText");
	
	var width = document.body.clientWidth;
	
	installbtn.style.top = (width * 0.4) + "px";
	installbtn.style.height = (width * 0.2) + "px";
	
	codeText.style.top = (width * 0.98) + "px";
	codeText.style.height = (width * 0.23) + "px";
}

function onInstall() {
	var sysName = navigator.userAgent.split(";")[0].split('(')[1];//判断系统
	if ( sysName == "iPhone" || sysName == "iphone" ) {
		window.location.href="./install.php";
	} else {
		alert ("当前只支持iPhone");
	}
}
</script>
</head>
<body>
	<div class="bkg">
		<img src="./invite.png" width="100%" />
		<div class="installbtn" id="installbtn" onClick="onInstall()"></div>
		<div class="codeText" id="codeText">
			<?php echo $code; ?>
		</div>
	</div>
	<script type="text/javascript" src="http://tajs.qq.com/stats?sId=29681740" charset="UTF-8"></script>
</body>
</html>
