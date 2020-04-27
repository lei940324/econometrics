function [beta,resid,cov_mat,AIC] = VAR(Y,X,p)
% 注意:只是实现了两变量的VAR模型，思考如何实现任意个变量的VAR
% p - 滞后阶数
% AIC - 信息准则

% 1.估计系数
[ADLy,ADLx] = ADLxx(Y,X,p,p);
[beta1,~,resid1] = regress(ADLy,ADLx);

[ADLy,ADLx] = ADLxx(X,Y,p,p);
[beta2,~,resid2] = regress(ADLy,ADLx);

beta = [beta1';beta2'];
resid = [resid1,resid2];

% 2.估计AIC值(eviews调整自由度之后的)
T = length(ADLy);
cov_mat = resid'*resid/(T-3);
AIC = log(det(cov_mat))+2*(2*p+1)*2/T;

% % 1.载入数据
% data = xlsread('C:\Users\Administrator\Desktop\hourse.xlsx');
% f1 = data(:,2); f2 = data(:,3); e = data(:,6);
% 
% % 2.估计VAR模型
% [beta,resid,AIC] = VAR(f1,e,2);