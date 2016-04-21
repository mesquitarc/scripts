function accept = ProbMCMC(dChi2,sigma)

accept = 0;
if dChi2 < 0
    accept = 1;
else
    prob = exp( -dChi2/(2*sigma) );
    if prob >= rand(1);
        accept = 1;
    end
end
return