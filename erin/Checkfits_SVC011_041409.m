%%Check curve fit,  By Erin
%3/11/09, trying to determine criteria to use to call a fit "good"
%abs(meanerror)<10
%stderror<35
%0<Beta<0.7
%1Hz<Intensity<30kHz
%Mean tail of correlation curve approaches 0
%Chi2<1
%Returns a vector 'goodfit' of 0's and 1's.  0=bad fit, 1=good

close all
clear all
subjectid='SVC011';
patdate='041409';
%To save files
savefigures=1;%=1 saves fit beta figure, ==0 saves set beta using first 3 points figure, ==2 doesnt save

load([ subjectid '_' patdate '_1_flow_output.mat'])

%Number of flow dets used:
Nd=2;
maxintensity=30000;

morefiles=1;
numfiles=1;
while(morefiles)
    fname=['../' subjectid '/' subjectid '_' patdate '/' subjectid '_' patdate '_1_flow_' num2str(numfiles) '.dat'];
    if exist(fname)==2
        data=load(fname);

        intensity=data(1,2:5)*1000;
        corrs=data(3:end,2:5);
        taus=data(3:end,1);

        goodfit(numfiles,1:Nd)=0;

        for i=1:Nd
            g1data(:,i)=sqrt(abs((corrs(:,i)-1)./Betasave(numfiles,i)));

            ind(numfiles,i)=find(abs(squeeze(Curvefit(:,numfiles,1,i))-0.3)==min(abs(squeeze(Curvefit(:,numfiles,1,i))-0.3)));
            errorfit(:,i)=(g1data(:,i)-squeeze(Curvefit(:,numfiles,1,i)))./squeeze(Curvefit(:,numfiles,1,i))*100;
            meanerror(numfiles,i)=mean(errorfit(1:ind(numfiles,i),i));
            stderror(numfiles,i)=std(errorfit(1:ind(numfiles,i),i));


            if Betasave(numfiles,i)<1
                if chisqr(numfiles,1,i)<1 && intensity(i)<maxintensity && intensity(i)>1 && abs(meanerror(numfiles,i))<10 && stderror(numfiles,i)<35 && Betasave(numfiles,i)<0.7 
                    %If light leaks, the tail of the data will not approach 0
                    meantail(numfiles,i)=mean(g1data(ind(numfiles,i):ind(numfiles,i)+100));
                    if meantail(numfiles,i)<0.3
                        %{
                   figure,subplot(2,2,1), semilogx(taus,g1data2,'b')
                    axis tight
                    ylim([0 1.2])
                    xlim([0 .01])
                    hold on, semilogx(taus,Curvefit(:,numfiles,1,2),'r')
                    title(['Frame: ' num2str(numfiles) ' norm.'],'FontSize',20);
                    text(5e-6,0.1,['\beta=' num2str(Betasave(numfiles,2),'%6.2f') ],'FontSize',16 )
                    text(5e-6,0.2,['I=' num2str(intensitydata(2),'%6.2f') ],'FontSize',16 )
                    xlabel('Time(s)','FontSize',18)
                    ylabel('g1','FontSize',18)
                    legend({['meas'],['fit']},'FontSize',16)
                    set(gca,'FontSize',16)
                    subplot(2,2,3), semilogx(taus(1:ind2),errorfit2(1:ind2),'b')
                    axis tight
                    ylim([-50 50])
                    xlim([0 .01])
                    title(['Frame: ' num2str(numfiles) ' % Error in fit'],'FontSize',20);
                    xlabel('Time(s)','FontSize',18)
                    ylabel('Error (%)','FontSize',18)
                    text(1e-4,-35,['Mean=' num2str(meanerror(numfiles,2),'%6.3f')],'FontSize',16 )
                    text(1e-4,-45,['Std=' num2str(stderror(numfiles,2),'%6.3f') ],'FontSize',16)
                    set(gca,'FontSize',16)
                    maxwindows(gcf)
                    pause
                    close all
                        %}
                        goodfit(numfiles,i)=1;
                    end
                end
            end
        end
        numfiles=numfiles+1;
    elseif exist(fname)==0
        morefiles=0;
    end
end


ff=['save ' subjectid '_' patdate '_1_flow_output.mat Dbfit Curvefit intensitydata fname1 minfiles measnum numfiles Marksflow Betasave chisqr goodfit'];
eval(ff);


