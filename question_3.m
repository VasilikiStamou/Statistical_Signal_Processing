%%
clear;clc;
%3
var_u=0;
%Theoretical Calculation
a=[-2.737,3.746,-2.629,0.922];
A=[1,a(1),a(2),a(3),a(4);
   a(1),1+a(2),a(3),a(4),0;
   a(2),a(1)+a(3),1+a(4),0,0;
   a(3),a(2)+a(4),a(1),1,0;
   a(4),a(3),a(2),a(1),1];

b=[1;0;0;0;0];
rx_theor=inv(A)*b;
rx_theor=rx_theor.';
rx_theor=fliplr(rx_theor);
rx_theor(6)=rx_theor(4);rx_theor(7)=rx_theor(3);rx_theor(8)=rx_theor(2);rx_theor(9)=rx_theor(1);
rx_theor= rx_theor/max(rx_theor);

Rx_theor=[rx_theor(5),rx_theor(6),rx_theor(7),rx_theor(8);
          rx_theor(6),rx_theor(5),rx_theor(6),rx_theor(7);
          rx_theor(7),rx_theor(6),rx_theor(5),rx_theor(6);
          rx_theor(8),rx_theor(7),rx_theor(6),rx_theor(5);
          ];

w_theor=inv(Rx_theor+var_u*eye(4,4))*rx_theor(6:9).'
error_theor=rx_theor(5)- rx_theor(6:9)*w_theor


%Experimental Calculation
N=10^5; variance=1;
n=1:N;
%Input H(z)
g(n)=sqrt(variance)*randn(1,length(n));

%Output Η(z)
x(1:4)=0;
for n=5:N
x(n)= g(n)-a(1)*x(n-1)-a(2)*x(n-2)-a(3)*x(n-3)-a(4)*x(n-4); 
end

for n=1:N-1
    d(n)=x(n+1);
end
    
%Input W(z)
u(n)=sqrt(var_u)*randn(1,length(n));
for n=1:N-1
y(n) = x(n) + u(n);
end
x=x.';
rx_exp= xcorr(x,4,'normalized');
Rx_exp=[rx_exp(5),rx_exp(6),rx_exp(7),rx_exp(8);
          rx_exp(6),rx_exp(5),rx_exp(6),rx_exp(7);
          rx_exp(7),rx_exp(6),rx_exp(5),rx_exp(6);
          rx_exp(8),rx_exp(7),rx_exp(6),rx_exp(5);
          ];

w_exp=inv(Rx_exp+var_u*eye(4,4))*rx_exp(6:9)


d_app=filter(w_exp,1,y);
error_exp=immse(d,d_app)

%Plots
plot(rx_theor,rx_exp)
xlabel("Theoretical")
ylabel("Experimental")

plot(rx_theor)
hold on;
plot(rx_exp)

stem(rx_theor,'filled')
hold on;
stem(rx_exp,'filled')
