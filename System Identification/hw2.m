clear;clc;
len=3;
question_to_run = '2.2';

switch question_to_run
    case '1'
        %%
        %1
        [w_opt,jmin,x,d,h]=quest1(len);
    case '2.2'
        %%        
        %2.2
        coeff=0.1;
        [w_opt,jmin,x,d,h]=quest1(len);
        [instant_se,w,est_weights,upper_bound]=LMS(len,d,x,coeff,2.2);
        %Plots for length of h=3
        if len==3
            plot([1:1500],est_weights(1,:),[1:1500],est_weights(2,:),[1:1500],est_weights(3,:))
            ylim([-0.2 2])
            yline(w_opt(1),'-',{'w(0)'});
            yline(w_opt(2),'-',{'w(1)'});
            yline(w_opt(3),'-',{'w(2)'});
            
        %Plots for length of h=4
        elseif len==4
            plot([1:1500],est_weights(1,:),[1:1500],est_weights(2,:),[1:1500],est_weights(3,:),[1:1500],est_weights(4,:))
            ylim([-0.4 2])
            yline(w_opt(1),'--',{'w(0)'});
            yline(w_opt(2),'--',{'w(1)'});
            yline(w_opt(3),'--',{'w(2)'});
            yline(w_opt(4),'--',{'w(3)'});
        end

    case '2.3'
        %%
        %2.3
        coeff=0.01;
        variance=1;N=1500; n=1:N;
        %Κρουστική Απόκριση 'Αγνωστου Συστήματος h
        if len==3
            h(1)= 1; %h(0)
            h(2)= 1.8; %h(1)
            h(3)= 0.81; %h(2)
        elseif len==4
                h(1)= 1; %h(0)
                h(2)= 1.8; %h(1)
                h(3)= 0.81; %h(2)
                h(4)=0; %h(3)
        end
        %Σήμα εισόδου x(θ,n)- Σήμα αναφορά d(θ,n)
        x=zeros(100,N); d=zeros(100,N);
        for i=1:100
            x(i,n)=sqrt(variance)*randn(1,length(n));
            d(i,:)=filter(h,1,x(i,:));
        end
        [instant_se,w,est_weights,upper_bound]=LMS(len,d,x,coeff,2.3);
        mean_instant_se= sum(instant_se)/100;
        plot([1:1500],mean_instant_se)
        
        %m=coeff*upper_bound;
        %Rx=variance*eye(len,len);
        %jex=(m/2)*jmin*trace(Rx)
    case '2.4'
        %%
        %2.4
        %Χρονικά Μεταβαλλόμενος συντελεστής b(n)
        N=1500; b=1:N;
        for n=1:length(b)
            if b(n) >=1 && b(n)<500
                b(n)=1;
            elseif b(n)>=500 && b(n)<1000
                b(n)=0;
            elseif b(n)>=1000 && b(n)<=1500
                b(n)=-0.4;
            end
        end
        variance=1; N=1500; n=1:N;
        %Είσοδος 'Αγνωστου Συστήματος h
        x(n)=sqrt(variance)*randn(1,length(n));
        %Κρουστική Απόκριση 'Αγνωστου Συστήματος h
        if len==3
            for n=1:N
                h(n,1)= b(n); %h(0)
                h(n,2)= 1.8; %h(1)
                h(n,3)= 0.81; %h(2);
            end
            
        elseif len==4
            for n=1:N
                h(n,1)= b(n); %h(0)
                h(n,2)= 1.8; %h(1)
                h(n,3)= 0.81; %h(2)
                h(n,4)= -0.2; %h(3)
            end
        end
                       
        %Έξοδος Άγνωστου Συστήματος h
        sum=0;
        for i = (len):1:1500
            for j = 1:1:len
                sum = sum + h(i,j)*x(1,(i+1-j));
            end
            d(1,i) = sum;
            sum = 0;
        end

        %Run 2.2
        coeff=0.1;
        [instant_se,w,est_weights,upper_bound]=LMS(len,d,x,coeff,2.2);
        %Plots for length of h=3
        if len==3
            hold on
             plot([1:1500],est_weights(1,:),'DisplayName','w(0)','LineWidth',1.5)
             plot([1:1500],est_weights(2,:),'DisplayName','w(1)','LineWidth',1.5)
             plot([1:1500],est_weights(3,:),'DisplayName','w(2)','LineWidth',1.5)
             plot([1:1500],h(:,1),'--','DisplayName','h(0)','LineWidth',2)
             plot([1:1500],h(:,2),'--','DisplayName','h(1)','LineWidth',2)
             plot([1:1500],h(:,3),'--','DisplayName','h(2)','LineWidth',2)
             ylim([-0.5 2])
             legend

        %Plots for length of h=4
        elseif len==4
            hold on
             plot([1:1500],est_weights(1,:),'DisplayName','w(0)','LineWidth',1.5)
             plot([1:1500],est_weights(2,:),'DisplayName','w(1)','LineWidth',1.5)
             plot([1:1500],est_weights(3,:),'DisplayName','w(2)','LineWidth',1.5)
             plot([1:1500],est_weights(4,:),'DisplayName','w(3)','LineWidth',1.5)
             plot([1:1500],h(:,1),'--','DisplayName','h(0)','LineWidth',2)
             plot([1:1500],h(:,2),'--','DisplayName','h(1)','LineWidth',2)
             plot([1:1500],h(:,3),'--','DisplayName','h(2)','LineWidth',2)
             plot([1:1500],h(:,4),'--','DisplayName','h(3)','LineWidth',2)             
             ylim([-0.6 2])
             legend

        end

    case '2.5'
        %%
        %2.5
        %Χρονικά Μεταβαλλόμενος συντελεστής b(n)
        N=1500; b=zeros(1,N);
        for n=1:N
            b(n)= sin((2*pi*n)/2500);
        end
        variance=1; N=1500; n=1:N;
        %Είσοδος 'Αγνωστου Συστήματος h
        x(n)=sqrt(variance)*randn(1,length(n));
        %Κρουστική Απόκριση 'Αγνωστου Συστήματος h
        if len==3
            for n=1:N
                h(n,1)= b(n); %h(0)
                h(n,2)= 1.8; %h(1)
                h(n,3)= 0.81; %h(2);
            end
            
        elseif len==4
            for n=1:N
                h(n,1)= b(n); %h(0)
                h(n,2)= 1.8; %h(1)
                h(n,3)= 0.81; %h(2)
                h(n,4)= -0.2; %h(3)
            end
        end
                       
        %Έξοδος Άγνωστου Συστήματος h
        sum=0;
        for i = (len):1:1500
            for j = 1:1:len
                sum = sum + h(i,j)*x(1,(i+1-j));
            end
            d(1,i) = sum;
            sum = 0;
        end

        %Run 2.2
        coeff=0.1;
        [instant_se,w,est_weights,upper_bound]=LMS(len,d,x,coeff,2.2);
        %Plots for length of h=3
        if len==3
            hold on
             plot([1:1500],est_weights(1,:),'DisplayName','w(0)','LineWidth',1.5)
             plot([1:1500],est_weights(2,:),'DisplayName','w(1)','LineWidth',1.5)
             plot([1:1500],est_weights(3,:),'DisplayName','w(2)','LineWidth',1.5)
             plot([1:1500],h(:,1),'--','DisplayName','h(0)','LineWidth',2)
             plot([1:1500],h(:,2),'--','DisplayName','h(1)','LineWidth',2)
             plot([1:1500],h(:,3),'--','DisplayName','h(2)','LineWidth',2)
             ylim([-0.5 2])
             legend

        %Plots for length of h=4
        elseif len==4
            hold on
             plot([1:1500],est_weights(1,:),'DisplayName','w(0)','LineWidth',1.5)
             plot([1:1500],est_weights(2,:),'DisplayName','w(1)','LineWidth',1.5)
             plot([1:1500],est_weights(3,:),'DisplayName','w(2)','LineWidth',1.5)
             plot([1:1500],est_weights(4,:),'DisplayName','w(3)','LineWidth',1.5)
             plot([1:1500],h(:,1),'--','DisplayName','h(0)','LineWidth',2)
             plot([1:1500],h(:,2),'--','DisplayName','h(1)','LineWidth',2)
             plot([1:1500],h(:,3),'--','DisplayName','h(2)','LineWidth',2)
             plot([1:1500],h(:,4),'--','DisplayName','h(3)','LineWidth',2)             
             ylim([-0.6 2])
             legend
        end
        
end 