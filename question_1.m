%%
%1
clear;clc;
N=10^5; a=0.2; t=1; var_u=0;
variance=1;
n=1:N;

%Input H(z)
g(n)=sqrt(variance)*randn(1,length(n));

%Output Η(z)
x(1)=0;
for n=2:N
x(n)= g(n)*sqrt(1-a^2) + a*x(n-1); 
end

%Signal d(n)
for n=1:N-t
    d(n)=x(n+t);
end
    
%Input W(z)
u(n)=sqrt(var_u)*randn(1,length(n));
for n=1:N-t
y(n) = x(n) + u(n);
end

%Output W(z)
rx= xcorr(x,t+1,'normalized');
rx(1:t+1)=[];
rx=rx.';
Rx=[rx(1),rx(2);rx(2),rx(1)];
Ru=var_u*eye(2,2);
w=inv(Rx+Ru)*rx(t+1:t+2)


for n=2:N-t
d_app(n) = w(1)*y(n)+w(2)*y(n-1); 
end
%d_app=filter(w,1,y);

emin_exp=immse(d,d_app)

%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%
%Theoretical Calculation
rx_th=[1;a;a^2;a^3;a^4];
Rx_th=[rx_th(1),rx_th(2);rx_th(2),rx_th(1)];
Ru_th=var_u*eye(2,2);
w_th=inv(Rx+Ru)*rx(t+1:t+2)
emin_th=1-rx_th(t+1:t+2).'*w_th