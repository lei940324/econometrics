% 1.编写目标函数
function z = ObjectFunction(Beta)
	z = (Beta(1)+1)^2 + (Beta(2)-1)^2;

% % 2.初始参数设定
% maxsize         = 2000;         % 生成均匀随机数的个数(用于赋初值)
% REP			    = 100;          % 若发散则继续进行迭代的次数
% nInitialVectors    = [maxsize, 2];    % 生成随机数向量
% MaxFunEvals    = 5000;         % 函数评价的最大次数
% MaxIter         = 5000;         % 允许迭代的最大次数
% options = optimset('LargeScale', 'off','HessUpdate', 'dfp','MaxFunEvals', ...
% MaxFunEvals, 'display', 'on', 'MaxIter', MaxIter, 'TolFun', 1e-6, 'TolX', 1e-6,'TolCon',10^-12);
% 
% % 3.寻找最优初值
% initialTargetVectors = unifrnd(-5,5, nInitialVectors);
% RQfval = zeros(nInitialVectors(1), 1);
% for i = 1:nInitialVectors(1)
%     RQfval(i) = ObjectFunction(initialTargetVectors(i,:));
% end
% Results          = [RQfval, initialTargetVectors];
% SortedResults    = sortrows(Results,1);
% BestInitialCond  = SortedResults(1,2: size(Results,2));    
% 
% % 4.迭代求出最优估计值Beta
% [Beta, fval exitflag] = fminsearch(' ObjectFunction ', BestInitialCond);
% for it = 1:REP
% if exitflag == 1, break, end
% [Beta, fval exitflag] = fminsearch(' ObjectFunction ', BestInitialCond);
% end
% if exitflag~=1, warning('警告：迭代并没有完成'), end

