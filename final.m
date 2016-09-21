clear all
filename1 = 'smyrb_fin.csv';
Ftx = csvread(filename1,1,1);

St = Ftx(:,1); %log St
m = Ftx(:,2);
y = Ftx(:,3);
r = Ftx(:,4);
b = Ftx(:,5);

X = [ones(size(m)) m y r b];
Y = regress(St,X);

a0 = Y(1,:); a1 = Y(2,:); a2 = Y(3,:); a3 = Y(4,:); a4 = Y(5,:);

%% h = a
a = 1;
h = a;
z = 42;
lz = 43;
rz = 83;
while h < 5
    h = a;
    L = [size(St)/2];
    L = L(:,1);

    pred_s = zeros(length(St),1);
    evec = zeros(length(St),1);
    % Loop to estimate a0 to a4 via OLS then predict St+h
    for i=1:z
        %Estimation
        ydata = St(1:i+41);
        xdata = [ones(41+i,1),m(1:i+41),y(1:i+41),r(1:i+41),b(1:i+41)];
        coef = inv(xdata'*xdata)*xdata'*ydata;
        %Prediction
        pred_s(41+i+1) = [1,m(41+i+1),y(41+i+1),r(41+i+1),b(41+i+1)]*coef;
        evec(41+i+1) = St(41+i+1) - pred_s(41+i+1);
    end
    disp(['The value of h is ' num2str(h)])
    MSE=evec'*evec/42     % MSE for the monetary model 
    MSE_rw=(St(lz:84)-St(42:rz))'*(St(lz:84)-St(42:rz))/42   % MSE for the random walk model
    
    a = a + 1;
    z = z - 1;
    lz = lz + 1;
    rz = rz - 1;
end
%Because the parameters are constant and known, the linear model outperforms the random walk in terms of accuracy.
%An increase in h raises the MSE for the random walk as the change in St becomes slightly more volatile.
%This, along with the explanatory power of the fundamentals reduces the MSE ratio, which can be observed by the decreasing trend of MSE values as h increases.