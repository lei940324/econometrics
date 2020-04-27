function [ARy,ARx] = ARxx(X,P)

% 获取自回归的估计向量
%  X   - 输入数据，列向量
%  P   - AR 阶数,标量

N = length(X);
ARx = zeros(N-P,P+1);
ARx(:,1) = ones(N-P,1);   %常数项
for m = 1:P
    ARx(:,m+1) = X(P-m+1:N-m,1);  %P-m+1 = N-m-(N-P)+1
end
ARy = X(P+1:N,1);

% % 1.载入数据
% data = xlsread('C:\Users\Administrator\Desktop\hourse.xlsx');
% f1 = data(:,2); f2 = data(:,3); e = data(:,6);
% 
% % 2.估计自回归模型f1 = c + f1(-1) + f1(-2)
% [ARy,ARx] = ARxx(f1,2);
% beta = regress(ARy,ARx);
% 
% % 3.计算各滞后阶AIC值,选取最优滞后阶数(最大阶数为6)
% T = length(f1);
% AR_AIC = zeros(6,1);
% for p = 1:6
%     [ARy,ARx] = ARxx(f1,p);
%     beta = regress(ARy,ARx);
%     y_hat = ARx*beta;
%     resid = ARy - y_hat;
%     AR_AIC(p) = log(resid'*resid/T)+2*(p+1)/T;
% end
% 
% % 4.找到最小的AIC值所对应的阶数
% Best_p = find(AR_AIC == min(AR_AIC));
% [ARy,ARx] = ARxx(f1,Best_p);
% beta = regress(ARy,ARx);
    
