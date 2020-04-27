function [Sup_wald,walds,AIC]=qwalds(data,AICS,select,pattern)

% % % % % % % % % % % % % % % % % % % % % 
% 帮助：
% qwalds是为了得出分位数格兰杰因果检验，计算各市场分位点SUP-Wald统计量的函数

% 实例：
% [wald,AIC_zhong]=qwalds(data,1,1,1)
% [wald,AIC_zhong]=qwalds(data,AICS,1,1)

% 输出变量：
% Sup_wald为各市场分位区间，滞后阶数，wald值总览
% walds是各市场wald值汇总，默认保留3位有效数字
% AIC是各市场AIC准则确定的滞后矩阵

% 输入变量:
% data表示数据集；第一列为解释变量，后面为被解释变量（X1,Y1,Y2....);或者最后一列为被解释变量（X1,X2,X3.....Y1);
% AICS若没有得出各分位区间最优滞后阶数和AIC值，则取值为1，自动计算最优阶数（当然这需要一点时间），否则输入此矩阵;
% select表示Wald计算方式不同，1为假定残差项服从idd，2为核密度估计

% pattern代表循环模式,
% 1为研究单一因素对各市场影响，比如房价对股票，汇率市场冲击；
% 2则为研究相互影响，比如房价与股票，汇率市场的相互冲击；
% 3则为某些因素对单个市场的影响，比如各情绪对汇率市场的冲击；
% 例如：data=[X,Y1,Y2,Y3],pattern=1 则为 X对Y1回归；X对Y2回归；X对Y3回归；（Y1=c1+c2*X)
% pattern=2 则为 X对Y1回归；X对Y2回归；X对Y3回归；Y1对X回归；Y1对Y2回归;Y1对Y3回归;.........
% pattern=3 data=[X1,X2,X3,Y1];X1对Y1回归，X2对Y1回归；X3对Y1回归；
% % % % % % % % % % % % % % % % % % % % % 
tic
lim=200;   %分钟
lim=lim*60;
AIC={};Sup_wald={};walds={};
T=size(data,2);
if pattern==1
    X=data(:,1);
    for i=2:T
        Y=data(:,i);
        if AICS==1
            [wald,AIC_zhong]=qwald(X,Y,1,select);
        else
        [wald,AIC_zhong]=qwald(X,Y,AICS{i-1,1},select);end
        AIC{i-1,1}=AIC_zhong;
        Sup_wald{i-1,1}=wald;
        walds(:,i-1)=wald(:,5);
        disp('***********************************************')
        disp(['第' num2str(i-1) '个已完成，共' num2str(T-1) '个'])
        disp('***********************************************')
        time_toc = toc;
        if time_toc > lim 
            disp(['已用时' num2str(time_toc/60,'%3.5g') '分钟'])
            pause
            tic
        end
    end
elseif pattern==2
    n=0;nn=nchoosek(T,2)*2;
    for i=1:T
        for j=1:T
            if i~=j
                n=n+1;
                X=data(:,i);Y=data(:,j);
                if AICS==1
                    [wald,AIC_zhong]=qwald(X,Y,1,select);
                else
                    [wald,AIC_zhong]=qwald(X,Y,AICS{n,1},select);end
                AIC{n,1}=AIC_zhong;
                Sup_wald{n,1}=wald;
                walds(:,n)=wald(:,5);
                disp('***********************************************')
                disp(['第' num2str(n) '个已完成，共' num2str(nn) '个'])
                disp('***********************************************')
                time_toc = toc;
                if time_toc > lim 
                    disp(['已用时' num2str(time_toc/60,'%3.5g') '分钟'])
                    pause
                    tic
                end
            end
        end
    end
elseif pattern==3
    Y=data(:,T);
    for i=1:T-1
        X=data(:,i);
        if AICS==1
            [wald,AIC_zhong]=qwald(X,Y,1,select);
        else
            [wald,AIC_zhong]=qwald(X,Y,AICS{i,1},select);end
        AIC{i,1}=AIC_zhong;
        Sup_wald{i,1}=wald;
        walds(:,i)=wald(:,5);
        disp('***********************************************')
        disp(['第' num2str(i) '个已完成，共' num2str(T-1) '个'])
        disp('***********************************************')
        time_toc = toc;
        if time_toc > lim 
            disp(['已用时' num2str(time_toc/60,'%3.5g') '分钟'])
            pause
            tic
        end
    end
end
                
xlswrite('C:\Users\Administrator\Desktop\qwalds1.xlsx',walds)
