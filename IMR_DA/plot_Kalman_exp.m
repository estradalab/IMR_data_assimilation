% This is a general plotting file for Kalman methods using simulated data
% This is the plotting file for the data assimilation paper, it is split up
% into different sections for different data types, methods, and type of
% plots. It is meant to be run locally

%%  add paths, define variables, etc
clear set

%addpath ./data
%addpath ../

set(groot, 'defaultAxesTickLabelInterpreter','latex');
set(groot, 'defaultLegendInterpreter','latex');
set(groot, 'defaulttextinterpreter','latex');

% For dimensional parameter calculation:
rho = 1060; % (Kg/m^3) Liquid Density taken from Estrada et. al
Uc = sqrt(P_inf/rho);

%% extract needed data from ensemble:

j_range = 1:j;
clear jj x_est std

% declare variables
x_est = zeros(N,j);

for jj = j_range
    
x_est(:,jj) = mean(x(:,:,jj),2);

x_min(:,jj) = min(x(:,:,jj)')';
x_max(:,jj) = max(x(:,:,jj)')';
sigma(:,jj) = std(x(:,:,jj)')'; % std deviation of ensemble
x_min_sigma(:,jj) = x_est(:,jj) - sigma(:,jj);
x_pls_sigma(:,jj) = x_est(:,jj) + sigma(:,jj);

%Ca_true(jj) = exp(xth(2*NT+NTM+7,jj));
%Re_true(jj) = exp(xth(2*NT+NTM+8,jj));
%De_true(jj) = exp(xth(2*NT+NTM+9,jj));
%alpha_true(jj) = exp(xth(2*NT+NTM+10,jj));
%lambda_nu_true(jj) = exp(xth(2*NT+NTM+11,jj));

Ca_est(jj) = exp(x_est(2*NT+NTM+7,jj));
Ca_min(jj) = exp(x_min(2*NT+NTM+7,jj));
Ca_max(jj) = exp(x_max(2*NT+NTM+7,jj));
Ca_min_sigma(jj) = exp(x_min_sigma(2*NT+NTM+7,jj));
Ca_pls_sigma(jj) = exp(x_pls_sigma(2*NT+NTM+7,jj));

Re_est(jj) = exp(x_est(2*NT+NTM+8,jj));
Re_min(jj) = exp(x_min(2*NT+NTM+8,jj));
Re_max(jj) = exp(x_max(2*NT+NTM+8,jj));
Re_min_sigma(jj) = exp(x_min_sigma(2*NT+NTM+8,jj));
Re_pls_sigma(jj) = exp(x_pls_sigma(2*NT+NTM+8,jj));

De_est(jj) = exp(x_est(2*NT+NTM+9,jj));
De_min(jj) = exp(x_min(2*NT+NTM+9,jj));
De_max(jj) = exp(x_max(2*NT+NTM+9,jj));
De_min_sigma(jj) = exp(x_min_sigma(2*NT+NTM+9,jj));
De_pls_sigma(jj) = exp(x_pls_sigma(2*NT+NTM+9,jj));

alpha_est(jj) = exp(x_est(2*NT+NTM+10,jj));
alpha_min(jj) = exp(x_min(2*NT+NTM+10,jj));
alpha_max(jj) = exp(x_max(2*NT+NTM+10,jj));
alpha_min_sigma(jj) = exp(x_min_sigma(2*NT+NTM+10,jj));
alpha_pls_sigma(jj) = exp(x_pls_sigma(2*NT+NTM+10,jj));

lambda_nu_est(jj) = exp(x_est(2*NT+NTM+11,jj));
lambda_nu_min(jj) = exp(x_min(2*NT+NTM+11,jj));
lambda_nu_max(jj) = exp(x_max(2*NT+NTM+11,jj));
lambda_nu_min_sigma(jj) = exp(x_min_sigma(2*NT+NTM+11,jj));
lambda_nu_pls_sigma(jj) = exp(x_pls_sigma(2*NT+NTM+11,jj));

y_est = h(x(:,:,jj));
yb_est = mean(y_est,2);

A_est = squeeze(x(:,:,jj)) - x_est(:,jj)*ones(1,q);
HA_est = y_est-yb_est*ones(1,q);

AHA(:,jj) = A_est*HA_est';

C_est(:,:,jj) = (A_est*A_est')/(q-1);  
Ctrace_est(jj) = trace(C_est(:,:,jj));

%err_tot(jj) = norm(x_est(:,jj) - xth(:,mod(jj-1,100)+1)) / ...
%    ((norm(xth(:,mod(jj-1,100)+1))+norm(x_est(:,jj)))/2);
end

%G_true = G_true*ones(size(Ca_true));
%mu_true = mu_true*ones(size(Re_true));

%CaError = 100*(abs(Ca_est-Ca_true)./Ca_true);
%ReError = 100*(abs(Re_est-Re_true)./Re_true);
%DeError = 100*(abs(De_est-De_true)./De_true);
%alphaError = 100*(abs(alpha_est-alpha_true)./alpha_true);
%lambda_nuError = 100*(abs(lambda_nu_est-lambda_nu_true)./lambda_nu_true);

G_est = P_inf./Ca_est;
G_min = P_inf./Ca_max;
G_max = P_inf./Ca_min;
G_min_sigma = P_inf./Ca_pls_sigma;
G_pls_sigma = P_inf./Ca_min_sigma;
%GError = 100*(abs(G_est-G_true)./G_true);

mu_est = (P_inf*R0)./(Re_est.*Uc);
mu_min = (P_inf*R0)./(Re_max.*Uc);
mu_max = (P_inf*R0)./(Re_min.*Uc);
mu_min_sigma = (P_inf*R0)./(Re_pls_sigma.*Uc);
mu_pls_sigma = (P_inf*R0)./(Re_min_sigma.*Uc);
%muError = 100*(abs(mu_est-mu_true)./mu_true);

sigmaG = sigma(2*NT+NTM+7,:); % For convenience in master plotting file
sigmamu = sigma(2*NT+NTM+8,:);

%% Further estimation accuracy analysis:

% This first table isn't right, need to correct if needed
%{
CaErrorVals = [Ca_true(1),Ca_est(1);0,CaError(1)];
ReErrorVals = [Re_true(1),Re_est(1);0,ReError(1)];
ColumnNames = cell(1,iterations+2);
ColumnNames{1} = 'Truth';
ColumnNames{2} = 'InitialGuess';
ii = 3
for ind = runlims
    CaErrorVals = [CaErrorVals,[Ca_est(ind);CaError(ind)]];
    ReErrorVals = [ReErrorVals,[Re_est(ind);ReError(ind)]];
    ColumnNames{ii} = ['Run' num2str(ii-2)];
    ii = ii+1;
end
CaErrorTable = array2table(CaErrorVals);
ReErrorTable = array2table(ReErrorVals);

CaErrorTable.Properties.RowNames = {'value','% error'};
ReErrorTable.Properties.RowNames = {'value','% error'};
CaErrorTable.Properties.VariableNames = ColumnNames
ReErrorTable.Properties.VariableNames = ColumnNames
%}
GErrorVals = [G_est(1),G_est(end)];
muErrorVals = [mu_est(1),mu_est(end)];
DeErrorVals = [De_est(1),De_est(end)];
alphaErrorVals = [alpha_est(1),alpha_est(end)];
lambda_nuErrorVals = [lambda_nu_est(1),lambda_nu_est(end)];
ColumnNames = cell(1,2);
ColumnNames{1} = 'Initial_Guess';
ColumnNames{2} = 'Final_Estimate';

GErrorTable = array2table(GErrorVals);
muErrorTable = array2table(muErrorVals);
DeErrorTable = array2table(DeErrorVals);
alphaErrorTable = array2table(alphaErrorVals);
lambda_nuErrorTable = array2table(lambda_nuErrorVals);

GErrorTable.Properties.RowNames = {'value'};
muErrorTable.Properties.RowNames = {'value'};
DeErrorTable.Properties.RowNames = {'value'};
alphaErrorTable.Properties.RowNames = {'value'};
lambda_nuErrorTable.Properties.RowNames = {'value'};

%GErrorTable.Properties.VariableNames = ColumnNames
muErrorTable.Properties.VariableNames = ColumnNames
%DeErrorTable.Properties.VariableNames = ColumnNames
alphaErrorTable.Properties.VariableNames = ColumnNames
%lambda_nuErrorTable.Properties.VariableNames = ColumnNames




%disp(['run time: ',num2str(round(run_time)),' seconds or ', ...
%    num2str(round(run_time/60)),' minutes'])

%% Other metrics 
R_err = abs(x_est(1,1:j)-yth(1:j));
avg_R_err = mean(R_err);
R_percent_err = 100*(R_err./yth(1:j));
avg_R_percent_err = mean(R_percent_err);

RMSE = sqrt(mean(R_err.^2));
NRMSE = RMSE/(mean(yth(1:j)))

disp(['avg R error: ',num2str(avg_R_err),' (',num2str(avg_R_percent_err), ...
    '%)']);

disp(['NRMSE = ',num2str(NRMSE)])
%% Plotting

% R

figure(1)
clf

hold on
plot(1:length(yth),yth,'rx','linewidth',2)
plot(j_range,x_est(1,j_range),'bo-')
fill([j_range,fliplr(j_range)],[x_min(1,j_range),fliplr(x_max(1,j_range))],'b','FaceAlpha',0.2,'EdgeColor','none')
fill([j_range,fliplr(j_range)],[x_min_sigma(1,j_range),fliplr(x_pls_sigma(1,j_range))],'b','FaceAlpha',0.2,'EdgeColor','none')
xlim([0 peak_time])
legend('data','Estimate','Ensemble','$\pm \sigma$','location','northeast')
xlabel('time step')
ylabel('$\frac{R}{R_{max}}$')
grid on
set(gca,'fontsize',20)

% U, P, S

figure(2)
clf

subplot(3,1,1)
hold on
plot(j_range,x_est(2,j_range),'bo-')
fill([j_range,fliplr(j_range)],[x_min(2,j_range),fliplr(x_max(2,j_range))],'b','FaceAlpha',0.2,'EdgeColor','none')
fill([j_range,fliplr(j_range)],[x_min_sigma(2,j_range),fliplr(x_pls_sigma(2,j_range))],'b','FaceAlpha',0.2,'EdgeColor','none')
legend('Estimate','Ensemble','$\pm \sigma$','location','northeast')
xlim([0 peak_time])
ylabel('U')
grid on
set(gca,'fontsize',20)

subplot(3,1,2)
hold on
plot(j_range,exp(x_est(3,j_range)),'bo-')
fill([j_range,fliplr(j_range)],[exp(x_min(3,j_range)),fliplr(exp(x_max(3,j_range)))],'b','FaceAlpha',0.2,'EdgeColor','none')
fill([j_range,fliplr(j_range)],[exp(x_min_sigma(3,j_range)),fliplr(exp(x_pls_sigma(3,j_range)))],'b','FaceAlpha',0.2,'EdgeColor','none')
xlim([0 peak_time])
ylabel('$\frac{p_b}{p_{\infty}}$')
grid on
set(gca,'fontsize',20)

subplot(3,1,3)
hold on
plot(j_range,x_est(4,j_range),'bo-')
fill([j_range,fliplr(j_range)],[x_min(4,j_range),fliplr(x_max(4,j_range))],'b','FaceAlpha',0.2,'EdgeColor','none')
fill([j_range,fliplr(j_range)],[x_min_sigma(4,j_range),fliplr(x_pls_sigma(4,j_range))],'b','FaceAlpha',0.2,'EdgeColor','none')
xlim([0 peak_time])
xlabel('time step')
ylabel('$\frac{S}{p_{\infty}}$')
grid on
set(gca,'fontsize',20)

% Compare truth and estimate for log(Ca), log(Re):
%{
figure(8)
clf

subplot(2,1,1)
hold on
plot(j_range,x_est(end-1,:),'ko-')
fill([j_range,fliplr(j_range)],[x_min(end-1,:),fliplr(x_max(end-1,:))],'b','FaceAlpha',0.2,'EdgeColor','none')
fill([j_range,fliplr(j_range)],[x_min_sigma(end-1,:),fliplr(x_pls_sigma(end-1,:))],'b','FaceAlpha',0.2,'EdgeColor','none')
legend('Estimate','Ensemble','$\pm \sigma$','location','northeast')
xlabel('time step')
ylabel('$log(Ca)$')
grid on
set(gca,'fontsize',20)

subplot(2,1,2)
hold on
plot(j_range,x_est(end,:),'ko-')
fill([j_range,fliplr(j_range)],[x_min(end,:),fliplr(x_max(end,:))],'b','FaceAlpha',0.2,'EdgeColor','none')
fill([j_range,fliplr(j_range)],[x_min_sigma(end,:),fliplr(x_pls_sigma(end,:))],'b','FaceAlpha',0.2,'EdgeColor','none')
xlabel('time step')
ylabel('$log(Re)$')
grid on
set(gca,'fontsize',20)
%}

% Compare truth and estimate for Ca, Re:
%{
figure(88)
clf

subplot(2,1,1)
hold on
plot(j_range,Ca_true,'k-','linewidth',2)
plot(j_range,Ca_est,'ko-')
fill([j_range,fliplr(j_range)],[Ca_min,fliplr(Ca_max)],'b','FaceAlpha',0.2,'EdgeColor','none')
fill([j_range,fliplr(j_range)],[Ca_min_sigma,fliplr(Ca_pls_sigma)],'b','FaceAlpha',0.2,'EdgeColor','none')
legend('true','Estimate','Ensemble','$\pm \sigma$','location','northeast')
xlabel('time step')
ylabel('Ca')
grid on
set(gca,'fontsize',20)

subplot(2,1,2)
hold on
plot(j_range,Re_true,'k-','linewidth',2)
plot(j_range,Re_est,'ko-')
fill([j_range,fliplr(j_range)],[Re_min,fliplr(Re_max)],'b','FaceAlpha',0.2,'EdgeColor','none')
fill([j_range,fliplr(j_range)],[Re_min_sigma,fliplr(Re_pls_sigma)],'b','FaceAlpha',0.2,'EdgeColor','none')
xlabel('time step')
ylabel('Re')
grid on
set(gca,'fontsize',20)
%}

% Compare truth and estimate for G,mu:
figure(89)
clf
%{
subplot(2,1,1)
hold on
plot(j_range,G_est,'ko-')
fill([j_range,fliplr(j_range)],[G_min,fliplr(G_max)],'b','FaceAlpha',0.2,'EdgeColor','none')
fill([j_range,fliplr(j_range)],[G_min_sigma,fliplr(G_pls_sigma)],'b','FaceAlpha',0.2,'EdgeColor','none')
legend('Estimate','Ensemble','$\pm \sigma$','location','northeast')
ylabel('$G \ [Pa]$')
grid on
set(gca,'fontsize',20)
%}
% alpha
subplot(2,1,1)
hold on
plot(j_range,alpha_est,'ko-')
fill([j_range,fliplr(j_range)],[alpha_min,fliplr(alpha_max)],'b','FaceAlpha',0.2,'EdgeColor','none')
fill([j_range,fliplr(j_range)],[alpha_min_sigma,fliplr(alpha_pls_sigma)],'b','FaceAlpha',0.2,'EdgeColor','none')
legend('Estimate','Ensemble','$\pm \sigma$','location','northeast')
ylabel('$\alpha$')
grid on
set(gca,'fontsize',20)

% mu
subplot(2,1,2)
hold on
plot(j_range,mu_est,'ko-')
fill([j_range,fliplr(j_range)],[mu_min,fliplr(mu_max)],'b','FaceAlpha',0.2,'EdgeColor','none')
fill([j_range,fliplr(j_range)],[mu_min_sigma,fliplr(mu_pls_sigma)],'b','FaceAlpha',0.2,'EdgeColor','none')
xlabel('time step')
ylabel('$\mu \ [Pa \cdot s]$')
grid on
set(gca,'fontsize',20)
%{
figure(90)
clf

subplot(2,1,1)
hold on
plot(j_range,alpha_est,'ko-')
fill([j_range,fliplr(j_range)],[alpha_min,fliplr(alpha_max)],'b','FaceAlpha',0.2,'EdgeColor','none')
fill([j_range,fliplr(j_range)],[alpha_min_sigma,fliplr(alpha_pls_sigma)],'b','FaceAlpha',0.2,'EdgeColor','none')
legend('Estimate','Ensemble','$\pm \sigma$','location','northeast')
ylabel('$\alpha$')
grid on
set(gca,'fontsize',20)

subplot(2,1,2)
hold on
plot(j_range,lambda_nu_est,'ko-')
fill([j_range,fliplr(j_range)],[lambda_nu_min,fliplr(lambda_nu_max)],'b','FaceAlpha',0.2,'EdgeColor','none')
fill([j_range,fliplr(j_range)],[lambda_nu_min_sigma,fliplr(lambda_nu_pls_sigma)],'b','FaceAlpha',0.2,'EdgeColor','none')
xlabel('iteration')
ylabel('$\lambda_{\nu}$')
grid on
set(gca,'fontsize',20)
%}
% Covariance
%{
figure(888)
clf

hold on
plot(j_range,Ctrace_est,'r-','linewidth',2)
xlabel('time step')
ylabel('Cov. Trace')
grid on
set(gca,'fontsize',20)
%}


%% Plots for paper

figure(11)
clf
hold on
plot(j_range,Ctrace_est,'r-','linewidth',2)
xlabel('time step')
ylabel('Cov. Trace')
grid on
set(gca,'fontsize',20)

figure(12)
clf
hold on
plot(j_range,R_err,'r-','linewidth',2)
xlabel('time step')
ylabel('R error')
grid on
set(gca,'fontsize',20)
%{
clear % for convenience
cd results_feb
cd SoftPA_paramagnetic
%}

%% Normalized time

% R
figure(111)
clf

hold on
plot(t(1:length(j_range)+3)./t0,yth(1:length(j_range)+3),'rx','linewidth',2)
plot(t(j_range)./t0,x_est(1,j_range),'bo-')
fill([t(j_range)./t0,fliplr(t(j_range)./t0)],[x_min(1,j_range),fliplr(x_max(1,j_range))],'b','FaceAlpha',0.2,'EdgeColor','none')
fill([t(j_range)./t0,fliplr(t(j_range)./t0)],[x_min_sigma(1,j_range),fliplr(x_pls_sigma(1,j_range))],'b','FaceAlpha',0.2,'EdgeColor','none')
xlim([0 t(length(j_range)+3)./t0])
legend('data','Estimate','location','northeast')
xlabel('$t^*$')
ylabel('$\frac{R}{R_{max}}$')
grid on
set(gca,'fontsize',20)

% alpha, mu
figure(222)
clf
% alpha
subplot(2,1,1)
hold on
plot(t(j_range)./t0,alpha_est,'ko-')
fill([t(j_range)./t0,fliplr(t(j_range)./t0)],[alpha_min,fliplr(alpha_max)],'b','FaceAlpha',0.2,'EdgeColor','none')
fill([t(j_range)./t0,fliplr(t(j_range)./t0)],[alpha_min_sigma,fliplr(alpha_pls_sigma)],'b','FaceAlpha',0.2,'EdgeColor','none')
legend('Estimate','Ensemble','location','northeast')
xlim([0 t(length(j_range))./t0])
ylabel('$\alpha$')
grid on
set(gca,'fontsize',20)

% mu
subplot(2,1,2)
hold on
plot(t(j_range)./t0,mu_est,'ko-')
fill([t(j_range)./t0,fliplr(t(j_range)./t0)],[mu_min,fliplr(mu_max)],'b','FaceAlpha',0.2,'EdgeColor','none')
fill([t(j_range)./t0,fliplr(t(j_range)./t0)],[mu_min_sigma,fliplr(mu_pls_sigma)],'b','FaceAlpha',0.2,'EdgeColor','none')
xlim([0 t(length(j_range))./t0])
xlabel('$t^*$')
ylabel('$\mu \ [Pa \cdot s]$')
grid on
set(gca,'fontsize',20)

%cd results_apr/SoftPA_paramagnetic