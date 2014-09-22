#!/usr/bin/env python

#import MySQLdb
import pymysql
MySQLdb = pymysql



conn = MySQLdb.connect('localhost', 'root', '')
cur = conn.cursor(MySQLdb.cursors.DictCursor)
cur.execute('SELECT phone_num, invite_code, id, inviter_id FROM wangcai.user_info')

tree_map = {}

for each in cur.fetchall():
    phone = each['phone_num']
    userid = int(each['id'])
    inviter = int(each['inviter_id'])
    invite_code = each['invite_code']
#    print '%s, %d, %d' %(phone, userid, inviter)
    tree_map[userid] = {
        'phone': phone,
        'userid': userid,
        'inviter': inviter,
        'invite_code': invite_code,
        'children': [],
        'flag': False
    }

cur.execute('SELECT userid, money, income FROM wangcai_billing.billing_account')

for each in cur.fetchall():
    userid = int(each['userid'])
    money = int(each['money'])
    income = int(each['income'])
    if userid in tree_map:
        tree_map[userid]['money'] = money
        tree_map[userid]['income'] = income


for k, v in sorted(tree_map.items(), key=lambda d:d[0]):
    inviter = v['inviter']
    if inviter != 0 and inviter in tree_map:
        tree_map[inviter]['children'].append(k)

def in_circle(userid, inviter, max_level):
    if userid == inviter:
        return True
    ancestor = [inviter]
    while inviter != 0 and max_level > 0:
        inviter = tree_map[inviter]['inviter']
        if userid == inviter:
            return True
        if inviter in ancestor:
            return False
        ancestor.append(inviter)
        max_level -= 1
#        print 'detectint circle: ', userid, inviter, str(ancestor)
    return False

def print_node(node, level=0):
    if level == 0:
        prefix = ''
    else:
        prefix = ' '*4*level + '+'

    print '%s %d (%s) - %s - %.2f/%.2f' % (prefix, 
            node['userid'], node['invite_code'], node['phone'], node['money']/100, node['income']/100)
    if len(node['children']) > 0:
        for i in node['children']:
#            print '  %s %d %d - %s' % (prefix, level, i, str(tree_map[i]['children']))
            if in_circle(i, node['userid'], level):
                pass
            else:
                print_node(tree_map[i], level+1)

        
for k, v in sorted(tree_map.items(), key=lambda d:d[0]):
    if v['inviter'] != 0 and k > v['inviter']:
        continue
        #print_node(v)
    else:
        print_node(v)


#    elif len(v['children']) == 0:
#        print '%d (%s)' % (v['userid'], v['phone'])
#    else:
#        print '%d (%s) - %s' % (v['userid'], v['phone'], str(v['children']))
#        for u in v['children']:
#            print '  + %d - %s' % (u, str(tree_map[u]['children']))
            


