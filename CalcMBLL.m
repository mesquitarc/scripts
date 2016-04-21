function [HbO,HbR,HbT] = CalcMBLL(A,baseline,DPF,sdlist,Ndet,Nsrc)



for det=1:Ndet
    for src=1:Nsrc
        bl1 = median(squeeze(A(src,1,det,baseline)));
        bl2 = median(squeeze(A(src,2,det,baseline)));
        bl3 = median(squeeze(A(src,3,det,baseline)));
        
        Int_t = [squeeze(A(src,1,det,:)) squeeze(A(src,2,det,:)) squeeze(A(src,3,det,:))];
        Int_0 = [bl1 bl2 bl3];
       
        lambdas = [830 786 690];  % for the heterodyne
        
        x = CalcConcModBeerLambert(Int_t,Int_0,lambdas,sdlist(src,det),DPF);
        
        hbo(:,src,det)=x(1,:)';
        hbr(:,src,det)=x(2,:)';
        
        clear hbotmp hbrtmp
    end
end

HbO = 1000*hbo;
HbR = 1000*hbr;
HbT = HbO+HbR;

