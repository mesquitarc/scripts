
finasubject=input('Subject ID? ','s');
finadate=input('Subject date? ','s');
syncmark=input('At which optmark did sync occur? ','s');

load([finasubject '_' finadate '_1_flow_output.mat'])
load(['agematch' finasubject '_' finadate '.mat'])
load(['agematch' finasubject '_' finadate '_barplot.mat'])
load(['agematch' finasubject '_' finadate '_finapres.mat'])

%first want to sync up
syncmark=str2double(syncmark);
fpsyncmark=fpmarks(syncmark); %add numbers here depending on if extra marks exist
flowsyncmark=Marksflow(syncmark);

fpsyncsec=finapress(fpsyncmark,1);
flowsyncsec=timeaxis(flowsyncmark)*60;
diff=fpsyncsec-flowsyncsec;
finapresrange=[50 150];

%next get collected points converted
for i=1:size(barplotdata,2)
finadata(i).xvalsecsL=barplotdata(i).xvalsL.*60+diff;
%finadata(i).xvalsR=barplotdata(i).xvalsR.*60+diff;
end

%find closest finapres time point to point clicked
for i=1:size(finadata,2)
    for j=1:size(finadata(i).xvalsecsL,2)
        [finadata(i).yvalsL(j),finadata(i).xvalsL(j)]=min(abs(finapress(:,1)-finadata(i).xvalsecsL(j)));
    end
end

myfiltersize=4;
for i=2:size(finapress,2)
finapress(:,i)=strokefilter(finapress(:,i),finasubject,myfiltersize);
end

%insert mean of all hob angles into finadata structure -- based on L points
%or R points?
for i=1:size(finadata,2)
    
    %systolic BP
    finadata(i).sys=mean(finapress(finadata(i).xvalsL,2));
    finadata(i).sysSD=std(finapress(finadata(i).xvalsL,2));
    finapicked(i,1)=finadata(i).sys;
    finapickedSD(i,1)=finadata(i).sysSD;
    
    %diastolic BP
    finadata(i).dia=mean(finapress(finadata(i).xvalsL,3));
    finadata(i).diaSD=std(finapress(finadata(i).xvalsL,3));
    finapicked(i,2)=finadata(i).dia;
    finapickedSD(i,2)=finadata(i).diaSD;
    
    %mean arterial pressure
    finadata(i).map=mean(finapress(finadata(i).xvalsL,4));
    finadata(i).mapSD=std(finapress(finadata(i).xvalsL,4));
    finapicked(i,3)=finadata(i).map;
    finapickedSD(i,3)=finadata(i).mapSD;
    
    %heartrate
    finadata(i).hr=mean(finapress(finadata(i).xvalsL,5));
    finadata(i).hrSD=std(finapress(finadata(i).xvalsL,5));
    finapicked(i,4)=finadata(i).hr;
    finapickedSD(i,4)=finadata(i).hrSD;
    
    %interbeat interval
    finadata(i).ibi=mean(finapress(finadata(i).xvalsL,6));
    finadata(i).ibiSD=std(finapress(finadata(i).xvalsL,6));
    finapicked(i,5)=finadata(i).ibi;
    finapickedSD(i,5)=finadata(i).ibiSD;
    
    %stroke volume
    finadata(i).sv=mean(finapress(finadata(i).xvalsL,7));
    finadata(i).svSD=std(finapress(finadata(i).xvalsL,7));
    finapicked(i,6)=finadata(i).sv;
    finapickedSD(i,6)=finadata(i).svSD;
    
    %cardiac output
    finadata(i).co=mean(finapress(finadata(i).xvalsL,8));
    finadata(i).coSD=std(finapress(finadata(i).xvalsL,8));
    finapicked(i,7)=finadata(i).co;
    finapickedSD(i,7)=finadata(i).coSD;
    
    %left ventricular ejection time
    finadata(i).lvet=mean(finapress(finadata(i).xvalsL,9));
    finadata(i).lvetSD=std(finapress(finadata(i).xvalsL,9));
    finapicked(i,8)=finadata(i).lvet;
    finapickedSD(i,8)=finadata(i).lvetSD;
    
    %total peripheral resistance
    finadata(i).tpr=mean(finapress(finadata(i).xvalsL,10));
    finadata(i).tprSD=std(finapress(finadata(i).xvalsL,10));
    finapicked(i,9)=finadata(i).tpr;
    finapickedSD(i,9)=finadata(i).tprSD;
    
    %artifact
%    finadata(i).art=mean(finapress(finadata(i).xvalsL,11));
%    finadata(i).artSD=std(finapress(finadata(i).xvalsL,11));
%    finapicked(i,10)=finadata(i).art;
%    finapickedSD(i,10)=finadata(i).artSD;
    
    %impedence
%    finadata(i).imp=mean(finapress(finadata(i).xvalsL,12));
%    finadata(i).impSD=std(finapress(finadata(i).xvalsL,12));
%    finapicked(i,11)=finadata(i).imp;
%    finapickedSD(i,11)=finadata(i).impSD;
    
    %windkessel compliance
%    finadata(i).wkc=mean(finapress(finadata(i).xvalsL,13));
%    finadata(i).wkcSD=std(finapress(finadata(i).xvalsL,13));
%    finapicked(i,12)=finadata(i).wkc;
%    finapickedSD(i,12)=finadata(i).wkcSD;
    
    %height correction
    finadata(i).hc=mean(finapress(finadata(i).xvalsL,14));
    finadata(i).hcSD=std(finapress(finadata(i).xvalsL,14));
    finapicked(i,10)=finadata(i).hc;
    finapickedSD(i,10)=finadata(i).hcSD;
end

%make bar plots 
figure;

for k=1:3
finaBP(:,k)=finapicked(:,k);
end

subplot(3,3,1)
h=bar(finaBP);
colormap summer
%set(gca,'FontSize',10)
legend([h(1),h(2),h(3)],[dataname(2).name;dataname(3).name;dataname(4).name]);
ylabel(dataname(2).unit)
set(gca,'XTickLabel',anglelist,'FontSize',10)
xlabel('HOB Angle ^o')
title('Blood Pressure')

for k=1:3
%h2=get(h(k),'Children');
%h3=get(h2,'Xdata');
%h4=get(h(k),'Xdata');
%xpointsL= h4+(h3(1,:)-h3(4,:))./5*k;
%xpointsL=[k*.5+.6 k*.5+5.6 k*.5+10.6 k*.5+15.6 k*.5+20.6]
xpointsL=[k*.2+.6 k*.2+1.6 k*.2+2.6 k*.2+3.6 k*.2+4.6]
hold on
h=errorbar(xpointsL,finapicked(:,k),finapickedSD(:,k));
h=get(h,'Children')
%set(h(1),'LineStyle','none')
set(h(2),'Color','b','LineWidth',3)
end
    
for j=4:size(finapicked,2)-1
    subplot(3,3,j-2)
    h=bar(finapicked(:,j));
    colormap summer
    set(gca,'FontSize',10)
    ylabel(dataname(j+1).unit)
    set(gca,'XTickLabel',anglelist,'FontSize',10)
    xlabel('HOB Angle ^o')
    title(dataname(j+1).name)
    
    h2=get(h(1),'Children');
    h3=get(h2,'Xdata');
    h4=get(h(1),'Xdata');
    xpointsL= h4+(h3(1,:)-h3(4,:))./12;

    hold on
    h=errorbar(xpointsL,finapicked(:,j),finapickedSD(:,j));
    h=get(h,'Children')
    set(h(1),'LineStyle','none')
    set(h(2),'Color','b','LineWidth',3)

end

subplot(3,3,8)
h=bar(finapicked(:,10));
colormap summer
set(gca,'FontSize',10)
ylabel(dataname(13+1).unit)
set(gca,'XTickLabel',anglelist,'FontSize',10)
xlabel('HOB Angle ^o')
title(dataname(13+1).name)
    
h2=get(h(1),'Children');
h3=get(h2,'Xdata');
h4=get(h(1),'Xdata');
xpointsL= h4+(h3(1,:)-h3(4,:))./12;

hold on
h=errorbar(xpointsL,finapicked(:,10),finapickedSD(:,10));
h=get(h,'Children')
set(h(1),'LineStyle','none')
set(h(2),'Color','b','LineWidth',3)
ylim([-2 3])

maxwindows;
pause;

set(gcf,'PaperPositionMode','auto')

saveas(gcf,['../' finasubject '/' finasubject 'notes/savedfigs/finabarplot' ...
            finasubject '_' finadate '.fig'],'fig')
saveas(gcf,['../' finasubject '/' finasubject 'notes/savedfigs/finabarplot' ...
            finasubject '_' finadate '.eps'],'epsc2')
saveas(gcf,['../' finasubject '/' finasubject 'notes/savedfigs/finabarplot' ...
            finasubject '_' finadate '.png'],'png')
        
%make normalized finapres bar plots
for k=1:size(finapicked,2)-1
    finapickednorm(:,k)=finapicked(:,k)./finapicked(1,k).*100;
    finapickednormSD(:,k)=finapickedSD(:,k)./finapicked(1,k);
end

for k=1:3
finaBPnorm(:,k)=finapickednorm(:,k);
finaBPnormSD(:,k)=finapickednormSD(:,k);
end

tt=['save finapres' finasubject '_' finadate '_barplots  finapicked finapickedSD finapickednorm finapickednormSD'];
eval(tt);

figure;
subplot(3,3,1)
h=bar(finaBPnorm);
colormap summer
%set(gca,'FontSize',10)
legend([h(1),h(2),h(3)],[dataname(2).name;dataname(3).name;dataname(4).name]);
ylabel('%')
set(gca,'XTickLabel',anglelist,'FontSize',10)
xlabel('HOB Angle ^o')
title('Blood Pressure')

for k=1:3
%h2=get(h(k),'Children');
%h3=get(h2,'Xdata');
%h4=get(h(k),'Xdata');
%xpointsL= h4+(h3(1,:)-h3(4,:))./5*k;
xpointsL=[k*.2+.6 k*.2+1.6 k*.2+2.6 k*.2+3.6 k*.2+4.6]
hold on
h=errorbar(xpointsL,finapickednorm(:,k),finapickednormSD(:,k));
h=get(h,'Children')
%set(h(1),'LineStyle','none')
set(h(2),'Color','b','LineWidth',3)
ylim(finapresrange)
end

for j=4:size(finapickednorm,2)
    subplot(3,3,j-2)
    h=bar(finapickednorm(:,j));
    colormap summer
    set(gca,'FontSize',10)
    ylabel('%')
    set(gca,'XTickLabel',anglelist,'FontSize',10)
    xlabel('HOB Angle ^o')
    title(dataname(j+1).name)
    
    h2=get(h(1),'Children');
    h3=get(h2,'Xdata');
    h4=get(h(1),'Xdata');
    xpointsL= h4+(h3(1,:)-h3(4,:))./12;

    hold on
    h=errorbar(xpointsL,finapickednorm(:,j),finapickednormSD(:,j));
    h=get(h,'Children')
    set(h(1),'LineStyle','none')
    set(h(2),'Color','b','LineWidth',3)
    ylim(finapresrange)

end

maxwindows;
pause;

set(gcf,'PaperPositionMode','auto')

saveas(gcf,['../' finasubject '/' finasubject 'notes/savedfigs/finabarplotnorm' ...
            finasubject '_' finadate '.fig'],'fig')
saveas(gcf,['../' finasubject '/' finasubject 'notes/savedfigs/finabarplotnorm' ...
            finasubject '_' finadate '.eps'],'epsc2')
saveas(gcf,['../' finasubject '/' finasubject 'notes/savedfigs/finabarplotnorm' ...
            finasubject '_' finadate '.png'],'png')
