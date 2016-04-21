function [F,varargout] = DCSCostFcMinSearchAll(x,d,rho,mua,musp,fitpts,GF)

global taufit


%*******************************************************
% DEFINING CONSTANTS AND PARAMETERS
%*******************************************************
n0=1.4;
c=2.99792458e10;
vo=c/n0;

R=-1.440./n0^2+0.710/n0+0.668+0.0636.*n0;

lambda=7.85e-5;
ko=2*pi*n0/lambda;

%*******************************************************
% CALCULATING AUTOCORRELATION FUNCTIONS
%*******************************************************
tau = taufit;

Db = x(1);
if length(x)>=2
    beta = x(2);
    if length(x)>=3
        mua = x(3);
        if length(x)>=4
            musp = x(4);
        end
    end      
else
    beta = 0.5;
end
if ~exist('mua')
    mua = 0.05;
end
if ~exist('musp')
    mua = 10;
end

lt = 1/musp;
Ls=2*lt./3.*(1+R)./(1-R);
z = 0;

if GF == 'SI'
    [G1,g1,g2]=SemiinfiniteSol(rho,z,lt,Ls,mua,musp,ko,Db,beta,tau);
elseif GF == 'SL'
    slablength = .2;
    [G1,g1,g2]=SlabSol(rho,z,slablength,lt,Ls,mua,musp,ko,Db,beta,tau,10);
elseif GF == '2L'
    %TwoLayerForwardSolver(n,Reff,mua1,mus1,aDb1,tau,lambda,rho,w,ell,mua2,mus2,aDb2,cutoff)
    Db_1 = x(1);
    Db_2 = x(2);
    beta = x(3);
    mua1 = 0.1;
    mua2 = 0.1;
    musp1 = 20;
    musp2 = 20;
    thickness = 1; % cm
    for i=1:length(tau)
        [G1(i),ph(i)]=TwoLayerForwardSolver(n0,R,mua1,musp1,Db_2,tau(i),lambda,rho,0,thickness,mua2,musp2,Db_2,500);
    end
    g1 = G1/G1(1);
    g2 = 1 + beta*abs(g1.*g1);
elseif GF == 'FC'
    a = 0.5; % radius of cylinder
    s = a;
    theta = rho/a;
    ab = s + Ls; % extrapolated radius
    db = 2.5;
    so = a - lt;
    zo = db/2;
    z = zo - rho;
    [G1,g1,g2] = FinCylSol(s,theta,z,so,zo,mua,musp,vo,ko,Db,ab,db,tau,beta,15,15);
end

%*******************************************************
% COST FUNCTION
%*******************************************************

dfit = d; %moving_average(d,5);
F = norm(g2(1:fitpts) - dfit(1:fitpts));
%F = sum(0.5*(g2(1:fitpts) - dfit(1:fitpts)).^2);

% clf, cla
% plot(log10(tau),dfit,'kx')
% hold on, plot(log10(tau),g2)
% ylim([1 1.7]); xlim([-8 0])
% pause

%sigma(:,i)=1./intensitydata(measnum+1,i).*sqrt(1./T./t).*sqrt(1+mean(setbeta).*exp(-gamma*taus));
%F = norm(g2-d(1:length(taufit)));

             
if nargout >1
    varargout{1} = g2;
end

return