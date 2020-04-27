function [Y_Yhat,VARbeta,coefficient_interval,stao,cT,Hn,wald]=qstd(Beta,Y,X,p,q,Q,select)
% **************************************** help *********************************************
% 说明如下：
% 实现对分位数回归的方差矩阵,wald检验量的计算
% 待估计方程为：y=c(1)+c(2)*y(-1)....+c(3)*x(-1)
% 注意：默认均含有截距项
% *****************************************************************************************
% 输入参数：
% Beta为估计出的参数值
% Y代表被解释变量
% X代表解释变量
% p代表被解释变量的滞后阶数，可以取0，这样解释变量不含y的滞后阶
% q代表被解释变量的滞后阶数，可以取0，这样解释变量为X
% 假设p=0,q=0
% 待估计方程为y=c(1)+c(2)*x
% Q为待估计分位数
% select表示Wald计算方式不同，1为假定残差项服从idd，2为核密度估计
% *****************************************************************************************
% 输出参数：
% Y_Yhat为残差
% VARbeta为方差-协方差矩阵
% coefficient_interval为95%置信区间
% stao为密度函数Sparsity
% cT为核估计窗宽cT
% Hn为Bandwidth method: Hall-Sheather,带宽bw
% wald为wald统计量
% ***************************************** help ********************************************
if q==0
     qq=1;
 else qq=q;
end
%确定Y,X序列,其形式为[C,Y(-p),X(-q)]以及残差
a=qregobjectiveFunction(Beta,Y,X,p,q,Q,2);
b=size(a,2);
ser=a(:,1:b-1);
Y_Yhat=a(:,b);
%求带宽Hn
afa=0.05;
T=length(Y_Yhat);
fen=(T^(-1/3));
fen1=(norminv(1-afa/2))^(2/3);
zafa=(normpdf(norminv(Q)))^2;
fen2=((1.5*zafa)/(2*(norminv(Q))^2+1))^(1/3);
Hn=fen*fen1*fen2;
D=zeros(T,p+qq+1);
D(:,1)=ones(T,1);
D(:,2:b-1)=ser(:,2:b-1);

s=std(Y_Yhat);
IQR=iqr(Y_Yhat);
k=min(s,IQR/1.34);
cT=k*(norminv(Q+Hn)-norminv(Q-Hn));
a=(1/(T*cT));
u=Y_Yhat/cT;
b=(3/4)*(1-u.^2);
for i=1:T
   if b(i,1)<0
      b(i,1)=0;
   else b(i,1)=b(i,1);
end 
end
stao=1/sum(a*b);
H2=zeros(p+q+1);
for i=1:T
    DD=D(i,:)'*D(i,:);
H=a*b(i,1)*DD+H2;
H2=H;
end
J=(D'*D)/T;
V=Q*(1-Q)*inv(H)*J*inv(H);
VARbeta=V/T;
%置信区间
stderr=sqrt(diag(VARbeta));
for i=1:(1+p+qq)
    coefficient_interval(i,1)=Beta(i,1)-stderr(i,1)*tinv(0.95,T-(1+p+qq));
    coefficient_interval(i,2)=Beta(i,1)+stderr(i,1)*tinv(0.95,T-(1+p+qq));
    coefficient_interval(i,3)=Beta(i,1)-stderr(i,1)*tinv(0.975,T-(1+p+qq));
    coefficient_interval(i,4)=Beta(i,1)+stderr(i,1)*tinv(0.975,T-(1+p+qq));
    coefficient_interval(i,5)=Beta(i,1)-stderr(i,1)*tinv(0.995,T-(1+p+qq));
    coefficient_interval(i,6)=Beta(i,1)+stderr(i,1)*tinv(0.995,T-(1+p+qq));
end
%wald检验
R=zeros(q,p+q+1);
if select==1    %(默认许启发论文做法)
	stao2=stao^2;
	for i=1:q
	R(i,p+i+1)=1;
	end
	VV=R*inv(J)*R';
	zi=T*(R*Beta)'*inv(VV)*(R*Beta)*(1/stao2);
	wald=zi/(Q*(1-Q));end

if select==2   %EVIEWS默认求协方差矩阵方法(核估计)
for i=1:q
R(i,p+i+1)=1;
end
wald=(R*Beta)'*inv(R*VARbeta*R')*(R*Beta);
end