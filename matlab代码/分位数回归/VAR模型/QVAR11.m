function [star,IR, IRplusSE, IRminusSE]=QVAR11(Y,X,THETA,Y_name,X_name,num,select)
% *****************************************************************************************
%Yt=c11+c12*Y(t-1)+c13*X(t-1)
%Xt=c21+c22*Y(t-1)+c23*X(t-1)
% 各变量说明
% THETA 表示分位点
% num 代表脉冲个数
% Beta = [c11,c12,c13
%         c21,c22,c23]
%star = [c11,c21,c12,c22,c13,c23]
%select=1只画一个交叉图
% *****************************************************************************************
[q, Beta,se,VC] = qvar(Y,X,1,1,THETA,1);
Beta1=reshape(Beta,1,6);
tstats=Beta1./se';
pvals=2-2*normcdf(abs(tstats));
star={};point=4;%保留几位小数
for i=1:6
    a=num2str(Beta1(i),['%3.' num2str(point) 'f']);
    if pvals(i)<=0.01
        star{1,i}=['' a '***'];
    elseif pvals(i)<=0.05
        star{1,i}=['' a '**'];
    elseif pvals(i)<=0.1
        star{1,i}=['' a '*'];
    else star{1,i}=['' a  ''];
    end
end
disp(char(star))
[IR, IRplusSE, IRminusSE] = OIRF(Beta, 1,q,VC,THETA,Y_name,X_name,num,select);
[IR, IRplusSE, IRminusSE] = OIRF(Beta, 2,q,VC,THETA,Y_name,X_name,num,select);
