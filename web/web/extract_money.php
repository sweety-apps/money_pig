<!DOCTYPE html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<link rel="stylesheet" type="text/css" href="extract_money.css" />
<script src="extract_money.js"></script>
<meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no"/>

</head>
<body>
	<div class="product">
	<div class="header">
		<div id="noattach" class="noattach">
			<img src="./img/warn.png" width="17px" />
			<div class="info">您还没有绑定手机,为了有效兑换</div>
		
			<div class="attachphone" onClick="attachPhone()">
				<img src="./img/attachphone.png" width="74px" />
				<div class="attachphonetext">绑定手机号</div>
			</div>
		</div>
		<div id="isattach" class="isattach">
			<img src="./img/BindTipsDuihao.png" width="17px" />
			<div class="info">可用余额：<span>22.3</span></div>
			<a href="/wangcai_js/exchange_info">
				<img class="btn" src="./img/exchange.png" width="74px" />
			</a>
		</div>
	</div>
	
	<div class="bdy">
		<img src="./img/alipay.png" width="65px" />
		<div class="alipay_select">
			请选择提取金额:
		</div>
		<div class="select">
			<div class="item" onClick="clickAlipay(5)">
				<img src="./img/select_alipay.png" width="55px" />
				<div class="text">5元</div>
			</div>
			<div class="item" onClick="clickAlipay(10)">
				<img src="./img/select_alipay.png" width="55px" />
				<div class="text">10元</div>
			</div>
			<div class="item" onClick="clickAlipay(20)">
				<img src="./img/select_alipay.png" width="55px" />
				<div class="text">20元</div>
			</div>
			<div class="item2" onClick="clickAlipay(30)">
				<img src="./img/select_alipay.png" width="55px" />
				<div class="text">30元</div>
				<div class="desc">多送1元</div>
			</div>
			<div class="item2 last" onClick="clickAlipay(50)">
				<img src="./img/select_alipay.png" width="55px" />
				<div class="text">50元</div>
				<div class="desc">多送5元</div>
			</div>
			<div class="clear"></div>
		</div>
		
		<img src="./img/phone.png" width="195px" style="margin-bottom:10px" />
		<div class="phone_select">
			<div class="item" onClick="clickPhone(10)">
				<img src="./img/phone_bkg.png" width="289px" />
				<div class="text">充值10元</div>
			</div>
			<div class="item" onClick="clickPhone(30)">
				<img src="./img/phone_bkg.png" width="289px" />
				<div class="text">充值30元<font color="#FF0000">(仅售29元)</font></div>
			</div>
			<div class="item" onClick="clickPhone(50)">
				<img src="./img/phone_bkg.png" width="289px" />
				<div class="text">充值50元<font color="#FF0000">(仅售48元)</font></div>
			</div>
		</div>
		<!--
		<a href="/wangcai_js/pay_to_alipay?coin=5.0">
			转账到支付宝
		</a>
		
		手机充值
		<a href="/wangcai_js/pay_to_phone?coin=5.0">
			话费充值
		</a>
		-->
	</div>
	<!--
	<div class="banner">
		<img src="./img/banner.png" width="320px" />
	</div>
	-->
	</div>
</body>
</html>
