%%
%2
clear;clc;
t=3; var_u=0;

%Output W(z)
rxx(1)=2;
for k=2:t+2
rxx(k)= 0.9^(k-1)*cos(pi*(k-1)/4);
end
rxx=rxx/max(rxx); %Normalize
rxx_trans=rxx.';
Rx=[rxx(1),rxx(2);rxx(2),rxx(1);];
w_opt=inv(Rx+var_u*eye(2,2))*rxx_trans(t+1:t+2)
min_e=rxx(1)- rxx(t+1:t+2)*w_opt