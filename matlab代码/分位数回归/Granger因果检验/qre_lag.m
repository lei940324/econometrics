function AIC_zhong=qre_lag(Y,X,select)

% **************************************** help *********************************************
% 说明:
% 此函数为计算各分位区间的最优滞后阶数,使用AIC准则
% 待估计方程为：y=c(1)+c(2)*y(-1)....+c(3)*x(-1)
% 注意：默认均含有截距项
% *****************************************************************************************
% 输入参数:
% Y代表被解释变量
% X代表解释变量

% 输出参数:
% 矩阵包括p,q,AIC值,
% ***************************************** help ********************************************

Q2=linspace(0.1,0.9,100);
for i=1:100
    Q=Q2(i);ii=0;
    for p=1:5
        for q=1:5
            ii = ii+1;
			[BetaHat,ser,Y_Yhat] = qar_estim(Y,X,p,q,Q,select);
			SSE=sum(Y_Yhat);
			n=length(Y)-max(p,q);
			%计算AIC值
			L=-(n/2)*log(2*pi)-(n/2)*log(SSE/n)-n/2;
			k=p+q+1;
			AIC=(2*k-2*L)/n;
			AICju(ii,:)=[Q,p,q,AIC];
			disp(['正在进行AIC计算，分位点为' num2str(Q) ',AIC值为' num2str(AIC) ',当前滞后阶数[' num2str(p) ',' num2str(q) '],当前进度(' num2str(ii) '/25),'])
        end
    end
	a=AICju(:,4);
	aa=find(a==min(a));
	AICjuzhen(i,:)=AICju(aa(1,1),:);
end
AIC_zhong(:,1)=linspace(0.1,0.9,17);
c=1;
for i=2:17
    b=find(Q2<=AIC_zhong(i,1));
    a=max(b);
    bb=AICjuzhen(c:a,4);
    aa=find(bb==min(bb));
    AIC_zhong(i-1,2:5)=AICjuzhen(c-1+aa(1,1),:);
    c=a+1;
end