%VAR: Yt = C + A * Yt-1 + Ut
filename3 = 'Ft2.csv';
filename4 = 'St.csv';
Ftx = csvread(filename3,1,1);
Stx = xlsread(filename4);

%Column K - N to find Ft (84 rows)
Ft0 = Ftx(:,10) - Ftx(:,13);

%Difference in Ft (2nd row minus 1st row); 83 rows
dFt = Ft0(2:length(Ft0)) - Ft0(1:length(Ft0)-1);
%dFt minus 1 (one period after); 82 rows
dFt2 = dFt(2:length(dFt));
%Re-define dFt as 82 rows (remove last row)
dFt = dFt(1:length(dFt)-1);
St = Stx(3:length(Stx));
Ft = Ft0(3:length(Ft0));
StFt = St - Ft;
%St-1 - Ft-1
St1Ft1 = Stx(2:length(Stx)-1) - Ft0(2:length(Ft0)-1);

%RHS
X = [ones(length(St1Ft1),1),dFt2,St1Ft1];
Y = dFt
%C1 A11 A12
Z1 = inv(X'*X) * X'*Y
Y = StFt;
%C2 A21 A22
Z2 = inv(X'*X) * X'*Y

%C is not important in final results => ignored
%Matrix of A by transposing row 2&3 horizontally
A = [Z1(2:3)';Z2(2:3)'];

Yt1 = [dFt2'; StFt'];

RHS = 0.9*A*inv(eye(2)-0.9*A)*Yt1; 
RHS = [1,0]*RHS
RHS = RHS'
figure
plot(RHS')
figure
plot(Yt1(2,:))
time=1:82;
figure
plot(time,RHS,time,Yt1(2,:))