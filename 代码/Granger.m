function [beta,wald,wald_P,AIC,p,q,cov_mat] = Granger(Y,X)

%待估计方程：y = c + y(-1) +....+y(-p) + x(-1) + ... + x(-q)
% 获取Granger因果检验wald值与p值
%  X   - 解释变量，列向量
%  Y   - 被解释变量，列向量
%  p   - ADL模型Y的滞后阶数,标量
%  q   - ADL模型X的滞后阶数,标量
%  wald - wald统计量
%  wald_P - wald统计量的P值
%  AIC - 最小AIC值

% 1.计算各滞后阶的AIC值
AIC = zeros(5,5);
for p = 1:5
    for q = 1:5
        [ADLy,ADLx] = ADLxx(Y,X,p,q);
        [~,~,resid] = regress(ADLy,ADLx);
        T = length(ADLy);
        AIC(p,q) = log(resid'*resid/T)+2*(p+q+1)/T;
    end
end

% 2.找到最小的AIC值所对应的阶数
[p,q] = find(AIC == min(min(AIC)));
[ADLy,ADLx] = ADLxx(Y,X,p,q);
[beta,~,resid] = regress(ADLy,ADLx);
 
% 3.计算wald统计量
R = [zeros(q,1+p),eye(q)];
% 3.1 计算协方差矩阵
T = length(ADLy);
nu = T-(1+p+q);
siga2 = sum(resid.^2)/nu;
cov_mat = siga2*inv(ADLx'*ADLx);
Rcov_mat = siga2*R*inv(ADLx'*ADLx)*R';
% 3.2 计算wald
wald = (R*beta)'*inv(Rcov_mat)*(R*beta);
wald_P = 1 - chi2cdf(wald,q);
