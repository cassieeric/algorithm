function [train_err,test_err,train_time,test_time,Testing_time1,Training_time1] = bls_train_enhance(train_x,train_y,test_x,test_y,s,C,N1,N2,N3,epochs,m,l)
% Incremental Learning Process of the proposed broad learning system: for
% the increment of enhancement nodes
%Input: 
%---train_x,test_x : the training data and learning data 
%---train_y,test_y : the label 
%----s: the shrinkage parameter for enhancement nodes
%----C: the regularization parameter for sparse regualarization
%----N1: the number of feature nodes  per window
%----N2: the number of windows of feature nodes
%----N3: the number of enhancements nodes
%---epochs: number of epochs 
%---m: number of enhancement nodes in each incremental learning 
%---l: steps of incremental learning
%output:
%---------Testing_time1:Accumulative Testing Times
%---------Training_time1:Accumulative Training Time

N11=N1;train_err=zeros(epochs,l);test_err=zeros(epochs,l);train_time=zeros(epochs,l);test_time=zeros(epochs,l);l2=zeros(1,l);
for r=1:epochs
    %%%%%%%%%%%%%%feature nodes%%%%%%%%%%%%%%
    tic
    train_x = zscore(train_x')';
    H1 = [train_x .1 * ones(size(train_x,1),1)];y=zeros(size(train_x,1),N2*N11);
    for i=1:N2
        we=2*rand(size(train_x,2)+1,N1)-1;
        A1 = H1 * we;A1 = mapminmax(A1);
        clear we;
        beta1  =  sparse_bls(A1,H1,1e-3,50)';
        beta11{i}=beta1;
        % clear A1;

        T1 = H1 * beta1;
        fprintf(1,'Feature nodes in window %f: Max Val of Output %f Min Val %f\n',i,max(T1(:)),min(T1(:)));

        [T1,ps1]  =  mapminmax(T1',0,1);T1 = T1';
        ps(i)=ps1;
        % clear H1;
        % y=[y T1];
        y(:,N11*(i-1)+1:N11*i)=T1;
    end

    %%%%%%%%%%%%%enhancement nodes%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    clear T1;
    H2 = [y .1 * ones(size(y,1),1)];

    if N1*N2>=N3
        wh=orth(2*rand(N2*N1+1,N3)-1);
    else
        wh=orth(2*rand(N2*N1+1,N3)'-1)'; 
    end
    T2 = H2 * wh;
    l2(1) = max(max(T2));
    l2(1) = s/l2(1);
    fprintf(1,'Enhancement nodes: Max Val of Output %f Min Val %f\n',l2(1),min(T2(:)));

    T2 = tansig(T2 * l2(1));
    T3=[y T2];
    clear T2;
    beta = (T3'  *  T3+eye(size(T3',1)) * (C)) \ ( T3' );
    beta2=beta*train_y;

    Training_time=toc;train_time(r,1) =Training_time;


    disp('Training has been finished!');
    disp(['The Total Training Time is : ', num2str(Training_time), ' seconds' ]);
    xx = T3 * beta2;

    %%%%%%%%%%%%%%%%%Training Accuracy%%%%%%%%%%%%%%%%%%%%%%%%%%
    yy = result(xx);
    train_yy = result(train_y);
    TrainingAccuracy = length(find(yy == train_yy))/size(train_yy,1);
    disp(['Training Accuracy is : ', num2str(TrainingAccuracy * 100), ' %' ]);
    train_err(r,1)=TrainingAccuracy;
    tic;
    %%%%%%%%%%%%%%%%%%%%%%Testing Process%%%%%%%%%%%%%%%%%%%
    test_x = zscore(test_x')';
    HH1 = [test_x .1 * ones(size(test_x,1),1)];
    %clear test_x;
    yy1=zeros(size(test_x,1),N2*N11);
    for i=1:N2
        beta1=beta11{i};ps1=ps(i);
        TT1 = HH1 * beta1;
        TT1  =  mapminmax('apply',TT1',ps1)';

        clear beta1; clear ps1;
        %yy1=[yy1 TT1];
        yy1(:,N11*(i-1)+1:N11*i)=TT1;
    end
    clear TT1;
    HH2 = [yy1 .1 * ones(size(yy1,1),1)]; 
    TT2 = tansig(HH2 * wh * l2(1));TT3=[yy1 TT2];
    clear b2;clear TT2;

    x = TT3 * beta2;
    y = result(x);
    test_yy = result(test_y);
    TestingAccuracy = length(find(y == test_yy))/size(test_yy,1);

    %%%%%%%%%%%%%%%%% testing accuracy%%%%%%%%%%%%%%%%%%%%%%%%%%%
    Testing_time=toc;test_time(r,1) = Testing_time;test_err(r,1)=TestingAccuracy;
    disp('Testing has been finished!');
    disp(['The Total Testing Time is : ', num2str(Testing_time), ' seconds' ]);
    disp(['Testing Accuracy is : ', num2str(TestingAccuracy * 100), ' %' ]);
    %%%%%%%%%%%%%incremental training steps%%%%%%%%%%%%%%%%%%%
    for e=1:l-1
        tic
        if N1*N2>=m
            wh=orth(2*rand(N2*N1+1,m)-1);
        else
            wh=orth(2*rand(N2*N1+1,m)'-1)'; 
        end

        Wh{e+1}=wh;
        t2=H2 * wh;
        l2(e+1) = max(max(t2));
        l2(e+1) = s/l2(e+1);
        fprintf(1,'Enhancement nodes in incremental setp %f: Max Val of Output %f Min Val %f\n',e,l2(e+1),min(t2(:)));
        t2 = tansig(t2 * l2(e+1));
        T3_temp=[T3 t2];
        d=beta*t2;
        c=t2-T3*d;
        if all(c(:)==0)
            [q,w]=size(d);
            b=(eye(w)-d'*d)\(d'*beta);
        else
            b = (c'  *  c+eye(size(c',1)) * (C)) \ ( c' );
        end
        beta=[beta-d*b;b];
        beta2=beta*train_y;
        T3=T3_temp;
        Training_time=toc;
        train_time(r,e+1) =Training_time;
        xx = T3 * beta2;
        yy = result(xx);
        train_yy = result(train_y);
        TrainingAccuracy = length(find(yy == train_yy))/size(train_yy,1);
        train_err(r,e+1)=TrainingAccuracy;

        disp(['Training Accuracy is : ', num2str(TrainingAccuracy * 100), ' %' ]);

        tic
        TT2 = tansig(HH2 * wh * l2(e+1));
        TT3=[TT3 TT2];
        clear wh;clear TT2;
        %%%%%%%%%%%%%incremental testing steps%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        x = TT3 * beta2;
        y = result(x);
        test_yy = result(test_y);
        TestingAccuracy = length(find(y == test_yy))/size(test_yy,1);


        Testing_time=toc;test_time(r,e+1) = Testing_time;test_err(r,e+1)=TestingAccuracy;
        disp('Testing has been finished!');
        disp(['The Total Testing Time is : ', num2str(Testing_time), ' seconds' ]);
        disp(['Testing Accuracy is : ', num2str(TestingAccuracy * 100), ' %' ]);


    end
    temp_test=sum(test_time(r,:));temp_train=sum(train_time(r,:));
    Testing_time1(1,r)=temp_test;Training_time1(1,r)=temp_train;
end
