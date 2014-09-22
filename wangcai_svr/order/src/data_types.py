# -*- coding: utf-8 -*-

class Order:
    def __init__(self):
        self.userid = 0
        self.device_id = ''
        self.serial_num = ''
        self.type = 0
        self.money = 0
        self.status = 0

class OrderType:
    T_NONE = 0
    T_ALIPAY_TRANSFER = 1
    T_PHONE_PAYMENT = 2
    T_EXCHANGE_CODE = 3

class OrderStatus:
    S_PENDING = 0
    S_CONFIRMED = 1
    S_OPERATED = 2


class OrderAlipayTransfer(Order):
    def __init__(self):
        Order.__init__(self)
        self.type = OrderType.T_ALIPAY_TRANSFER
        self.alipay_account = ''
        self.status = 0
        self.create_time = ''
        self.confirm_time = ''
        self.operate_time = ''


class OrderPhonePayment(Order):
    def __init__(self):
        Order.__init__(self)
        self.type = OrderType.T_PHONE_PAYMENT
        self.phone_num = ''
        self.status = 0
        self.create_time = ''
        self.confirm_time = ''
        self.operate_time = ''


class OrderExchangeCode(Order):
    def __init__(self):
        Order.__init__(self)
        self.type = OrderType.T_EXCHANGE_CODE
        self.exchange_type = 0
        self.exchange_code = ''
        self.status = 0
        self.create_time = ''
        self.confirm_time = ''
        self.operate_time = ''


class ExchangeType:
    T_UNDEFINED = 0
    T_JINGDONG = 1
    T_XLVIP = 2


class ExchangeEntry:
    def __init__(self):
        self.type = 0
        self.name = ''
        self.icon = ''
        self.price = 0
        self.remain = 0




