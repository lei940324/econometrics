function [se,VC]=qvarstandardErrors(Y,X, THETA, q)
T=length(q);N=2;
y=[Y,X];
% 1. Compute gradient of MQ CAViaR (refer to mqRQobjectiveFunction.m file).
dA1 = [eye(2), zeros(2,4)];
dA2 = [zeros(4,2), eye(4)];

dq = zeros(2, 6, T);
for t = 2:T+1
    dq(:,:,t-1) = dA1 + kron(y(t-1,:), eye(N))*dA2 ;
end
%
% 2. Compute V and Q.
eps =q;
%Bandwidth (old value ==1)
% Bandwidth of Koenker (2005) - see http://privatewww.essex.ac.uk/~jmcss/JM_JSS.pdf
s=std(eps(:,1));
IQR=iqr(eps(:,1));
kk=min(s,IQR/1.34);
% kk = median(abs(eps(:,1)-median(eps(:,1))));
hh = T^(-1/3)*(norminv(1-0.05/2))^(2/3)*((1.5*(normpdf(norminv(THETA)))^2)/(2*(norminv(THETA))^2+1))^(1/3);
c = kk*(norminv(THETA+hh)-norminv(THETA-hh));%c=1;
disp(c), disp(sum(eps(:,1)<c))

Q = zeros(6); V=Q;
for t = 1:T
    psi = THETA - (eps(t,:)'<0);
    eta = reshape(dq(:,:,t),N,6).*(psi*ones(1,6));
    eta = sum(eta);
    V = V + eta'*eta;
    
    Qt = zeros(6);
    for j = 1: N
        Qt = Qt + (abs(eps(t,j))<c) * (reshape(dq(j,:,t),6,1) * reshape(dq(j,:,t),1,6));
    end
    Q = Q + Qt;
end
V = V/T; 
Q = Q/(2*c*T);
VC = (Q\V/Q)/T;
se = sqrt(diag(VC));
