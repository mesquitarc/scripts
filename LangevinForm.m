function [G1,g1,g2] = LangevinForm(rho,z,lt,Ls,mua,musp,ko,Deff,tau_c,beta,tau)

%global taufit
  
r1 = sqrt(rho^2 + (z-lt)^2);
r2 = sqrt(rho^2 + (z+lt+2*Ls)^2);

Dr_2 = 6*Deff*(tau-tau_c*(1-exp(-tau/tau_c)));

K = sqrt(3*mua*musp + ko*ko*musp*musp*Dr_2);
Ko = sqrt(3*mua*musp);


G1 = 3*musp/(4*pi)*( exp(-r1*K)./r1 - exp(-r2*K)./r2 );

g1 = G1./( 3*musp/(4*pi)*(exp(-r1*Ko)./r1 - exp(-r2*Ko)./r2 ));

g2 = 1 + beta*abs(g1.*g1);

return