function [x,varargout] = MinimizeDCSData(tau,d,Nmax,Xo)


global taufit
global dfit

taufit = tau(1:Nmax);
dfit = d(1:Nmax);


%*******************************************************
% INITIAL GUESS FOR STATE VECTOR
%*******************************************************
if ~exist('Xo')
    Xo=zeros(4,3);   %[Lower Bound /Initial Guess / Upper Bound]
    d=1e-15;
    Xo(1,:)=[0.5-d   0.5   0.5+d];      % Beta
    Xo(2,:)=[1e-10  1e-8  1e-6];     % alpha*Db
    Xo(3,:)=[0.1-d  0.1   0.1+d];     % mua
    Xo(4,:)=[10-d  10    10+d];       % musp
end

        
        
% Set an options file for LSQNONLIN to use the large-scale algorithm
options = optimset('TolFun',1E-10,'TolX',1E-10,'MaxFunEvals',2E6,'MaxIter',2E6,'display','off',...
    'Diagnostics','off','NonlEqnAlgorithm','lm','LargeScale','on');
warning('off','MATLAB:declareGlobalBeforeUse')

% Calculate the new coefficients using nonlinear square fit
[x,resnorm,residual,exitflag,output,lambda] =lsqnonlin(@DCSCostFc,Xo(:,2),Xo(:,1),Xo(:,3),options);

if nargout >=1
    varargout{1} = resnorm;
end

return
