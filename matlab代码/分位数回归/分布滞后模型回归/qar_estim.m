function [BetaHat,ser,Y_Yhat,fval,VARbeta,coefficient_interval,stao,cT,Hn,stderr,tstats,pvals,wald,exitflag] = qar_estim(Y,X,p,q,Q,select)

% **************************************** help *********************************************
% 说明如下：
% 此函数为分位数分布滞后模型估计
% 待估计方程为：y=c(1)+c(2)*y(-1)....+c(3)*x(-1)
% 注意：默认均含有截距项
% *****************************************************************************************
% 输入参数：
% Y代表被解释变量
% X代表解释变量
% p代表被解释变量的滞后阶数，可以取0，这样解释变量不含y的滞后阶
% q代表被解释变量的滞后阶数，可以取0，这样解释变量为X
% 假设p=0,q=0
% 待估计方程为y=c(1)+c(2)*x
% select表示Wald计算方式不同，1为假定残差项服从idd，2为核密度估计
% *****************************************************************************************
% 输出参数：
% BetaHat为估计参数，顺序为[C,Y(-p),X(-q)]
% ser为真实估计序列(不包括常数项)，其形式为[Y,Y(-p),X(-q)]
% Y_Yhat为残差
% fval为分位数加权残差和
% VARbeta为方差-协方差矩阵
% coefficient_interval为95%置信区间
% stao为密度函数Sparsity
% cT为核估计窗宽cT
% Hn为Bandwidth method: Hall-Sheather,带宽bw
% stderr表示标准差
% tstats表示t检验
% pvals表示t检验的概率值
% wald表示wald统计量
% exitflag = 1表示收敛,否则表示迭代并没有完成
% ***************************************** help ********************************************

% 1.估计参数设定
 maxsize         = 2000;         % 生成均匀随机数的个数(用于赋初值)
 REP			 = 100;          % 若发散则继续进行迭代的次数
 nInitialVectors = [maxsize, 1]; % 生成随机数向量
 MaxFunEvals     = 5000;         % 函数评价的最大次数
 MaxIter         = 5000;         % 允许迭代的最大次数
% options = optimset('MaxFunEvals',MaxFunEvals, 'display', 'on', 'MaxIter', MaxIter,'TolCon',10^-12,'TolFun',10^-6,'TolX',10^-6);
% options = optimset('Display','iter','TolCon',10^-12,'TolFun',10^-4,'TolX',10^-6);
 options = optimset('LargeScale', 'off','HessUpdate', 'dfp','MaxFunEvals', ...
                      MaxFunEvals, 'display', 'on', 'MaxIter', MaxIter, 'TolFun', 1e-6, 'TolX', 1e-6,'TolCon',10^-12);
% warning('off', 'verbose') 
% *****************************************************************************************

% 2.得到真实估计序列ser(不包括常数项),其形式为[Y,Y(-p),X(-q)]
 C=Y((max(p,q)+1):length(Y),1);
 if p==0,Y_p=[];else
 for i=1:p,Y_p(:,i)=Y((max(p,q)-(i-1)):(length(Y)-i),1);end;end
 if q==0,X_q=[X];else
 for i=1:q,X_q(:,i)=X((max(p,q)-(i-1)):(length(X)-i),1);end;end
 ser=[C,Y_p,X_q];
 if q==0,qq=1;else qq=q;end
 ser=[C,Y_p,X_q];
 c=ones(length(C),1);  %常数项
 x=[c,Y_p,X_q];        %被解释变量构造
% *****************************************************************************************

% 3.利用OLS回归选择最优的初值
 beta_ols=regress(C,x);Q_range=abs(Q-0.5)+0.1;
 initialTargetVectors(:,1) =beta_ols(1)+ unifrnd(-Q_range, Q_range, nInitialVectors);
 initialTargetVectors(:,2:p+qq+1)=beta_ols(2:p+qq+1)'.*ones(maxsize,p+qq)+ unifrnd(-Q_range, Q_range, [maxsize,p+qq]);
 RQfval = zeros(nInitialVectors(1), 1);
 for i = 1:nInitialVectors(1)
    RQfval(i) = qregobjectiveFunction(initialTargetVectors(i,:),Y,X,p,q,Q,1);
 end
 Results          = [RQfval, initialTargetVectors];
 SortedResults    = sortrows(Results,1);
 BestInitialCond  = SortedResults(1,2:p+qq+2);    
 Beta = zeros(size(BestInitialCond)); fval = Beta(:,1); exitflag = Beta(:,1);
% *****************************************************************************************

% 4.进行参数估计得到 BetaHat
 for i = 1:size(BestInitialCond,1)
    [Beta(i,:), fval(i,1), exitflag(i,1)] = fminsearch('qregobjectiveFunction', BestInitialCond(i,:), ...
        options,Y,X,p,q,Q,1);
    for it = 1:REP
        if exitflag(i,1) == 1, break, end
        [Beta(i,:), fval(i,1), exitflag(i,1)] = fminsearch('qregobjectiveFunction', Beta(i,:), ...
            options, Y,X,p,q,Q,1);
        if exitflag(i,1) == 1, break, end
    end
 end
 BetaHat = Beta';
 if exitflag~=1, disp('警告：迭代并没有完成'), end
% *****************************************************************************************

% 5.计算残差,方差-协方差矩阵,t检验,标准差等参数值
 [Y_Yhat,VARbeta,coefficient_interval,stao,cT,Hn,wald]=qstd(BetaHat,Y,X,p,qq,Q,select);
 %t检验
 stderr=sqrt(diag(VARbeta));
 tstats= BetaHat./stderr;
 pvals=2-2*normcdf(abs(tstats));

