# -*- coding: utf-8 -*-

#import MySQLdb
import pymysql
MySQLdb = pymysql

import logging
from config import *
from 

logger = logging.getLogger('db_helper')

conn = MySQLdb.connect(host=MYSQL_HOST, user=MYSQL_USER, passwd=MYSQL_PASSWD, db=MYSQL_DB, charset='utf8')

def 


