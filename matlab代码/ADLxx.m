function [ADLy,ADLx] = ADLxx(Y,X,p,q)

%待估计方程：y = c + y(-1) +....+y(-p) + x(-1) + ... + x(-q)
% 获取自回归分布滞后模型的估计向量
%  X   - 解释变量，列向量
%  Y   - 被解释变量，列向量
%  p   - ADL模型Y的滞后阶数,标量
%  q   - ADL模型X的滞后阶数,标量

T = length(Y);
N = max(p,q)+1;

ADLy = Y(N:T);
c = ones(length(ADLy),1);  %常数项
ADLx = zeros(length(ADLy),1+p+q);
ADLx(:,1) = c;
for i=1:p, ADLx(:,1+i) = Y(N-i:T-i);end
for i=1:q, ADLx(:,1+p+i) = X(N-i:T-i);end

% % 1.载入数据
% data = xlsread('C:\Users\Administrator\Desktop\hourse.xlsx');
% f1 = data(:,2); f2 = data(:,3); e = data(:,6);
% 
% % 2.估计ADL模型f1 = c + f1(-1) + f1(-2) + e(-1)
% [ADLy,ADLx] = ADLxx(f1,e,2,1);
% beta = regress(ADLy,ADLx);