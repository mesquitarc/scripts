function [Betasave,Dbfit,Curvefit] = plotDCS(Betasave,Dbfit,Curvefit,N)
%
% N is the frame to plot Curvefit....





% pairstoplot=[1 1;1 2];
% for kk=1:length(pairstoplot)
%     figure,plot(squeeze(Dbfit(:,pairstoplot(kk,1),pairstoplot(kk,2))),'.-');
%     legend(['S ' num2str(pairstoplot(kk,1)) ' D ' num2str(pairstoplot(kk,2))]);
%     tmplim=get(gca,'YLim');
%     for kkkk=1:length(Marksflow)
%         h=line([Marksflow(kkkk) Marksflow(kkkk)],[tmplim(1) tmplim(2)]);
%         set(h,'Color',[0 0 0]);
%     end
% end
% 
% figure,plot(squeeze(Betasave(:,1,:)),'.','MarkerSize',10)
% xlabel('Frame','FontSize',25)
% ylabel('\beta','FontSize',25)
% axis tight
% set(gca,'FontSize',20)
% legend({['D1'],['D2']},'FontSize',20)
% set(gcf,'PaperPositionMode','Auto')
% saveas(gcf,['Beta_' patID '_' patdate '.fig'],'fig')
% %
% % figure,plot(intensitydata,'.','MarkerSize',10)
% % xlabel('Frame','FontSize',25)
% % ylabel('Intensity (kHz)','FontSize',25)
% % axis tight
% % set(gca,'FontSize',20)
% % legend({['D1'],['D2']},'FontSize',20)
% % set(gcf,'PaperPositionMode','Auto')
% % saveas(gcf,['Intensity_' patID '_' patdate '.fig'],'fig')

return