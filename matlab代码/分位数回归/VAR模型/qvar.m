function [q, Beta,se,VC] = qvar(Y,X,p,qq,THETA,select)
%--------------------------------------------------------------------------
%Yt=c11+c12*Y(t-1)+c13*X(t-1)
%Xt=c21+c22*Y(t-1)+c23*X(t-1)
%INPUT:
% Y,X分别为因变量和自变量
%p,q分别Y,X的滞后阶数，只实现了滞后一阶过程
%THETA为分位点
%select=1表示分别估计两个方程，select=2表示联合估计两个方程（其实两者是等价的）
%
%OUTPUT: 
% q = 残差序列
% Beta = [c11,c12,c13
%         c21,c22,c23]
% se代表估计量的标准差
%VC代表估计量的方差矩阵
%--------------------------------------------------------------------------

options = optimset('Display','off', 'MaxFunEvals', 10000, 'TolFun', 1e-10, 'TolX', 1e-7);warning('off')
%_____________________________________
% 2. Estimate the initial values of the parameters using univariate CAViaR.
c=zeros(3,2);
[c(:,1),ser1,q1]= qar_estim(Y,X,p,qq,THETA,1); 
[c(:,2),ser2,q2]= qar_estim(X,Y,p,qq,THETA,1); 
% Beta0=zeros(2+4*(p+qq),1);
[c(2,2),c(3,2)] = deal(c(3,2),c(2,2));
if select==1
    q=[q1,q2];
    Beta=[c(:,1)';c(:,2)'];
else
Beta0=reshape(c',6,1);
% Beta0=[];
% for j=1:size(c,2)
%     for i=2:size(c,1)
%     a=diag([c(i,j),c(i,j)]);
%     a=reshape(a,4,1);
%     Beta0=[Beta0;a];
%     end
% end
%     [Beta1] = fminsearch('qvarobjectiveFunction', Beta0, options,ser1,ser2,THETA, 1); % it does not work with OUT=2 
Beta = fminsearch('qvarobjectiveFunction', Beta0, options,ser1,ser2,THETA, 1);% it does not work with OUT=2 
q = qvarobjectiveFunction(Beta, ser1,ser2,THETA, 2);
Beta=reshape(Beta,2,3);
end
[se,VC]=qvarstandardErrors(Y,X, THETA, q);