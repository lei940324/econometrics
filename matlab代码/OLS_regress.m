function [B,resid,siga2,bint,cov_matrix,t,t_p] = OLS_regress(Y,X)

%输入变量:
%Y - 被解释变量
%X - 解释变量

%输出变量:
% B - 待估计参数beta
% resid - 残差
% siga2 - 残差方差
% bint - 95%置信区间序列
% cov_matrix - 协方差矩阵

% 1.求OLS估计量B
B = inv(X'*X)*X'*Y;

% 2.计算协方差矩阵
resid = Y - X*B;  %残差
[n,K] = size(X);  
siga2 = sum(resid.^2)/(n-K);
cov_matrix = siga2*inv(X'*X);

% 3.t检验
t = B./sqrt(diag(cov_matrix));
t_p = 2*(1-tcdf(abs(t),n-K));

% 4.计算95%置信区间
alpha = 0.05;   %置信度
nu = max(0,n-K);  %自由度
tval = tinv(1-alpha/2,nu);
se = sqrt(diag(cov_matrix));
bint = [B-tval*se, B+tval*se];



