% 1.导入数据
data = xlsread('C:\Users\Administrator\Desktop\各市场收益率');
rst   = data(:,2);   %WTI市场现货原始收益率
mldate   = x2mdate(data(:,1)); % 导入日期

% 2.处理汇率收益率序列
epsilon=rst-mean(rst);   %现货原始收益率残差
T=length(epsilon);

% 3.构建GARCH(1,1)模型
options=optimset('fminunc');
 
options=optimset(options,'TolFun',1e-005); 
 
options=optimset(options,'TolX',1e-005); 
 
options=optimset(options,'Display','off'); 
 
options=optimset(options,'Diagnostics','off'); 
 
options=optimset(options,'LargeScale','off');
 
options=optimset(options,'MaxFunEvals',2000);
 
[garch11p,garch11LL,garch11ht,garch11vcvrobust]=tarch(epsilon,1,0,1,'SKEWT',[],[],options);
[garch11text,garch11AIC,garch11BIC]=tarch_display(garch11p,garch11LL,garch11vcvrobust,epsilon,1,2,1);

% 4.检验残差分布选择是否合理(可以利用AIC值、QQ图、KS检验、标准残差做ARCH检验)
% 4.1 KS检验
ehat = epsilon./sqrt(garch11ht);   %标准残差
u = skewtcdf(ehat,garch11p(4,1),garch11p(5,1));     %概率积分变换
v = unifrnd(0,1,T,1);
[H, pValue, KSstatistic] = kstest2(u,v);

% 4.2 QQ图
fig=figure;
set(fig,'Position',[100 100 550 500],'Color',[1 1 1])
y = unifinv((1:T)'/(T+1),0,1);
LB = 0;
UB=1;
h=plot([LB UB],[LB UB],sort(u),y);
set(h(1),'LineStyle','--','Color',[1 0 0],'LineWidth',1)
set(h(2),'LineStyle','none','Marker','o','MarkerSize',1,'Color',[0 0 1])
axis tight
set(gca,'FontSize',16)
a = 'WTI';
title(['' a '原油现货收益率Q-Q图'],'FontSize',16)
xlabel('U(0，1)')
ylabel('残差概率值');

% 4.3 标准残差做ARCH检验,p值高说明无法拒绝原假设(不存在条件异方差)
[h,p,stat,cValue] = archtest(ehat,'lags',10);
if p<=0.01
    arch{1,1} = ['' num2str(stat,'%3.3f') '***'];
    elseif p<=0.05
        arch{1,1} = ['' num2str(stat,'%3.3f') '**'];
    elseif p<=0.1
        arch{1,1} = ['' num2str(stat,'%3.3f') '*'];
    else arch{1,1} = ['' num2str(stat,'%3.3f') ''];
end
