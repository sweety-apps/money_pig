# -*- coding: utf-8 -*-

class AnonymousAccount:
    def __init__(self):
        self.device_id = ''
        self.money = 0
        self.flag = 0
        self.create_time = 0


class BillingAccount:
    def __init__(self):
        self.userid     = 0
        self.money      = 0
        self.freeze     = 0
        self.income     = 0
        self.outgo      = 0
        self.shared_income = 0
        self.status     = 0
        self.create_time = 0


class BillingLog:
    def __init__(self):
        self.serial_num = ''
        self.userid = 0
        self.device_id = ''
        self.money = 0
        self.remark = ''
        self.time = ''


class BillingTransaction:
    def __init__(self):
        self.serial_num = ''
        self.userid = 0
        self.device_id = ''
        self.money = 0
        self.status = 0
        self.remark = ''


class AccountStatus:
    S_NORMAL = 0
    S_FREEZED = 1


class TransactionStatus:
    S_PENDING = 0
    S_CANCELLED = 1
    S_COMMITTED = 2


class BillingError:
    E_OK = 0
    E_NO_SUCH_ACCOUNT   = 1
    E_INVALID_ACCOUNT   = 2
    E_INSUFFIENT_FUNDS  = 3
    E_SERIAL_NOT_FOUND  = 4
    E_INVALID_TRANSACTION = 5
    E_TRANSACTION_CANCELLED = 6

    @staticmethod
    def strerror(err):
        return dict([(v, k) for k, v in BillingError.__dict__.items() if k.startswith('E_')])[err]


