
% Code for testing linearity of ISS instrument
% Created 11/18/08 by MNK

foldername='ISSWithDCS_030309';
filename='Data_200903';
plotname='ISSWithDCS030309';
initiald=2; % initial source-detector distance, in cm
fitdata=1;

% Must sort the rest
files=dir(['../' foldername '/*.txt']); 
for numfile=1:size(files,1)
    names(numfile,:)=files(numfile).name(12:end-4);
end
names=sortrows(names);

data=[];
for i=1:size(files,1)
fid = fopen(['../' foldername '/' filename names(i,:) '.txt'], 'r');
[tmpdata, count]=fscanf(fid,'%c %s',1235);
clear tmpdata count
[tmpdata, count]=fscanf(fid,'%g %g',[106 inf]);  
fclose(fid)
tmpdata=tmpdata.';
data=cat(1,data,tmpdata);
end

% The columns of data:
% Column 1: Time (in seconds) *NOT RELIABLE! DON'T USE FOR TIME AXIS!*
% Column 2: Data group
% Column 3: Step (has to do with external GPIB devices)
% Column 4: Mark
% Column 5: Flag (turn into binary for message about data)
% Columns 6-21: AC data for Detector A, Sources 1-16
% Columns 22-37: DC data for Detector A, Sources 1-16
% Columns 38-53: Phase data for Detector A, Sources 1-16
% Columns 54-69: AC data for Detector B, Sources 1-16
% Columns 70-85: DC data for Detector B, Sources 1-16
% Columns 86-101: Phase data for Detector B, Sources 1-16
% Columns 102-105: Analog output data 1-4
% Column 106: Digital output data

updatetime=1/6.25; % Update time, set to 6.25 Hz.
timeaxis=0:updatetime:(length(data(:,1))-1)*updatetime;

sourcesused=[1 3 5 9 11 13]; % which sources, out of 16
wavelengths=[826.25 687.75 786.5 785.75 826.0 691.0];
marks=find(data(:,4)~=0);

% Plot noncalibrated AC, DC and phase data for Detectors A & B
for j=1:length(sourcesused)
ACdetA(:,j)=data(:,5+sourcesused(j));
ACdetB(:,j)=data(:,53+sourcesused(j));
DCdetA(:,j)=data(:,21+sourcesused(j));
DCdetB(:,j)=data(:,69+sourcesused(j));
phasedetA(:,j)=data(:,37+sourcesused(j));
phasedetB(:,j)=data(:,85+sourcesused(j));
end

%Rearrange by wavelength
ACmeanA=mean(ACdetA,1);
ACstdA=std(ACdetA,0,1);
ACmeanB=mean(ACdetB,1);
ACstdB=std(ACdetB,0,1);

tmp=[ACmeanA(5) ACmeanA(6) ACmeanA(4)];
tmpstd=[ACstdA(5) ACstdA(6) ACstdA(4)];
tmp1=[ACmeanB(5) ACmeanB(6) ACmeanB(4)];
tmp1std=[ACstdB(5) ACstdB(6) ACstdB(4)];

DCmeanA=mean(DCdetA,1);
DCstdA=std(DCdetA,0,1);
DCmeanB=mean(DCdetB,1);
DCstdB=std(DCdetB,0,1);

%Rearrange by wavelength
tmp=[DCmeanA(5) DCmeanA(6) DCmeanA(4)];
tmpstd=[DCstdA(5) DCstdA(6) DCstdA(4)];
tmp1=[DCmeanB(5) DCmeanB(6) DCmeanB(4)];
tmp1std=[DCstdB(5) DCstdB(6) DCstdB(4)];

phasemeanA=mean(phasedetA,1);
phasestdA=std(phasedetA,0,1);
phasemeanB=mean(phasedetB,1);
phasestdB=std(phasedetB,0,1);

%Rearrange by wavelength
tmp=[phasemeanA(5) phasemeanA(6) phasemeanA(4)];
tmpstd=[phasestdA(5) phasestdA(6) phasestdA(4)];
tmp1=[phasemeanB(5) phasemeanB(6) phasemeanB(4)];
tmp1std=[phasestdB(5) phasestdB(6) phasestdB(4)];

figure, subplot(2,2,1),
plot(timeaxis, ACdetA(:,1:3))
set(gca,'FontSize',14)
xlabel('Time (sec)')
ylabel('AC, Det A')
title('ISS Testing, Det A, 2cm Separation')
leg=legend([num2str(wavelengths(1))],[num2str(wavelengths(2))],[num2str(wavelengths(3))])

subplot(2,2,2)
plot(timeaxis, [ACdetA(:,1)./mean(ACdetA(1:50,1)),ACdetA(:,2)./mean(ACdetA(1:50,2)),ACdetA(:,3)./mean(ACdetA(1:50,3))].*100-100)
set(gca,'FontSize',14)
xlabel('Time (sec)')
ylabel('Relative AC, Det A (%)')
title('ISS Testing, Det A, 2cm Separation')
leg=legend([num2str(wavelengths(1))],[num2str(wavelengths(2))],[num2str(wavelengths(3))])

subplot(2,2,3)
barweb([ACmeanA(1:3)],[ACstdA(1:3)],[],{'DetA, 2cm'},'ISS Testing',[],'AC')
set(gca,'FontSize',14)
leg=legend([num2str(wavelengths(1))],num2str(wavelengths(2)), num2str(wavelengths(3)))

maxwindows;
saveas(gcf,['../plots/' plotname '_AC.fig'],'fig')
saveas(gcf,['../plots/' plotname '_AC.eps'],'epsc2')
saveas(gcf,['../plots/' plotname '_AC.png'],'png')

figure, subplot(2,2,1),
plot(timeaxis, DCdetA(:,1:3))
set(gca,'FontSize',14)
xlabel('Time (sec)')
ylabel('DC, Det A')
title('ISS Testing, Det A, 2cm Separation')
leg=legend([num2str(wavelengths(1))],[num2str(wavelengths(2))],[num2str(wavelengths(3))])

subplot(2,2,2),
plot(timeaxis, [DCdetA(:,1)./mean(DCdetA(1:50,1)),DCdetA(:,2)./mean(DCdetA(1:50,2)),DCdetA(:,3)./mean(DCdetA(1:50,3))].*100-100)
set(gca,'FontSize',14)
xlabel('Time (sec)')
ylabel('Relative DC, Det A (%)')
title('ISS Testing, Det A, 2cm Separation')
leg=legend([num2str(wavelengths(1))],[num2str(wavelengths(2))],[num2str(wavelengths(3))])

subplot(2,2,3), barweb([DCmeanA(1:3)],[DCstdA(1:3)],[],{'DetA, 2cm'},'ISS Testing',[],'DC')
set(gca,'FontSize',14)
leg=legend([num2str(wavelengths(1))],num2str(wavelengths(2)), num2str(wavelengths(3)))

maxwindows;
saveas(gcf,['../plots/' plotname '_DC.fig'],'fig')
saveas(gcf,['../plots/' plotname '_DC.eps'],'epsc2')
saveas(gcf,['../plots/' plotname '_DC.png'],'png')

% Plot phase data for Detectors A & B
figure, subplot(2,2,1),
plot(timeaxis, phasedetA(:,1:3))
set(gca,'FontSize',14)
xlabel('Time (sec)')
ylabel('Phase, Det A')
title('ISS Testing, Det A, 2cm Separation')
leg=legend([num2str(wavelengths(1))],[num2str(wavelengths(2))],[num2str(wavelengths(3))])

subplot(2,2,2),
plot(timeaxis, [phasedetA(:,1)-mean(phasedetA(1:50,1)),phasedetA(:,2)-mean(phasedetA(1:50,2)),phasedetA(:,3)-mean(phasedetA(1:50,3))])
set(gca,'FontSize',14)
xlabel('Time (sec)')
ylabel('Relative Phase, Det A (deg)')
title('ISS Testing, Det A, 2cm Separation')
leg=legend([num2str(wavelengths(1))],[num2str(wavelengths(2))],[num2str(wavelengths(3))])

subplot(2,2,3), barweb([phasemeanA(1:3)],[phasestdA(1:3)],[],{'DetA, 2cm'},'ISS Testing',[],'Phase')
set(gca,'FontSize',14)
leg=legend([num2str(wavelengths(1))],num2str(wavelengths(2)), num2str(wavelengths(3)))

maxwindows;
saveas(gcf,['../plots/' plotname '_phase.fig'],'fig')
saveas(gcf,['../plots/' plotname '_phase.eps'],'epsc2')
saveas(gcf,['../plots/' plotname '_phase.png'],'png')


