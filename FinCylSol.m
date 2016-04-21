function [G1,g1,g2] = FinCylSol(s,theta,z,so,zo,mua,musp,v,ko,Db,ab,db,tau,beta,m,n)
         
global taufit

D = v/(3*musp+mua);
K = sqrt(3*mua*musp + 6*ko*ko*musp*musp*Db*tau);
Ko = sqrt(3*mua*musp);

SumM = 0;
SumMo = 0;
for i=1:m
    km = sqrt(K.^2 + (i*pi/db)^2);
    km0 = sqrt(Ko^2 + (i*pi/db)^2);

    SumN = 0;
    SumNo = 0;
    for j=-n:n
        SumN = SumN + besseli(j,s*km) .* ( besseli(j,ab*km).*besselk(j,so*km) - ...
            besselk(j,ab*km).*besseli(j,so*km) ) .* cos(j*theta) ./ besseli(j,ab*km);
        SumNo = SumNo + besseli(j,s*km0) .* ( besseli(j,ab*km0).*besselk(j,so*km0) - ...
            besselk(j,ab*km0).*besseli(j,so*km0) ) .* cos(j*theta) ./ besseli(j,ab*km0);
    end

    SumM = SumM + sin(i*pi*z/db).*sin(i*pi*zo*db).*SumN;
    SumMo = SumMo + sin(i*pi*z/db)*sin(i*pi*zo*db)*SumNo;
end

G1 = 1/(pi*D*db)*SumM;

g1 = G1./( 1/(pi*D*db)*SumMo );

g2 = 1 + beta*abs(g1.*g1);

return