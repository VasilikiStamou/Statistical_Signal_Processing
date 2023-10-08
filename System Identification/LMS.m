function [instant_se,w,est_weights,upper_bound]=LMS(len,d,x,coeff,question)
if question==2.2    
    %Διάστημα τιμών βήματος μ
    rx=xcorr(x,len,'normalized');
    upper_bound=2/(len*rx(len+1));
    lower_bound=0;
    %Αρχικοποίηση συντελεστών και βήματος
    sum=0;
    w=zeros(1,len);
    m=coeff*upper_bound;
    %Ανανέωση συντελεστών 
    for i = (len):1:1500
        for j = 1:1:len
            sum = sum + w(1,j)*x(1,(i+1-j));
        end
            y(1,i) = sum;
            sum = 0;
            e(1,i) = d(1,i) - y(1,i);
            for j = 1:1:len
                w(1,j) = w(1,j) + m*e(1,i)*x(1,(i+1-j));
            end
            est_weights(:,i)=w;
    end
    instant_se=0;
    
elseif question==2.3    
    %Διάστημα τιμών βήματος μ
    for i=1:100
        rx(i,1:2*len+1)=xcorr(x(i,:),len,'normalized');
    end
    %rx(len+1) 1 σε όλες τις παρατηρήσεις, το αντικαθιστούμε απευθείας
    upper_bound=2/(len);
    lower_bound=0;    
    
    %Αρχικοποίηση συντελεστών και βήματος
    est_weights=0;
    sum=0;
    w=zeros(100,len);
    m=coeff*upper_bound;
    %Ανανέωση συντελεστών 
    for obs=1:100
        for i = (len):1:1500
            for j = 1:1:len
                sum = sum + w(obs,j)*x(obs,(i+1-j));
            end
            y(obs,i) = sum;
            sum = 0;
            e(obs,i) = d(obs,i) - y(obs,i);
            for j = 1:1:len
                w(obs,j) = w(obs,j) + m*e(obs,i)*x(obs,(i+1-j));
            end        
        end
    end

    for obs=1:100
        for i=1:1500
            instant_se(obs,i)=e(obs,i)*e(obs,i);
        end
    end

end

