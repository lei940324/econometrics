clc;clear;
% 1.导入数据
data = xlsread('C:\Users\Administrator\Desktop\hourse.xlsx');
mldate = x2mdate(data(:,1)); % 导入日期
f1 = data(:,2);%一线城市房价同月环比
f2 = data(:,3);%二线城市房价同月环比
f3 = data(:,4);%三线城市房价同月环比
e = data(:,6);%汇率做对数差分

% 2.绘制原始数据波动图
% 2.1 创建绘图窗口
fig=figure; 
% 2.2 设置窗口位置及颜色
set(fig,'Position',[100 100 1100 320],'Color',[1 1 1])
% 2.3 绘制第二个子图
subplot(1,2,2);f2plot = plot(mldate,e,'-o'); 
% 2.4 将横轴改为日期格式
datetick('x','keeplimits')
% 2.5 更改字号大小
set(gca,'FontSize',14) 
% 2.6 使图像更紧凑
axis tight;
% 2.7 添加标题
title('汇率波动图（对数差分）','FontSize',14) 
% 2.8 调整图像颜色以及线条宽度,可以在2.3内同时进行
set(f2plot,'Color',[0 0 1],'LineWidth',2)
% 2.9 添加网格线
grid on
set(gca, 'GridLineStyle' ,'--','LineWidth',1,'GridAlpha',1)
% 2.9 绘制第一个子图
subplot(1,2,1);fplot=plot(mldate,f1,'-rs'); 
hold on   %保证不覆盖上图
plot(mldate,f2,'-^','LineWidth',2,'MarKerFaceColor',[1 .1 1],'Color',[1 .1 0.1]);
plot(mldate,f3,'-p','LineWidth',2,'MarKerFaceColor',[1 0.5 0],'Color',[1 0.5 0]);
datetick('x','keeplimits')
axis tight;
set(gca,'FontSize',14) 
title('各线城市房价波动图','FontSize',14) 
set(fplot,'Color',[0.196080 .803920 .19608],'LineWidth',2)
grid on
set(gca, 'GridLineStyle' ,'--','LineWidth',1,'GridAlpha',1)
% 2.10 调整图像坐标位置
set(fig.Children(1),'Position',[0.055,0.1,0.42,0.8])
set(fig.Children(2),'Position',[0.55,0.1,0.42,0.8])
% 2.11 加上第一个子图图例
legend('一线城市','二线城市','三线城市')







    

