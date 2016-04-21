function [G1,g1,g2] = SemiinfiniteSol(rho,z,lt,Ls,mua,musp,ko,Db,beta,tau)

global taufit
  
r1 = sqrt(rho^2 + (z-lt)^2);
r2 = sqrt(rho^2 + (z+lt+2*Ls)^2);

K = sqrt(3*mua*musp + 6*ko*ko*musp*musp*Db*tau);
Ko = sqrt(3*mua*musp);


G1 = 3*musp/(4*pi)*( exp(-r1*K)./r1 - exp(-r2*K)./r2 );

g1 = G1./( 3*musp/(4*pi)*(exp(-r1*Ko)./r1 - exp(-r2*Ko)./r2 ));

g2 = 1 + beta*abs(g1.*g1);

return