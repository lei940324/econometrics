function [output] = qvarobjectiveFunction(Beta, ser1,ser2,THETA, OUT)
%--------------------------------------------------------------------------
% mqRQobjectiveFunction computes the multivariate quantiles and the associated
% RQ criterion, for given vector of parameters BETA.
% If OUT=1, the output is the regression quantile objective function.
% If OUT=2, the output is the quantiles time series.
%--------------------------------------------------------------------------
[L,T]=size(ser1);
%
% 1. Predefine the matrix of quantiles and initialise them at the empirical quantile.
A = reshape(Beta', 2, T); % A = reshape(Beta0, N, 2+N);
c=A(:,1); q1=c;
for j=1:L
for i=2:2:2*(T-2)
    a=A(:,i:i+1);
    b=a*[ser1(j,i);ser1(j,1+i)];
    q1=q1+b;
end
q(:,j)=q1;
q1=c;
end
q=q';
res=[ser1(:,1),ser2(:,1)]-q;
y=[ser1(:,1),ser2(:,1)];
%
% 4. Compute the Regression Quantile criterion.
S = res.*(THETA*ones(L,2) - (y<q));
S = sum(S,2); S = mean(S); % First sum the cross section and then take the average over time.
% 5. Prepare output.
if OUT == 1, output = S;%y=c1+c2y(-1£©+c3x(-1)
else output = res;
end