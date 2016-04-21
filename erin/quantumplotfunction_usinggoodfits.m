%%Time-stamp: "2007-01-24 13:55:25 matlabuser"

if exist('cutpoint')~=1

    if plotoxygen
        Marks(length(Marks)+1)=length(hbo2series);
    end

    Marksflow(length(Marksflow)+1)=length(Dbfit);
    cutpointo2=length(Marks);
    cutpointflow=length(Marksflow);

end



Markstime=Marks.*secsperframe; %time corrected
Markstime=Markstime./60; %convert time to minutes

%calculate time axis
if plotoxygen
    timeaxis=((1:length(hbo2series))-1).*secsperframe;
    timeaxis=timeaxis(1:Marks(cutpointo2));
    timeaxis=timeaxis./60;
else
    timeaxis=((1:length(Dbfit))-1).*secsperframe;
    timeaxis=timeaxis(1:Marksflow(cutpointflow));
    timeaxis=timeaxis./60;
end


fig1=figure;
%To plot oxygen data
if plotoxygen

    %to *not* average
    plot1a=strokefilter(squeeze(hbo2series(1:Marks(cutpointo2))),subjectid,myfiltersize);
    plot2a=strokefilter(squeeze(hbseries(1:Marks(cutpointo2))),subjectid,myfiltersize);

    figure(fig1),subplot(subplotsize,1,plotoxygen)
    plot(timeaxis,plot1a.*1000,'x-r','LineWidth',2)
    hold on, plot(timeaxis,plot2a.*1000,'o-b','LineWidth',2)
    title(['Patient ID=' subjectid '\_' patdate ],'FontSize',24)
    ylim(oxylimrange)
    xlim([min(timeaxis) max(timeaxis)])
    set(gca,'FontSize',24)
    legend({'HbO2','Hb'},legendlocation,'FontSize',16)
    ylabel('\Delta\muM','FontSize',20)
    xlabel('Min','FontSize',20)
    tmplim3=get(gca,'YLim');

    for kkkk=1:length(markstoshow)
        line([Markstime(markstoshow(kkkk)) Markstime(markstoshow(kkkk))],[tmplim3(1) tmplim3(2)],'Color',[0 0 0])
    end

    for kkkk=1:length(positionstolabel)
        text(Markstime(positionstolabel(kkkk))+labelshift, tmplim3(2)+labelshiftyoxy-kkkk*2,anglestolabel(kkkk),'Color',[1 0 0],'FontSize',16)
    end

    grid on

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5


Markstime=Marksflow.*secsperframe; %time axis corrected
Markstime=Markstime./60;
timeaxis=((1:length(Dbfit))-1).*secsperframe;
timeaxis=timeaxis./60;
timeaxis=timeaxis(1:Marksflow(cutpointflow));

plot1b=strokefilter(Dbfit(1:Marksflow(cutpointflow),1,1),subjectid,myfiltersize);
plot2b=strokefilter(Dbfit(1:Marksflow(cutpointflow),1,2),subjectid,myfiltersize);
ind1b=find(goodfit(:,1)==0);
ind2b=find(goodfit(:,2)==0);
plot1b(ind1b)=NaN;
plot2b(ind2b)=NaN;

baselines=nanmean(squeeze(plot1b(baselinerangeflow)));
%baselines=mean(squeeze(plot1a(1:Marksflow(1))));
plot1b=plot1b./baselines;

baselines=nanmean(squeeze(plot2b(baselinerangeflow)));
%baselines=mean(squeeze(plot1b(1:Marksflow(1))));
plot2b=plot2b./baselines;

flowavg=nanmean([plot1b.';plot2b.']);

if plotflow
    figure(fig1)
    subplot(subplotsize,1,secondplot)
    h1=plot(timeaxis,flowavg.*100,'.','Color',[0 0.5 0],'LineWidth',2,'MarkerSize',30);
    hold on
    axis tight
    ylim(flowlimrange)
    set(gca,'FontSize',24)
    ylabel('rCBF(%)')
    xlabel('Min')
    tmplim3=get(gca,'YLim');
    for kkkk=1:length(markstoshow)
        line([Markstime(markstoshow(kkkk)) Markstime(markstoshow(kkkk))],[tmplim3(1) tmplim3(2)],'Color',[0 0 0])
    end

    for kkkk=1:length(positionstolabel)
        text(Markstime(positionstolabel(kkkk))+labelshift, tmplim3(2)+labelshiftyflow-kkkk*13,anglestolabel(kkkk),'Color',[1 0 0],'FontSize',16)
    end
    grid on

end

set(fig1,'PaperPositionMode','Auto')
maxwindows(fig1);

if savefigures
    figure(fig1)
    saveas(gcf,['../' subjectid '/' subjectid 'notes/savedfigs/MRI_' patdate '_' subjectid '_flowoxy.fig'],'fig')
    saveas(gcf,['../' subjectid '/' subjectid 'notes/savedfigs/MRI_' patdate '_' subjectid '_flowoxy.eps'],'epsc2')
    saveas(gcf,['../' subjectid '/' subjectid 'notes/savedfigs/MRI_' patdate '_' subjectid '_flowoxy.png'],'png')

end

