function [IR, IRplusSE, IRminusSE] = OIRF(Beta, IMP,q,VC,THETA,Y_name,X_name,num,select)
%--------------------------------------------------------------------------
% 估计分位数脉冲响应
% 方程为Yt=c11+c12*Y(t-1)+c13*X(t-1)
%       Xt=c21+c22*Y(t-1)+c23*X(t-1)

% INPUT:
% Beta为估计系数
% Beta = [c11,c12,c13
%         c21,c22,c23]
% IMP选择冲击对象，IMP=1则为Y，IMP=2，则为X
% q = 残差序列
% VC代表估计量的方差矩阵
%Y_name代表因变量名
%num代表脉冲期数
%select=1画交叉的图，否则为两个图

% OUTPUT: 
% IR代表脉冲响应
% IRplusSE, IRminusSE分别为脉冲响应的标准误差，上下限
%--------------------------------------------------------------------------
% 1.正交化分解，估计P矩阵
a=q'*q;
T=length(q);
a=a/(T-3);
P = chol(a, 'lower');

% 2.估计IR,s=1期为ADt,s=k，则为A^(k)Dt
b=Beta(:,2:3);
SHOCK = zeros(2,1);
if IMP == 1
    var=Y_name;
    SHOCK(1,1) = 1; 
elseif IMP == 2
    var=X_name;
    SHOCK(2,1) = 1; 
end
IR = zeros(num,2);
IR(1,:) = b*(P*SHOCK);
for s=2:num, IR(s,:) = (b*IR(s-1,:)')'; end

% 3. Compute standard errors for impulse responses
dVecA = [zeros(4,2),eye(4)];
seIRF = zeros(num,2);
    G1 = kron((P*SHOCK)', eye(2)) * dVecA;
    seIRF(1,:) = diag(sqrt(G1 * VC * G1'));
    G=G1;
    for i=2:num
        G=b*G+kron((b^(i-1)*P*SHOCK)',eye(2)) * dVecA;
        seIRF(i,:) = diag(sqrt(G * VC * G'));
    end
 IRplusSE  = IR + 2*seIRF;
 IRminusSE = IR - 2*seIRF;
 
%  4.画出脉冲响应图像
 ff=figure; width=5;
if select==1
    set(ff,'Position',[100 100 750 520],'Color',[1 1 1])
   if IMP==1
      plot(IR(:,2),'-*','LineWidth',width,'MarKerSize',4,'MarKerFaceColor',[1 1 1],'Color',[.5 .5 1]);
     hold on
     plot(IRplusSE(:,2),'--','LineWidth',width,'MarKerSize',5,'MarKerFaceColor',[1 0 0],'Color',[1 0 0]);
     plot(IRminusSE(:,2),'--','LineWidth',width,'MarKerSize',5,'MarKerFaceColor',[1 0 0],'Color',[1 0 0]);
     set(gca,'FontSize',20)
%      title(['[' num2str(THETA-0.025) ',' num2str(THETA+0.025) ']分位区间' X_name '对' var ''],'Interpreter','none')
     title(['[' num2str(THETA-0.025) ',' num2str(THETA+0.025) ']分位区间' X_name '对' var ''])
   else; plot(IR(:,2),'-*','LineWidth',width,'MarKerSize',4,'MarKerFaceColor',[1 1 1],'Color',[.5 .5 1]);
     hold on
     plot(IRplusSE(:,2),'--','LineWidth',width,'MarKerSize',5,'MarKerFaceColor',[1 0 0],'Color',[1 0 0]);
     plot(IRminusSE(:,2),'--','LineWidth',width,'MarKerSize',5,'MarKerFaceColor',[1 0 0],'Color',[1 0 0]);
     set(gca,'FontSize',20)
%      title(['[' num2str(THETA-0.025) ',' num2str(THETA+0.025) ']分位区间' Y_name '对' var ''],'Interpreter','none')
     title(['[' num2str(THETA-0.025) ',' num2str(THETA+0.025) ']分位区间' Y_name '对' var ''])
   end
     set(ff.Children(1),'Position',[0.1,0.1,0.85,0.8]);
   else
 set(ff,'Position',[100 100 1300 420],'Color',[1 1 1])
 for i=1:2
     subplot(1,2,i);
     plot(IR(:,i),'-*','LineWidth',width,'MarKerSize',4,'MarKerFaceColor',[1 1 1],'Color',[.5 .5 1]);
     hold on
     plot(IRplusSE(:,i),'--','LineWidth',width,'MarKerSize',5,'MarKerFaceColor',[1 0 0],'Color',[1 0 0]);
     plot(IRminusSE(:,i),'--','LineWidth',width,'MarKerSize',5,'MarKerFaceColor',[1 0 0],'Color',[1 0 0]);
     set(gca,'FontSize',20)
     if i==1
        title(['[' num2str(THETA-0.025) ',' num2str(THETA+0.025) ']分位区间' Y_name '对' var ''],'Interpreter','none')
     else title(['[' num2str(THETA-0.025) ',' num2str(THETA+0.025) ']分位区间' X_name '对' var ''],'Interpreter','none')
     end
 end
%  xlabel('天数')
 set(ff.Children(2),'Position',[0.055,0.1,0.42,0.8])
 set(ff.Children(1),'Position',[0.55,0.1,0.42,0.8])
end

%--------------------------------------------------------------------------     
% 均值脉冲响应函数     
% for i=1:60
%     c=b^i*P;d(1,i)=c(1,1);
%     d(2,i)=c(1,2);
%     d(3,i)=c(2,1);
%     d(4,i)=c(2,2);
% end
% plot(d(1,:),'-*','LineWidth',0.7,'MarKerSize',5,'MarKerFaceColor',[1 1 1],'Color',[.5 .5 1]);
% hold on
% plot(d(2,:),'-+','LineWidth',0.7,'MarKerSize',5,'MarKerFaceColor',[1 1 1],'Color',[1 .1 0.1]);
% plot(d(3,:),'-*','LineWidth',0.7,'MarKerSize',5,'MarKerFaceColor',[1 1 1],'Color',[.5 .5 1]);
% hold on
% plot(d(4,:),'-+','LineWidth',0.7,'MarKerSize',5,'MarKerFaceColor',[1 1 1],'Color',[1 .1 0.1]);

     
        
