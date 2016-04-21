close all
clear all

% ---- INPUTS -----

baselinerangeoxy=[1 3]+1;
DPF=[4.35 4.2 4.4];



% lambdas=[830 786 686];
% usedlambda=[1 2 3]; 
% lambdas=lambdas(usedlambda);
% numdets=4; %Even though we are only using 1 of the 4 dets
% % approximate dpf factors for the above wavelengths, AO Vol32(418)-Fig 8a
% % 41weeks gestation, dont cite for lower than 720nm
% useddet=4;%Typically use either PMT3 or 4


% ---- READING FILES -----

[fg2a,fg2p,fg2I,fg2Q,sources2,Marks]=readDPDW('/mnt/d/upenn/baby/AOCHD04_121808_MRI_1_',4,3,2);


%get baseline
baselines=Marks(baselinerangeoxy(1)):Marks(baselinerangeoxy(2)); %baseline frames


% ---- LOADING SD INFORMATION -----

%load the probe map, sdlist etc.
plott=0;
flatbabyprobe; %Loads s-d seps in cm


% ---- ???????? -----

fig1=figure;

numdets=4;
ct=1;
for kk=1:numdets
    for kkk=1:numsources-1
        %{
        for i=1:length(usedlambda)
            y(kk,kkk,i,:)=-log(squeeze(fg2a(kk,i,kkk,:))./mean(squeeze(fg2a(kk,i,kkk,baselines))))/DPF(i)/sdlist(kkk,kk);
        end
        %}
        [hbseries,hbo2series]=threewavelengthdpf(squeeze(fg2a(kk,1,kkk,:)),squeeze(fg2a(kk,2,kkk,:)),squeeze(fg2a(kk,3,kkk,:)),...
            mean(squeeze(fg2a(kk,1,kkk,baselines))),mean(squeeze(fg2a(kk,2,kkk,baselines))),mean(squeeze(fg2a(kk,3,kkk,baselines))),...
            lambdas,sdlist(kkk,kk),DPF(1),DPF(2),DPF(3));
        
        figure(fig1),subplot(numdets,numsources-1,ct),plot((hbo2series+hbseries).*1000,'.g'), hold on
        figure(fig1),subplot(numdets,numsources-1,ct),plot(hbseries.*1000,'.r'), hold on
        figure(fig1),subplot(numdets,numsources-1,ct),plot(hbo2series.*1000,'.k'), hold on
        legend({['THC'],['Hb'],['HbO_{2}']})
        hbo2seriestmp(kk,kkk,:)=hbo2series;
        hbseriestmp(kk,kkk,:)=hbseries;
        tmplim=get(gca,'YLim');
        for kkkk=1:length(Marks)
            line([Marks(kkkk) Marks(kkkk)],[tmplim(1) tmplim(2)])
            %legend('THC','Hbr','HbO_2',-1)
        end
        maxwindows(gcf)
        ct=ct+1;
        clear hbo2series hbseries
    end
end

tt=['save ' fname 'dpfout.mat Marks hbo2seriestmp hbseriestmp fg2a useddet'];
eval(tt);

%pairstoplot s1d1,s1d2,s2d1,s3d2
pairstoplot=[1 3];
for kk=1:size(pairstoplot,1)
    figure;
    subplot(1,2,1),plot(squeeze(hbseriestmp(pairstoplot(kk,2),pairstoplot(kk,1),:)),'.-');
    ylabel('\delta Hb')
    subplot(1,2,2),plot(squeeze(hbo2seriestmp(pairstoplot(kk,2),pairstoplot(kk,1),:)),'.-');
    ylabel('\delta HbO2')
    legend(['S ' num2str(pairstoplot(kk,1)) ' D ' num2str(pairstoplot(kk,2))]);
    tmplim=get(gca,'YLim');
    for kkkk=1:length(Marks)
        h=line([Marks(kkkk) Marks(kkkk)],[tmplim(1) tmplim(2)]);
        set(h,'Color',[0 0 0]);
    end
    maxwindows(gcf)
end
