%%Time-stamp: "2007-05-15 15:14:13 matlabuser"

%%% EDITED TO MAKE A PLOT FOR QUANTUM GRANT
%% AFTER PLOTTING THE GRAPH , IT LETS ME TAKE POINTS FOR A BAR PLOT

close all
clear all

subjectid='SVC011';
patdate='041409';

%Copy checkfitframes from Checkfit.m
markstoshow=[1 4 5 6 7 8 9 10 11]+1;
anglestolabel={'MRI START','Increase Anesthesia','CO2 on','CO2 seen','ABG','','Diffusion','','MRI END'};
vitalsstartmark=71;%Note the line in the vitals that time sync mark occured at
%For this study, we did not time sync.  Instead, I'm just using the time we
%closed the MRI (7:31am)
timesyncmark_dcs=[2]+1;%Note the mark in optics data where time synced
tt=['load ' subjectid '_' patdate '_1_flow_output.mat'];
eval(tt);
excelfiletoread=['../' subjectid '/' subjectid 'notes/' subjectid '_' patdate 'VitalSigns_EBedits.xls'];


baselinerangeflow=Marksflow(1):Marksflow(4);


%plot oxygen or not?
plotoxygen=1;
plotflow=1;
subplotsize=2;
secondplot=plotflow+plotoxygen;

if plotoxygen
    tt=['load ' subjectid '_' patdate '_dpfout.mat'];
    eval(tt);
end

%ACCIDENTALLY MISSED A MARK WITH FLOW DATA
%Comment this line out for all other kids:
Marks=Marksflow;

tmp=Marksflow;
Marksflow(2:length(tmp)+1)=tmp;
Marksflow(1)=1;

%%for saving figures
savefigures=1; %=1 saves

%frame rate used for plots found in TIMING file
fdir1=['../' subjectid '/' subjectid '_' patdate '/'];
fname1=[ subjectid '_' patdate '_1_'];
fname_timing=[ fdir1 fname1 'TIMING.dat'];
fi=fopen(fname_timing,'rt');
tmp=fscanf(fi,['%g'],[1 1]);
fclose(fi);
secsperframe=tmp/1000;%Convert time to sec.s

%filter for gaussian
myfiltersize=1;

%%TWO SIDED
side2='Right';
side1='Left ';

if plotoxygen
    %if first mark is missing
    tmp=Marks;
    Marks(2:length(tmp)+1)=tmp;
    Marks(1)=1;
end

positionstolabel=markstoshow;

labelshift=50; %in seconds
labelshift=labelshift./60;
labelshiftyflow=-20;
labelshiftyoxy=-3;
legendlocation=3;


%TO CUT DATA
cutdata=0; %to cut the data a some mark
cutpoint=12;


if cutdata==0
    if plotoxygen
        Marks(length(Marks)+1)=length(hbo2series);
        cutpointo2=length(Marks);
    end

    Marksflow(length(Marksflow)+1)=length(Dbfit);

    cutpointflow=length(Marksflow);
end

if plotoxygen==0
    Marks=Marksflow;
end

%plot ranges
oxylimrange=[-20 40];
flowlimrange=[0 250];

quantumplotfunction_usinggoodfits;
tt=['save quantum' subjectid '_' patdate ' plot1a plot2a plot1b plot2b flowavg timeaxis Marks markstoshow'];
eval(tt);


%% Let's get the excel vital signs

[vitals vitalheader]=xlsread(excelfiletoread);
%since note taking begun at Marks(1). DIFFERENT FOR EACH PATIENT
%to convert datevec stuff to minutes without going to zero at each 59.
noteminutes= vitals(1:end,1).*1440-vitals(vitalsstartmark,1).*1440; 
noteminutes=noteminutes+timeaxis(Marksflow(timesyncmark_dcs)); 

plotlist=1:size(vitals,1);

%HR
figure,
plot(noteminutes(1:length(plotlist)),vitals(plotlist,2),'.k-','MarkerSize',40,'LineWidth',3)
set(gca,'FontSize',24)
xlim([min(timeaxis) max(timeaxis)])
tmplim3=get(gca,'YLim');
for kkkk=1:length(markstoshow)
    line([Markstime(markstoshow(kkkk)) Markstime(markstoshow(kkkk))],[tmplim3(1) tmplim3(2)],'Color',[0 0 0])
end
labelshifty=-(tmplim3(2)-tmplim3(1)).*0.03;
for kkkk=1:length(anglestolabel)
    text(Markstime(markstoshow(kkkk))+labelshift, tmplim3(2)+labelshifty-1*(kkkk-1),anglestolabel(kkkk),'Color',[1 0 0],'FontSize',16)
end

grid on
h1=legend('HR');
set(h1,'FontSize',16)
ylabel('Heart Rate (bpm)')
xlabel('min')
maxwindows(gcf);
set(gcf,'PaperPositionMode','Auto')
if savefigures

    saveas(gcf,['../' subjectid '/' subjectid 'notes/savedfigs/MRI' patdate '_' subjectid '_HR.fig'],'fig')
    saveas(gcf,['../' subjectid '/' subjectid 'notes/savedfigs/MRI' patdate '_' subjectid '_HR.eps'],'epsc2')
    saveas(gcf,['../' subjectid '/' subjectid 'notes/savedfigs/MRI' patdate '_' subjectid '_HR.png'],'png')

end

%StO2
figure,
plot(noteminutes(1:length(plotlist)),vitals(plotlist,3),'.k-','MarkerSize',40,'LineWidth',3)
set(gca,'FontSize',24)
xlim([min(timeaxis) max(timeaxis)])
tmplim3=get(gca,'YLim');
for kkkk=1:length(markstoshow)
    line([Markstime(markstoshow(kkkk)) Markstime(markstoshow(kkkk))],[tmplim3(1) tmplim3(2)],'Color',[0 0 0])
end
labelshifty=-(tmplim3(2)-tmplim3(1)).*0.03;
for kkkk=1:length(anglestolabel)
    text(Markstime(markstoshow(kkkk))+labelshift, tmplim3(2)+labelshifty.*(kkkk-1),anglestolabel(kkkk),'Color',[1 0 0],'FontSize',16)
end
grid on
h1=legend('O_2 Sat');
set(h1,'FontSize',16)
ylabel('O_2 Sat(%)')
xlabel('min')
maxwindows(gcf);
set(gcf,'PaperPositionMode','Auto')
if savefigures

    saveas(gcf,['../' subjectid '/' subjectid 'notes/savedfigs/MRI' patdate '_' subjectid '_SpO2.fig'],'fig')
    saveas(gcf,['../' subjectid '/' subjectid 'notes/savedfigs/MRI' patdate '_' subjectid '_SpO2.eps'],'epsc2')
    saveas(gcf,['../' subjectid '/' subjectid 'notes/savedfigs/MRI' patdate '_' subjectid '_SpO2.png'],'png')

end
%BP
figure,
plot(noteminutes(1:length(plotlist)),vitals(plotlist,4),'.b-','MarkerSize',40,'LineWidth',3)
hold on
plot(noteminutes(1:length(plotlist)),vitals(plotlist,5),'.-','Color',[0 0.5 0],'MarkerSize',40,'LineWidth',3)
hold on
plot(noteminutes(1:length(plotlist)),vitals(plotlist,6),'r.-','MarkerSize',40,'LineWidth',3)
hold on
set(gca,'FontSize',24)
tmplim3=get(gca,'YLim');
xlim([min(timeaxis) max(timeaxis)])
for kkkk=1:length(markstoshow)
    line([Markstime(markstoshow(kkkk)) Markstime(markstoshow(kkkk))],[tmplim3(1) tmplim3(2)],'Color',[0 0 0])
end
labelshifty=-(tmplim3(2)-tmplim3(1)).*0.03;
for kkkk=1:length(anglestolabel)
    text(Markstime(markstoshow(kkkk))+labelshift, tmplim3(2)+labelshifty.*(kkkk-1),[anglestolabel(kkkk)],'Color',[1 0 0],'FontSize',16)
end
grid on
set(gca,'FontSize',24)
h1=legend('Systolic','Diastolic','MAP');
set(h1,'FontSize',16)
ylabel('mmHg')
xlabel('min')
maxwindows(gcf);
set(gcf,'PaperPositionMode','Auto')
if savefigures

    saveas(gcf,['../' subjectid '/' subjectid 'notes/savedfigs/MRI' patdate '_' subjectid '_BP.fig'],'fig')
    saveas(gcf,['../' subjectid '/' subjectid 'notes/savedfigs/MRI' patdate '_' subjectid '_BP.eps'],'epsc2')
    saveas(gcf,['../' subjectid '/' subjectid 'notes/savedfigs/MRI' patdate '_' subjectid '_BP.png'],'png')

end
%InCO2
figure,
plot(noteminutes(1:length(plotlist)),vitals(plotlist,7),'.b-','MarkerSize',40,'LineWidth',3)
hold on, plot(noteminutes(1:length(plotlist)),vitals(plotlist,8),'.r-','MarkerSize',40,'LineWidth',3)
set(gca,'FontSize',24)
tmplim3=get(gca,'YLim');
for kkkk=1:length(markstoshow)
    line([Markstime(markstoshow(kkkk)) Markstime(markstoshow(kkkk))],[tmplim3(1) tmplim3(2)],'Color',[0 0 0])
end
labelshifty=-(tmplim3(2)-tmplim3(1)).*0.03;
for kkkk=1:length(anglestolabel)
    text(Markstime(markstoshow(kkkk))+labelshift, tmplim3(2)+labelshifty.*(kkkk-1),[anglestolabel(kkkk)],'Color',[1 0 0],'FontSize',16)
end
grid on
set(gca,'FontSize',24)
h1=legend('InCO_2','EtCO_2');
set(h1,'FontSize',16)
ylabel('InCO_2(mmHg)')
xlabel('min')
xlim([min(timeaxis) max(timeaxis)])
maxwindows(gcf);
set(gcf,'PaperPositionMode','Auto')
if savefigures

    saveas(gcf,['../' subjectid '/' subjectid 'notes/savedfigs/MRI' patdate '_' subjectid '_inco2.fig'],'fig')
    saveas(gcf,['../' subjectid '/' subjectid 'notes/savedfigs/MRI' patdate '_' subjectid '_inco2.eps'],'epsc2')
    saveas(gcf,['../' subjectid '/' subjectid 'notes/savedfigs/MRI' patdate '_' subjectid '_inco2.png'],'png')

end
%%% this one is for putting flow and CO2 together
fig1=figure;
figure(fig1)
h1=plot(timeaxis,flowavg.*100);
hold on
h2=plot(noteminutes(1:length(plotlist)),vitals(plotlist,7)+100);
ylim([0 400])
set(gca,'FontSize',24)
set(h1,'LineWidth',6,'Color','k')
set(h2,'LineWidth',6,'Color','b','Marker','o')
set(gca,'YTick',[50 100 150 200 250 300],'YTickLabel',num2str([50;100;150;200;250;300]));
h3=legend({' rCBF ','inCO_2'}, legendlocation);
ylabel(gca,'rCBF(%), inCO_2(mmHg+100)')
xlabel('Min')
xlim([min(timeaxis) max(timeaxis)])
figure(fig1)
tmplim3=get(gca,'YLim');
for kkkk=1:length(markstoshow)
    line([Markstime(markstoshow(kkkk)) Markstime(markstoshow(kkkk))],[tmplim3(1) tmplim3(2)],'Color',[0 0 0],'LineWidth',3)
end
labelshifty=-(tmplim3(2)-tmplim3(1)).*0.03;
for kkkk=1:length(anglestolabel)
    text(Markstime(markstoshow(kkkk))+labelshift, tmplim3(2)+labelshifty.*(kkkk-1),anglestolabel(kkkk),'Color',[1 0 0],'FontSize',16)
end
grid on
title(['Patient ID=' subjectid '\_' patdate ],'FontSize',24)
maxwindows(gcf);
set(gcf,'PaperPositionMode','Auto')
if savefigures

    saveas(gcf,['../' subjectid '/' subjectid 'notes/savedfigs/MRI' patdate '_' subjectid '_co2flow.fig'],'fig')
    saveas(gcf,['../' subjectid '/' subjectid 'notes/savedfigs/MRI' patdate '_' subjectid '_co2flow.eps'],'epsc2')
    saveas(gcf,['../' subjectid '/' subjectid 'notes/savedfigs/MRI' patdate '_' subjectid '_co2flow.png'],'png')

end
%{
%%%CMRO2 Metabolism
%approximations from "Can the cerebral metabolic rate of oxygen
% be estimated with near infrared spectroscopy?"
%Boas et al, Phys Med Biol, 48 (2003), 2405-18
gammar=1;
gammat=1;
backgroundthc=85; %in micro molar
backgroundsat=0.65;
backgroundhbo2=backgroundsat.*backgroundthc;
backgroundhb=backgroundthc-backgroundhbo2;
hbt0=backgroundthc; %%%%% IN ORDER TO GET A REASONABLE CMRO2, SHOULD BE 20, it is 100 in david, I found 85
sat0=backgroundsat;
hbr0=backgroundhb;

tmphb=tmphb.*1000;
tmphbO2=tmphbO2.*1000;
tmpthc=tmpthc.*1000;

tmpsat=squeeze((tmphbO2+backgroundhbo2)./(tmpthc+backgroundthc));


CMRO2=(1+gammar.* tmphb./hbr0)./(1+gammat.*tmpthc./hbt0).*(tmpcbf);

CMRO2old=(0.98-tmpsat)./(0.98-backgroundsat).*(tmpcbf);


figure;
h1=plot(timeaxis,CMRO2.*100,'x-k')
  ylim(flowlimrange)
  set(gca,'FontSize',24)
  hl=legend([h1],[side1], 'Location',legendlocation)
  set(hl,'FontSize',16)
  ylabel('rCMRO_2(%)')
  xlabel('Min')
    tmplim3=get(gca,'YLim');
    for kkkk=1:length(markstoshow)
    line([Markstime(markstoshow(kkkk)) Markstime(markstoshow(kkkk))],[tmplim3(1) tmplim3(2)],'Color',[0 0 0])
  end

  labelshifty=-(tmplim3(2)-tmplim3(1)).*0.03;
  for kkkk=1:length(anglestolabel)
    text(Markstime(markstoshow(kkkk))+labelshift, tmplim3(2)+labelshifty.*(kkkk-1),[anglestolabel(kkkk)],'Color',[1 0 0],'FontSize',16)
  end

  grid on
  maxwindows(gcf);
  figct=figct+1;
figurelist(figct)=gcf;


caption(figurelist(figct)).name=['{\bf ' subjectid '}: CMRO$_2$: calculated'];

  if savefigures

  saveas(gcf,['../' subjectid '/' subjectid 'notes/savedfigs/ochdquantum_' patdate '_' subjectid 'CMRO2.fig'],'fig')
  saveas(gcf,['../' subjectid '/' subjectid 'notes/savedfigs/ochdquantum_' patdate '_' subjectid 'CMRO2.eps'],'epsc2')
  saveas(gcf,['../' subjectid '/' subjectid 'notes/savedfigs/ochdquantum_' patdate '_' subjectid 'CMRO2.png'],'png')

end
%}
%}





