<?php
function getExchangeInfo() {
	$obj = array();

	// 记录1
	$tmp = array();
	
	array_push($tmp, "2013-11-12");

	$text = array();
	$text['type'] = 2;	// 1.绿色圈	 2.黄色圈  绿色进，黄色出
	$text['coin'] = 10;
	$text['info'] = "兑换10元话费";
	$text['num'] = 182371831;
	array_push($tmp, $text);
	
	array_push($obj, $tmp);
	
	// 记录2
	$tmp = array();
	
	array_push($tmp, "2013-11-13");
	
	$text = array();
	$text['type'] = 10;	// 1.绿色圈	 2.黄色圈  绿色进，黄色出
	$text['coin'] = 3;
	$text['info'] = "试玩窃听风云";
	array_push($tmp, $text);
	
	$text = array();
	$text['type'] = 1;
	$text['coin'] = 3;
	$text['info'] = "签到抽奖";
	array_push($tmp, $text);
	
	$text = array();
	$text['type'] = 1;
	$text['coin'] = 3;
	$text['info'] = "首次安装旺财";
	array_push($tmp, $text);
	
	array_push($obj, $tmp);
	
	// 记录3
	$tmp = array();
	
	array_push($tmp, "2013-11-14");
	
	$text = array();
	$text['type'] = 10;	// 1.绿色圈	 2.黄色圈  绿色进，黄色出
	$text['coin'] = 3;
	$text['info'] = "试玩窃听风云";
	array_push($tmp, $text);
	
	$text = array();
	$text['type'] = 10;	// 1.绿色圈	 2.黄色圈  绿色进，黄色出
	$text['coin'] = 3;
	$text['info'] = "试玩窃听风云";
	array_push($tmp, $text);
	
	$text = array();
	$text['type'] = 10;	// 1.绿色圈	 2.黄色圈  绿色进，黄色出
	$text['coin'] = 3;
	$text['info'] = "试玩窃听风云";
	array_push($tmp, $text);
	
	array_push($obj, $tmp);
	
	return $obj;
}

$data = getExchangeInfo();
?>

<!DOCTYPE html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<link rel="stylesheet" type="text/css" href="exchange_info.css" />
<!-- <script src="exchange_info.js"></script> -->
<meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no"/>

</head>
<body>
	<div class="header">
		<img src="./img/exchange_head.png" width="320px" />
		<div class="info">
			<table border="0">
				<tr>
					<th>231.1</th>
					<th class="symbol">-</th>
					<th>10.0</th>
					<th class="symbol">=</th>
					<th>228.1</th>
				</tr>
				<tr class="desc">
					<th>总收入</th>
					<th class="symbol"></th>
					<th>支出</th>
					<th class="symbol"></th>
					<th>余额</th>
				</tr>
			</table>
		</div>
	</div>
	<div class="exchangeinfo">
<?php
	foreach ( $data as $info ) {
?>
		<div class="item">
			<div class="date">
				<?php echo $info[0]; ?>
			</div>
			<div class="info">
<?php
			for ($i = 1; $i < count($info); $i ++ ) {
				$item = $info[$i];
				if ( $item['type'] == 1 ) {
					$img = "./img/withdraw.png";
				} else {
					$img = "./img/buy.png";
				}
?>
				<div class="left">
					<div class="fl_img">
						<img src="<?php echo $img; ?>" width="11px" />
					</div>
					<div class="fl">
						<?php echo $item['info']; ?>
					</div>
					<div class="clear"></div>
<?php
				if ( array_key_exists('num', $item) ) {
?>
					<div class="ordernumber fl">
						<div class="fl_img">
						</div>
						<div class="fl">
							单号：<a href="/wangcai_js/order_info?num=<?php echo $item['num']; ?>"><font><?php echo $item['num']; ?></font></a>
						</div>
						<div class="clear"></div>
					</div>
<?php
				}
?>
				</div>
				<div class="right">
<?php
				if ( $item['type'] == 1 ) {
					echo '获得'.$item['coin'].'元';
				} else {
					echo '支出'.$item['coin'].'元';
				}
?>
				</div>
				<div class="clear"></div>
<?php
			}
?>
			</div>
			<div class="clear"></div>
			<img src="./img/line.png" width="320px" height="1px" />
		</div>
<?php
	}
?>
	</div>
</body>
</html>
