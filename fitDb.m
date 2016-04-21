function [Betasave,Dbfit,Curvefit,varargout] = fitDb(intensitydata,corrs,taus,fsdlist,Ns,Nd,fitbeta,cutusingdefinednumber,datalength,Marksflow)
%
% It uses options.m file to load options for fitting...
% fitbeta = 0 do not fit beta, ==1 fit beta, ==2 beta is .5
%
% Structure like fitDb(intensitydata,corrs,taus,fsdlist,Ns,Nd,fitbeta,cutusingdefinednumber,data
% length,Marksflow)
%
% Example: [Betasave,Dbfit,Curvefit] = fitDb(intensitydata,corrs,taus,fsdlist,Ns,Nd,1,1,90,marks)
%
% Created by: R. Mesquita ( 2009/03/11 )
%


tst = clock;
% Load option parameters
optionsset
warning('OFF');

for rk=1:length(intensitydata)
    for snum=1:Ns
        for i=1:Nd

            corrs0=mean([1.5*corrs(rk,1,i) corrs(rk,2,i) 0.5*corrs(rk,3,i)])-1;

            if fitbeta==1
                avgnum=6;
                % slidingavg smooths data, basically
                foo=min(find(slidingavg(corrs(rk,:,i),avgnum)<=1.2));
                if isempty(foo)
                    tmpf(i)=datalength;
                else
                    tmpf(i)=min(find(slidingavg(corrs(rk,:,i),avgnum)<=1.2));
                end
                % find a threshold n smooth data
                corrstmp=corrs(rk,1:tmpf(i),i);
                corrstmp=slidingavg(corrstmp,avgnum);
                % Minimize to find beta
                Beta(i)=fminsearch('curvefit',[corrs0],[],squeeze(taus(rk,1:tmpf(i))),squeeze(corrstmp(:)),fsdlist(snum,i),muspo,muao,ko,ze,Dbr0,tmpf(i),mux0);
            elseif fitbeta==2
                Beta(i)=0.5;
            else
                Beta(i)=corrs0;
                if Beta(i)<0
                    Beta(i)=0.5;
                end
            end

            Betasave(rk,snum,i)=Beta(i);

            % Fit Db
            if cutusingdefinednumber==1
                % Get g1 from data and calculated beta
                g1data(:,i)=sqrt(abs((corrs(rk,:,i)-1)./Beta(i)));

                % Use good points to fit for Db only
                avgnum=10;
                foo=min(find(slidingavg(g1data(:,i),avgnum)<=0.3));
                if isempty(foo)
                    tmpf(i)=datalength;
                else
                    tmpf(i)=min(find(slidingavg(g1data(:,i),avgnum)<=0.3));
                end
                corrstmp=corrs(rk,1:tmpf(i),i);
                corrstmp=slidingavg(corrstmp,avgnum);
                g1=sqrt(abs((corrstmp(:)-1)./Beta(i)));

                % Fit for Db only
                [Dbfit(rk,snum,i) res tmp infofmin]=fminsearch('xg1fitx',[Dbr0],options,mux0,fsdlist(snum,i),taus(rk,:),muspo,muao,ko,ze,squeeze(g1),length(g1));
                infofmin;
                residue(rk,snum,i)=res;
            else
                g1(:,i)=sqrt(abs((corrs(:,i)-1)./Beta(i)));
                Dbfit(rk,snum,i)=fminsearch('xg1fitx',[Dbr0],options,mux0,fsdlist(snum,i),taus(rk,:),muspo,muao,ko,ze,squeeze(g1(:,i)),datalength);
            end

            % Store Curve from fit
            Curvefit(rk,snum,i,:)=g1fitx(Dbfit(rk,snum,i),fsdlist(snum,i),taus(rk,:),muspo,muao,mux0,ko,ze);
        end

    end

end

if nargout >=1
    varargout{1}=residue;
end

tend = clock;
telapsed = tend-tst
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