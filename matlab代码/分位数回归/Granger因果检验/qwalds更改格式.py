# -*- coding: utf-8 -*-
"""
Created on Thu Mar 28 17:56:00 2019

@author: Administrator
"""

import xlrd
from time import sleep
import win32com.client as win32
#需要更改路径
path="C:\\Users\\Administrator\\Desktop\\"
workbook = xlrd.open_workbook(path+'qwalds.xlsx')
tables=workbook.sheets()[0]

app = 'Excel'
xl = win32.gencache.EnsureDispatch('%s.Application' % app)
ss = xl.Workbooks.Add()
sh = ss.ActiveSheet
xl.Visible = True
sleep(1)
column_num=tables.ncols #列数
line_num=tables.nrows #行数

for i in range(column_num):
    e=[]        
    rows=tables.col_values(i)
    for j in range(1,line_num):
        xing=str(rows[j]).find('*')
        if xing !=-1:
            c=rows[j].split('*')
            c2=(len(c)-1)*'*'
            d='%.3f' % float(c[0])
            d2=c[len(c)-1].replace('\\',"")
            sh.Cells(j,i+1).Value =d+c2+'\n'+d2
            sh.Cells(j,i+1).Font.Bold = True
        else:
            c=rows[j].split('\\')
            d='%.3f' % float(c[0])
            sh.Cells(j,i+1).Value =d+'\n'+c[1]
sh.Range(sh.Cells(1, 1), sh.Cells(line_num, column_num+1)).Font.Name = "Times New Roman"
sh.Range(sh.Cells(1, 1), sh.Cells(line_num, column_num+1)).Font.Size = 10.5
'''
sh.SaveAs(path+'demo.xls')
ss.Close(False)
xl.Application.Quit()
'''