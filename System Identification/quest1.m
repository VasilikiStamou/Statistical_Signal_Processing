function [w_opt,jmin,x,d,h]=quest1(len)
variance=1; N=1500; n=1:N;
%Είσοδος 'Αγνωστου Συστήματος h
x(n)=sqrt(variance)*randn(1,length(n));
%Κρουστική Απόκριση 'Αγνωστου Συστήματος h
if len==3
    h(1)= 1; %h(0)
    h(2)= 1.8; %h(1)
    h(3)= 0.81; %h(2)
elseif len==4
        h(1)= 1; %h(0)
        h(2)= 1.8; %h(1)
        h(3)= 0.81; %h(2)
        h(4)= -0.2; %h(3)
end

%Έξοδος Άγνωστου Συστήματος h
d=filter(h,1,x);

%Μητώο αυτοσυσχέτισης Rx
Rx=variance*eye(len,len);

%Ακολουθία ετεροσυσχέτισης rdx
rdx=h;
%Υπολογισμός βέλτιστου φίτρου Wiener w (εκτιμητής του h)
w_opt=inv(Rx)*rdx.';
d_app=filter(w_opt,1,x);

%Υπολογισμός Ελάχιστου Σφάλματος
rd_zero=0;
for i=1:len
    rd_zero=rd_zero+h(i)^2;
end
jmin=rd_zero-rdx*inv(Rx)*rdx.'; 

