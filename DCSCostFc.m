function [F,varargout] = DCSCostFc(x)

global taufit
global dfit


%*******************************************************
% DEFINING CONSTANTS AND PARAMETERS
%*******************************************************
n0=1.4;
c=2.99792458e10;
vo=c/n0;

R=-1.440./n0^2+0.710/n0+0.668+0.0636.*n0;
ze=2./3.*(1+R)./(1-R);

lambda=7.85e-5;
ko=2*pi*n0/lambda;

rho = 2.5;
z0 = 1.0;
z = 0;


%*******************************************************
% CALCULATING AUTOCORRELATION FUNCTIONS
%*******************************************************
tau = taufit;
if x(1)==NaN
    beta = 0.5;
    mua = 0.1;
    musp = 0.10;
else
    beta = x(1);
    mua = x(3);
    musp = x(4);
end
Db = x(2);

r1 = sqrt(rho^2 + (z-z0)^2);
r2 = sqrt(rho^2 + (z+z0+2*ze)^2);

G1 = 3*musp/(4*pi)*( exp(-r1*sqrt(3*mua*musp + 6*ko*ko*musp*musp*Db*tau))./r1 - exp(-r2*sqrt(3*mua*musp + 6*ko*ko*musp*musp*Db*tau))./r2 );

g1 = G1./( 3*musp/(4*pi)*(exp(-r1*sqrt(3*mua*musp))./r1 - exp(-r2*sqrt(3*mua*musp))./r2 ));

g2 = 1 + beta*abs(g1.*g1);


%*******************************************************
% COST FUNCTION
%*******************************************************

%sigma(:,i)=1./intensitydata(measnum+1,i).*sqrt(1./T./t).*sqrt(1+mean(setbeta).*exp(-gamma*taus));

if x(1)==NaN
    F = norm(g2-dfit);
else
F = (g2 - dfit);
end

             
if nargout >=1
    varargout{1} = g2;
end

return