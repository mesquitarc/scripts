function [G1,g1,g2] = SlabSol(rho,z,d,lt,Ls,mua,musp,ko,Db,beta,tau,m)

global taufit

K = sqrt(3*mua*musp + 6*ko*ko*musp*musp*Db*tau);
Ko = sqrt(3*mua*musp);
Sumtmp = 0;
Sumnot = 0;
for i = -m:m
    zp = 2*i*(d + 2*Ls) + lt;
    zm = 2*i*(d + 2*Ls) - 2*Ls - lt;
    
    rp = sqrt(rho^2 + (z - zp)^2);
    rm = sqrt(rho^2 + (z - zm)^2);
    
    Sumtmp = Sumtmp + ( exp(-K*rp)./rp - exp(-K*rm)./rm );
    Sumnot = Sumnot + ( exp(-Ko*rp)./rp - exp(-Ko*rm)./rm ); 
end

G1 = 3*musp/(4*pi)*Sumtmp;

g1 = G1./( 3*musp/(4*pi)*Sumnot );    

g2 = 1 + beta*abs(g1.*g1);

return