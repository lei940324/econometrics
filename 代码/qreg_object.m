function loss_sum = qreg_object(beta,y,x,q)
% beta - 待估计参数,列向量
% y - 被解释变量,列向量
% x - 解释变量,列向量
% q - 分位点
[T,~] = size(x); 
y_hat = zeros(T,1);
for i = 1:T
    y_hat(i) = x(i,:)*beta;
end
resid = y-y_hat;

loss = zeros(T,1);
for i=1:T
    if resid(i)>0
        loss(i) = q*resid(i);
    else
        loss(i) = (q-1)*resid(i);
    end
end
loss_sum = sum(loss);

% % 估计分位数方程：f1 = c + e ,分位点为0.4
% % 1.载入数据
% data = xlsread('C:\Users\Administrator\Desktop\hourse.xlsx');
% f1 = data(:,2); f2 = data(:,3); e = data(:,6); q = 0.4;
%  
% % 2.初始参数设定
% maxsize         = 2000;         % 生成均匀随机数的个数(用于赋初值)
% REP			    = 100;          % 若发散则继续进行迭代的次数
% nInitialVectors    = [maxsize, 2];    % 生成随机数向量
% MaxFunEvals    = 5000;         % 函数评价的最大次数
% MaxIter         = 5000;         % 允许迭代的最大次数
% options = optimset('LargeScale', 'off','HessUpdate', 'dfp','MaxFunEvals', ...
% MaxFunEvals, 'display', 'on', 'MaxIter', MaxIter, 'TolFun', 1e-6, 'TolX', 1e-6,'TolCon',10^-12);
% 
% % 3.使用OLS回归估计最优初值
% beta = regress(f1,[ones(length(f1),1),e]);
% 
% % 4.迭代求出最优估计值Beta
% [Beta, fval, exitflag] = fminsearch(' qreg_object ', beta ,options,f1,[ones(length(f1),1),e],q);
% for it = 1:REP
% if exitflag == 1, break, end
% [Beta, fval, exitflag] = fminsearch(' qreg_object ', beta ,options,f1,[ones(length(f1),1),e],q);
% end
% if exitflag~=1, warning('警告：迭代并没有完成'), end