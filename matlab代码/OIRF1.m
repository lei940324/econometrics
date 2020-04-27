function [beta,IR] = OIRF1(Y,X,num,IMP)

% num - 脉冲期数

% 1.估计VAR模型参数
[beta,~,cov_mat] = VAR(Y,X,1);

% 2.脉冲响应函数
% 2.1 正交化分解，估计P矩阵
P = chol(cov_mat, 'lower');
% 2.2 估计IR,s=1期为ADt,s=k，则为A^(k)Dt
b = beta(:,2:3);
SHOCK = zeros(2,1);
if IMP == 1
    SHOCK(1,1) = 1; 
elseif IMP == 2
    SHOCK(2,1) = 1; 
end
IR = zeros(num,2);
IR(1,:) = b*(P*SHOCK);
for s=2:num, IR(s,:) = (b*IR(s-1,:)')'; end