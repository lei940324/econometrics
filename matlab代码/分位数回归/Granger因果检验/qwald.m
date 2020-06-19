function [wald,AIC_zhong]=qwald(Y,X,AIC_zhong,select)

% % % % % % % % % % % % % % % % % % % % % 
% 帮助：
% qwald是为了得出分位数格兰杰因果检验，计算各分位点SUP-Wald统计量的函数
% Sup-wald默认保留3位有效数字
% 其中wald为SUP-Wald矩阵；AIC_zhong为各分位区间最优滞后阶数和AIC值
% X为自变量；Y为因变量；
% AIC_zhong若没有得出各分位区间最优滞后阶数和AIC值，则取值为1，自动计算最优阶数（当然这需要一点时间），否则输入此矩阵;
% select表示Wald计算方式不同，1为假定残差项服从idd，2为核密度估计
% 实例：
% [wald,AIC_zhong]=qwald(X,Y,1,1)
% [wald,AIC_zhong]=qwald(X,Y,AIC_zhong,1)
% % % % % % % % % % % % % % % % % % % % % 

if AIC_zhong==1
	AIC_zhong=qre_lag(Y,X,select);
end
%计算各分位点Wald统计量
Q2=linspace(0.1,0.9,1000);
wald_text(1,:)=Q2;page=0;
for i=1:1000
    page=page+1;
	%选取最优滞后阶数
	a=AIC_zhong(:,1);
	aa=find(a<=Q2(i));
	b=max(aa);
	if b==17
		b=16;
	end
	p=AIC_zhong(b,3);
	q=AIC_zhong(b,4);
	[BetaHat,ser,Y_Yhat,fval,VARbeta,coefficient_interval,stao,cT,Hn,stderr,tstats,pvals,wald,exitflag] = qar_estim(Y,X,p,q,Q2(i),select);
	wald_text(2,i)=p;
	wald_text(3,i)=q;
	wald_text(4,i)=wald;
	disp(['正在进行Sup_wald计算，分位点为' num2str(Q2(i)) ',wald值为' num2str(wald) ',滞后阶数为[' num2str(p) ',' num2str(q) '],进度为(' num2str(page) '/1000),'])
end
%%%计算区间SUP-Wald统计量
WALD(1,:)=linspace(0.1,0.9,17);
c=1;
for i=2:17
    b=find(Q2<=WALD(1,i));
    a=max(b);
    WALD(2,i-1)=max(wald_text(4,c:a));
    c=a+1;
end
WALD2=WALD';

%检验SUP-Wald统计量是否显著
star=supwaldstar(AIC_zhong,WALD2(1:16,2));
a='分位段';a1='0.1-0.15';a2='0.15-0.2';a3='0.2-0.25';a4='0.25-0.3';a5='0.3-0.35';a6='0.35-0.4';a7='0.4-0.45';a8='0.45-0.5';a9='0.5-0.55';a10='0.55-0.6';
a11='0.6-0.65';a12='0.65-0.7';a13='0.7-0.75';a14='0.75-0.8';a15='0.8-0.85';a16='0.85-0.9';
wald=[];
wald{1,1}=a;wald{2,1}=a1;wald{3,1}=a2;wald{4,1}=a3;wald{5,1}=a4;wald{6,1}=a5;wald{7,1}=a6;wald{8,1}=a7;wald{9,1}=a8;wald{10,1}=a9;wald{11,1}=a10;
wald{12,1}=a11;wald{13,1}=a12;wald{14,1}=a13;wald{15,1}=a14;wald{16,1}=a15;wald{17,1}=a16;
wald{1,2}=['p'];wald{1,3}=['q'];wald{1,4}=['AIC'];wald{1,5}=['sup-wald'];

point=3;%保留几位小数
for i=1:16
%     wald{i+1,2}=num2str(AIC_zhong(i,3));
%     wald{i+1,3}=num2str(AIC_zhong(i,4));
%     wald{i+1,4}=num2str(AIC_zhong(i,5),'%4.4f');
    wald{i+1,2}=AIC_zhong(i,3);
    wald{i+1,3}=AIC_zhong(i,4);
    wald{i+1,4}=AIC_zhong(i,5);
    l=num2str(WALD2(i,2),['%3.' num2str(point) 'g']);
    if star(i,2)==3
    wald{i+1,5}=['' l '***\[' num2str(AIC_zhong(i,4)) ']'];
    elseif star(i,2)==2
        wald{i+1,5}=['' l '**\[' num2str(AIC_zhong(i,4)) ']'];
    elseif star(i,2)==1
        wald{i+1,5}=['' l '*\[' num2str(AIC_zhong(i,4)) ']'];
    else; wald{i+1,5}=['' l '\[' num2str(AIC_zhong(i,4)) ']'];
    end
end
for i=1:17
    disp(wald{i,5})
end
%xlswrite('C:\Users\Administrator\Desktop\qwald.xlsx',wald)


% out1=[];out2=[];out3=[];out4=[];out5=[];
% for i=1:17
% out1=strvcat(out1,wald{i,1});
% out2=strvcat(out2,wald{i,2});
% out3=strvcat(out3,wald{i,3});
% out4=strvcat(out4,wald{i,4});
% out5=strvcat(out5,wald{i,5});
% end
% out={out1,out2,out3,out4,out5};


