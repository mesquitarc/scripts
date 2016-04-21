%%Time-stamp: "2007-03-07 13:13:27 matlabuser"
finasubject=input('Subject ID? ','s');
finadate=input('Subject date? ','s');

finapress=load(['../' finasubject '/' finasubject 'notes/converted' finasubject '.out']);
fpmarks=load(['../' finasubject '/' finasubject 'notes/MARKS' finasubject '.out']);



%time, systolic, diastolic, map, heart rate, interbeat interval, stroke volume, cardiac output, left
%ventricular ejection time, total peripheral resistance,  artifact, impedance, windkessel compliance,
%height correction
dataname(1).name='Time';
dataname(1).unit='s';
dataname(2).name='reSYS';
dataname(2).unit='mmHg';
dataname(3).name='reDIA';
dataname(4).unit='mmHg';
dataname(4).name='reMAP';
dataname(5).unit='mmHg';
dataname(5).name='HR';
dataname(5).unit='bpm';
dataname(6).name='IBI';
dataname(6).unit='s';
dataname(7).name='SV';
dataname(7).unit='ml';
dataname(8).name='CO';
dataname(8).unit='lpm';
dataname(9).name='EJT';
dataname(9).unit='s';
dataname(10).name='TPR';
dataname(10).unit='mmHg.s/ml';
dataname(11).name='Artifact';
dataname(11).unit='na';
dataname(12).name='Zao';
dataname(12).unit='na';
dataname(13).name='Cwk';
dataname(13).unit='na';
dataname(14).name='Height';
dataname(14).unit='mmHg';
          
          
fighandle=figure,
subplot(3,4,1),
plot(finapress(:,1),finapress(:,2));
hold on, 
plot(finapress(:,1),finapress(:,3),'k');
plot(finapress(:,1),finapress(:,4),'r');
set(gca,'FontSize',14)
ylabel(dataname(2).unit)
title('Blood Pressures')
legend(dataname(2:4).name)
tmplim=get(gca,'YLim');
  for kkkk=1:length(fpmarks)
    h=line([finapress(fpmarks(kkkk),1) finapress(fpmarks(kkkk),1)],[tmplim(1) tmplim(2)]);
    set(h,'Color',[0 0 0]);
  end

for i=5:14

subplot(3,4,i-3),plot(finapress(:,1),finapress(:,i))
set(gca,'FontSize',14)
ylabel(dataname(i).unit)
xlabel('s')
title(dataname(i).name)
tmplim=get(gca,'YLim');
  for kkkk=1:length(fpmarks)
    h=line([finapress(fpmarks(kkkk),1) finapress(fpmarks(kkkk),1)],[tmplim(1) tmplim(2)]);
    set(h,'Color',[0 0 0]);
  end
  
  
end
  
tt=['save agematch' finasubject '_' finadate '_finapres.mat finapress finasubject fpmarks dataname'];
eval(tt);

maxwindows;
pause;

set(gcf,'PaperPositionMode','auto')

saveas(gcf,['../' finasubject '/' finasubject 'notes/savedfigs/finapresplot' ...
            finasubject '_' finadate '.fig'],'fig')
saveas(gcf,['../' finasubject '/' finasubject 'notes/savedfigs/finapresplot' ...
            finasubject '_' finadate '.eps'],'epsc2')
saveas(gcf,['../' finasubject '/' finasubject 'notes/savedfigs/finapresplot' ...
            finasubject '_' finadate '.png'],'png')

