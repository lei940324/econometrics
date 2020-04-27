clc;clear;
% 1.载入数据
data = xlsread('C:\Users\Administrator\Desktop\hourse.xlsx');
f1 = data(:,2); f2 = data(:,3); e = data(:,6); q = 0.4;

% 2.绘制置信区间图
Q = linspace(0.1,0.9,30);
fig = figure; 
for k = 1:length(Q)
    p = 1; q = 1;
    [beta1,ser,Y_Yhat,fval,VARbeta,coefficient_interval] = qar_estim(f1,e,p,q,Q(k),1);
    beta(1,k)=beta1(2+p,1);
    UP(1,k)=coefficient_interval(2+p,4);
    LOW(1,k)=coefficient_interval(2+p,3);
end 
Q2 = Q(end:-1:1);
UP3 = UP(end:-1:1);
fill([Q,Q2],[LOW,UP3],[0.7451	0.7451	0.7451]);
hold on
plot(Q,beta,'LineWidth',3,'Color',[0 0 0]);
plot(Q,UP,'Color',[1 1 1]);
plot(Q,LOW,'Color',[1 1 1]);
axis tight;
%axis([0.1,0.9,-2.4,0.6]) 
set(gca,'FontSize',20)
title('房价的滞后一阶系数置信区间示意图','FontSize',20)
xlabel('分位点','FontSize',20)
%ylim([-0.4,0.6])