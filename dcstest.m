%
% This file sets up the probe configuration to be used for both DCS and
% oxygenation data. Its outputs are: 
% sources [Ns vs xy coord]
% detectors [Nd vs xy coord]
% fsources (flow sources)
% fdetectors (flow detectors)
% Ns (# sources)
% Nd (# detectors)
% sdlist (r coord for all src/det combinations)
% fsdlist (flow sdlist)
%

clear sources;
clear detectors;
clear fsources;
clear fdetectors;

sources(1,:)=[0 0];
detectors(1,:)=[1.5 0];
detectors(2,:)=[2.5 0];
detectors(3,:)=[3.5 0];
detectors(4,:)=[4.5 0];
detectors(5,:)=[1.5 2];
detectors(6,:)=[2.5 2];
detectors(7,:)=[3.5 2];
detectors(8,:)=[4.5 2];

fsources=sources;

fdetectors=detectors;

for kk=1:size(sources,1)
    for kkk=1:size(detectors,1)
        sdlist(kk,kkk)=sqrt((detectors(kkk,1)-sources(kk,1)).^2+(detectors(kkk,2)-sources(kk,2)).^2);
    end
end

for kk=1:size(fsources,1)
    for kkk=1:size(fdetectors,1)
        fsdlist(kk,kkk)=sqrt((fdetectors(kkk,1)-fsources(kk,1)).^2+(fdetectors(kkk,2)-fsources(kk,2)).^2);
    end
end

 Ns=size(fsources,1);
 Nd=size(fdetectors,1);
 
%to plot the map
if 0
    figure,
    hold on,plot(fsources(:,1),fsources(:,2),'xr')
    text(fsources(:,1),fsources(:,2)-0.05,num2str( (1:size(fsources,1)).'));
    hold on,plot(fdetectors(:,1),fdetectors(:,2),'dk')
    text(fdetectors(:,1),fdetectors(:,2)-0.05,num2str( (1:size(fdetectors,1)).'));
    hold on,plot(sources(:,1),sources(:,2),'or')
    text(sources(:,1),sources(:,2)-0.05,num2str( (1:size(sources,1)).'));
    hold on,plot(detectors(:,1),detectors(:,2),'.y')
    text(detectors(:,1),detectors(:,2)-0.05,num2str( (1:size(detectors,1)).'));
%    xlim([-rd-1 rd+1])
%    ylim([-rd-1 rd+1])
end

clear kk kkk


