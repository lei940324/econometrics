function y=qregobjectiveFunction(Beta,Y,X,p,q,Q,select)

% **************************************** help *********************************************
% 说明：
% 此函数为分位数目标函数
% 待估计方程为：y=c(1)+c(2)*y(-1)....+c(3)*x(-1)
% 注意：默认均含有截距项
% *****************************************************************************************
% 输入参数：
% Beta为初值
% Y代表被解释变量
% X代表解释变量
% p代表被解释变量的滞后阶数，可以取0，这样解释变量不含y的滞后阶
% q代表被解释变量的滞后阶数，可以取0，这样解释变量为X
% 假设p=0,q=0
% 待估计方程为y=c(1)+c(2)*x
% Q为待估计分位点
% select确定输入参数类型,具体如下
% *****************************************************************************************
% 输出参数：
% select = 1,表示输出y为残差和
% select = 2,表示输出y为估计序列ser，以及残差,形式为[ser,e]
% ***************************************** help ********************************************

% 1.得到真实估计序列ser(不包括常数项),其形式为[Y,Y(-p),X(-q)]
C=Y((max(p,q)+1):length(Y),1);
 if p==0,Y_p=[];else
	for i=1:p,Y_p(:,i)=Y((max(p,q)-(i-1)):(length(Y)-i),1);end;end
 if q==0
	X_q=[X];
 else
	for i=1:q,X_q(:,i)=X((max(p,q)-(i-1)):(length(X)-i),1);end;end
 ser=[C,Y_p,X_q];

% 2.求残差
 Y_hat(:,1)=Beta(1)*ones(length(C),1);
if p==0
   Y_hat(:,1)=Beta(1)*ones(length(C),1);
else
 for i=1:p
Y_hat(:,(i+1))=Beta(i+1)*Y_p(:,i);
 end
end
if q==0
     Y_hat(:,2+p)=Beta(2+p)*X_q;
else
for i=1:q
Y_hat(:,(1+p+i))=Beta(1+p+i)*X_q(:,i);
end
end
Y_hat=sum(Y_hat,2);    
Y_Yhat=Y((max(p,q)+1):length(Y),1)-Y_hat;
%加权方差
c1=length(Y_Yhat);
y1=zeros(c1,1);
for i=1:1:c1
    if Y_Yhat(i)>0
        y1(i)=Q*Y_Yhat(i);
    else
        y1(i)=(Q-1)*Y_Yhat(i);
    end
end
if select==1
y=sum(y1);
else y=[ser,Y_Yhat];
end