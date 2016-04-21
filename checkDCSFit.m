function [goodnessfit] = checkDCSFit(intensity,corrs,taus,Betasave,Curvefit,residue,Ns,Nd)
% It checks curve fits, and try to comes up with a criteria for evaluating
% the goodness-of-fit of the autocorrelation function. It returns a vector
% of 0s and 1s, which means bad and good fits, respectively. If any of the
% criteria fails, goodnessfit(frame) = 0.  
% Here, the criteria are:
%
% 1. abs(meanerror) < 10
% 2. stderror < 35
% 3. 0 < Beta < 0.7
% 4. 1Hz < Intensity < 30kHz
% 5. Mean tail of correlation curve approaches 0
% 6. Chi2 < 1
% 
% Syntax: checkDCSFit(intensity,corrs,taus,beta,Curvefit, 
%
% Created by: E. Buckley ( 2009/03/11 )
%


maxintensity=30000;
intensity = intensity*1000; % units in kHz...
 
goodnessfit = zeros(size(Curvefit,1),Ns,Nd);
fr = 1:size(corrs,2)';
for j=1:Ns  
    for k=1:size(Curvefit,1)  % same as numfiles
        for i=1:Nd
            g1data(:,i)=sqrt(abs((corrs(k,:,i)-1)./Betasave(k,j,i)));
            % Find beginning of the tail...
            ind(k,i)=find(abs(squeeze(Curvefit(k,j,i,:))-0.3)==min(abs(squeeze(Curvefit(k,j,i,:))-0.3)));
            % Calculating errors
            errorfit(:,i)=(g1data(:,i)-squeeze(Curvefit(k,j,i,:)))./squeeze(Curvefit(k,j,i,:))*100;
            meanerror(k,i)=mean(errorfit(1:ind(k,i),i));
            stderror(k,i)=std(errorfit(1:ind(k,i),i));
            if i==2
                figure, plot(fr,g1data(:,i),'bo',fr,squeeze(Curvefit(k,j,i,:)),'k')
            end
            chisqr = residue.*residue;
            if Betasave(k,j,i)<1
                if chisqr(k,j,i)<10 && intensity(k,i)<maxintensity && intensity(k,i)>1 && abs(meanerror(k,i))<15 && stderror(k,i)<35 && Betasave(k,j,i)<0.7 
                    % If light leaks, the tail of the data will not approach 0
                    meantail(k,i)=mean(g1data(ind(k,i):ind(k,i)+100));
                    if meantail(k,i)<0.3
                        goodnessfit(k,j,i)=1;
                    end
                end
            end
        end
    end
end

return

