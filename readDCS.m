function [intensity,corrs,taus,marks,varargout] = readDCS(filenm,cutusingdefinednumber,datalength,Ns,Nd,plotint)

% 
% This function reads files from DCS instruments. The arguments are
%             readDCS(filename,cutdata,datalength,Ns,Nd)
% where cutdata can be at a defined number (1) or using arbitrary number
% fromdatalength(0). The datalength to be cut is datalength, and Ns and Nd
% are the number of sources and detectors, respectively.
% 
% Example: [instensity,corrs,taus,marks,t] = readDCS('/mnt/d/rickson/test_flow_',1,90,1,2) 
%
% Created by: R. Mesquita ( 2009/04/02 )
% Last modified by: R. Mesquita ( 2010/01/30 )


% ---- LOAD FLOW DATA -----
fname1 = [filenm 'flow_'];

minfiles=1;
measnum=0;
morefiles=1; % 1:more files to read, 0:quit
snum=1;
marks=[];
time=[];

while (morefiles)
    if snum>Ns
        snum=1;
        measnum=measnum+1;
    end
    numfiles=measnum.*Ns+snum+minfiles-1;
    fname=[fname1 sprintf('%01d',measnum) '.dat'];

    if exist(fname)==2
        data=load(fname);
        % Cutting data
        if cutusingdefinednumber==1
            intensity(numfiles,:)=data(1,2:Nd+1);
            corrs(numfiles,:,:)=data(3:end,2:Nd+1);
            taus(numfiles,:,:)=data(3:end,1);
        else         % for fixed cut
            corrs=data(3:2+datalength,2:Nd+1);
            taus=data(3:2+datalength,1);
        end

        % Getting Marks into marks
        if data(end,1)>0
            marks(data(end,1))=measnum+1;
        end
        
        % Getting exact time
        fi = fopen(fname,'rt');
        tmp = fscanf(fi,['%c %d/%d/%d %d:%d:%d %*s \n'],[1 inf]);
        st = fclose(fi);        
        time(numfiles,:)=tmp(2:end);        

        snum=snum+1;
    elseif exist(fname)==0 %file does not exist
        if measnum==0
            disp('');
            disp('File does not exist. Please, check the filename out');
            disp('');
        end
        morefiles=0;
    end
end

if nargout >=1
    varargout{1}=time;
end

if plotint
    figure;
    subplot(2,1,1)
    plot(1:size(intensity,1),intensity(:,1:4));
    title(['DCS Intensity at all APDs'])
    legend('1','2','3','4')
    xlabel('Frame'); ylabel('Amplitude (kHz)')
    for k=1:length(marks)
        line([marks(k) marks(k)],[min(min(intensity(:,1:4))) max(max(intensity(:,1:4)))],'Color',[0 0 0]);
        text(marks(k), max(max(intensity(:,1:4))), num2str(k), 'Color', 'b');
    end
    if size(intensity,2)>4
        subplot(2,1,2)
        plot(1:size(intensity,1),intensity(:,5:8));
        legend('5','6','7','8')
        xlabel('Frame'); ylabel('Amplitude (kHz)')
        for k=1:length(marks)
            line([marks(k) marks(k)],[min(min(intensity(:,5:8))) max(max(intensity(:,5:8)))],'Color',[0 0 0]);
            text(marks(k), max(max(intensity(:,5:8))), num2str(k), 'Color', 'b');
        end
    end
end

return