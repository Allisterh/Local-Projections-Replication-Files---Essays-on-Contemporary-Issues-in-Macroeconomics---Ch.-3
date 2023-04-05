% This code estimates the Smooth Local Projections following Barnichon and
% Brownlees (2019) using the MP shock estimated in our first emprirical
% step.

clc
clear 

%% Load data
load 'Dataset - Level - 1997-2019.mat'
%load 'Dataset - Diff - 1997-2019.mat'

%T = size(data,1);
T  = 274
P  = 0; % number of lags used in LP for controls

%% Estimating the IR of GDP to a monetary shock

    H_min = 1; % start LP at H_min=0 or 1 (H_min=1 if impose no contemporanous impact)
    H_max = 36;
    
    subplot(2,1,2)
    autocorr(MPS) %Autocorrelation function
    set(gca,'FontSize',16)

    
    %Variables log level
    
    mpu=(log(mpu(:,1)))*100; 
    smu=(log(smu(:,1)))*100;
    TT=(log(Timetrend(:,1)))*100;
    FedFundsRate_lags=lagmatrix(FedFundsRate,1:3);
    MPS_Lags=lagmatrix(MPS,1:10);
    MPSExp_Lags=lagmatrix(MPSExp,1:10);
    MPSRec_Lags=lagmatrix(MPSRec,1:12);
    MPSTurb_Lags=lagmatrix(MPSTurb,1:19);
    MPSTran_Lags=lagmatrix(MPSTran,1:10);
    MPSPos_Lags=lagmatrix(MPSPos,1:11);
    MPSNeg_Lags=lagmatrix(MPSNeg,1:10);
    MPSPosRec_Lags=lagmatrix(MPSPosRec,1:8);
    MPSPosExp_Lags=lagmatrix(MPSPosExp,1:11);
    MPSNegRec_Lags=lagmatrix(MPSNegRec,1:15);
    MPSNegExp_Lags=lagmatrix(MPSNegExp,1:17);
    MPSPosTurb_Lags=lagmatrix(MPSPosTurb,1:6);
    MPSPosTran_Lags=lagmatrix(MPSPosTran,1:19);
    MPSNegTurb_Lags=lagmatrix(MPSNegTurb,1:18);
    MPSNegTran_Lags=lagmatrix(MPSNegTran,1:20);
    
    %Variables diff
    
    %mpu=diff(log(mpu(:,1)))*100; 
    %smu=diff(log(smu(:,1)))*100;
    %FedFundsRate_lags=lagmatrix(FedFundsRate,1:3);
    %MPS_Lags=lagmatrix(MPS,1:10);
    %MPSExp_Lags=lagmatrix(MPSExp,1:10);
    %MPSRec_Lags=lagmatrix(MPSRec,1:12);
    %MPSTurb_Lags=lagmatrix(MPSTurb,1:19);
    %MPSTran_Lags=lagmatrix(MPSTran,1:10);
    %MPSPos_Lags=lagmatrix(MPSPos,1:11);
    %MPSNeg_Lags=lagmatrix(MPSNeg,1:10);
    %MPSPosRec_Lags=lagmatrix(MPSPosRec,1:8);
    %MPSPosExp_Lags=lagmatrix(MPSPosExp,1:11);
    %MPSNegRec_Lags=lagmatrix(MPSNegRec,1:15);
    %MPSNegExp_Lags=lagmatrix(MPSNegExp,1:17);
    %MPSPosTurb_Lags=lagmatrix(MPSPosTurb,1:6);
    %MPSPosTran_Lags=lagmatrix(MPSPosTran,1:19);
    %MPSNegTurb_Lags=lagmatrix(MPSNegTurb,1:18);
    %MPSNegTran_Lags=lagmatrix(MPSNegTran,1:20);
    
       
    %Include the corresponding dependent variable inside y
    y = [mpu]
    
    %Create lags for the dependent variable
    y_Lags=lagmatrix(y,1:3);
    
    
    %Include the corresponding MP shock inside x
    x = [MPS];
    
    %Include controls
    w = [MPS_Lags dummy_2008 y_Lags TT]; 
    
    newData = cat(2, y, x, w);

    newData(any(isnan(newData), 2), :) = [];

    % Re-declare variables after removing missings
y  = newData(:,1); % endogenous variable
x  = newData(:,2); % endoegnous variable related to the shock
w = newData(:,3:size(newData,2)); % control variables and lags

lp = locproj(y,x,w,H_min,H_max,'reg'); % IR from (standard) Local Projection

r = 2; %(r-1)=order of the limit polynomial (so r=2 implies the IR is shrunk towards a line )
lambda = 100; % value of penalty

slp    = locproj(y,x,w,H_min,H_max,'smooth',r,lambda); %IR from Smooth Local Projection
slp_lim= locproj(y,x,w,H_min,H_max,'smooth',r,1e10); % Limit IR in Smooth Local Projection

figure(1)
hold on,
plot( 0:H_max , [ lp.IR slp.IR slp_lim.IR] )
plot( 0:H_max , zeros(H_max+1,1) , '-k' , 'LineWidth' , 2 )
grid
xlim([0 H_max])
legend('IR_{lp}','IR_{slp}','IR_{slp,max pen}','Location','Best')

%% Cross-Validation Choice of Lambda

slp = locproj(y,x,w,H_min,H_max,'smooth',r,0.01);

lambda = [ 1:0.5:10] * T;
slp    = locproj_cv(slp,5,lambda);

figure(2)
plot( lambda , slp.rss , '-o' )

lambda_opt = lambda( min( slp.rss ) == slp.rss );

%% Confidence Intervals

lp = locproj(y,x,w,H_min,H_max,'reg'); % IR from (regular) Local Projection
lp = locproj_conf(lp,H_max); % it takes a bit too run! please be patient

figure(3)
hold on,
plot( 0:H_max , lp.IR   , 'r' , 'LineWidth' , 2 )
plot( 0:H_max , lp.conf , 'r' )
plot( 0:H_max , zeros(H_max+1,1) , '-k' , 'LineWidth' , 2 )
grid
xlim([0 H_max])

r      = 2;
slp    = locproj(y,x,w,H_min,H_max,'smooth',r,lambda_opt); 
slp    = locproj_conf(slp,H_max,lambda_opt/2);

figure(4)
hold on,
plot( 0:H_max , slp.IR   , 'r' , 'LineWidth' , 2 )
plot( 0:H_max , slp.conf , 'r' )
plot( 0:H_max , zeros(H_max+1,1) , '-k' , 'LineWidth' , 2 )
grid
xlim([0 H_max])
