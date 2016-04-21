function [F,varargout] = DCSCostFcMinSearchAllHet(x,d,rho,mua,musp,GF)


% ADAPTAR ALGORITMO PARA RESOLVER O PROBLEMA PARA COLUNAS DE d

% USAR ISSO PARA 2-LAYER SOLVER


global taufit
tau = taufit;


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

Db = x(1);
if length(x)>=2
    beta = x(2);    
else
    beta = 0.5;
end
if ~exist('mua')
    mua = 0.05;
end
if ~exist('musp')
    mua = 10;
end

if GF=='SI' | GF=='SL' | GF=='LG'
    lt = 1/musp;
    Ls=2*lt./3.*(1+R)./(1-R);
    z = 0;
end


%*******************************************************
F = 0;

dfit = moving_average(d,5);
g2all = [];
for k = 1:size(d,2)
    clear lst G1 g1 g2 ng2 nd ntau Fi
    lst = find( dfit(:,k) > 1.15 );
    
    if ~isempty(lst)
        foo = find(diff(lst)>1);
        if ~isempty(foo)
            lst((foo(1)+1):end)=[];
        end
    end
    nd = d(lst,k);

    ntau = tau(lst);


    if GF == 'SI'
        %beta = median(dfit(1:5))-1;
        [G1,g1,g2]=SemiinfiniteSol(rho(k),z,lt,Ls,mua,musp,ko,Db,beta,ntau);
    elseif GF == 'LG'
        Deff = x(1);
        beta = x(2);
        tau_c = x(3);
        [G1,g1,g2]=LangevinForm(rho(k),z,lt,Ls,mua,musp,ko,Deff,tau_c,beta,ntau);
    elseif GF == 'SL'
        slablength = 1.0; % in cm
        [G1,g1,g2]=SlabSol(rho(k),z,slablength,lt,Ls,mua(k),musp,ko,Db,beta,ntau,2);
    elseif GF == '2L'
        %TwoLayerForwardSolver(n,Reff,mua1,mus1,aDb1,tau,lambda,rho,w,ell,mua2,mus2,aDb2,cutoff)
        Db_1 = x(1);
        Db_2 = x(2);
        beta = x(3);
        mua1 = mua(1,1);
        mua2 = mua(1,2);
        musp1 = musp(1,1);
        musp2 = musp(1,2);
        % According to Tom Floyd, a rough estimation would be spinal cord
        % being 1 cm diameter, so anterior artery would be located at
        % ~0.5cm from the posterior region (where the probe is currently
        % located); the anterior spinal artery has ~2mm diameter (Daniel
        % Boll et al, AJR 2006). Therefore,
        thickness = 0.4; % cm
        if ~isempty(ntau)
            for i=1:length(ntau)
                [G1(i),ph(i)]=TwoLayerForwardSolver(n0,R,mua1,musp1,Db_1,ntau(i),lambda,rho(k),0,thickness,mua2,musp2,Db_2,500);
            end
            g1 = G1/G1(1);
            g2 = 1 + beta*abs(g1.*g1);
        else
            g2 = [];
        end
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
    
    if ~isempty(nd)
        Fi = norm(g2' - nd);%nd);
        F = F + Fi;
        
        ng2 = g2;
        ng2(end:size(tau,2))=NaN;
        ng2 = ng2';
        g2all = [g2all ng2(:,1)];
    else
        F = 0;
    end
    

end

             
if nargout >1
    varargout{1} = g2all;
end

return